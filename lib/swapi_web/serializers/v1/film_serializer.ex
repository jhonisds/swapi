defmodule SwapiWeb.V1.FilmSerializer do
  @moduledoc """
  Film serializer is responsible to convert the record to map,
  applying all the changes needed to the record be exposed to the Web API.
  """

  alias Swapi.Entities.Film

  def serialize(%Film{} = film) do
    %{
      data: serialize(film, :without_root_key)
    }
  end

  def serialize(%CleanArchitecture.Pagination{entries: entries} = pagination) do
    serialized_films = Enum.map(entries, &serialize(&1, :without_root_key))

    %{
      data: serialized_films,
      meta: pagination |> Map.from_struct() |> Map.delete(:entries)
    }
  end

  def serialize(entries) when is_list(entries) do
    Enum.map(entries, &serialize(&1, :without_root_key))
  end

  def serialize(nil, :without_root_key), do: nil

  def serialize(%Film{} = film, :without_root_key) do
    %{
      id: film.id,
      title: film.title,
      release_date: film.release_date,
      director: film.director,
      inserted_at: film.inserted_at,
      updated_at: film.updated_at
    }
  end
end
