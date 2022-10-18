module ApplicationHelper
  def show_flash(type)
    return unless flash[type]

    content_tag(:div, flash[type].html_safe, class: "alert alert-#{get_type_flash(type)}")
  end

  def get_type_flash(type)
    { alert: 'warning', notice: 'info' }[type] || type.to_s
  end
end
