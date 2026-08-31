# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:alice_report)
    visit reports_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'Password!'
    click_button 'ログイン'
    assert_text 'ログインしました'
  end
  test '日報の一覧を表示' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test '日報を作成' do
    visit reports_url
    click_on '日報の新規作成'
    fill_in 'タイトル', with: '海賊王に'
    fill_in '内容', with: '俺はなる！！'
    click_on '登録する'
    assert_text '日報が作成されました。'
    assert_text '海賊王に'
    assert_text '俺はなる！！'
    click_on '日報の一覧に戻る'
  end

  test '日報を編集' do
    visit report_url(@report)
    click_on 'この日報を編集', match: :first
    fill_in 'タイトル', with: '冥王'
    fill_in '内容', with: 'レイリー'
    click_on '更新する'
    assert_text '日報が更新されました。'
    assert_text '冥王'
    assert_text 'レイリー'
    click_on '日報の一覧に戻る'
  end

  test '日報を削除' do
    visit report_url(@report)
    click_on 'この日報を削除', match: :first
    assert_text '日報が削除されました。'
    assert_no_text @report.title
  end
end
