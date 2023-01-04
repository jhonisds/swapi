defmodule Swapi.Contracts.Planet.LoadTest do
  use Swapi.DataCase

  alias Swapi.Contracts.Planet.Load

  @valid_attrs %{
    resource: "planet",
    integration_id: "1"
  }

  describe "changeset" do
    test "creates valid changeset when all parameters are valid" do
      changeset = Load.changeset(@valid_attrs)

      assert changeset.valid?
    end

    test "returns error when changeset is missing any required field" do
      changeset = Load.changeset(%{})

      assert Enum.sort(changeset.errors) ==
               Enum.sort(
                 resource: {"can't be blank", [validation: :required]},
                 integration_id: {"can't be blank", [validation: :required]}
               )
    end

    test "returns error when resource is invalid" do
      attrs = Map.put(@valid_attrs, :resource, :invalid)
      changeset = Load.changeset(attrs)

      assert "is invalid" in errors_on(changeset).resource
    end
  end
end
