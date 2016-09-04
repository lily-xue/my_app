class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.date :start_day
      t.date :end_day
      t.string :application_reasons
      t.string :admin_comments
      t.string :status,default: "申请中"

      t.timestamps
    end
  end
end
