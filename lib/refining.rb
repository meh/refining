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

class Module
  def refine_method (meth, &block)
    return unless block

    old = instance_method(meth) rescue proc {}

    define_method(meth) {|*args|
      instance_exec((old.is_a?(UnboundMethod) ? old.bind(self) : old), *args, &block)
    }
  end

  def refine_class_method (meth, &block)
    class << self
      self
    end.refine_method meth, &block
  end; alias refine_module_method refine_class_method
end

class Object
  def refine_instance_method (meth, &block)
    class << self
      self
    end.refine_method meth, &block
  end
end
