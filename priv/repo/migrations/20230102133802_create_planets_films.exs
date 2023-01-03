defmodule Swapi.Repo.Migrations.CreatePlanetsFilms do
  use Ecto.Migration

  def change do
    create table(:planets_films, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")

      add :planet_id, references(:planets, type: :uuid), null: false
      add :film_id, references(:films, type: :uuid), null: false
    end

    create unique_index(:planets_films, [:planet_id, :film_id], name: "unique_planets_films")
  end
end
