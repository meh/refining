#! /usr/bin/env ruby
require 'rubygems'
require 'benchmark'
require 'refining'

class LOL
	def lol
		2 + 2
	end

	def omg
		2 + 2
	end

	def wat
		2 + 2
	end

	refine_method :omg do |old|
		old.call
	end

	refine_method :wat, :prefix => 'bench' do
		__send__ 'bench_wat'
	end
end

Benchmark.bm do |b|
	lol = LOL.new

	b.report('normal: ') {
		10_000.times { lol.lol == 4 }
	}

	b.report('refined: ') {
		10_000.times { lol.omg == 4}
	}

	b.report('alias refined: ') {
		10_000.times { lol.wat == 4}
	}
end
