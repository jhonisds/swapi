defmodule Mix.Tasks.Start do
  @moduledoc """
  The task responsible for loading a planet from the integration.
  """

  use Mix.Task

  alias Swapi.Cli.Main

  @requirements ["app.start"]

  @impl Mix.Task
  def run(_), do: Main.start_app()
end
