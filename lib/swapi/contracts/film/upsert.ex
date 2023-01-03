defmodule Swapi.Contracts.Film.Upsert do
  @moduledoc """
  Input pattern necessary to perform a film upsert.

  ## Fields:

  - `title` :: Film title.
  - `release_date` :: The movie release date.
  - `integration_id` :: The ID at the integration source.
  - `director` :: The related director ID.
  """
  use CleanArchitecture.Contract

  embedded_schema do
    field :title, :string
    field :release_date, :date
    field :director, :string
    field :integration_id, :string
  end

  @fields [
    :title,
    :release_date,
    :integration_id,
    :director
  ]

  @required @fields

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@required)
  end
end
