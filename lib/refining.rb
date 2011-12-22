#--
#           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                   Version 2, December 2004
#
#  Copyleft meh. [http://meh.paranoid.pk | meh@paranoici.org]
#
#           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

class Object
	def refine_singleton_method (meth, options = {}, &block)
		return unless block

		what = class << self
			self
		end

		if options[:alias] || options[:prefix]
			what.instance_eval {
				begin
					alias_method options[:alias] || "#{options[:prefix]}_#{meth}", meth
				rescue NameError
					define_method options[:alias] || "#{options[:prefix]}_#{meth}" do |*args| end
				end

				define_method meth, &block
			}
		else
			target = self

			(method(meth) rescue nil).tap {|old|
				old ||= proc {}

				what.instance_eval {
					define_method meth do |*args, &blk|
						what.instance_eval {
							define_method 'temporary method for refining', &block

							target.__send__('temporary method for refining', old, *args, &blk).tap {
								undef_method('temporary method for refining') rescue nil
							}
						}
					end
				}
			}
		end
	end
end

class Module
	def refine_method (meth, options = {}, &block)
		return unless block

		if options[:alias] || options[:prefix]
			instance_eval {
				begin
					alias_method options[:alias] || "#{options[:prefix]}_#{meth}", meth
				rescue NameError
					define_method options[:alias] || "#{options[:prefix]}_#{meth}" do |*args| end
				end

				define_method meth, &block
			}
		else
			(instance_method(meth) rescue nil).tap {|old|
				old ||= proc {}

				define_method meth do |*args, &blk|
					target = self
					what   = class << target
						self
					end

					what.instance_eval {
						define_method 'temporary method for refining', &block

						target.__send__('temporary method for refining', old.is_a?(UnboundMethod) ? old.bind(target) : old, *args, &blk).tap {
							undef_method 'temporary method for refining' rescue nil
						}
					}
				end
			}
		end
	end

	alias refine_module_method refine_singleton_method
end

class Class
	alias refine_class_method refine_singleton_method
end
