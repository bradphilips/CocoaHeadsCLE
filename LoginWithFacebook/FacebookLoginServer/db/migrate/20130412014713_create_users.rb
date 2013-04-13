class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :email,               :null => false                  # required, you can use login instead, or both
      t.string    :firstname,           :null => false                  # required, users first name

      t.integer   :facebook_uid,        :null => true, :limit => 8      # optional, facebook user id

      # Authentication; uses AuthLogic
      t.string    :crypted_password,    :null => false                  # required, see below
      t.string    :password_salt,       :null => false                  # required, but highly recommended
      t.string    :persistence_token,   :null => false                  # required
      t.string    :perishable_token,    :null => false                  # optional, see Authlogic::Session::Perishability

      # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by
      # Authlogic if they are present.
      t.integer   :login_count,         :null => false, :default => 0   # required, see Authlogic::Session::MagicColumns
      t.integer   :failed_login_count,  :null => false, :default => 0   # required, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                        # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                     # optional, see Authlogic::Session::MagicColumns

      t.timestamps
    end
  end
end
