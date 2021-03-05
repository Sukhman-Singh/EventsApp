defmodule EventsApp.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :body, :string
    field :date, :utc_datetime
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :body, :date])
    |> validate_required([:name, :body, :date])
  end
end
