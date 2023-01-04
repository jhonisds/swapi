defmodule Swapi.Interactors.Film.List do
  @moduledoc """
  Film list use case.
  Do not call this module directly, use always the Swapi module that is the boundary context
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
