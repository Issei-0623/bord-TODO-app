import { Controller } from "@hotwired/stimulus";

/*
  カード全体をクリック可能にしつつ、
  cardlink_ignore が付いた要素や a / button などは除外する。
  Enter/Space でも遷移できるようにする（アクセシビリティ）。
*/
export default class extends Controller {
  static values = { url: String }

  go(event) {
    if (!this.shouldFollow(event)) return;
    this.visit();
  }

  key(event) {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault();
      this.visit();
    }
  }

  shouldFollow(event) {
    const t = event.target;

    // cardlink_ignore 指定のものは除外
    if (t?.dataset?.cardlinkIgnore === "true") return false;

    // インタラクティブ要素は除外
    const tag = t.tagName?.toLowerCase();
    const interactive = ["a","button","input","select","textarea","label","svg","use","img"];
    if (interactive.includes(tag)) return false;

    // 修飾キーでのクリックも除外
    if (event.altKey || event.ctrlKey || event.shiftKey || event.metaKey) return false;

    return true;
  }

  visit() {
    if (!this.hasUrlValue) return;
    window.location.href = this.urlValue;
  }
}
