import "@hotwired/turbo-rails"
import "controllers"

import Rails from "@rails/ujs"
Rails.start()

function setupResponsivePerPage() {
  const CARD_WIDTH = 420; // .authenticate-card の幅
  const GAP = 30;         // .cards-container の gap
  const MAX = 5;
  const MIN = 1;
  const PAGE_SIDE_PADDING = 80; // .authenticate-page が左右 40px ずつ

  function desiredColumns() {
    // モバイルは常に 1（CSS と一致）
    if (window.matchMedia("(max-width: 899px)").matches) return 1;

    // 画面幅ベースで列数計算（container幅に依存しない）
    const viewportWidth = document.documentElement.clientWidth;
    const contentWidth = Math.max(0, viewportWidth - PAGE_SIDE_PADDING);
    const cols = Math.floor((contentWidth + GAP) / (CARD_WIDTH + GAP));
    return Math.min(MAX, Math.max(MIN, cols));
  }

  function applyPerPageIfNeeded() {
    const want = desiredColumns();

    // 毎回最新の URL を生成（使い回さない）
    const url = new URL(window.location.href);
    const current = parseInt(url.searchParams.get("per_page") || "0", 10);

    if (current !== want) {
      url.searchParams.set("per_page", String(want));
      // ページが範囲外になるのを避けるため 1 に戻す
      url.searchParams.set("page", "1");
      window.location.replace(url.toString());
    }
  }

  // 初回
  applyPerPageIfNeeded();

  // 画面幅変更にも追随（デバウンス）
  let timer = null;
  window.addEventListener("resize", () => {
    clearTimeout(timer);
    timer = setTimeout(applyPerPageIfNeeded, 150);
  });
}

// Turbo/通常どちらでも初期化
document.addEventListener("turbo:load", setupResponsivePerPage);
document.addEventListener("DOMContentLoaded", setupResponsivePerPage);
