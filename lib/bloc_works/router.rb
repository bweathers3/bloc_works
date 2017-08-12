module BlocWorks

  class Application

    def controller_and_action(env)
      _, controller, action, _ = env["PATH_INFO"].split("/", 4)
      controller = controller.capitalize
      controller = "#{controller}Controller"
      # puts "controller and Action"
      # puts "%%%%%%%%%%%%"
      # puts "env : #{env}"
      # puts "%%%%%%%%%%%%"
      # puts "Object.const_get(controller), action]  : #{[Object.const_get(controller), action]}"
      # puts "%%%%%%%%%%%%"
      [Object.const_get(controller), action]
    end

    def fav_icon(env)
      # puts "from fav_icon"
      # puts "%%%%%%%%%%%%"
      # puts "env : #{env}"
      # puts "%%%%%%%%%%%%"
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end
    end

  end
end
