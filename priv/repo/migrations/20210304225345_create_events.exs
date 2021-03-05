defmodule EventsApp.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string, null: false
      add :body, :text, null: false
      add :date, :utc_datetime, null: false

      timestamps()
    end

  end
end
