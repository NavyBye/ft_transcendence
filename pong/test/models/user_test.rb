require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @valid_user = users(:hyeyoo)
  end

  test 'valid normal case' do
    assert @valid_user.valid?
  end

  # nickname test
  test 'nickname uniqueness validations' do
    @dupl_user = users(:hyeyoo_duplicated)
    @dupl_user.nickname = @valid_user.nickname
    assert_not @dupl_user.valid?

    @dupl_user.nickname = "\r\n #{@valid_user.nickname} "
    assert_not @dupl_user.valid?

    # test with stripped
    @valid_user.nickname = 'newcomer'
    @dupl_user.nickname = @valid_user.nickname
    assert @dupl_user.valid?
  end

  test 'nickname length validations' do
    @valid_user.nickname = 'aa'
    assert @valid_user.valid?
    @valid_user.nickname = 'aaaaaaaaaaaaaaaaaaaa'
    assert @valid_user.valid?

    @valid_user.nickname = 'a'
    assert_not @valid_user.valid?
    @valid_user.nickname = 'aaaaaaaaaaaaaaaaaaaaa'
    assert_not @valid_user.valid?
    # test with stripped
    @valid_user.nickname = " a \r \n "
    assert_not @valid_user.valid?
  end

  # status test
  test 'status validations' do
    assert_raises ArgumentError do
      @valid_user.status = -1
    end
    assert_raises ArgumentError do
      @valid_user.status = 4
    end
    (0..3).each do |i|
      @valid_user.status = i
      assert @valid_user.valid?
    end
  end

  test 'trophy validation' do
    @valid_user.trophy = -1
    assert_not @valid_user.valid?
  end

  test 'presence test' do
    @valid_user.status = nil
    assert_not @valid_user.valid?
    @valid_user.status = 0

    @valid_user.is_banned = nil
    assert_not @valid_user.valid?
    @valid_user.is_banned = false

    @valid_user.is_email_auth = nil
    assert_not @valid_user.valid?
    @valid_user.is_email_auth = false

    @valid_user.rating = nil
    assert_not @valid_user.valid?
    @valid_user.rating = 1500

    @valid_user.rank = nil
    assert_not @valid_user.valid?
    @valid_user.rank = 1

    @valid_user.trophy = nil
    assert_not @valid_user.valid?
    @valid_user.trophy = 10
  end

  test 'image can be updated' do
    file_dir = Rails.root.join('test/fixtures/files/')
    user = users(:user_without_image)
    assert_changes 'user.reload.image' do
      File.open(file_dir.join('rails_logo.png')) do |opened_image|
        user.image = opened_image
        user.save!
      end
    end
  end

  # role test
  test 'role validations' do
    assert_raises ArgumentError do
      @valid_user.role = -1
    end
    assert_raises ArgumentError do
      @valid_user.role = 3
    end
    (0..2).each do |i|
      @valid_user.status = i
      assert @valid_user.valid?
    end
  end
end
