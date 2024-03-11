class CreateDnsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :dns do |t|
      t.string :ip, null: false

      t.timestamps
    end
  end
end
