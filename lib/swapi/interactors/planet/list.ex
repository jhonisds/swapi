defmodule Swapi.Interactors.Planet.List do
  @moduledoc """
  Planet list use case.
  Do not call this module directly, use always the Swapi module that is the boundary context.

  ## General rules:

  - Input param `page` and `page_size` are required.
  - If the other filter params are empty, it will return planets without any filters but respecting pagination rules.
  - Orders by `inserted_at` desc. This means that newer planets comes first.
  - Deleted records are excluded form the query.
  - Planet associations (climates, terrains and movies) are preloaded.

  ## Input params allowed
  - `page` :: Used to paginate.
  - `page_size` :: Used to paginate.
  - `name` :: Filter list by name. (Name filter will search for names that starts with the informed string)
  """

  use CleanArchitecture.Interactor

  import CleanArchitecture.Pagination

  alias Swapi.Entities.Planet
  alias Swapi.Repo

  @doc """
  Lists planets.
  """
  def call(%{page: page, page_size: page_size} = input)
      when is_integer(page) and is_integer(page_size) do
    Planet
    |> filter_not_deleted()
    |> filter_by_name(input)
    |> order_by(desc: :inserted_at)
    |> preload([:films])
    |> paginate(Repo, %{page: page, page_size: page_size})
  end

  defp filter_not_deleted(query) do
    where(query, [t], is_nil(t.deleted_at))
  end

  defp filter_by_name(query, %{name: name}) when is_binary(name) do
    name = name |> String.downcase()

    where(
      query,
      [p],
      fragment("LOWER(?) LIKE ?", p.name, ^"#{name}%")
    )
  end

  defp filter_by_name(query, _), do: query
end
