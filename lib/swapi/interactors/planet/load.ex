defmodule Swapi.Interactors.Planet.Load do
  @moduledoc """
  Planet load from an integration use case.

  Do not call this module directly, use always the Swapi module that is the boundary context.

  It will request the API according to the integration source informed and persist the data to the database.
  """

  use CleanArchitecture.Interactor

  alias Ecto.Multi

  alias Swapi.Entities.Planet
  alias Swapi.Repo

  alias Swapi.Integration.API
  alias Swapi.Integration.Resources.Film
  alias Swapi.Integration.Resources.Planet, as: PlanetResponse

  @doc """
  Loads a planet from an integration.
  """
  def call(%{resource: resource, integration_id: "" <> integration_id}) do
    case API.get_resource(resource, integration_id) do
      {:ok, %PlanetResponse{films: films} = planet_response} ->
        Multi.new()
        |> Multi.run(:films, &upsert_films(&1, &2, films))
        |> Multi.run(:planet, &upsert_planet(&1, &2, planet_response))
        |> Repo.transaction()
        |> handle_output()

      error_response ->
        error_response
    end
  end

  defp upsert_films(_repo, _, films) when is_list(films) do
    films = Enum.map(films, &upsert_film(&1))

    {:ok, films}
  end

  defp upsert_film(%Film{
         title: title,
         release_date: release_date,
         integration_id: integration_id,
         director: director
       }) do
    {:ok, film} =
      Swapi.upsert_film(%{
        title: title,
        release_date: release_date,
        integration_id: integration_id,
        director: director
      })

    film
  end

  defp upsert_planet(
         _repo,
         %{films: films},
         planet
       ) do
    Swapi.upsert_planet(%{
      name: planet.name,
      integration_id: planet.integration_id,
      climate: planet.climate,
      terrain: planet.terrain,
      films: films
    })
  end

  defp handle_output({:ok, %{planet: %Planet{} = planet}}), do: {:ok, planet}
end
