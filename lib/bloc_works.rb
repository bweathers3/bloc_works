require_relative "./bloc_works/version.rb"

require "bloc_works/dependencies"
require "bloc_works/controller"


module BlocWorks
  class Application
    def call(env)
      [200, {'Content-Type' => 'text/html'}, ["Hello All Blocheads!"]]
    end
  end
end
