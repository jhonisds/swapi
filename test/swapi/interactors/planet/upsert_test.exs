defmodule Swapi.Interactors.Planet.UpsertTest do
  use Swapi.DataCase

  alias Swapi.Entities.Planet

  alias Swapi.Interactors.Planet.Upsert
  alias Swapi.Repo

  @valid_attrs %{
    name: "Tatooine",
    integration_id: "#{:rand.uniform(999_999_999)}",
    climate: "Arid",
    terrain: "Ocean",
    films: []
  }

  defp planet_fixture(attrs) do
    Factory.insert(:planet, attrs)
  end

  defp assert_has_upserted_planet_attrs(planet) do
    assert_match = fn planet ->
      assert planet.name == @valid_attrs.name
      assert planet.integration_id == @valid_attrs.integration_id
    end

    assert_match.(planet)

    persisted_planet = Repo.reload!(planet)
    assert_match.(persisted_planet)
  end

  describe "call/1" do
    test "creates a planet when planet does not exist yet" do
      assert Repo.aggregate(Planet, :count, :id) == 0

      assert {:ok, %Planet{} = planet} = Upsert.call(@valid_attrs)

      assert_has_upserted_planet_attrs(planet)

      assert Repo.aggregate(Planet, :count, :id) == 1
    end

    test "creates a planet with associations when planet does not exist yet" do
      assert Repo.aggregate(Planet, :count, :id) == 0

      films = Factory.insert_list(3, :film)

      attrs =
        @valid_attrs
        |> Map.put(:films, films)

      assert {:ok, %Planet{} = planet} = Upsert.call(attrs)

      assert_has_upserted_planet_attrs(planet)

      assert Enum.sort(planet.films) == Enum.sort(films)

      reloaded_planet = planet |> Repo.reload!() |> Repo.preload([:films])

      assert Enum.sort(reloaded_planet.films) == Enum.sort(films |> Repo.reload!())

      assert Repo.aggregate(Planet, :count, :id) == 1
    end

    test "updates a planet when planet already exists" do
      planet_fixture(%{
        integration_id: @valid_attrs.integration_id
      })

      assert Repo.aggregate(Planet, :count, :id) == 1

      assert {:ok, %Planet{} = planet} = Upsert.call(@valid_attrs)

      assert_has_upserted_planet_attrs(planet)

      assert Repo.aggregate(Planet, :count, :id) == 1
    end

    # test "updates a planet when planet already exists but the name contains empty spaces" do
    #   planet_fixture(%{
    #     integration_source: @valid_attrs.integration_source,
    #     integration_id: @valid_attrs.integration_id
    #   })

    #   assert Repo.aggregate(Planet, :count, :id) == 1

    #   assert {:ok, %Planet{} = planet} =
    #            @valid_attrs |> Map.put(:name, " #{@valid_attrs.name}  ") |> Upsert.call()

    #   assert_has_upserted_planet_attrs(planet)

    #   assert Repo.aggregate(Planet, :count, :id) == 1
    # end

    # test "updates a planet when planet already exists but the name is lower cased" do
    #   planet_fixture(%{
    #     integration_source: @valid_attrs.integration_source,
    #     integration_id: @valid_attrs.integration_id
    #   })

    #   assert Repo.aggregate(Planet, :count, :id) == 1

    #   assert {:ok, %Planet{} = planet} =
    #            @valid_attrs |> Map.put(:name, String.downcase(@valid_attrs.name)) |> Upsert.call()

    #   assert_has_upserted_planet_attrs(planet)

    #   assert Repo.aggregate(Planet, :count, :id) == 1
    # end

    test "updates a planet when planet already exists removing existent associations" do
      film_one = Factory.insert(:film)
      film_two = Factory.insert(:film)

      before_update_films = [film_one, film_two]

      {:ok, created_planet} =
        Upsert.call(%{
          @valid_attrs
          | films: before_update_films
        })

      assert Repo.aggregate(Planet, :count, :id) == 1

      attrs =
        @valid_attrs
        |> Map.put(:films, [film_one])

      assert {:ok, %Planet{} = planet} = Upsert.call(attrs)

      assert planet.id == created_planet.id
      assert_has_upserted_planet_attrs(planet)

      assert planet.films == [film_one]

      reloaded_planet = planet |> Repo.reload!() |> Repo.preload([:films])

      assert reloaded_planet.films == [Repo.reload!(film_one)]

      assert Repo.reload!(film_two)

      assert Repo.aggregate(Planet, :count, :id) == 1
    end

    test "creates a planet when planet with integration attrs exists but was deleted" do
      deleted_planet =
        planet_fixture(%{
          integration_id: @valid_attrs.integration_id,
          deleted_at: DateTime.now!("Etc/UTC")
        })

      assert Repo.aggregate(Planet, :count, :id) == 1

      assert {:ok, %Planet{} = planet} = Upsert.call(@valid_attrs)

      assert planet.id != deleted_planet.id
      assert planet.name == @valid_attrs.name
      assert planet.deleted_at == nil

      assert Repo.aggregate(Planet, :count, :id) == 2
    end
  end
end
