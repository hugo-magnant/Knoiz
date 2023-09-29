class ApplicationController < ActionController::Base
  protect_from_forgery

  # CurrentUserConcern est responsable de la gestion de l'utilisateur courant de la session.
  include CurrentUserConcern
  # StripeSubscriptionConcern gère la logique liée aux abonnements Stripe de l'utilisateur courant.
  include StripeSubscriptionConcern
  # SpotifyConcern gère la logique liée à l'intégration de Spotify, notamment le rafraîchissement du jeton d'accès.
  include SpotifyConcern
  # StatsConcern s'occupe de la collecte et de la mise à jour des statistiques liées à l'utilisateur.
  include StatsConcern
end
