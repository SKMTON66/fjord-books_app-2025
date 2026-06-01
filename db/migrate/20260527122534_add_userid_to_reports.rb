class AddUseridToReports < ActiveRecord::Migration[8.0]
  def change
    add_reference :reports, :user, null: true, foreign_key: true
  end
end
