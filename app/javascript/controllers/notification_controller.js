import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["notification"];
  static values = {
    notificationKeyValue: String,
  };

  connect() {
    const lastNotificationShownAt = this.getLastNotificationShownAt();
    const now = new Date();

    if (lastNotificationShownAt) {
      const oneDayInMs = 1000 * 60 * 60 * 24;
      const msSinceLastNotification = now - new Date(lastNotificationShownAt);

      if (msSinceLastNotification < oneDayInMs) {
        this.hideNotification();
        return;
      }
    }

    this.setLastNotificationShownAt(now.toISOString());
  }

  getLastNotificationShownAt() {
    return this.cookieValueForKey(this.notificationKeyValueValue);
  }

  setLastNotificationShownAt(value) {
    document.cookie = `${this.notificationKeyValueValue}=${value}; expires=Fri, 31 Dec 9999 23:59:59 GMT; SameSite=None; Secure`;
  }

  hideNotification() {
    this.notificationTarget.style.display = "none";
  }

  cookieValueForKey(key) {
    const cookies = document.cookie.split(";");
    const cookie = cookies.find((cookie) =>
      cookie.trim().startsWith(`${key}=`)
    );
    return cookie ? cookie.split("=")[1] : null;
  }
}
