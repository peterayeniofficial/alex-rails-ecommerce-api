# app/errors/representation_builder_error.rb
class RepresentationBuilderError < StandardError
  attr_accessor :invalid_params

  def initialize(invalid_params)
    @invalid_params = invalid_params
    super
  end
end