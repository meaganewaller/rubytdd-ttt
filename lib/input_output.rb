class InputOutput
  attr_writer :valid_input
  def setup(input, output)
    @in = input
    @out = output
  end

  def request(*message)
    input = nil
    while not valid_input?(input)
      @out.print(*message)
      input = @in.gets
      input.chomp! if input.respond_to?(:chomp)
    end
    input
  end

  def valid_input?(input)
    input.is_a?(String) && ((not @valid_input.is_a?(Array)) || @valid_input.include?(input))
  end
end
