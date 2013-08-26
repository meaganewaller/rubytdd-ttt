class InputOutput
  attr_writer :valid_input

  def self.new_with_setup(input, output)
    new.setup(input, output)
  end

  def setup(input, output)
    @in = input
    @out = output
  end

  def request(*message)
    input = nil
    while !valid_input?(input)
      @out.print(*message)
      input = @in.gets.chomp
    end
    input
  end

  def valid_input?(input)
    input.is_a?(String) && (!@valid_input.is_a?(Array) || @valid_input.include?(input))
  end
end
