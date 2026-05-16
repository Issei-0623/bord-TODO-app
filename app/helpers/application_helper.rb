module ApplicationHelper
  def deadline_display(deadline)
    label = content_tag(:span, '期限:', class: 'deadline-label')
    value = if deadline.present?
      css = if deadline < Date.current
        'deadline-overdue'
      elsif deadline == Date.current
        'deadline-today'
      end
      content_tag(:span, l(deadline, format: :long), class: css)
    else
      content_tag(:span, '未設定')
    end
    label + value
  end

  def profile_avatar_url(profile)
    if profile.avatar.attached?
      url_for(profile.avatar)
    elsif profile.user.avatar&.attached?
      url_for(profile.user.avatar.variant(resize_to_fill: [80, 80]).processed)
    else
      asset_path('default-avatar.png')
    end
  end
end
