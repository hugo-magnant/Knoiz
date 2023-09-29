module ApplicationHelper
  def nav_link(text, path, display_condition)
    content_tag(:a, text, href: path, class: link_classes(display_condition))
  end

  def link_classes(display_condition)
    base_classes = "ml-6 mb-2 text-knoiz-blanc hover:bg-knoiz-gris hover:text-white group flex items-center px-3.5 py-3.5 text-sm font-medium rounded-2xl"
    display_condition ? "#{base_classes} bg-knoiz-gris" : base_classes
  end
end
