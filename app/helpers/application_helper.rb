module ApplicationHelper
  def content_id
    "#{controller_name.underscore}_#{action_name}"
  end

  def nav_link_to(text, url, options = {})
    link_to(text, url, options.merge(class: nav_link_class(url)))
  end

  def nav_link_class(url)
    page_active?(url) ? "active" : ""
  end

  def page_active?(url)
    current_page?(url) ||
      case url
      when lenses_path
        current_page?(root_path)
      else
        false
      end
  end
end
