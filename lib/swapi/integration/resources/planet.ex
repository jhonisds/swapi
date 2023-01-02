defmodule Swapi.Integration.Resources.Planet do
  @moduledoc """
  Planet struct.

  Specifies fields received by the integration.
  """

  defstruct [:name, :integration_id, :climate, :terrain, :films]
end
