defmodule EventsAppWeb.Helpers do
  def have_current_user?(conn) do
    conn.assigns[:current_user] != nil
  end

  def current_user_id?(conn, user_id) do
    user = conn.assigns[:current_user]
    user && user.id == user_id
  end

  def current_user_id(conn) do
    user = conn.assigns[:current_user]
    user && user.id
  end

  def current_user_email(conn) do
    user = conn.assigns[:current_user]
    user.email
  end

#  def on_invite_list?(conni, event_id) do
#    user = conn.assigns[:current_user]
#    curr_email = user.email
#
#    
#  end

end
