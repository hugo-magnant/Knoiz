import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["countdown"];

  // Exécuté lors de la connexion du contrôleur à un élément du DOM
  connect() {
    // Récupération de l'attribut data-timestamp et du temps actuel
    const timestamp = this.element.getAttribute("data-timestamp");
    const now = Math.floor(Date.now() / 1000);

    // Récupération du bouton à soumettre
    const submitBtn = document.getElementById("submitBtn");

    // Vérification de l'état de l'abonnement
    const hasSubscription = this.element.getAttribute("data-subscription") === "true";
    
    // Calcul du temps restant en fonction de l'abonnement
    const oneWeekInSeconds = 7 * 24 * 60 * 60;
    const timeLeft = hasSubscription ? 60 - (now - timestamp) : oneWeekInSeconds - (now - timestamp);

    if (timeLeft > 0) {
      // Démarrage du compte à rebours
      this.startCountdown(timeLeft, submitBtn);

      // Désactivation du bouton
      this.toggleButtonState(submitBtn, false);
    }
  }

  // Fonction pour gérer l'état du bouton
  toggleButtonState(btn, isEnabled) {
    const classList = btn.classList;
    if (isEnabled) {
      classList.add("cursor-pointer", "hover:bg-spotify-vert-hover");
      classList.remove("cursor-not-allowed", "opacity-50");
      btn.disabled = false;
    } else {
      classList.remove("cursor-pointer", "hover:bg-spotify-vert-hover");
      classList.add("cursor-not-allowed", "opacity-50");
      btn.disabled = true;
    }
  }

  // Fonction pour démarrer le compte à rebours
  startCountdown(timeLeft, submitBtn) {
    this.countdownTarget.innerText = timeLeft;

    // Mise à jour du compte à rebours toutes les secondes
    setInterval(() => {
      timeLeft--;

      if (timeLeft <= 0) {
        // Réinitialisation et activation du bouton
        this.countdownTarget.innerText = "";
        this.toggleButtonState(submitBtn, true);
      } else {
        // Mise à jour de l'affichage du compte à rebours
        const days = Math.floor(timeLeft / (3600 * 24));
        const hours = Math.floor(timeLeft / 3600);
        const minutes = Math.floor((timeLeft % 3600) / 60);
        const seconds = timeLeft % 60;
        this.countdownTarget.innerText = `${days}d ${hours.toString().padStart(2, "0")}h ${minutes.toString().padStart(2, "0")}m ${seconds.toString().padStart(2, "0")}s`;
      }
    }, 1000);
  }
}
