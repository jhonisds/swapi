defmodule Swapi.Entities.Planet do
  @moduledoc """
  Planet entity.

  The entity contains the mapped fields.
  """

  use CleanArchitecture.Entity

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "planets" do
    field :name, :string
    field :climate, :string
    field :terrain, :string
    field :integration_id, :string

    field(:deleted_at, :utc_datetime_usec)
    timestamps(type: :utc_datetime_usec)

    many_to_many :films, Swapi.Entities.Film,
      join_through: "planets_films",
      on_delete: :delete_all,
      on_replace: :delete,
      unique: true,
      where: [deleted_at: nil]
  end

  @fields [
    :name,
    :integration_id,
    :climate,
    :terrain,
    :deleted_at
  ]

  @required_fields @fields -- [:integration_id, :deleted_at]

  @doc false
  def changeset do
    changeset(%__MODULE__{}, %{})
  end

  def changeset(%__MODULE__{} = planet) do
    changeset(planet, %{})
  end

  def changeset(%{} = attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(%__MODULE__{} = planet, %{} = attrs) do
    planet
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:integration_id, name: "unique_planet_integration_id")
  end
end
