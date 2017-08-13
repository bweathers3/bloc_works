require "erubis"

module BlocWorks

  class Controller

    def initialize(env)
      @env = env
    end

    def render(view, locals = {})
      # puts "view, locals : #{view}     #{locals}"
      filename = File.join("app", "views", controller_dir, "#{view}.html.erb")
      template = File.read(filename)
      eruby = Erubis::Eruby.new(template)
      # puts "%%%%%%%%%%%%"
      # puts " #{eruby.result(locals.merge(env: @env))}"
      # puts "%%%%%%%%%%%%"
      eruby.result(locals.merge(env: @env))

      # self.instance_variables.each do |instance_variable_name|
      #   locals[instance_variable_name] = self.instance_variable_get(instance_variable_name)
      # end
      #
      # eruby.result(locals)
    end


    def controller_dir
      klass = self.class.to_s
      klass.slice!("Controller")
      # puts "from controller dir %%%%%%%%%%%%"
      # puts "%%%%%%%%%%%%"
      # puts "#{BlocWorks.snake_case(klass)}"
      BlocWorks.snake_case(klass)
    end

  end

end
