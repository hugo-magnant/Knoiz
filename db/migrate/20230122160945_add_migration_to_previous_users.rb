class AddMigrationToPreviousUsers < ActiveRecord::Migration[7.0]
  def up
    User.all.each do |user|
      user.create_subscription
    end
  end
end
