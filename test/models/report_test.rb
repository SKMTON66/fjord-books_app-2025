# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '日報の作成者と同じユーザーなら編集できる' do
    user = users(:alice)
    report = reports(:alice_report)

    assert report.editable?(user)
  end
  test '日報の作成者と違うユーザーは編集できない' do
    user = users(:alice)
    report = reports(:bob_report)

    assert_not report.editable?(user)
  end
  test 'created_onの日付を返す' do
    report = reports(:alice_report)
    report.created_at = Time.zone.parse('2026-08-12 15:30:45')

    assert_equal Date.new(2026, 8, 12), report.created_on
  end
  test '複数の日報への言及を保存できる' do
    report = reports(:alice_report)
    mentioned_report1 = reports(:bob_report)
    mentioned_report2 = reports(:john_doe_report)
    report.update!(content: <<~CONTENT
      http://localhost:3000/reports/#{mentioned_report1.id}
      http://localhost:3000/reports/#{mentioned_report2.id}
    CONTENT
                  )

    assert_equal [mentioned_report1.id, mentioned_report2.id].sort, report.mentioning_report_ids.sort
  end

  test '日報を更新した際に言及内容も更新される' do
    report = reports(:alice_report)
    mentioned_report1 = reports(:bob_report)
    mentioned_report2 = reports(:john_doe_report)
    new_report = reports(:charlie_report)
    report.update!(content: <<~CONTENT
      http://localhost:3000/reports/#{mentioned_report1.id}
      http://localhost:3000/reports/#{mentioned_report2.id}
    CONTENT
                  )

    report.update!(content: <<~CONTENT
      http://localhost:3000/reports/#{mentioned_report1.id}
      http://localhost:3000/reports/#{new_report.id}
    CONTENT
                  )

    assert_equal [mentioned_report1.id, new_report.id].sort, report.reload.mentioning_report_ids.sort
  end
  test '言及が重複しても1件のみ保存される' do
    report = reports(:alice_report)
    mentioned_report = reports(:bob_report)
    report.update!(content: <<~CONTENT
      http://localhost:3000/reports/#{mentioned_report.id}
      http://localhost:3000/reports/#{mentioned_report.id}
    CONTENT
                  )

    assert_equal [mentioned_report.id], report.mentioning_report_ids
  end
  test '自分自身への言及は除外される' do
    report = reports(:alice_report)
    mentioned_report = reports(:bob_report)
    report.update!(content: <<~CONTENT
      http://localhost:3000/reports/#{report.id}
      http://localhost:3000/reports/#{mentioned_report.id}
    CONTENT
                  )

    assert_not_includes report.mentioning_reports, report
    assert_includes report.mentioning_reports, mentioned_report
  end
end
