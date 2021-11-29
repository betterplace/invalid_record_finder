require 'spec_helper'

describe InvalidRecordFinder::Result do
  let(:result) do
    InvalidRecordFinder::Result.new('User' => user_list, 'Blog' => blog_list)
  end
  let(:user_list) do
    list = InvalidRecordFinder::FindingsList.new
    list.add_if_invalid(invalid_user)
    list
  end
  let(:invalid_user) { User.new(id: 7, first_name: '') }
  let(:blog_list) do
    list = InvalidRecordFinder::FindingsList.new
    list.add_if_invalid(invalid_blog)
    list
  end
  let(:invalid_blog) { Blog.new(id: 8, title: '') }

  describe '#flatten' do
    it 'combines all FindingsLists into one' do
      combined_list = InvalidRecordFinder::FindingsList.new
      combined_list.add_if_invalid(invalid_user)
      combined_list.add_if_invalid(invalid_blog)

      expect(result.flatten.to_h).to eq('ApplicationRecord' => combined_list)
    end
  end

  describe '#mail' do
    it 'sends one mail built by the Mailer per FindingsList' do
      expect(InvalidRecordFinder::Mailer).to receive(:mail)
        .with(hash_including(model_name: 'User', findings_list: user_list))
        .and_call_original
      expect(InvalidRecordFinder::Mailer).to receive(:mail)
        .with(hash_including(model_name: 'Blog', findings_list: blog_list))
        .and_call_original

      expect { result.mail(from: 'a@example.com', to: 'b@example.com') }
        .to change { ActionMailer::Base.deliveries.count }.from(0).to(2)
    end
  end

  describe '#save_csvs' do
    it 'writes one csv file per FindingsList, returning the file paths' do
      csv_dir = result.default_csv_dir
      FileUtils.rm_rf(csv_dir) if Dir.exist?(csv_dir)

      expect do
        return_value = result.save_csvs
        expect(return_value).to be_an Array
        expect(return_value.size).to eq 2
        expect(return_value).to all(match /.csv\z/)
      end.to change { Dir["#{csv_dir}/*.csv"].count }.from(0).to(2)
    end
  end

  describe '#inspect' do
    it 'does not spam the console with its potentially large hash' do
      expect(InvalidRecordFinder::Result.new(foo: :bar).inspect)
        .to match /\A#<InvalidRecordFinder::Result:0x\h+>\z/
    end
  end
end
