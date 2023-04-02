import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  tracks() {
    if (document.getElementById("tracks").classList.contains("hidden")) {
      document.getElementById("tracks").classList.remove("hidden");
    }
    if (!document.getElementById("artists").classList.contains("hidden")) {
      document.getElementById("artists").classList.add("hidden");
    }
    document.getElementById("object-type").innerHTML = "Tracks";
  }

  artists() {
    if (!document.getElementById("tracks").classList.contains("hidden")) {
      document.getElementById("tracks").classList.add("hidden");
    }
    if (document.getElementById("artists").classList.contains("hidden")) {
      document.getElementById("artists").classList.remove("hidden");
    }
    document.getElementById("object-type").innerHTML = "Artists";
  }

  short_term() {
    if (
      document.getElementById("short_term_tracks").classList.contains("hidden")
    ) {
      document.getElementById("short_term_tracks").classList.remove("hidden");
    }
    if (
      document.getElementById("short_term_artists").classList.contains("hidden")
    ) {
      document.getElementById("short_term_artists").classList.remove("hidden");
    }

    if (
      !document
        .getElementById("medium_term_tracks")
        .classList.contains("hidden")
    ) {
      document.getElementById("medium_term_tracks").classList.add("hidden");
    }
    if (
      !document
        .getElementById("medium_term_artists")
        .classList.contains("hidden")
    ) {
      document.getElementById("medium_term_artists").classList.add("hidden");
    }

    if (
      !document.getElementById("long_term_tracks").classList.contains("hidden")
    ) {
      document.getElementById("long_term_tracks").classList.add("hidden");
    }
    if (
      !document.getElementById("long_term_artists").classList.contains("hidden")
    ) {
      document.getElementById("long_term_artists").classList.add("hidden");
    }

    document.getElementById("object-term").innerHTML = "1 month";
  }

  medium_term() {
    if (
      !document.getElementById("short_term_tracks").classList.contains("hidden")
    ) {
      document.getElementById("short_term_tracks").classList.add("hidden");
    }
    if (
      !document
        .getElementById("short_term_artists")
        .classList.contains("hidden")
    ) {
      document.getElementById("short_term_artists").classList.add("hidden");
    }

    if (
      document.getElementById("medium_term_tracks").classList.contains("hidden")
    ) {
      document.getElementById("medium_term_tracks").classList.remove("hidden");
    }
    if (
      document
        .getElementById("medium_term_artists")
        .classList.contains("hidden")
    ) {
      document.getElementById("medium_term_artists").classList.remove("hidden");
    }

    if (
      !document.getElementById("long_term_tracks").classList.contains("hidden")
    ) {
      document.getElementById("long_term_tracks").classList.add("hidden");
    }
    if (
      !document.getElementById("long_term_artists").classList.contains("hidden")
    ) {
      document.getElementById("long_term_artists").classList.add("hidden");
    }

    document.getElementById("object-term").innerHTML = "6 months";
  }

  long_term() {
    if (
      !document.getElementById("short_term_tracks").classList.contains("hidden")
    ) {
      document.getElementById("short_term_tracks").classList.add("hidden");
    }
    if (
      !document
        .getElementById("short_term_artists")
        .classList.contains("hidden")
    ) {
      document.getElementById("short_term_artists").classList.add("hidden");
    }

    if (
      !document
        .getElementById("medium_term_tracks")
        .classList.contains("hidden")
    ) {
      document.getElementById("medium_term_tracks").classList.add("hidden");
    }
    if (
      !document
        .getElementById("medium_term_artists")
        .classList.contains("hidden")
    ) {
      document.getElementById("medium_term_artists").classList.add("hidden");
    }

    if (
      document.getElementById("long_term_tracks").classList.contains("hidden")
    ) {
      document.getElementById("long_term_tracks").classList.remove("hidden");
    }
    if (
      document.getElementById("long_term_artists").classList.contains("hidden")
    ) {
      document.getElementById("long_term_artists").classList.remove("hidden");
    }

    document.getElementById("object-term").innerHTML = "1 year";
  }
}
