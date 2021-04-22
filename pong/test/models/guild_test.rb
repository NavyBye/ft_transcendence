require "test_helper"

class GuildTest < ActiveSupport::TestCase
  def setup
    @test_guild = guilds(:one)
  end
  test "guild_name length" do
    @test_guild.name = 'abc'
    assert_not @test_guild.valid?

    @test_guild.name = 'abcd'
    assert @test_guild.valid?

    @test_guild.name = '1234567890'
    assert @test_guild.valid?

    @test_guild.name = '1234567890+'
    assert_not @test_guild.valid?
  end

  test "guild_name length with striping" do
    @test_guild.name = '  abc  '
    assert_not @test_guild.valid?

    @test_guild.name = '  abcd  '
    assert @test_guild.valid?

    @test_guild.name = '   1234567890   '
    assert @test_guild.valid?

    @test_guild.name = '     1234567890+      '
    assert_not @test_guild.valid?
  end

  test "anagram length should be 4" do
    @test_guild.anagram = '123'
    assert_not @test_guild.valid?

    @test_guild.anagram = '1234'
    assert @test_guild.valid?

    @test_guild.anagram = '12345'
    assert_not @test_guild.valid?

    @test_guild.anagram = '1234567890+'
    assert_not @test_guild.valid?
  end

  test "anagram length should be 4 with strip" do
    @test_guild.anagram = ' 123 '
    assert_not @test_guild.valid?

    @test_guild.anagram = ' 1234 '
    assert @test_guild.valid?

    @test_guild.anagram = ' 1  4 '
    assert @test_guild.valid?

    @test_guild.anagram = ' 12345  '
    assert_not @test_guild.valid?

    @test_guild.anagram = '  1   5  '
    assert_not @test_guild.valid?
  end

  test "guild name uniqueness" do
    @test_guild.name = 'test2'
    assert_not @test_guild.valid?

    @test_guild.name = 'lotto'
    assert @test_guild.valid?

    @test_guild.name = '  test2  '
    assert_not @test_guild.valid?

    @test_guild.name = ' pow pow '
    assert @test_guild.valid?
  end

  test "guild anagram uniqueness" do
    @test_guild.anagram = 'HELL'
    assert_not @test_guild.valid?

    @test_guild.anagram = 'TEST'
    assert @test_guild.valid?

    @test_guild.anagram = '  HELL  '
    assert_not @test_guild.valid?

    @test_guild.anagram = ' T  T '
    assert @test_guild.valid?
  end
end
