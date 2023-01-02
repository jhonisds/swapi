defmodule Swapi.Integration.Resources.Root do
  @moduledoc """
  Root struct.

  Specifies fields received by the integration.
  """

  defstruct [:films, :people, :planets, :species, :starships, :vehicles]
end
