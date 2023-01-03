defmodule Swapi.Entities.Film do
  @moduledoc """
  Film entity.

  The entity contains the mapped fields.
  """

  use CleanArchitecture.Entity

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "films" do
    field :title, :string
    field :release_date, :date
    field :director, :string
    field :integration_id, :string

    field(:deleted_at, :utc_datetime_usec)
    timestamps(type: :utc_datetime_usec)
  end

  @fields [
    :title,
    :release_date,
    :integration_id,
    :director,
    :deleted_at
  ]

  @required_fields @fields -- [:integration_id, :deleted_at]

  @doc false
  def changeset do
    changeset(%__MODULE__{}, %{})
  end

  def changeset(%__MODULE__{} = film) do
    changeset(film, %{})
  end

  def changeset(%{} = attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(%__MODULE__{} = film, %{} = attrs) do
    film
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:integration_id, name: "unique_film_integration_id")
  end
end
