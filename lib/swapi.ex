defmodule Swapi do
  @moduledoc """
  Swapi keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  use CleanArchitecture.BoundedContext

  alias Swapi.Entities.Film
  alias Swapi.Entities.Planet

  @doc """
  Creates or updates a film.

  ## Examples
      iex> upsert_film(%{field: "value"})
      {:ok, %Film{}}

      iex> upsert_film(%{field: "bad_value"})
      {:error, %Ecto.Changeset{}}
  """
  def upsert_film(%{} = input) do
    with {:ok, validated_input} <- Contracts.Film.Upsert.validate_input(input),
         {:ok, %Film{} = film} <-
           Interactors.Film.Upsert.call(validated_input) do
      {:ok, film}
    else
      {:error, %Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Gets a planet by id.
  Raises `Ecto.NoResultError` if the Planet does not exist.

  ## Examples
      iex> get_planet!(%{id: "679a45df-380c-4057-ac73-a0f1de5abb5b"}
      {:ok, %Planet{}}

      iex> get_planet!(%{id: "d5265c50-67ab-4a11-8d7e-8c2caa589634"}
      ** (Ecto.NoResultsError)

      iex> get_planet!(%{id: "invalid"}
      ** (Ecto.Query.CastError)
  """

  def get_planet!(input) do
    case Contracts.Planet.Get.validate_input(input) do
      {:ok, validated_input} ->
        %Planet{} = Interactors.Planet.Get.call(validated_input)

      {:error, %Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Returns the list of planets.

  ## Examples
      iex> list_planets()
      %Pagination{
        entries: [], page_number: 1, page_size: 10, total_entries: 0, total_pages: 0
      }

      iex> list_planets(%{page: 2, page_size: 4})
      %Pagination{
        entries: [%Planet{}, ...], page_number: 2, page_size: 4, total_entries: 8, total_pages: 2
      }
  """
  def list_planets(input \\ %{}) do
    case Contracts.Planet.List.validate_input(input) do
      {:ok, validated_input} ->
        %Pagination{entries: _, page_number: _, page_size: _, total_entries: _, total_pages: _} =
          Interactors.Planet.List.call(validated_input)

      {:error, %Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Creates or updates a planet.

  ## Examples
      iex> upsert_planet(%{field: "value"})
      {:ok, %Planet{}}

      iex> upsert_planet(%{field: "bad_value"})
      {:error, %Ecto.Changeset{}}
  """
  def upsert_planet(%{} = input) do
    with {:ok, validated_input} <- Contracts.Planet.Upsert.validate_input(input),
         {:ok, %Planet{} = planet} <-
           Interactors.Planet.Upsert.call(validated_input) do
      {:ok, planet}
    else
      {:error, %Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Loads a planet from the integration.

  ## Examples
      iex> load_planet(%{field: "value"})
      {:ok, %Planet{}}

      iex> load_planet(%{field: "value"})
      {:error, "Resource not found - status code: 404"}
  """
  def load_planet(%{} = input) do
    with {:ok, validated_input} <- Contracts.Planet.Load.validate_input(input),
         {:ok, %Planet{} = planet} <-
           Interactors.Planet.Load.call(validated_input) do
      {:ok, planet}
    else
      {:error, %Changeset{} = changeset} ->
        {:error, changeset}

      {:error, error} ->
        {:error, error}
    end
  end
end
