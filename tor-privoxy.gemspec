Gem::Specification.new do |gem|
  gem.name = "tor-privoxy"
  gem.version = "0.1.1"
  gem.description = "Mechanize wrapper to work via Tor/Privoxy with endpoint switching ability"
  gem.summary = gem.description
  gem.authors = ["Phil Pirozhkov"]
  gem.email = ["pirj@mail.ru"]
  gem.date = Time.now.strftime '%Y-%m-%d'
  gem.homepage = "https://github.com/pirj/tor-privoxy"
  gem.require_paths = ["lib"]
  gem.files = [
    'lib/tor-privoxy.rb',
    'lib/tor-privoxy/agent.rb',
    'lib/tor-privoxy/switcher.rb'
    ]

  gem.add_dependency 'mechanize'
end

