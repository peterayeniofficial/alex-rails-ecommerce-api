# app/presenters/base_presenter.rb
class BasePresenter
  include Rails.application.routes.url_helpers

  # Define a class level instance variable
  @build_attributes = []
  @relations = []
  @sort_attributes = []
  @filter_attributes = []

  # Open the door to class methods
  class << self
    # Define an accessor for the class level instance
    # variable we created above
    attr_accessor :relations, :sort_attributes,
                  :filter_attributes, :build_attributes

    # Create the actual class method that will
    # be used in the subclasses
    # We use the splash operation '*' to get all
    # the arguments passed in an array
    def build_with(*args)
      @build_attributes = args.map(&:to_s)
    end

    # Add a bunch of methods that will be used in the
    # model presenters
    def related_to(*args)
      @relations = args.map(&:to_s)
    end

    def sort_by(*args)
      @sort_attributes = args.map(&:to_s)
    end

    def filter_by(*args)
      @filter_attributes = args.map(&:to_s)
    end


  end
  
  attr_accessor :object, :params, :data

  def initialize(object, params, options = {})
    @object = object
    @params = params
    @options = options
    @data = HashWithIndifferentAccess.new
  end

  def as_json(*)
    @data
  end

  def build(actions)
    actions.each { |action| send(action) }
    self
  end

  def fields
    FieldPicker.new(self).pick
  end

  def embeds
    EmbedPicker.new(self).embed
  end

end