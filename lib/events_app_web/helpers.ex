defmodule EventsAppWeb.Helpers do
  def have_current_user?(conn) do
    conn.assigns[:current_user] != nil
  end
end
