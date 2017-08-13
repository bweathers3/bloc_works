require "erubis"
require 'pry'

module BlocWorks

  class Controller

    def initialize(env)
      @env = env
      @routing_params = {}
    end

    def dispatch(action, routing_params = {})
      @routing_params = routing_params
      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
      puts " in dispatch before send"
       puts " in dispacth action: #{action} then routing_params: #{routing_params}"
       puts "!!!!  @routing_params !!!!:     #{@routing_params}"
      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
      text = self.send(action)
      #binding.pry
      if has_response?
      #binding.pry
        rack_response = get_response
        [rack_response.status, rack_response.header, [rack_response.body].flatten]
      else
        [200, {'Content-Type' => 'text/html'}, [text].flatten]
      end
    end

    def self.action(action, response = {})
      # puts "&&&&&&&&&&&&&&&&&&&"
       # puts " in self.action with action = to :      #{action}"
      # puts " or with the result of proc { |env| self.new(env).dispatch(action, response) } equal to:   #{proc { |env| self.new(env).dispatch(action, response) }}"
      # puts "&&&&&&&&&&&&&&&&&&&"
      proc { |env| self.new(env).dispatch(action, response) }
    end

    def request
      # puts "******************"
       # puts " in request with view:       #{@request}"
      # puts " or with the result of @request ||= Rack::Request.new(@env) equal to:   #{@request ||= Rack::Request.new(@env)}"
      # puts "******************"
      @request ||= Rack::Request.new(@env)
    end

    def params
      puts "request.params.merge(@routing_params) as :    #{request.params.merge(@routing_params)}"
      request.params.merge(@routing_params)
    end

    def create_response_array(view, locals = {})
      # puts "******************"
       puts " in create_reponse_array with view:       #{view}"
       puts " in create_reponse_array with locals:       #{locals}"
      # puts "******************"
      filename = File.join("app", "views", controller_dir, "#{view}.html.erb")
      template = File.read(filename)
      eruby = Erubis::Eruby.new(template)
      puts "******************"
      puts " in create_response_array with **eruby.result(locals.merge(env: @env))** of:       #{eruby.result(locals.merge(env: @env))}"
      puts "******************"
      eruby.result(locals.merge(env: @env))
    end

    def controller_dir
      klass = self.class.to_s
      klass.slice!("Controller")
      # puts "******************"
       # puts " in controller_dir with snake case klass of:       #{BlocWorks.snake_case(klass)}"
      # puts "******************"

      BlocWorks.snake_case(klass)
    end

    def response(text, status = 200, headers = {})
      # puts "******************"
       # puts " in response with text:  #{text}"
      # puts " in response with !@response.nil?: #{!@response.nil?}"
      # puts "******************"

      raise "Cannot respond multiple times" unless @response.nil?
      # puts "******************"
      # puts " in response with @response: #{Rack::Response.new([text].flatten, status, headers)}"
      # puts "******************"
      @response = Rack::Response.new([text].flatten, status, headers)
    end

    def render(*args)
      puts "******************"
       puts " in render with args of #{args}"
      puts "******************"
      response(create_response_array(*args))
    end

    def get_response
      # puts "******************"
       # puts " in get_response with @response: #{@response}"
      # puts "******************"
      @response
    end

    def has_response?
      # puts "******************"
       # puts " in has_response? with !@response.nil?: #{!@response.nil?}"
      # puts "******************"

      !@response.nil?
    end

  end

end
