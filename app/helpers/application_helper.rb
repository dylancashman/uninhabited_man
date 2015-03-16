module ApplicationHelper
  def formatted_date_string(date)
    date ? date.strftime('%m/%d/%Y') : ""
  end
end
