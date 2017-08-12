require_relative "./bloc_works/version.rb"


require "bloc_works/router"
require "bloc_works/utility"
require "bloc_works/dependencies"
require "bloc_works/controller"


module BlocWorks
  class Application
    def call(env)
      puts "env:     #{env}"
      puts "%%%%%%%%%%%%"
      puts "#{[200, {'Content-Type' => 'text/html'}, ["Hello All Blocheads!"]]}"
      puts "%%%%%%%%%%%%"
      [200, {'Content-Type' => 'text/html'}, ["Hello All Blocheads!"]]
    end
  end
end
