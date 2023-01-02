defmodule Swapi.Integration.Resources.People do
  @moduledoc """
  People struct.

  Specifies fields received by the integration.
  """

  defstruct [:name, :gender, :integration_id, :planet]
end
