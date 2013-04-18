module ApplicationHelper                       #将相关方法组织在一起

  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"          #字符串插值
    end
  end

end
