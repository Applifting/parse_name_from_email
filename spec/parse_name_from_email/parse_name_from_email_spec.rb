require 'spec_helper'

describe ParseNameFromEmail do
  let(:parse_name_from_email) { described_class }

  it 'sets custom regex' do
    parse_name_from_email.configure do |config|
      config.regex = /(?=[A-Z])/
    end

    expect(parse_name_from_email.configuration.regex).to eq /(?=[A-Z])/

    parse_name_from_email.reset # reset back to defaults
  end
  
  it 'customizes friendly plus part' do
    parse_name_from_email.configure do |config|
      config.friendly_plus_part = false
    end

    expect(parse_name_from_email.configuration.friendly_plus_part).to be false

    parse_name_from_email.reset # reset back to defaults
  end

  it 'should split string by @' do
    email = 'some-email@example.com'
    expect(parse_name_from_email.get_email_name(email)).to eq('some-email')
  end

  it 'should split string by +' do
    email = 'some-email+extended@example.com'
    expect(parse_name_from_email.split_plus_part(email)).to eq %w(some-email extended@example.com)
  end

  it 'should split string by default regex' do
    email = 'Some-myEmail+extended@example.com'
    expect(parse_name_from_email.split_to_words(email)).to eq %w(Some my Email extended@example com)
  end

  describe 'valid parsing outputs' do

    it 'should parse by \.' do
      email = 'some.email@example.com'
      expect(parse_name_from_email.parse_name_from(email)).to eq 'Some Email'
    end

    it 'should parse by \-' do
      email = 'some-email@example.com'
      expect(parse_name_from_email.parse_name_from(email)).to eq 'Some Email'
    end

    it 'should parse by \!' do
      email = 'some!email@example.com'
      expect(parse_name_from_email.parse_name_from(email)).to eq 'Some Email'
    end

    it 'should parse by \?' do
      email = 'some?email@example.com'
      expect(parse_name_from_email.parse_name_from(email)).to eq 'Some Email'
    end

    it 'should parse by \;' do
      email = 'some;email@example.com'
      expect(parse_name_from_email.parse_name_from(email)).to eq 'Some Email'
    end

    it 'should parse by \_' do
      email = 'some_email@example.com'
      expect(parse_name_from_email.parse_name_from(email)).to eq 'Some Email'
    end

    it 'should parse by set of numbers' do
      email = 'some123email@example.com'
      expect(parse_name_from_email.parse_name_from(email)).to eq 'Some 123 Email'
    end

    it 'should parse by big chars' do
      email = 'SomeEmail@example.com'
      expect(parse_name_from_email.parse_name_from(email)).to eq 'Some Email'
    end

    it 'should friendly parse by \+' do
      email = 'some+email@example.com'
      expect(parse_name_from_email.parse_name_from(email)).to eq 'Some (email)'
    end

    it 'should not friendly parse by \+ if not configured' do
      parse_name_from_email.configure do |config|
        config.friendly_plus_part = false
      end

      email = 'some+email@example.com'
      expect(parse_name_from_email.parse_name_from(email)).to eq 'Some Email'

      parse_name_from_email.reset # reset back to defaults
    end

    it 'should not parse because not regex valid character' do
      email = 'someemail@example.com'
      expect(parse_name_from_email.parse_name_from(email)).to eq 'Someemail'
    end

  end

end