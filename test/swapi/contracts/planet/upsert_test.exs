defmodule Swapi.Contracts.Planet.UpsertTest do
  use Swapi.DataCase

  alias Swapi.Contracts.Planet.Upsert

  alias Swapi.Entities.Film

  @valid_attrs %{
    name: "Tatooine",
    integration_id: "#{:rand.uniform(999_999_999)}",
    climate: "Arid",
    terrain: "Ocean",
    films: [%Film{id: Ecto.UUID.generate()}]
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
                 name: {"can't be blank", [validation: :required]},
                 integration_id: {"can't be blank", [validation: :required]},
                 climate: {"can't be blank", [validation: :required]},
                 terrain: {"can't be blank", [validation: :required]},
                 films: {"can't be blank", [validation: :required]}
               )
    end
  end
end
