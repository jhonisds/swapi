defmodule Swapi.Interactors.Film.List do
  @moduledoc """
  Film list use case.
  Do not call this module directly, use always the Swapi module that is the boundary context.

  ## General rules:

  - Input param `page` and `page_size` are required.
  - If the other filter params are empty, it will return movies without any filters but respecting pagination rules.
  - Orders by `inserted_at` desc. This means that newer movies comes first.
  - Deleted records are excluded form the query.
  - Movie association (director) is preloaded.

  ## Input params allowed
  - `page` :: Used to paginate.
  - `page_size` :: Used to paginate.
  - `title` :: Filter list by title. (Name filter will search for titles that starts with the informed string)
  """

  use CleanArchitecture.Interactor

  import CleanArchitecture.Pagination

  alias Swapi.Entities.Film
  alias Swapi.Repo

  @doc """
  Lists films.
  """
  def call(%{page: page, page_size: page_size} = input)
      when is_integer(page) and is_integer(page_size) do
    Film
    |> filter_not_deleted()
    |> filter_by_title(input)
    |> order_by(desc: :inserted_at)
    |> preload([:director])
    |> paginate(Repo, %{page: page, page_size: page_size})
  end

  defp filter_not_deleted(query) do
    where(query, [t], is_nil(t.deleted_at))
  end

  defp filter_by_title(query, %{title: title}) when is_binary(title) do
    title = title |> String.downcase()

    where(
      query,
      [p],
      fragment("LOWER(?) LIKE ?", p.title, ^"#{title}%")
    )
  end

  defp filter_by_title(query, _), do: query
end
