class Object

  def self.const_missing(const)
      # puts "%%%%%%%%%%%%"
      # puts "from self.const_missing: #{const}"
      #   puts "%%%%%%%%%%%%"
    #begin
      require BlocWorks.snake_case(const.to_s)
    # puts "from self.const_missing: #{Object.const_get(const)}"
    # puts "%%%%%%%%%%%%"
      Object.const_get(const)
    #rescue LoadError
    #end
  end
end
