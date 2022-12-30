defmodule Swapi.Integration.Resource do
  @moduledoc """
  Resource struct.

  Redefine integration source for this struct.
  """

  defstruct [:films, :people, :planets, :species, :starships, :vehicles]
end
