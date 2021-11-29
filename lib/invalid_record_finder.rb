require_relative 'invalid_record_finder/finding'
require_relative 'invalid_record_finder/findings_list'
require_relative 'invalid_record_finder/mailer'
require_relative 'invalid_record_finder/model_picker'
require_relative 'invalid_record_finder/result'
require_relative 'invalid_record_finder/scanner'
require_relative 'invalid_record_finder/version'

module InvalidRecordFinder
  class Error < StandardError; end

  # @return [InvalidRecordFinder::Result]
  def self.call(
    models: [],
    ignored_namespaces: [],
    ignored_models: [],
    verbose: false
  )
    models = ModelPicker.call(
      given_models: models,
      ignored_models: ignored_models,
      ignored_namespaces: ignored_namespaces,
    )
    Scanner.call(models: models, verbose: verbose)
  end
end
