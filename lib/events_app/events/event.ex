defmodule EventsApp.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :body, :string
    field :date, :utc_datetime
    field :name, :string
    belongs_to :user, EventsApp.Users.User
    has_many :comments, EventsApp.Comments.Comment

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :body, :date, :user_id])
    |> validate_required([:name, :body, :date, :user_id])
  end
end
