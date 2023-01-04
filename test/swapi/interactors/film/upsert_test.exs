defmodule Swapi.Interactors.Film.UpsertTest do
  use Swapi.DataCase

  alias Swapi.Entities.Film

  alias Swapi.Interactors.Film.Upsert
  alias Swapi.Repo

  @valid_attrs %{
    title: "A New Hope",
    release_date: ~D[2002-12-01],
    integration_id: "#{:rand.uniform(999_999_999)}",
    director: "George Lucas"
  }

  defp film_fixture(attrs) do
    Factory.insert(:film, attrs)
  end

  defp assert_has_upserted_film_attrs(film) do
    assert_match = fn film ->
      assert film.title == @valid_attrs.title
      assert film.release_date == @valid_attrs.release_date
      assert film.integration_id == @valid_attrs.integration_id
      assert film.director == @valid_attrs.director
    end

    assert_match.(film)

    persisted_film = Repo.reload!(film)
    assert_match.(persisted_film)
  end

  describe "call/1" do
    test "creates a film when does not exist one" do
      assert Repo.aggregate(Film, :count, :id) == 0

      assert {:ok, %Film{} = film} = Upsert.call(@valid_attrs)

      assert_has_upserted_film_attrs(film)

      assert Repo.aggregate(Film, :count, :id) == 1
    end

    test "updates a film when already exists one" do
      film_fixture(%{
        integration_id: @valid_attrs.integration_id
      })

      assert Repo.aggregate(Film, :count, :id) == 1

      assert {:ok, %Film{} = film} = Upsert.call(@valid_attrs)

      assert_has_upserted_film_attrs(film)

      assert Repo.aggregate(Film, :count, :id) == 1
    end

    test "does not create film when attrs are invalid" do
      attrs = Map.merge(@valid_attrs, %{release_date: nil})

      assert Repo.aggregate(Film, :count, :id) == 0

      assert {:error, %Ecto.Changeset{} = changeset} = Upsert.call(attrs)

      assert "can't be blank" in errors_on(changeset).release_date

      assert Repo.aggregate(Film, :count, :id) == 0
    end

    test "does not update when attrs are invalid" do
      film =
        film_fixture(%{
          integration_id: @valid_attrs.integration_id
        })

      attrs = Map.merge(@valid_attrs, %{release_date: nil})

      assert {:error, %Ecto.Changeset{} = changeset} = Upsert.call(attrs)

      assert "can't be blank" in errors_on(changeset).release_date

      reloaded_film = Repo.reload(film)

      assert reloaded_film.release_date == film.release_date
    end
  end
end
