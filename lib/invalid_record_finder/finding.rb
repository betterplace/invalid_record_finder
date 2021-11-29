# lightweight representation of a single validation error on one record
module InvalidRecordFinder
  class Finding
    attr_reader :model, :field, :field_value, :message, :id

    def initialize(record, field, message)
      @model       = record.class.name
      @field       = field
      @field_value = record[field]
      @message     = message
      @id          = record.id
    end

    def to_a
      [model, field, field_value, message, id]
    end

    def to_h
      { model: model, field: field, field_value: field_value, message: message, id: id }
    end

    def ==(other)
      other.is_a?(self.class) && other.to_h == to_h
    end
  end
end
