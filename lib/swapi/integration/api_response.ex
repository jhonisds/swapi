defmodule Swapi.Integration.APIResponse do
  @moduledoc """
  Parser response.

  Every integration source that retrieves a planet needs to respond with this struct.
  """

  alias Swapi.Integration.Resources.Film
  alias Swapi.Integration.Resources.People
  alias Swapi.Integration.Resources.Planet
  alias Swapi.Integration.Resources.Specie
  alias Swapi.Integration.Resources.Starship
  alias Swapi.Integration.Resources.Vehicle
  alias Swapi.Integration.Resources.Root

  def get_integration_id(url) when is_binary(url) do
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
    {:ok,
     %Root{
       films: films,
       people: people,
       planets: planets,
       species: species,
       starships: starships,
       vehicles: vehicles
     }}
  end

  def resource(%{
        url: planet_url,
        name: name,
        climate: climate,
        terrain: terrain,
        films: film_urls
      }) do
    films = Swapi.Integration.API.list_resources_by_urls(film_urls)
    integration_id = get_integration_id(planet_url)

    {:ok,
     %Planet{
       name: name,
       integration_id: integration_id,
       climate: climate,
       terrain: terrain,
       films: films
     }}
  end

  def resource(%{
        url: film_url,
        title: title,
        director: director,
        release_date: release_date
      }) do
    integration_id = get_integration_id(film_url)

    {:ok,
     %Film{
       title: title,
       integration_id: integration_id,
       director: director,
       release_date: release_date
     }}
  end

  def resource(%{
        url: people_url,
        name: name,
        gender: gender,
        homeworld: planet_url
      }) do
    {:ok, planet} = Swapi.Integration.API.get_resource(planet_url)
    integration_id = get_integration_id(people_url)

    {:ok,
     %People{
       name: name,
       integration_id: integration_id,
       gender: gender,
       planet: planet
     }}
  end

  def resource(%{
        url: specie_url,
        name: name,
        language: language,
        classification: classification
      }) do
    integration_id = get_integration_id(specie_url)

    {:ok,
     %Specie{
       name: name,
       integration_id: integration_id,
       language: language,
       classification: classification
     }}
  end

  def resource(%{
        url: starship_url,
        name: name,
        model: model,
        hyperdrive_rating: hyperdrive_rating
      }) do
    integration_id = get_integration_id(starship_url)

    {:ok,
     %Starship{
       name: name,
       integration_id: integration_id,
       model: model,
       hyperdrive_rating: hyperdrive_rating
     }}
  end

  def resource(%{
        url: vehicle_url,
        name: name,
        model: model,
        max_atmosphering_speed: max_atmosphering_speed
      }) do
    integration_id = get_integration_id(vehicle_url)

    {:ok,
     %Vehicle{
       name: name,
       integration_id: integration_id,
       model: model,
       max_atmosphering_speed: max_atmosphering_speed
     }}
  end
end
