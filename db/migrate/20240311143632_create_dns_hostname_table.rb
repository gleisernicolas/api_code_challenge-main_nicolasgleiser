class CreateDnsHostnameTable < ActiveRecord::Migration[6.1]
  def change
    create_table :dns_hostnames do |t|
      t.integer :dns_id, null: false, foreign_key: true
      t.integer :hostname_id, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
