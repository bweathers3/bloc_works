require_relative "./bloc_works/version.rb"

require "bloc_works/controller"
require "bloc_works/router"
require "bloc_works/utility"
require "bloc_works/dependencies"
require "pry"



module BlocWorks
  class Application

    # def controller_and_action(env)
    #   # puts "******************"
    #   # puts "\n<bloc_works.rb> BlocWorks::Application.controller_and_action(env)\nenv: #{env}\n"
    #   # puts "******************"
    #
    #   _, controller, action, _ = env["PATH_INFO"].split("/", 4)
    #   # puts "******************"
    #   # puts "\n<bloc_works.rb> BlocWorks::Application.controller_and_action(env)\ncontroller: #{controller}\n"
    #   # puts "\n<bloc_works.rb> BlocWorks::Application.controller_and_action(env)\naction: #{action}\n"
    #   # puts "******************"
    #
    #   controller = controller.capitalize
    #   controller = "#{controller}Controller"
    #
    #   [Object.const_get(controller), action]
    #   end
    #
    # def fav_icon(env)
    #   # puts "******************"
    #   # puts "\n<bloc_works.rb> BlocWorks::Application.fav_icon(env)\nenv: #{env}\n"
    #   # puts "******************"
    #   if env['PATH_INFO'] == '/favicon.ico'
    #     return [404, {'Content-Type' => 'text/html'}, []]
    #   end
    #
    #   rack_app = get_rack_app(env)
    #   # puts "******************"
    #   # puts "\n<bloc_works.rb> BlocWorks::Application.fav_icon(env)\nrack_app: #{rack_app}\n"
    #   # puts "******************"
    #   rack_app.call(env)
    # end
    #
    # def route(&block)
    #   # puts "******************"
    #   # puts "\n<bloc_works.rb> BlocWorks::Application.route(&block)\nblock: #{block}\n"
    #   # puts "******************"
    #   @router ||= Router.new
    #   @router.instance_eval(&block)
    # end
    #
    # def get_rack_app(env)
    #   if @router.nil?
    #     raise "No routes defined"
    #   end
    #
    #   puts @router.look_up_url(env["PATH_INFO"])
    #   #binding.pry
    #   @router.look_up_url(env["PATH_INFO"])
    # end

    def call(env)

      # puts "******************"
      # puts "from def call(env)"
      # puts "\n<bloc_works.rb> BlocWorks::Application.call(env)\nenv: #{env}\n"
      # puts "******************"
      # puts "env['PATH_INFO'] as: #{env['PATH_INFO']}"
      # puts "'/favicon.ico' as #{'/favicon.ico'}"
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end
      # puts "******************"
      #
      # puts "env@@@@   2:   #{env}"
      # puts "*******************"
      rack_app = get_rack_app(env)
      #binding.pry
      puts "******************"
      puts "from def call(env) step 2"
      puts "\n<bloc_works.rb> BlocWorks::Application.call(env)\nAFTER rack_app: #{rack_app}\n"
      puts "******************"

      puts "env  3333333:   #{env}"
      puts "*******************"
      rack_app.call(env)
    end
  end
end
