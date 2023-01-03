defmodule Swapi.Contracts.Planet.Load do
  @moduledoc """
  Input pattern necessary to perform a planet load from an integration.

  ## Fields:

  - `resource` :: The integration source used to load the planet.
  - `integration_id` :: The ID at the integration source.
  """
  use CleanArchitecture.Contract

  embedded_schema do
    field :resource, :string
    field :integration_id, :string
  end

  @fields [
    :resource,
    :integration_id
  ]

  @required @fields

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@required)
  end
end
