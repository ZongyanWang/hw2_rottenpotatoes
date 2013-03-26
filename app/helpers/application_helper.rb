module ApplicationHelper
  def sortable(title, column)
    direction = column == @sort_column && @sort_direction == "asc" ? "desc" : "asc" 
    link_to title , movies_path(:sort => column, :direction => direction, :ratings => @selected_ratings), { :id => "#{column}_header"}
  end
end
