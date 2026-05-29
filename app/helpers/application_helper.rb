module ApplicationHelper
  def role_name(role_value)
    case role_value
    when 0
      "Admin"
    when 1
      "User"
    when 2
      "Viewer"
    else
      "Unknown"
    end
  end
end
