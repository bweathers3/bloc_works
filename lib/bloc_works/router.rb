
require 'pry'

module BlocWorks

  class Application

    def controller_and_action(env)
      #puts "\n<router.rb> BlocWorks::Application.controller_and_action(env)\nenv: #{env}\n"
      _, controller, action, _ = env["PATH_INFO"].split("/", 4)
      controller = controller.capitalize
      controller = "#{controller}Controller"

      [Object.const_get(controller), action]
    end

    def fav_icon(env)
      #puts "\n<router.rb> BlocWorks::Application.fav_icon(env)\nenv: #{env}\n"
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end
    end

    def route(&block)
      #puts "\n<router.rb> BlocWorks::Application.route(&block)\nblock: #{block}\n"
      @router ||= Router.new
      #puts "\n<router.rb> BlocWorks::Application.route(&block)\nblock: #{@router.instance_eval(&block)}\n"
      @router.instance_eval(&block)
    end

    def get_rack_app(env)
      #puts "\n<router.rb> BlocWorks::Application.get_rack_app(env)\nenv: #{env}\nenv['PATH_INFO']: #{env["PATH_INFO"]}"
      if @router.nil?
        raise "No routes defined"
      end
      #puts "\n<router.rb> BlocWorks::Application.get_rack_app(env)\nenv: #{env}\nenv['PATH_INFO']: #{env["PATH_INFO"]}"
      @router.look_up_url(env["PATH_INFO"])
    end

  end

  class Router

    def initialize
        # puts "\n<router.rb> BlocWorks::Router.initialize\n"
      @rules = []
    end

    def map(url, *args)
      #puts "\n<router.rb> BlocWorks::Router.map(url, *args)\nBEFORE url: #{url}, *args: #{args}\n"
      options = {}
      options = args.pop if args[-1].is_a?(Hash)
      options[:default] ||= {}

      destination = nil
      destination = args.pop if args.size > 0
      raise "Too many args!" if args.size > 0

      parts = url.split("/")
      parts.reject! { |part| part.empty? }

      vars, regex_parts = [], []

      parts.each do |part|
        case part[0]
        when ":"
          vars << part[1..-1]
          regex_parts << "([a-zA-Z0-9]+)"
        when "*"
          vars << part[1..-1]
          regex_parts << "(.*)"
        else
          regex_parts << part
        end
      end

      regex = regex_parts.join("/")
      @rules.push({ regex: Regexp.new("^/#{regex}\/?$"),
                   vars: vars, destination: destination,
                   options: options })
      # puts "\n<router.rb> BlocWorks::Router.map(url, *args)\nAFTER regex: #{regex}, vars: #{vars}, destination: #{destination}, options: #{options}\n"
      # @rules.push({
      #     regex: Regexp.new("/books/index"),
      #     :vars=>[],
      #     :destination=>"books#index",
      #     :options=>{:default=>{}}
      #   })
      # @rules.push({
      #     regex: Regexp.new("/books/"),
      #     :vars=>[],
      #     :destination=>"books#index",
      #     :options=>{:default=>{}}
      #   })
        #
      puts "@rules second set:    #{@rules}"
    end

    def look_up_url(url)
       #puts "\n<router.rb> BlocWorks::Router.look_up_url(url) (1)\nurl: #{url}\n"

      @rules.each do |rule|
        rule_match = rule[:regex].match(url)
        # puts "\n<router.rb> BlocWorks::Router.look_up_url(url) (2)\nrule: #{rule}, rule_match: #{rule_match}\n"

        # we do not have a rule to match the /books/index pattern
        # binding.pry

        if rule_match
          options = rule[:options]
          params = options[:default].dup
          # puts "\n<router.rb> BlocWorks::Router.look_up_url(url) (3)\noptions: #{options}, params: #{params}\n"
          rule[:vars].each_with_index do |var, index|
            params[var] = rule_match.captures[index]
            # puts "\n<router.rb> BlocWorks::Router.look_up_url(url) (4)\nvar: #{var}, index: #{index}, params[var]: #{params[var]}\n"
          end

          if rule[:destination]
            # puts "\n<router.rb> BlocWorks::Router.look_up_url(url) (5)\nrule[:destination]: #{rule[:destination]}\n"
            return get_destination(rule[:destination], params)
          else
            controller = params["controller"]
            action = params["action"]
            # puts "\n<router.rb> BlocWorks::Router.look_up_url(url) (6)\ncontroller: #{controller}, action: #{action}"
            return get_destination("#{controller}##{action}", params)
          end
        end
      end
    end

    # def resources(controller)
    #     ## Note there is also a map functions in blocBooks::config.ru
    #     ## Richard added the code below
    #       map ":controller/:id", default: { "action" => "show" }
    #       map ":controller", default: { "action" => "index" }
    #       map ":controller", default: { "action" => "new" }
    #       map ":controller/:id", default: { "action" => "edit" }
    #       map ":controller/:id", default: { "action" => "update" }
    #       map ":controller", default: { "action" => "create" }
    #       map ":controller/:id", default: { "action" => "destroy" }
    # end

    def get_destination(destination, routing_params = {})
       #puts "\n<router.rb> BlocWorks::Router.get_destination(destination, routing_params = {})\ndestination: #{destination}, routing_params: #{routing_params}\n"
      if destination.respond_to?(:call)
        # puts "\n<router.rb> BlocWorks::Router.get_destination(destination, routing_params = {})\nIF destination.respond_to?(:call)\n"
        return destination
      end

      if destination =~ /^([^#]+)#([^#]+)$/
        name = $1.capitalize
        controller = Object.const_get("#{name}Controller")
        # puts "\n<router.rb> BlocWorks::Router.get_destination(destination, routing_params = {})\nIF destination =~ /^([^#]+)#([^#]+)&/\nname: #{name}, conotroller: #{controller}, controller's class: #{controller.class}, $1: #{$1}, $2: #{$2}"
        return controller.action($2, routing_params)
      end
      raise "Destination no found: #{destination}"
    end
  end
end
