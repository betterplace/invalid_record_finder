# A map of model names to FindingsLists.
module InvalidRecordFinder
  class Result
    require 'forwardable'
    extend Forwardable

    def_delegators :@hash, :[], :[]=, :each, :empty?, :to_h

    def initialize(data = {})
      @hash = data
    end

    # Flattens all the FindingsLists (for multiple models) into one,
    # e.g. to send as a single mail or write into a single CSV.
    #
    # @return [InvalidRecordFinder::Result]
    def flatten
      flat_list = FindingsList.new(@hash.values.flat_map(&:to_a))
      self.class.new('ApplicationRecord' => flat_list)
    end

    def mail(from:, to:, subject_prefix: nil, delivery_method: :deliver_now)
      each do |model_name, findings_list|
        findings_list.empty? || Mailer.mail(
          model_name:     model_name,
          findings_list:  findings_list,
          from:           from,
          to:             to,
          subject_prefix: subject_prefix,
        ).send(delivery_method)
      end
    end

    require 'fileutils'

    def save_csvs(to: default_csv_dir)
      FileUtils.mkdir_p(to)

      each.with_object([]) do |(model_name, findings_list), acc|
        next if findings_list.empty?

        acc << (path = File.join(to, "#{model_name}.csv"))
        File.write(path, findings_list.to_csv)
      end
    end

    def default_csv_dir
      Rails.root.join('tmp', 'invalid_records')
    end

    def ==(other)
      other.is_a?(self.class) && other.to_h == to_h
    end

    def inspect
      "#<#{self.class}:0x%x>" % (object_id << 1)
    end
  end
end
