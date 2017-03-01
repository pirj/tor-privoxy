require 'net/telnet'
require 'mechanize'

module TorPrivoxy
  class Agent
    attr_accessor :max_retries

    def initialize host, pass, control, &callback
      @proxy = Switcher.new host, pass, control
      @max_retries = control.size
      @mechanize = Mechanize.new
      @mechanize.set_proxy(@proxy.host, @proxy.port)
      @circuit_timeout = 10
      if callback
        @callback = callback
        @callback.call self
      end
    end

    def method_missing method, *args, &block
      retries ||= @max_retries
      @mechanize.send method, *args, &block
    rescue Mechanize::ResponseCodeError # 403 etc
      switch_circuit
      retries -= 1
      retry if retries > 0
      raise
    end

    def switch_circuit
      localhost = Net::Telnet::new('Host' => @proxy.host, 'Port' => @proxy.control_port,
                                 'Timeout' => @circuit_timeout, 'Prompt' => /250 OK\n/)
      localhost.cmd("AUTHENTICATE \"#{@proxy.pass}\"") { |c| throw "cannot authenticate to Tor!" if c != "250 OK\n" }
      localhost.cmd('signal NEWNYM') { |c| throw "cannot switch Tor to new route!" if c != "250 OK\n" }
      localhost.close

      @proxy.next
      @mechanize = Mechanize.new
      @mechanize.set_proxy(@proxy.host, @proxy.port)

      if @callback
        @callback.call self
      end
    end

    def ip
      @mechanize.get('http://canihazip.com/s').body
    rescue exception
      puts "error getting ip: #{exception.to_s}"
      return ""
    end
  end
end
