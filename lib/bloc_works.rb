require_relative "./bloc_works/version.rb"

require "bloc_works/controller"
require "bloc_works/router"
require "bloc_works/utility"
require "bloc_works/dependencies"
require "pry"

module BlocWorks
  class Application

    def call(env)
      #puts "\n<bloc_works.rb> BlocWorks::Application.call(env)\nenv: #{env}\n"
      # puts "env['PATH_INFO'] as: #{env['PATH_INFO']}"
      # puts "'/favicon.ico' as #{'/favicon.ico'}"
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      rack_app = get_rack_app(env)
      #binding.pry
      #puts "\n<bloc_works.rb> BlocWorks::Application.call(env)\nAFTER rack_app: #{rack_app}\n"
      rack_app.call(env)
    end
  end
end
