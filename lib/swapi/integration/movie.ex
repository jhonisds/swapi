defmodule Swapi.Integration.Movie do
  @moduledoc """
  Movie struct.

  Redefine integration source for this struct.
  """

  defstruct [:title, :release_date, :integration_id, :director]
end
