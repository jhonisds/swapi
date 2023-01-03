defmodule Swapi.Interactors.Planet.Delete do
  @moduledoc """
  Delete planet use case.

  Do not call this module directly, use always the Swapi module that is the boundary context.
  """
  use CleanArchitecture.Interactor

  alias Swapi.Entities.Planet
  alias Swapi.Repo

  @doc """
  Deletes a planet.
  """
  def call(%{id: _id, deleted_at: _deleted_at} = input) do
    input
    |> get_planet()
    |> delete_planet()
    |> handle_output()
  end

  defp get_planet(%{id: id} = input) do
    planet = Swapi.get_planet!(%{id: id})

    Map.put(input, :planet, planet)
  end

  defp delete_planet(%{planet: {:error, _} = get_planet_error}), do: get_planet_error

  defp delete_planet(%{planet: %Planet{} = planet, deleted_at: deleted_at}) do
    planet |> Planet.changeset(%{deleted_at: deleted_at}) |> Repo.update()
  end

  defp handle_output({:ok, %Planet{} = planet}), do: {:ok, planet}
  defp handle_output({:error, %Ecto.Changeset{} = changeset}), do: {:error, changeset}
end
