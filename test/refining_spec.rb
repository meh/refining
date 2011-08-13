#! /usr/bin/env ruby
require 'rubygems'
require 'refining'

describe 'Refining' do
  before do
    class LOL
      def lol
        23
      end

      refine_method :lol do |old|
        [old.call, 42]
      end
    end
  end

  it 'refines correctly a method on a class' do
    LOL.new.lol.should == [23, 42]
  end

  it 'refines correctly a method on an object, without affecting other objects of the same class' do
    a = LOL.new
    b = LOL.new

    a.refine_singleton_method :lol do |old|
      old.call.reverse
    end

    a.lol.should == [42, 23]
    b.lol.should == [23, 42]
  end
end
