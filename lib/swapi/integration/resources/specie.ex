defmodule Swapi.Integration.Resources.Specie do
  @moduledoc """
  Specie struct.

  Specifies fields received by the integration.
  """

  defstruct [:name, :language, :integration_id, :classification]
end
