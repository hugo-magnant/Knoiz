import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["countdown"];

  connect() {
    const timestamp = this.element.getAttribute("data-timestamp");
    const now = Math.floor(Date.now() / 1000);
    const submitBtn = document.getElementById("submitBtn");

    if (this.element.getAttribute("data-subscription") === "true") {
      const timeLeft = 60 - (now - timestamp);
      if (timeLeft > 0) {
        this.startCountdown(timeLeft, submitBtn);
        submitBtn.classList.remove("cursor-pointer");
        submitBtn.classList.remove("hover:bg-spotify-vert-hover");
        submitBtn.classList.add("cursor-not-allowed");
        submitBtn.classList.add("opacity-50");
      }
    } else {
      const timeLeft = 24 * 60 * 60 - (now - timestamp);
      if (timeLeft > 0) {
        this.startCountdown(timeLeft, submitBtn);
        submitBtn.classList.remove("cursor-pointer");
        submitBtn.classList.remove("hover:bg-spotify-vert-hover");
        submitBtn.classList.add("cursor-not-allowed");
        submitBtn.classList.add("opacity-50");
      }
    }
  }

  startCountdown(timeLeft, submitBtn) {
    this.countdownTarget.innerText = timeLeft;

    setInterval(() => {
      timeLeft--;

      if (timeLeft <= 0) {
        this.countdownTarget.innerText = "";
        submitBtn.disabled = false;
        submitBtn.classList.add("cursor-pointer");
        submitBtn.classList.add("hover:bg-spotify-vert-hover");
        submitBtn.classList.remove("cursor-not-allowed");
        submitBtn.classList.remove("opacity-50");
      } else {
        const hours = Math.floor(timeLeft / 3600);
        const minutes = Math.floor((timeLeft % 3600) / 60);
        const seconds = timeLeft % 60;
        this.countdownTarget.innerText = `${hours}:${minutes
          .toString()
          .padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`;
      }
    }, 1000);
  }
}
