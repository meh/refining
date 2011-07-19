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
  def refine_method (meth, &block)
    return unless block

    old = self.method(meth) rescue Proc.new {}

    define_singleton_method(meth) {|*args|
      self.instance_exec(old, *args, &block)
    }
  end
end

class Class
  def refine_method (meth, &block)
    return unless block

    old = self.instance_method(meth) rescue Proc.new {}

    define_method(meth) {|*args|
      self.instance_exec((old.is_a?(Proc) ? old : old.bind(self)), *args, &block)
    }
  end

  def refine_class_method (meth, &block)
    return unless block

    old = self.method(meth) rescue Proc.new {}

    define_singleton_method(meth) {|*args|
      self.instance_exec((old.is_a?(Proc) ? old : old.bind(self)), *args, &block)
    }
  end
end
