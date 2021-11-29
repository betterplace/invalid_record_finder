require 'spec_helper'

describe InvalidRecordFinder::Scanner do
  let(:scanner) { InvalidRecordFinder::Scanner }

  it 'finds invalid records' do
    User.create!(first_name: 'ok') # valid user
    invalid_user = User.new(first_name: '')
    invalid_user.save!(validate: false)

    result = scanner.call(models: [Blog, User])

    expect(result).to be_a(InvalidRecordFinder::Result)
    expect(result.to_h.keys.sort).to eq ['Blog', 'User']
    expect(result.to_h.values).to all(be_a InvalidRecordFinder::FindingsList)
    expect(result['Blog']).to be_empty
    expect(result['User'].size).to eq 1
    expect(result['User'][0]).to be_a InvalidRecordFinder::Finding
    expect(result['User'][0].id).to eq invalid_user.id

    User.destroy_all # cleanup
  end
end
