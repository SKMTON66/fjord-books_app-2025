# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'ユーザー名が登録されている場合はユーザー名を表示' do
    user = users(:alice)
    assert_equal 'Alice', user.name_or_email
  end
  test 'ユーザー名が登録されていない場合はメールアドレスを表示' do
    user = users(:john_doe)
    assert_equal 'example@example.com', user.name_or_email
  end
end
