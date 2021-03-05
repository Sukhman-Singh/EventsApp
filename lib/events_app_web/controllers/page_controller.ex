defmodule EventsAppWeb.PageController do
  use EventsAppWeb, :controller

  def index(conn, _params) do
    events = EventsApp.Events.list_events()
    render(conn, "index.html", events: events)
  end
end
