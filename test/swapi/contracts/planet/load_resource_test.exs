defmodule Swapi.Contracts.Planet.LoadResourceTest do
  use Swapi.DataCase

  alias Swapi.Contracts.Planet.LoadResource

  @valid_attrs %{
    resource: "planet",
    integration_id: "1"
  }

  describe "changeset" do
    test "creates valid changeset when all parameters are valid" do
      changeset = LoadResource.changeset(@valid_attrs)

      assert changeset.valid?
    end

    test "returns error when changeset is missing any required field" do
      changeset = LoadResource.changeset(%{})

      assert Enum.sort(changeset.errors) ==
               Enum.sort(
                 resource: {"can't be blank", [validation: :required]},
                 integration_id: {"can't be blank", [validation: :required]}
               )
    end

    test "returns error when resource is invalid" do
      attrs = Map.put(@valid_attrs, :resource, :invalid)
      changeset = LoadResource.changeset(attrs)

      assert "is invalid" in errors_on(changeset).resource
    end
  end
end
