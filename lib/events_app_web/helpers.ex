defmodule EventsAppWeb.Helpers do

  def have_current_user?(conn) do
    conn.assigns[:current_user] != nil
  end

  def current_user_id?(conn, user_id) do
    user = conn.assigns[:current_user]
    user && user.id == user_id
  end

  def current_user_email?(conn, user_email) do
    user = conn.assigns[:current_user]
    user && user.email == user_email
  end

  def current_user_id(conn) do
    user = conn.assigns[:current_user]
    user && user.id
  end

  def current_user_email(conn) do
    user = conn.assigns[:current_user]
    user.email
  end

  def get_username_by_email(email) do
    user = EventsApp.Users.get_user_by_email(email)
    if user do
      user.name
    else
      email <> " (no associated account with this email)"
    end
  end

  def get_username_by_id(id) do
    user = EventsApp.Users.get_user(id)
    user.name
  end

  def on_invite_list?(conn, event) do
    user = conn.assigns[:current_user]
    if user do
      invite = EventsApp.Invites.get_invite_by_email_and_event(user.email, event.id)

      # if invite exits, user is on the invite list
      if invite do
        true
      else
        false
      end
    # no user = not on invite list
    else
      false
    end
  end

  def get_total_replies(reply, invites) do
    if length(invites) === 0 do
      0
    else
      if hd(invites).response === reply do
        1 + get_total_replies(reply, tl(invites))
      else
        get_total_replies(reply, tl(invites))
      end
    end
  end

end
