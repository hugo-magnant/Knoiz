class Profile < ApplicationRecord
  before_create :set_username

  belongs_to :user

  private

  def set_username
    self.username = self.user.email.split("@").first
  end

end
