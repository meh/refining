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
    class << self
      self
    end.refine_method meth, &block
  end
end

class Module
  def refine_method (meth, &block)
    return unless block

    old = instance_method(meth) rescue nil

    define_method(meth) {|*args|
      instance_exec((old.is_a?(UnboundMethod) ? old.bind(self) : old) || proc {}, *args, &block)
    }

    old
  end

  alias refine_module_method refine_singleton_method
end

class Class
  alias refine_class_method refine_singleton_method
end
