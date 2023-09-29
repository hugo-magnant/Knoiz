# Le module StatsHelper contient des méthodes d'aide pour la gestion de l'affichage des statistiques et des tops.
module StatsHelper
  # Liste des types de pages qui peuvent être affichées
  DISPLAYABLE_PAGES = %w[stats tops recently top_global].freeze

  def display_stats?
    display_page?("stats")
  end

  def display_tops?
    display_page?("tops")
  end

  def display_recently?
    display_page?("recently")
  end

  def display_top_global?
    display_page?("top_global")
  end

  private

  # Vérifie si le paramètre de page correspond à une page spécifiée.
  def display_page?(page)
    DISPLAYABLE_PAGES.include?(params[:page]) && params[:page] == page
  end
end
