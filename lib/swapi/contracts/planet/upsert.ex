defmodule Swapi.Contracts.Planet.Upsert do
  @moduledoc """
  Input pattern necessary to perform a planet upsert.

  ## Fields:

  - `name` :: Planet name.
  - `integration_id` :: The ID at the integration.
  - `climate` :: Climate related to the planet.
  - `terrain` :: Terrains related to the planet.
  - `films` :: A list of films related to the planet.
  """
  use CleanArchitecture.Contract

  embedded_schema do
    field :name, :string
    field :integration_id, :string
    field :climate, :string
    field :terrain, :string
    field :films, {:array, :map}
  end

  @fields [
    :name,
    :integration_id,
    :climate,
    :terrain,
    :films
  ]

  @required @fields

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@required)
  end
end
