defmodule Swapi.Integration.Resources.Vehicle do
  @moduledoc """
  Vehicle struct.

  Specifies fields received by the integration.
  """

  defstruct [:name, :model, :integration_id, :max_atmosphering_speed]
end
