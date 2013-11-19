# Tor/Privoxy wrapped Mechanize

tor-privoxy is a Ruby Mechanize wrapper for accessing the web via Tor/Privoxy.
It allows multiple Privoxy instances, switching endpoints, and switching the
proxy when you get an HTTP 4xx error code.
It is useful for web robots, scanners, and scrapers when accessing sites which may
ban/block you unexpectedly

## Using

The first step is to install the gem:

    gem install tor-privoxy

To use in your application:

    require 'tor-privoxy'

To get a Mechanize instance wrapped to use Tor and able to use another endpoint when it encounters an HTTP 4xx code:

    agent ||= TorPrivoxy::Agent.new '127.0.0.1', '', {8123 => 9051} do |agent|
      sleep 10
      puts "New IP is #{agent.ip}"
    end
    
And use the agent as a usual Mechanize agent instance:
    
    agent.get "http://example.com"

### Configuration options

Configuration options are passed when creating an agent and consist of:
 - IP/Host of machine where Tor/Privoxy resides
 - password for Tor Control
 - a hash of Privoxy port => Tor port
 - a block which is called when agent switches to a new endpoint

## Author

Created by [Phil Pirozhkov](https://github.com/pirj)

[Origin](https://github.com/pirj/tor-privoxy)

## Future

- No Mechanize dependency, ability to work with any HTTP library
- Extend configuration options, allowing for fine proxy setting control
- Better "ban" detection, e.g. Captcha, etc.
