class User < ActiveRecord::Base

  attr_accessible :email, :firstname, :password, :password_confirmation, :facebook_uid
  attr_protected :crypted_password, :perishable_token, :persistence_token, :perishable_token
  acts_as_authentic do |config|
    external = Proc.new { |r| r.externally_authenticated }

    config.merge_validates_confirmation_of_password_field_options(:unless => external)
    config.merge_validates_length_of_password_confirmation_field_options(:unless => external)
    config.merge_validates_length_of_password_field_options(:unless => external)
    config.perishable_token_valid_for = 3.days
  end

  def externally_authenticated
    return !facebook_uid.blank?
  end

  def self.ignored_attributes
    [ :persistence_token, :crypted_password, :password_salt, :perishable_token ]
  end
end