require 'spec_helper'

describe InvalidRecordFinder::ModelPicker do
  let(:picker) { InvalidRecordFinder::ModelPicker }

  it 'returns all ApplicationRecord descendants by default' do
    expect(picker.call.sort_by(&:name)).to eq [Blog, User]
  end

  it 'can target specific models' do
    expect(picker.call(given_models: [Blog])).to eq [Blog]
  end

  it 'can target specific scopes' do
    expect(picker.call(given_models: [Blog.none])).to eq [Blog.none]
  end

  it 'supports various input formats' do
    expect(picker.call(given_models: Blog)).to eq [Blog]
    expect(picker.call(given_models: 'Blog')).to eq [Blog]
    expect(picker.call(given_models: %w[Blog])).to eq [Blog]
    expect(picker.call(given_models: nil).sort_by(&:name)).to eq [Blog, User]
    expect(picker.call(given_models: [nil]).sort_by(&:name)).to eq [Blog, User]
  end

  it 'can ignore models' do
    expect(picker.call(ignored_models: Blog)).to eq [User]
  end

  it 'can ignore namespaces' do
    expect(picker.call(ignored_namespaces: 'B')).to eq [User]
  end

  it 'raises if there are no models to look through' do
    expect { picker.call(ignored_models: [Blog, User]) }
      .to raise_error(InvalidRecordFinder::Error)
  end
end
