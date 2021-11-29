module InvalidRecordFinder
  module ModelPicker
    def self.call(given_models: [], ignored_models: [], ignored_namespaces: [])
      given_models = parse_given_models(given_models)
      return given_models if given_models.any?

      ignored_models     = to_string_array(ignored_models)
      ignored_namespaces = to_string_array(ignored_namespaces)

      Rails.configuration.cache_classes || Rails.application.eager_load!

      models = defined?(ApplicationRecord) && ApplicationRecord
        .descendants
        .reject(&:abstract_class?)
        .map(&:name)
      models.blank? && raise(Error, 'No models inherit from ApplicationRecord.')

      if ignored_namespaces.any?
        models = models.grep_v(/\A(?:#{Regexp.union(ignored_namespaces)})/)
      end
      models.empty? && raise(Error, 'All models are ignored through namespaces.')

      if ignored_models.any?
        models -= ignored_models.map(&:to_s)
      end
      models.empty? && raise(Error, 'All models are ignored.')

      models.map(&:constantize)
    end

    def self.parse_given_models(arg)
      Array(arg).map { |el| el.respond_to?(:constantize) ? el.constantize : el }.compact
    end

    def self.to_string_array(arg)
      Array(arg).map { |obj| obj.respond_to?(:name) ? obj.name : obj&.to_s }.compact
    end
  end
end
