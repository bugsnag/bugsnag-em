Gem::Specification.new do |gem|
  gem.name = 'bugsnag-em'
  gem.version = '0.1'

  gem.summary = 'A Bugsnag notifier for Eventmachine'
  gem.description = "Let's you rescue errors asynchronously while keeping track of context"

  gem.authors = ['Conrad Irwin']
  gem.email = %w(conrad@bugsnag.com)
  gem.homepage = 'http://github.com/bugsnag/bugsnag-em'

  gem.license = 'MIT'

  gem.add_dependency 'eventmachine'
  gem.add_dependency 'lspace', '>= 0.13'
  gem.add_dependency 'bugsnag'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "pry"

  gem.files = `git ls-files`.split("\n")
end
