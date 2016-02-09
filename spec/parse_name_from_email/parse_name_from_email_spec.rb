require 'spec_helper'

describe ParseNameFromEmail do
  let(:parse_name_from_email) { described_class }

  it 'sets custom regexp' do
    parse_name_from_email.configure do |config|
      config.regexp = /(?=[A-Z])/
    end

    expect(parse_name_from_email.configuration.regexp).to eq /(?=[A-Z])/

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

  it 'should split string by default regexp' do
    email = 'Some-myEmail+extended@example.com'
    expect(parse_name_from_email.split_to_words(email)).to eq %w(Some my Email extended@example com)
  end

  describe 'validation of rfc format' do
    it 'should be valid in full format' do
      email = 'Firstname Lastname <firstname.lastname@example.com>'
      expect(parse_name_from_email.valid_rfc_format?(email)).to be true
    end

    it 'should be valid without name' do
      email = '<firstname.lastname@example.com>'
      expect(parse_name_from_email.valid_rfc_format?(email)).to be true
    end

    it 'should be valid format with numbers and \-' do
      email = 'First123Name Last-Name <first123name.last-name@ex9ample.it>'
      expect(parse_name_from_email.valid_rfc_format?(email)).to be true
    end

    it 'should be invalid format wihtout \<' do
      email = 'firstname.lastname@example.com>'
      expect(parse_name_from_email.valid_rfc_format?(email)).to be false
    end

    it 'should be invalid format wihtout \>' do
      email = 'firstname.lastname@example.com>'
      expect(parse_name_from_email.valid_rfc_format?(email)).to be false
    end
  end

  describe 'valid parsing outputs' do
    it 'should parse correct RFC format of email' do
      email = 'Firstname Lastname <firstname.lastname@example.com>'
      expect(parse_name_from_email.parse_name_from(email)).to eq 'Firstname Lastname'
    end

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

    it 'should not parse because not regexp valid character' do
      email = 'someemail@example.com'
      expect(parse_name_from_email.parse_name_from(email)).to eq 'Someemail'
    end

  end

  describe 'valid simple batch parsing output' do
    it 'should valid parse names from rfc emails' do
      string_with_emails = 'John Snow <john.snow@example.com>, Lily Black <lilyblack@example.com>, Alice White <alice.123@3x4mpl3.app>'
      expect(parse_name_from_email.parse_names_from(string_with_emails)).to eq ['John Snow', 'Lily Black', 'Alice White']
    end

    it 'should valid parse names from rfc emails, but some email is without name' do
      string_with_emails = 'John Snow <john.snow@example.com>, Lily Black <lilyblack@example.com>, alice.123@3x4mpl3.app'
      expect(parse_name_from_email.parse_names_from(string_with_emails)).to eq ['John Snow', 'Lily Black', 'Alice 123']
    end

    it 'should valid parse names in non rfc format of emails' do
      string_with_emails = 'john.snow@example.com, LilyBlack@example.com, alice.123@3x4mpl3.app'
      expect(parse_name_from_email.parse_names_from(string_with_emails)).to eq ['John Snow', 'Lily Black', 'Alice 123']
    end

    it 'should valid parse names in non rfc format of emails and any email is with \+' do
      string_with_emails = 'john.snow@example.com, lily+black@example.com, alice.123@3x4mpl3.app'
      expect(parse_name_from_email.parse_names_from(string_with_emails)).to eq ['John Snow', 'Lily (black)', 'Alice 123']
    end
  end

  describe 'valid advanced batch parsing output' do
    it 'should valid parse names from rfc emails' do
      string_with_emails = 'John Snow <john.snow@example.com>, Lily Black <lilyblack@example.com>, Alice White <alice.123@3x4mpl3.app>'
      expected_hash = {'john.snow@example.com' => 'John Snow', 'lilyblack@example.com' => 'Lily Black', 'alice.123@3x4mpl3.app' => 'Alice White'}

      expect(parse_name_from_email.parse_emails_with_names_from(string_with_emails)).to eq expected_hash
    end

    it 'should valid parse names from rfc emails, but some email is without name' do
      string_with_emails = 'John Snow <john.snow@example.com>, Lily Black <lilyblack@example.com>, alice.123@3x4mpl3.app'
      expected_hash = {'john.snow@example.com' => 'John Snow', 'lilyblack@example.com' => 'Lily Black', 'alice.123@3x4mpl3.app' => 'Alice 123'}

      expect(parse_name_from_email.parse_emails_with_names_from(string_with_emails)).to eq expected_hash
    end

    it 'should valid parse names in non rfc format of emails' do
      string_with_emails = 'john.snow@example.com, LilyBlack@example.com, alice.123@3x4mpl3.app'
      expected_hash = {'john.snow@example.com' => 'John Snow', 'LilyBlack@example.com' => 'Lily Black', 'alice.123@3x4mpl3.app' => 'Alice 123'}

      expect(parse_name_from_email.parse_emails_with_names_from(string_with_emails)).to eq expected_hash
    end

    it 'should valid parse names in non rfc format of emails and any email is with \+' do
      string_with_emails = 'john.snow@example.com, lily+black@example.com, alice.123@3x4mpl3.app'
      expected_hash = {'john.snow@example.com' => 'John Snow', 'lily+black@example.com' => 'Lily (black)', 'alice.123@3x4mpl3.app' => 'Alice 123'}

      expect(parse_name_from_email.parse_emails_with_names_from(string_with_emails)).to eq expected_hash
    end
  end

end