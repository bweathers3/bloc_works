class Object

  def self.const_missing(const)
    #  puts "\n<dependencies.rb> ()::Object.self.const_missing(const)\nconst: #{const}\n"
    require BlocWorks.snake_case(const.to_s)
    Object.const_get(const)
  end
end
