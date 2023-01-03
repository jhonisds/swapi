defmodule Swapi.Contracts.Film.UpsertTest do
  use Swapi.DataCase

  alias Swapi.Contracts.Film.Upsert

  @valid_attrs %{
    title: "A New Hope",
    release_date: ~D[2000-01-01],
    integration_id: "#{:rand.uniform(999_999_999)}",
    director: "George Lucas"
  }

  describe "changeset" do
    test "creates valid changeset when all parameters are valid" do
      changeset = Upsert.changeset(@valid_attrs)

      assert changeset.valid?
    end

    test "returns error when changeset is missing any required field" do
      changeset = Upsert.changeset(%{})

      assert Enum.sort(changeset.errors) ==
               Enum.sort(
                 title: {"can't be blank", [validation: :required]},
                 release_date: {"can't be blank", [validation: :required]},
                 integration_id: {"can't be blank", [validation: :required]},
                 director: {"can't be blank", [validation: :required]}
               )
    end
  end
end
