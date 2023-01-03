defmodule Swapi.Entities.FilmTest do
  use Swapi.DataCase

  alias Swapi.Entities.Film
  alias Swapi.Support.Factory

  @valid_attrs %{
    title: "A New Hope",
    release_date: ~D[2000-01-01],
    integration_id: "#{:rand.uniform(999_999_999)}",
    director: "George Lucas"
  }

  describe "changeset" do
    test "creates a changeset when no parameters was informed" do
      changeset = Film.changeset()

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates a changeset when just the schema was informed" do
      changeset = Film.changeset(%Film{})

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates valid changeset when all parameters are valid" do
      changeset = Film.changeset(@valid_attrs)

      assert changeset.valid?
    end

    test "returns error when changeset is missing required fields" do
      changeset = Film.changeset(%{})

      assert changeset.errors == [
               title: {"can't be blank", [validation: :required]},
               release_date: {"can't be blank", [validation: :required]},
               director: {"can't be blank", [validation: :required]}
             ]
    end

    test "returns data correctly when it's updated" do
      film =
        Factory.build(:film, %{
          title: "The Empire Strikes Back",
          release_date: ~D[2002-02-02],
          integration_id: "321",
          director: "Irvin Kershner"
        })

      updated_changeset = Film.changeset(film, @valid_attrs)

      assert updated_changeset.changes == %{
               title: @valid_attrs.title,
               release_date: @valid_attrs.release_date,
               integration_id: @valid_attrs.integration_id,
               director: @valid_attrs.director
             }
    end

    test "returns error when integration_id is already taken" do
      film = Factory.insert(:film)

      assert {:error, changeset} =
               @valid_attrs
               |> Map.put(:integration_id, film.integration_id)
               |> Film.changeset()
               |> Repo.insert()

      assert "has already been taken" in errors_on(changeset).integration_id
    end

    test "does not return error when inserting a non conflicted integration_id" do
      _film = Factory.insert(:film)
      other_integration_id = "abc"

      assert {:ok, _record} =
               @valid_attrs
               |> Map.put(:integration_id, other_integration_id)
               |> Film.changeset()
               |> Repo.insert()
    end

    test "does not return error when integration_id is deleted film" do
      film = Factory.insert(:film, deleted_at: DateTime.now!("Etc/UTC"))

      assert {:ok, _record} =
               @valid_attrs
               |> Map.put(:integration_id, film.integration_id)
               |> Film.changeset()
               |> Repo.insert()
    end
  end
end
