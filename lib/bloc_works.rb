
require "bloc_works/version"
require "bloc_works/controller"
require "bloc_works/utility"
require "bloc_works/router"
require "bloc_works/dependencies"

module BlocWorks
  class Application
    def call(env)
       puts "env: #{env}"
      [200, {'Content-Type' => 'text/html'}, ["Hello Blocheads 123!"]]
    end
  end
end
