defmodule EventsAppWeb.InviteController do
  use EventsAppWeb, :controller

  alias EventsApp.Invites
  alias EventsApp.Invites.Invite
  alias EventsApp.Events

  plug :fetch_invite when action in [:show, :edit, :update, :delete]
  plug :require_event_owner when action in [:delete]
  plug :require_invitee when action in [:edit, :update]

  def require_invitee(conn, _args) do
    user = conn.assigns[:current_user]
    invite = conn.assigns[:invite]
    
    if user.email == invite.user_email do
      conn
    else
      conn
      |> put_flash(:error, "Only the invitee can respond to an invite.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def fetch_invite(conn, _args) do
    id = conn.params["id"]
    invite = Invites.get_invite!(id)
    assign(conn, :invite, invite)
  end

  def require_event_owner(conn, _args) do
    user = conn.assigns[:current_user]
    invite = conn.assigns[:invite]
    event = Events.get_event(invite.event_id)

    if user.id == event.user_id do
      conn
    else
      conn
      |> put_flash(:error, "Only the owner of an event can delete an invite.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end


  def index(conn, _params) do
    invites = Invites.list_invites()
    render(conn, "index.html", invites: invites)
  end

  def new(conn, _params) do
    changeset = Invites.change_invite(%Invite{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"invite" => invite_params}) do
    duplicateInvite = Invites.get_invite_by_email_and_event(Map.get(invite_params, "user_email"), Map.get(invite_params, "event_id"))

    if duplicateInvite do
	conn
          |> put_flash(:error, "This person has already been invited.")
          |> redirect(to: Routes.invite_path(conn, :index))
    else
      case Invites.create_invite(invite_params) do
        {:ok, invite} ->
          conn
          |> put_flash(:info, "Invite created successfully.")
          |> redirect(to: Routes.invite_path(conn, :show, invite))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    render(conn, "show.html", invite: invite)
  end

  def edit(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    changeset = Invites.change_invite(invite)
    render(conn, "edit.html", invite: invite, changeset: changeset)
  end

  def update(conn, %{"id" => id, "invite" => invite_params}) do
    invite = Invites.get_invite!(id)

    case Invites.update_invite(invite, invite_params) do
      {:ok, invite} ->
        conn
        |> put_flash(:info, "Invite updated successfully.")
        |> redirect(to: Routes.invite_path(conn, :show, invite))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", invite: invite, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    {:ok, _invite} = Invites.delete_invite(invite)

    conn
    |> put_flash(:info, "Invite deleted successfully.")
    |> redirect(to: Routes.invite_path(conn, :index))
  end
end
