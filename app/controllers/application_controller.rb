# すべてのコントローラが継承する「共通の親クラス」
# アプリ全体で共通に効かせたい設定/フィルタ など記述
class ApplicationController < ActionController::Base

  # 新しめの CSS/JS を前提に開発できるようにするためのもの
  allow_browser versions: :modern
end
