defmodule Swapi.Integration.Resources.Film do
  @moduledoc """
  Film struct.

  Specifies fields received by the integration.
  """

  defstruct [:title, :release_date, :integration_id, :director]
end
