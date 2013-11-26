require 'bugsnag-em'

Bugsnag::configure do |config|
  config.api_key = "066f5ad3590596f9aa8d601ea89af845"
end

EM::run do
  Bugsnag.with(user: {id: 'conrad', email: 'conrad@bugsnag.com'}, details: {foo: :bar}) do
    EM::next_tick do
      raise 'oops'
    end
  end
end
