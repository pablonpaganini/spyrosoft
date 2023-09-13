class CreateTableros < ActiveRecord::Migration[7.0]
  def change
    create_table :tableros do |t|
      t.text :state
      t.boolean :game_end,  default: false
      t.timestamps
    end
  end
end
