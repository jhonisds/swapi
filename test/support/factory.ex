defmodule Swapi.Support.Factory do
  @moduledoc """
  Factory used to create entities for tests.
  """

  # with Ecto
  use ExMachina.Ecto, repo: Swapi.Repo

  alias Swapi.Entities.Film
  alias Swapi.Entities.Planet

  def film_factory do
    title = sequence(:title, &"Film #{&1}")

    %Film{
      title: title,
      release_date: Date.utc_today(),
      integration_id: "#{:rand.uniform(999_999_999)}",
      director: "George Lucas",
      deleted_at: nil
    }
  end

  def planet_factory do
    name = sequence(:name, &"Planet #{&1}")

    %Planet{
      name: name,
      climate: "Arid",
      terrain: "Ocean",
      integration_id: "#{:rand.uniform(999_999_999)}",
      deleted_at: nil
    }
  end
end
