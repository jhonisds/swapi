defmodule Swapi.Interactors.Film.Upsert do
  @moduledoc """
  Film upsert use case.
  Do not call this module directly, use always the Swapi module that is the boundary context.

  ## General rules:

  - When a film with the given `integration_source` and `integration_id` already exist, it will be updated.
  - When a film with the given `integration_source` and `integration_id` does not exist, it will be created.
  """

  use CleanArchitecture.Interactor

  alias Swapi.Entities.Film
  alias Swapi.Repo

  @doc """
  Upserts a film.
  """
  def call(%{title: _title, integration_id: _integration_id} = input) do
    input
    |> get_existent_film()
    |> upsert_film()
    |> handle_output()
  end

  defp get_existent_film(%{integration_id: integration_id} = input) do
    existent_film =
      Film
      |> where([t], is_nil(t.deleted_at))
      |> Repo.get_by(integration_id: integration_id)

    input |> Map.put(:existent_film, existent_film)
  end

  defp upsert_film(%{existent_film: nil} = input) do
    input
    |> Film.changeset()
    |> Repo.insert()
  end

  defp upsert_film(%{existent_film: %Film{} = existent_film} = input) do
    existent_film
    |> Film.changeset(input)
    |> Repo.update()
  end

  defp handle_output({:ok, %Film{} = film}), do: {:ok, film}
  defp handle_output({:error, %Ecto.Changeset{} = changeset}), do: {:error, changeset}
end
