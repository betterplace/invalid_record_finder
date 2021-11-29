# Goes through all records of the given models, collects all invalid ones.
module InvalidRecordFinder
  module Scanner
    class << self
      # @return [InvalidRecordFinder::Result]
      def call(models:, verbose: false)
        models.each_with_object(Result.new) do |model, acc|
          puts "Checking #{model}..." if verbose
          list = FindingsList.new
          each_record(model, verbose: verbose) { |r| list.add_if_invalid(r) }
          puts "Found #{list.size} invalid #{model}\n\n" if verbose
          acc[model.name] = list
        end
      end

      private

      require 'fortschritt'

      def each_record(model, verbose: false)
        scope = model.all
        if verbose
          scope = scope.with_fortschritt
        end
        scope.find_each { |record| yield(record.fortschritt) }
      end
    end
  end
end
