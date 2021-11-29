require 'spec_helper'

describe InvalidRecordFinder do
  it 'has a version number' do
    expect(InvalidRecordFinder::VERSION).not_to be nil
  end

  it 'uses ModelPicker to pick models to investigate, passing them to Scanner' do
    expect(InvalidRecordFinder::ModelPicker)
      .to receive(:call)
      .with(given_models: :foo, ignored_models: :bar, ignored_namespaces: :baz)
      .and_return(:model_picker_result)

    expect(InvalidRecordFinder::Scanner)
      .to receive(:call)
      .with(models: :model_picker_result, verbose: false)
      .and_return(:scanner_result)

    result = InvalidRecordFinder.call(
      models: :foo,
      ignored_models: :bar,
      ignored_namespaces: :baz,
    )

    expect(result).to eq :scanner_result
  end
end
