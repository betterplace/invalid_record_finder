require 'spec_helper'

describe InvalidRecordFinder::Finding do
  let(:user) { User.new(first_name: 'Daniel', id: 7) }

  it 'can be turned into an Array' do
    finding = InvalidRecordFinder::Finding.new(user, 'first_name', 'an error')
    expect(finding.to_a).to eq ['User', 'first_name', 'Daniel', 'an error', 7]
  end

  it 'can be turned into a Hash' do
    finding = InvalidRecordFinder::Finding.new(user, 'first_name', 'an error')
    expect(finding.to_h).to eq(
      model:       'User',
      field:       'first_name',
      field_value: 'Daniel',
      message:     'an error',
      id:          7,
    )
  end
end
