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
end
