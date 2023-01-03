defmodule Swapi.Interactors.Film.Get do
  @moduledoc """
  Get film use case.

  Do not call this module directly, use always the Swapi module that is the boundary context.
  """
  use CleanArchitecture.Interactor

  alias Swapi.Entities.Film
  alias Swapi.Repo

  @doc """
  Gets a film.
  """
  def call(%{id: id}) do
    Film
    |> filter_not_deleted()
    |> Repo.get!(id)
  end

  defp filter_not_deleted(query) do
    where(query, [p], is_nil(p.deleted_at))
  end
end
