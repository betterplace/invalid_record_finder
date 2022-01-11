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

  it 'stores UUIDs in condensed format' do
    blog = Blog.new(id: '123e4567-e89b-12d3-a456-426614174000')
    finding = InvalidRecordFinder::Finding.new(blog, 'title', 'an error')
    expect(finding.id).to eq '123e4567e89b12d3a456426614174000'
  end

  it 'works with other primary_key values' do
    expect(user.class).to receive(:primary_key).and_return :first_name
    finding = InvalidRecordFinder::Finding.new(user, 'first_name', 'an error')
    expect(finding.id).to eq 'Daniel'
  end
end
