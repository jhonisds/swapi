defmodule Swapi.Integration.API do
  @moduledoc """
  Send request to the Star Wars public API.
  """

  alias Swapi.HTTPClient
  alias Swapi.Integration.APIResponse

  @base_url "https://swapi.dev/api"

  @doc """
  Gets a list of available resources.

  Example:
      iex> Swapi.Integration.StarWarsAPI.list_resources
      {:ok, %Swapi.Integration.Resource{
        films: "https://swapi.dev/api/films/",
        people: "https://swapi.dev/api/people/",
        planets: "https://swapi.dev/api/planets/",
        species: "https://swapi.dev/api/species/",
        starships: "https://swapi.dev/api/starships/",
        vehicles: "https://swapi.dev/api/vehicles/"
     }
    }
  """
  def list_resources, do: send_request(@base_url)

  @doc """
  Gets a resource from the Star Wars Universe.

  Example:
      iex> Swapi.Integration.StarWarsAPI.get_resource("planet", 1)
      {:ok,  {[...]}}
  """
  def get_resource(resource, id) do
    send_request("#{@base_url}/#{resource}/#{id}/")
  end

  def get_resource(url) do
    send_request(url)
  end

  defp send_request(url) do
    case HTTPClient.get(url) do
      {:ok, %HTTPoison.Response{body: body}} ->
        body
        |> APIResponse.map_to_atom()
        |> APIResponse.resource()

      {:error, error} ->
        {:error, error}
    end
  end

  def list_resources_by_urls(urls) do
    urls
    |> Enum.map(&get_resource(&1))
    |> Enum.map(fn {:ok, response} -> response end)
  end
end
