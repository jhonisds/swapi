defmodule Swapi.Integration.Planet do
  @moduledoc """
  Planet struct.

  Redefine integration source for this struct.
  """

  defstruct [:name, :integration_id, :climate, :terrain, :movies]
end
