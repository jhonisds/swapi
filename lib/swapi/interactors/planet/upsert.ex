defmodule Swapi.Interactors.Planet.Upsert do
  @moduledoc """
  Planet upsert use case.
  Do not call this module directly, use always the Swapi module that is the boundary context.

  ## General rules:

  - When a planet with the given `integration_id` already exist and is not deleted, it will be updated.
  - When a planet with the given `integration_id` does not exist, it will be created.
  """

  use CleanArchitecture.Interactor

  alias Swapi.Entities.Planet
  alias Swapi.Repo

  @doc """
  Upserts a planet.
  """
  def call(%{name: _name, integration_id: _integration_id} = input) do
    input
    |> get_existent_planet()
    |> upsert_planet()
    |> preload_associations()
    |> handle_output()
  end

  defp get_existent_planet(%{integration_id: integration_id} = input) do
    existent_planet =
      Planet
      |> where([t], is_nil(t.deleted_at))
      |> Repo.get_by(integration_id: integration_id)

    input |> Map.put(:existent_planet, existent_planet)
  end

  defp upsert_planet(%{existent_planet: nil, films: films} = input) do
    input
    |> Planet.changeset()
    |> Ecto.Changeset.put_assoc(:films, films)
    |> Repo.insert()
  end

  defp upsert_planet(
         %{
           existent_planet: %Planet{} = existent_planet,
           films: films
         } = input
       ) do
    existent_planet
    |> preload_associations!()
    |> Planet.changeset(input)
    |> Ecto.Changeset.put_assoc(:films, films)
    |> Repo.update()
  end

  defp preload_associations({:ok, %Planet{} = planet}) do
    {:ok, preload_associations!(planet)}
  end

  defp preload_associations!(%Planet{} = planet) do
    Repo.preload(planet, [:films])
  end

  defp handle_output({:ok, %Planet{} = planet}), do: {:ok, planet}
end
