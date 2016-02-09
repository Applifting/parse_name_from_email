require 'spec_helper'

describe ParseNameFromEmail::Configuration do
  let(:configuration) { described_class.new }

  it 'sets the default regexp' do
    expect(configuration.regexp).to eq /(?=[A-Z])|(?:([0-9]+))|\.|-|\?|!|\+|\;|\_/
  end

  it 'sets default value for friendly plus part to true' do
    expect(configuration.friendly_plus_part).to be true
  end

end