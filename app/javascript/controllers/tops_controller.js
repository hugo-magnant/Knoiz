import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  currentTerm = ""; // Variable pour stocker le terme actuel (comme "1 mois", "6 mois", "+1 an")
  currentType = ""; // Variable pour stocker le type d'objet actuel (comme "Tracks" ou "Artists")

  // Méthode pour afficher ou cacher un groupe d'éléments HTML par leur ID
  toggleGroupVisibility(group, shouldShow) {
    group.forEach((elementId) => {
      const element = document.getElementById(elementId);
      shouldShow ? element.classList.remove("hidden") : element.classList.add("hidden");
    });
  }

  // Méthode pour mettre à jour les détails de l'objet actuel dans le DOM
  updateObjectDetails() {
    if (this.currentType) document.getElementById("object-type").innerHTML = this.currentType;
    if (this.currentTerm) document.getElementById("object-term").innerHTML = this.currentTerm;
  }

  // Méthode pour sélectionner "Tracks" comme le type d'objet actuel et mettre à jour le DOM
  tracks() {
    this.currentType = "Tracks";
    this.toggleGroupVisibility(["tracks"], true);
    this.toggleGroupVisibility(["artists"], false);
    this.updateObjectDetails();
  }

  // Méthode pour sélectionner "Artists" comme le type d'objet actuel et mettre à jour le DOM
  artists() {
    this.currentType = "Artists";
    this.toggleGroupVisibility(["tracks"], false);
    this.toggleGroupVisibility(["artists"], true);
    this.updateObjectDetails();
  }

  // Méthode généralisée pour définir le terme et les groupes d'éléments à afficher/cacher
  setTerm(term, visibleIds, hiddenIds) {
    this.currentTerm = term;
    this.toggleGroupVisibility(visibleIds, true);
    this.toggleGroupVisibility(hiddenIds, false);
    this.updateObjectDetails();
  }

  // Méthode pour définir le terme à "1 month" et ajuster la visibilité des éléments en conséquence
  short_term() {
    this.setTerm("1 month", ["short_term_tracks", "short_term_artists"], ["medium_term_tracks", "medium_term_artists", "long_term_tracks", "long_term_artists"]);
  }

  // Méthode pour définir le terme à "6 months" et ajuster la visibilité des éléments en conséquence
  medium_term() {
    this.setTerm("6 months", ["medium_term_tracks", "medium_term_artists"], ["short_term_tracks", "short_term_artists", "long_term_tracks", "long_term_artists"]);
  }

  // Méthode pour définir le terme à "+1 year" et ajuster la visibilité des éléments en conséquence
  long_term() {
    this.setTerm("+1 year", ["long_term_tracks", "long_term_artists"], ["short_term_tracks", "short_term_artists", "medium_term_tracks", "medium_term_artists"]);
  }
}
