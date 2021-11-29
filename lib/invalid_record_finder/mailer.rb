begin
  require 'action_mailer'
rescue LoadError
  # leave this class undefined if ActionMailer is not present
  return
end

module InvalidRecordFinder

  # sends mails
  class Mailer < ActionMailer::Base
    def mail(model_name:, findings_list:, from:, to:, subject_prefix: nil)
      attachments["#{model_name}.csv"] = findings_list.to_csv
      super(
        from:    from,
        to:      to,
        body:    build_body(model_name, findings_list),
        subject: build_subject(model_name, findings_list, subject_prefix),
      )
    end

    private

    def build_body(model_name, findings_list)
      <<~END
        # Errors on #{model_name}
        ```
        #{findings_list.to_table}
        ```
      END
    end

    def build_subject(model_name, findings_list, prefix)
      [
        prefix,
        "InvalidRecordFinder found #{findings_list.size} invalid #{model_name} records",
      ].compact.join(' ')
    end
  end
end
