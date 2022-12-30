defmodule Swapi.Integration.ParserResponse do
  @moduledoc """
  Parser response.

  Every integration source that retrieves a planet needs to respond with this struct.
  """

  alias Swapi.Integration.Movie
  alias Swapi.Integration.Planet
  alias Swapi.Integration.Resource

  def extract_id_from_integration(url) when is_binary(url) do
    url
    |> String.split(~w(. /), parts: 1000, trim: true)
    |> List.last()

    # |> parse_id
    # |> fetch_id
  end

  # defp parse_id(nil), do: :error
  # defp parse_id(x) when is_binary(x), do: Integer.parse(x)

  # defp fetch_id({number, ""}) when is_integer(number), do: number
  # defp fetch_id(:error), do: :error

  def map_to_atom(body) do
    {:ok, json_body} = Jason.decode(body)

    Enum.reduce(json_body, %{}, fn {key, val}, acc -> Map.put(acc, String.to_atom(key), val) end)
  end

  def resource(%{
        films: films,
        people: people,
        planets: planets,
        species: species,
        starships: starships,
        vehicles: vehicles
      }) do
    resource_response = %Resource{
      films: films,
      people: people,
      planets: planets,
      species: species,
      starships: starships,
      vehicles: vehicles
    }

    {:ok, resource_response}
  end

  def resource(%{
        url: planet_url,
        name: name,
        climate: climate,
        terrain: terrain,
        films: movie_urls
      }) do
    movies = Swapi.Integration.StarWarsAPI.get_movies(movie_urls)

    planet_response = %Planet{
      name: name,
      integration_id: extract_id_from_integration(planet_url),
      climate: climate,
      terrain: terrain,
      movies: movies
    }

    {:ok, planet_response}
  end

  def resource(%{
        url: movie_url,
        title: title,
        director: director,
        release_date: release_date
      }) do
    movie_response = %Movie{
      title: title,
      integration_id: extract_id_from_integration(movie_url),
      director: director,
      release_date: release_date
    }

    {:ok, movie_response}
  end
end
