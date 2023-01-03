defmodule Swapi.Repo.Migrations.CreateFilms do
  use Ecto.Migration

  def change do
    create table(:films, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")

      add :title, :string, null: false
      add :release_date, :date, null: false
      add :director, :string, null: false

      add :integration_id, :string

      add :deleted_at, :utc_datetime_usec
      timestamps(type: :utc_datetime_usec)
    end

    create index(:films, :deleted_at)

    create unique_index(:films, [:integration_id],
             name: "unique_film_integration_id",
             where: "deleted_at IS NULL"
           )
  end
end
