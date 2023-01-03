defmodule Swapi.Entities.PlanetTest do
  use Swapi.DataCase

  alias Swapi.Entities.Planet
  alias Swapi.Support.Factory

  @valid_attrs %{
    name: "Tatooine",
    climate: "Arid",
    terrain: "Ocean",
    integration_id: "1"
  }

  describe "changeset" do
    test "creates a changeset when no parameters was informed" do
      changeset = Planet.changeset()

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates a changeset when just the schema was informed" do
      changeset = Planet.changeset(%Planet{})

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates valid changeset when all parameters are valid" do
      changeset = Planet.changeset(@valid_attrs)

      assert changeset.valid?
    end

    test "returns error when changeset is missing required fields" do
      changeset = Planet.changeset(%{})

      assert changeset.errors == [
               name: {"can't be blank", [validation: :required]},
               climate: {"can't be blank", [validation: :required]},
               terrain: {"can't be blank", [validation: :required]}
             ]
    end

    test "returns data correctly when it's updated" do
      planet =
        Factory.build(:planet, %{
          name: "Kashyyyk",
          climate: "tropical",
          terrain: "forest",
          integration_id: 14
        })

      updated_changeset = Planet.changeset(planet, @valid_attrs)

      assert updated_changeset.changes == %{
               name: @valid_attrs.name,
               climate: @valid_attrs.climate,
               terrain: @valid_attrs.terrain,
               integration_id: @valid_attrs.integration_id
             }
    end

    test "returns error when integration_id is already taken" do
      planet = Factory.insert(:planet)

      assert {:error, changeset} =
               @valid_attrs
               |> Map.put(:integration_id, planet.integration_id)
               |> Planet.changeset()
               |> Repo.insert()

      assert "has already been taken" in errors_on(changeset).integration_id
    end

    test "does not return error when inserting a non conflicted integration_id" do
      _planet = Factory.insert(:planet)
      other_integration_id = "abc"

      assert {:ok, _record} =
               @valid_attrs
               |> Map.put(:integration_id, other_integration_id)
               |> Planet.changeset()
               |> Repo.insert()
    end

    test "does not return error when integration_id is the same as other deleted planet" do
      planet = Factory.insert(:planet, deleted_at: DateTime.now!("Etc/UTC"))

      assert {:ok, _record} =
               @valid_attrs
               |> Map.put(:integration_id, planet.integration_id)
               |> Planet.changeset()
               |> Repo.insert()
    end

    test "ables to insert related films" do
      film_one = Factory.insert(:film) |> Swapi.Repo.reload!()
      film_two = Factory.insert(:film) |> Swapi.Repo.reload!()

      assert {:ok, record} =
               @valid_attrs
               |> Planet.changeset()
               |> put_assoc(:films, [film_one, film_two])
               |> Repo.insert()

      assert record.films == [film_one, film_two]

      reloaded_record = record |> Swapi.Repo.reload!() |> Swapi.Repo.preload(:films)
      assert Enum.sort(reloaded_record.films) == Enum.sort([film_one, film_two])
    end
  end
end
