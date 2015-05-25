class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :username, :limit => 64
    	t.string :display_name
    	t.string :first_name
    	t.string :last_name
    	t.string :email
    	t.string :password
    	t.string :password_hash
    	t.string :provider
    	t.string :uid
    	t.string :oauth_token
    	t.datetime :oauth_expires_at 
      t.timestamps
    end
  end
end
