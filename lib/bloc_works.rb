require_relative "./bloc_works/version.rb"


require "bloc_works/router"
require "bloc_works/utility"
require "bloc_works/dependencies"
require "bloc_works/controller"

#
# module BlocWorks
#   class Application
#     def call(env)
#       # puts "env:     #{env}"
#       # puts "%%%%%%%%%%%%"
#       # puts "#{[200, {'Content-Type' => 'text/html'}, ["Hello All Blocheads!"]]}"
#       # puts "%%%%%%%%%%%%"
#       [200, {'Content-Type' => 'text/html'}, ["Hello All Blocheads!"]]
#     end
#   end
# end


module BlocWorks
  class Application
    def call(env)
      puts "********** env **********:     #{env}"
      if env['PATH_INFO'] != '/favicon.ico'
        puts "********** controller_and_action(env) **********:     #{controller_and_action(env)}"
        puts " after controller_and_action(env)"

        controller_name, action_name = controller_and_action(env)
        if !controller_name.nil?
          controller = controller_name.new(env)

          if controller.respond_to?(action_name)
            text = controller.send(action_name)
            return [200, {'Content-Type' => 'text/html'}, [text]]
          end
        end
      end

      return [404, {'Content-Type' => 'text/html'}, []]
    end
  end
end
