module TorPrivoxy
  class Switcher
    attr_reader :host, :pass

    def initialize host, pass, control
      @host, @pass, @control = host, pass, control
      @current = 0
    end
    
    def next
      @current = @current + 1
      @current = 0 if @current >= @control.size
    end
    
    def port
      @control.keys[@current]
    end
    
    def control_port
      @control[port]
    end
  end
end
