# frozen_string_literal: true

class Report < ApplicationRecord
  after_save :update_mentions

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :active_report_mentions,
           class_name: 'ReportMention',
           foreign_key: :mentioning_report_id,
           inverse_of: :mentioning_report,
           dependent: :destroy

  has_many :mentioning_reports,
           through: :active_report_mentions,
           source: :mentioned_report

  has_many :passive_report_mentions,
           class_name: 'ReportMention',
           foreign_key: :mentioned_report_id,
           inverse_of: :mentioned_report,
           dependent: :destroy

  has_many :mentioned_reports,
           through: :passive_report_mentions,
           source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def mentioned_report_ids
    content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i)
  end

  def update_mentions
    active_report_mentions.destroy_all

    mentioned_report_ids.each do |report_id|
      active_report_mentions.create!(mentioned_report_id: report_id)
    end
  end
end
