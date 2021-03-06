Gem::Specification.new {|s|
	s.name         = 'refining'
	s.version      = '0.0.5.4'
	s.author       = 'meh.'
	s.email        = 'meh@paranoici.org'
	s.homepage     = 'http://github.com/meh/refining'
	s.platform     = Gem::Platform::RUBY
	s.summary      = 'Easily refine methods'
	s.files        = Dir.glob('lib/**/*.rb')
	s.require_path = 'lib'

	s.add_development_dependency 'rake'
	s.add_development_dependency 'rspec'
}
