import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["productHuntButton"]

    connect() {
        this.refreshUrl();
    }

    refreshUrl() {
        let originalSrc = this.productHuntButtonTarget.src.split('?')[0];
        let timestamp = new Date().getTime();
        this.productHuntButtonTarget.src = `${originalSrc}?post_id=451317&theme=light&t=${timestamp}`;
    }
}
