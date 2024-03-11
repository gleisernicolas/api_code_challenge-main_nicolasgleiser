class CreateIpTable < ActiveRecord::Migration[6.1]
  def change
    create_table :ip_tables do |t|
      t.string :value

      t.timestamps
    end
  end
end
