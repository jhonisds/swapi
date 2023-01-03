defmodule Swapi.Repo.Migrations.CreatePlanets do
  use Ecto.Migration

  def change do
    create table(:planets, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")

      add :name, :string, null: false
      add :climate, :string, null: false
      add :terrain, :string, null: false
      add :integration_id, :string

      add :deleted_at, :utc_datetime_usec
      timestamps(type: :utc_datetime_usec)
    end

    create index(:planets, :deleted_at)

    create unique_index(:planets, [:integration_id],
             name: "unique_planet_integration_id",
             where: "deleted_at IS NULL"
           )
  end
end
