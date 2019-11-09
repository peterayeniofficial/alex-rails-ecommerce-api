# app/representation_builders/field_picker.rb
class FieldPicker

  def initialize(presenter)
    @presenter = presenter
  end

  def pick
    build_fields
    @presenter
  end

  # We will need to access the fields from outside later on
  def fields
    @fields ||= validate_fields
  end

  private

  # We check each field to see if it's included in the
  # build_attributes array of the given presenter.
  def validate_fields
    return pickable if @presenter.params[:fields].blank?

    fields = if !@presenter.params[:fields].blank?
      @presenter.params[:fields].split(',')
    else
      []
    end

    return pickable if fields.blank?

    fields.each do |field|
      error!(field) unless pickable.include?(field)
    end

    fields
  end

  def build_fields
    fields.each do |field|
      target = @presenter.respond_to?(field) ? @presenter : @presenter.object
      @presenter.data[field] = target.send(field) if target
    end
  end

  def error!(field)
    build_attributes = @presenter.class.build_attributes.join(',')
    raise RepresentationBuilderError.new("fields=#{field}"),
    "Invalid Field Pick. Allowed field: (#{build_attributes})"
  end

  def pickable
    @pickable ||= @presenter.class.build_attributes
  end

end