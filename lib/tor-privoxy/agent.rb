require 'net/telnet'
require 'mechanize'

module TorPrivoxy
  class Agent
    def initialize host, pass, control, &callback
      @proxy = Switcher.new host, pass, control
      @mechanize = Mechanize.new
      @mechanize.set_proxy(@proxy.host, @proxy.port)
      @callback = callback
      @callback.call self
    end
    
    def method_missing method, *args, &block
      begin
        @mechanize.send method, *args, &block
      rescue Mechanize::ResponseCodeError # 403 etc
        switch_circuit
        retry
      end
    end

    def switch_circuit
      localhost = Net::Telnet::new('Host' => @proxy.host, 'Port' => @proxy.control_port,
                                 'Timeout' => 2, 'Prompt' => /250 OK\n/)
      localhost.cmd("AUTHENTICATE \"#{@proxy.pass}\"")
      localhost.cmd('signal NEWNYM')
      localhost.close

      @proxy.next
      @mechanize = Mechanize.new
      @mechanize.set_proxy(@proxy.host, @proxy.port)

      @callback.call self
    end

    def ip
      @mechanize.get('http://ifconfig.me/ip').body
    end
  end
end
