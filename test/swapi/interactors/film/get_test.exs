defmodule Swapi.Interactors.Film.GetTest do
  use Swapi.DataCase

  alias Swapi.Interactors.Film.Get

  alias Swapi.Repo

  def fixture(attrs \\ %{}) do
    Factory.insert(:film, attrs)
  end

  describe "call/1" do
    test "returns a film by the given id" do
      film = fixture()
      input = %{id: film.id}

      assert Get.call(input) == Repo.reload!(film)
    end

    test "raises cast error when id is in an invalid format" do
      input = %{id: "invalid"}

      assert_raise Ecto.Query.CastError, fn ->
        Get.call(input)
      end
    end

    test "raises not found error when id is not existent" do
      input = %{id: Ecto.UUID.generate()}

      assert_raise Ecto.NoResultsError, fn ->
        Get.call(input)
      end
    end

    test "raises not found error when film is deleted" do
      film = fixture(%{deleted_at: DateTime.utc_now()})
      input = %{id: film.id}

      assert_raise Ecto.NoResultsError, fn ->
        Get.call(input)
      end
    end
  end
end
