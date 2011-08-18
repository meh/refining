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
  def refine_singleton_method (meth, &block)
    return unless block

    target = self

    (method(meth) rescue nil).tap {|old|
      old ||= proc {}

      what = class << target
        self
      end

      what.send :define_method, meth do |*args, &blk|
        return if @__refining_defined__ && [:method_added, :singleton_method_added].member?(meth)
        
        @__refining_defined__ = true
        what.send(:define_method, 'temporary method for refining', &block)
        
        target.send('temporary method for refining', old.is_a?(UnboundMethod) ? old.bind(self) : old, *args, &blk).tap {
          what.send(:undef_method, 'temporary method for refining') rescue nil

          @__refining_defined__ = false
        }
      end
    }
  end
end

class Module
  def refine_method (meth, &block)
    return unless block

    (instance_method(meth) rescue nil).tap {|old|
      old ||= proc {}

      define_method(meth) {|*args, &blk|
        return if @__refining_defined__ && [:method_added, :singleton_method_added].member?(meth)

        what = class << self
          self
        end

        @__refining_defined__ = true
        what.send(:define_method, 'temporary method for refining', &block)
        
        send('temporary method for refining', old.is_a?(UnboundMethod) ? old.bind(self) : old, *args, &blk).tap {
          what.send(:undef_method, 'temporary method for refining') rescue nil

          @__refining_defined__ = false
        }
      }
    }
  end

  alias refine_module_method refine_singleton_method
end

class Class
  alias refine_class_method refine_singleton_method
end
