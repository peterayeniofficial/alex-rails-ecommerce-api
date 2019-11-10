# app/serializers/alexandria/serializer.rb
module Alexandria
  class Serializer

    def initialize(data:, params:, actions:, options: {})
      @data = data
      @params = params
      @actions = actions
      @options = options
      @serializer = @data.is_a?(ActiveRecord::Relation) ? collection_serializer :
                                                          entity_serializer
    end

    def to_json
      # We skip caching if the presenter is not configured for it
      return data unless @serializer.cache?

      Rails.cache.fetch("#{@serializer.key}/json", { raw: true }) do
        data
      end
    end

    private

    def data
      { data: @serializer.serialize }.to_json
    end

    def collection_serializer
      CollectionSerializer.new(@data, @params, @actions)
    end

    def entity_serializer
      presenter_klass = "#{@data.class}Presenter".constantize
      presenter = presenter_klass.new(@data, @params, @options)
      EntitySerializer.new(presenter, @actions)
    end

  end
end