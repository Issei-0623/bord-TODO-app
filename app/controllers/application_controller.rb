class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!, unless: :devise_controller?

  private

  def setup_pagination(default_per_page: 10)
    @per_page = params[:per_page].presence&.to_i || default_per_page
    @per_page = default_per_page if @per_page <= 0
    @page     = [params[:page].to_i, 1].max
  end

  def paginate(scope)
    @total_pages = (scope.count / @per_page.to_f).ceil
    scope.offset((@page - 1) * @per_page).limit(@per_page)
  end
end
