defmodule Swapi.Interactors.Planet.Get do
  @moduledoc """
  Get planet use case.

  Do not call this module directly, use always the Swapi module that is the boundary context.
  """
  use CleanArchitecture.Interactor

  alias Swapi.Entities.Planet
  alias Swapi.Repo

  @doc """
  Gets a planet.
  """
  def call(%{id: id}) do
    Planet
    |> filter_not_deleted()
    |> preload([:films])
    |> Repo.get!(id)
  end

  defp filter_not_deleted(query) do
    where(query, [p], is_nil(p.deleted_at))
  end
end
