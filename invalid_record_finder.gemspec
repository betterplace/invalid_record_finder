
require_relative 'lib/invalid_record_finder/version'

Gem::Specification.new do |spec|
  spec.name     = 'invalid_record_finder'
  spec.version  = InvalidRecordFinder::VERSION
  spec.authors  = ['betterplace development team']
  spec.email    = ['developers@betterplace.org']

  spec.summary  = 'Finds invalid ActiveRecord entries and reports them'
  spec.homepage = 'https://github.com/betterplace/invalid_record_finder'
  spec.license  = 'Apache-2.0'

  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 5.0'
  spec.add_dependency 'fortschritt', '>= 0.3', '< 2'
  spec.add_dependency 'tabulo', '~> 2.7'
end
