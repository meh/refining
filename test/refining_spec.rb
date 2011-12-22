#! /usr/bin/env ruby
require 'rubygems'
require 'refining'

describe 'Refining' do
	before do
		class LOL
			def lol
				23
			end

			def omg (&block)
				!!block
			end

			refine_method :lol do |old|
				[old.call, 42]
			end

			refine_method :omg do |old, &block|
				old.call(&block)
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

	it 'passes blocks correctly' do
		LOL.new.omg {}.should == true
	end

	it 'refines correctly an unexisting method' do
		Class.new(Object) {
			refine_method :method_added, :prefix => 'refining_' do |name|
				refining_method_added(name)
			end

			def lol
				42
			end
		}.new.lol.should == 42
	end
end
