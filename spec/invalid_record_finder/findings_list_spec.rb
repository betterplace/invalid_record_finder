require 'spec_helper'

describe InvalidRecordFinder::FindingsList do
  let(:record_with_error) { User.new(first_name: '', id: 7) }
  let(:list) { InvalidRecordFinder::FindingsList.new }

  describe '#add_if_invalid' do
    it 'adds a Finding when given an invalid record' do
      expect { list.add_if_invalid(record_with_error) }
        .to change { list.size }.from(0).to(1)
      expect(list[0]).to be_a InvalidRecordFinder::Finding
      expect(list[0].to_h).to eq(
        model:       'User',
        field:       'first_name',
        field_value: '',
        message:     "can't be blank",
        id:          7,
      )
    end

    it 'does not add valid records' do
      expect { list.add_if_invalid(User.new(first_name: 'ok')) }
        .not_to change { list.size }.from(0)
    end

    it 'turns an exception into its own error' do
      record = User.new(id: 666)
      allow(record).to receive(:valid?).and_raise('ohnoooo')
      list.add_if_invalid(record)
      expect(list[0].to_h).to eq(
        model:       'User',
        field:       'EXCEPTION',
        field_value: nil,
        message:     'ohnoooo',
        id:          666,
      )
    end
  end

  describe '#to_table' do
    it 'turns the list into an ascii table' do
      list.add_if_invalid(record_with_error)
      expect(list.to_table.to_s).to eq <<~EOS.chomp
        +-------+------------+-------------+----------------+----+
        | model | field      | field_value | message        | id |
        +-------+------------+-------------+----------------+----+
        | User  | first_name |             | can't be blank |  7 |
        +-------+------------+-------------+----------------+----+
      EOS
    end

    it 'does not line-wrap UUIDs' do
      record_with_error = Blog.new(id: '123e4567e89b12d3a456426614174000')
      list.add_if_invalid(record_with_error)
      finding = list[0]
      long_string = 'a veryveryvery veryveryveryveryvery long string'
      expect(finding).to receive(:model).at_least(:once).and_return long_string
      expect(finding).to receive(:field).at_least(:once).and_return long_string
      expect(finding).to receive(:field_value).at_least(:once).and_return long_string
      expect(finding).to receive(:message).at_least(:once).and_return long_string

      expect(list.to_table.to_s).to include('123e4567e89b12d3a456426614174000')
    end

    it 'only returns the first 100 errors' do
      200.times { list.add_if_invalid(record_with_error) }
      expect(list.to_table.to_s.lines.count).to eq 104
    end
  end

  describe '#to_csv' do
    it 'returns a proper csv' do
      list.add_if_invalid(record_with_error)
      expect(list.to_csv).to eq <<~END
        model,field,field_value,message,id
        User,first_name,"",can't be blank,7
      END
    end
  end
end
