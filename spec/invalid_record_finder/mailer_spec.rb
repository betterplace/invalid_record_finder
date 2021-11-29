require 'spec_helper'

describe InvalidRecordFinder::Mailer do
  it 'builds mails' do
    invalid_user = User.new(first_name: '', id: 7)
    findings_list = InvalidRecordFinder::FindingsList.new
    findings_list.add_if_invalid(invalid_user)
    expect(findings_list.size).to eq 1

    mail = InvalidRecordFinder::Mailer.mail(
      model_name:     'USER',
      findings_list:  findings_list,
      from:           'no-reply@example.com',
      to:             'developers@example.com',
      subject_prefix: '[IMPORTANT]',
    )

    expect(mail.from).to eq ['no-reply@example.com']
    expect(mail.to).to eq ['developers@example.com']
    expect(mail.subject).to eq '[IMPORTANT] InvalidRecordFinder found 1 invalid USER records'
    expect(mail.text_part.body).to match(/User .* first_name .* can't be blank .* #{invalid_user.id}/)
  end
end
