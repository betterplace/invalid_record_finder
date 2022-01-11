# Collects Findings
module InvalidRecordFinder
  class FindingsList
    require 'forwardable'
    extend Forwardable

    def_delegators :@findings, :[], :empty?, :size, :to_a

    def initialize(data = [])
      @findings = data
    end

    def add_if_invalid(record)
      return if record.valid? # Just make sure that the validation has run

      record.errors.each do |err|
        findings << InvalidRecordFinder::Finding.new(
          record, err.attribute.to_s, err.message
        )
      end
    rescue => e
      # handle and report exceptions that occur during validation
      findings << InvalidRecordFinder::Finding.new(record, 'EXCEPTION', e.message)
    end

    require 'tabulo'

    def to_table
      Tabulo::Table.new(findings.first(100), *headers, align_header: :left)
        .autosize_columns
        .shrink_to(:screen, except: :id)
    end

    require 'csv'

    def to_csv
      CSV.generate do |csv|
        csv << headers
        findings.map(&:to_a).each { |line| csv << line }
      end
    end

    def ==(other)
      other.is_a?(self.class) && other.to_a == to_a
    end

    private

    attr_reader :findings

    def headers
      %i[model field field_value message id]
    end
  end
end
