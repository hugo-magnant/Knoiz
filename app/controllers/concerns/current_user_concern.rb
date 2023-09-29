module CurrentUserConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
  end

  private

  # Elle est utilisée pour stocker l'utilisateur actuellement connecté
  def set_current_user
    # Trouve l'utilisateur en fonction de l'ID stocké dans la session et l'assigne à la variable d'instance @current_user
    @current_user = User.find_by(id: session[:user_id])

    # Gestion des exceptions si l'utilisateur n'est pas trouvé
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("User not found: #{e.message}")
  end
end
