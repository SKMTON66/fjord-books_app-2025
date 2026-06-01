class ChangeTitleNullInReports < ActiveRecord::Migration[8.0]
  def change
    change_column_null :reports, :title, false
  end
end
