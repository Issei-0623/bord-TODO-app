import "@hotwired/turbo-rails"
import "controllers"

import Rails from "@rails/ujs"
Rails.start()

// 二重にイベントを張らないためのフラグ
let boardsPerPageHandlerInstalled = false;

function setupResponsivePerPage() {
  // ★ ホームのボード一覧にだけ存在するコンテナ
  const boardList = document.querySelector('.authenticate-page .cards-container');
  if (!boardList) return;               // ← 一覧以外のページでは何もしない
  if (boardsPerPageHandlerInstalled) return;
  boardsPerPageHandlerInstalled = true;

  const CARD_WIDTH = 420;      // .authenticate-card の幅
  const GAP = 30;              // .cards-container の gap
  const MAX = 5;
  const MIN = 1;
  const PAGE_SIDE_PADDING = 80; // .authenticate-page の左右余白(合計)

  function desiredColumns() {
    // モバイルは常に 1（CSS と一致）
    if (window.matchMedia("(max-width: 899px)").matches) return 1;

    const vw = document.documentElement.clientWidth;
    const contentWidth = Math.max(0, vw - PAGE_SIDE_PADDING);
    const cols = Math.floor((contentWidth + GAP) / (CARD_WIDTH + GAP));
    return Math.min(MAX, Math.max(MIN, cols));
  }

  function applyPerPageIfNeeded() {
    const want = desiredColumns();
    const url = new URL(window.location.href);
    const current = parseInt(url.searchParams.get("per_page") || "0", 10);

    if (current !== want) {
      url.searchParams.set("per_page", String(want));
      url.searchParams.set("page", "1"); // 範囲外防止で 1 に戻す
      window.location.replace(url.toString());
    }
  }

  // 初回判定
  applyPerPageIfNeeded();

  // 画面幅変更にも追随（デバウンス）
  let timer = null;
  const onResize = () => {
    clearTimeout(timer);
    timer = setTimeout(applyPerPageIfNeeded, 150);
  };
  window.addEventListener("resize", onResize, { passive: true });

  // Turbo で別ページに遷移する時に後片付け（ハンドラの蓄積を防止）
  document.addEventListener("turbo:before-render", () => {
    window.removeEventListener("resize", onResize);
    boardsPerPageHandlerInstalled = false;
  }, { once: true });
}

// Turbo/通常どちらでも初期化
document.addEventListener("turbo:load", setupResponsivePerPage);
document.addEventListener("DOMContentLoaded", setupResponsivePerPage);
