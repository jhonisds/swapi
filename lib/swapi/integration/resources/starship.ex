defmodule Swapi.Integration.Resources.Starship do
  @moduledoc """
  Starship struct.

  Specifies fields received by the integration.
  """

  defstruct [:name, :model, :integration_id, :hyperdrive_rating]
end
