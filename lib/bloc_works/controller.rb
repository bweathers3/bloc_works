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
      #puts " in dispacth action: #{action} then routing_params: #{routing_params}"
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
      # puts " or with the result of proc { |env| self.new(env).dispatch(action, response) } equal to:   #{proc { |env| self.new(env).dispatch(action, response) }}"
      proc { |env| self.new(env).dispatch(action, response) }
    end

    def request
      # puts " or with the result of @request ||= Rack::Request.new(@env) equal to:   #{@request ||= Rack::Request.new(@env)}"
      @request ||= Rack::Request.new(@env)
    end

    def params
      #puts "request.params.merge(@routing_params) as :    #{request.params.merge(@routing_params)}"
      request.params.merge(@routing_params)
    end

    def create_response_array(view, locals = {})
      #puts " in create_reponse_array with view:       #{view}"
      #puts " in create_reponse_array with locals:       #{locals}"
      filename = File.join("app", "views", controller_dir, "#{view}.html.erb")
      template = File.read(filename)
      eruby = Erubis::Eruby.new(template)
      #puts " in create_response_array with **eruby.result(locals.merge(env: @env))** of:       #{eruby.result(locals.merge(env: @env))}"
      eruby.result(locals.merge(env: @env))
    end

    def controller_dir
      klass = self.class.to_s
      klass.slice!("Controller")
      # puts " in controller_dir with snake case klass of:       #{BlocWorks.snake_case(klass)}"
      BlocWorks.snake_case(klass)
    end

    def response(text, status = 200, headers = {})
      # puts " in response with !@response.nil?: #{!@response.nil?}"

      raise "Cannot respond multiple times" unless @response.nil?
      # puts " in response with @response: #{Rack::Response.new([text].flatten, status, headers)}"
      @response = Rack::Response.new([text].flatten, status, headers)
    end

    def render(*args)
      # puts " in render with args of #{args}"
      response(create_response_array(*args))
    end

    def get_response
       # puts " in get_response with @response: #{@response}"
      @response
    end

    def has_response?
       # puts " in has_response? with !@response.nil?: #{!@response.nil?}"
      !@response.nil?
    end

  end

end
