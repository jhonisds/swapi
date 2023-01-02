defmodule Swapi.Cli.Main do
  @moduledoc """
  Perform CLI interaction.
  """
  alias Mix.Shell.IO, as: Shell
  alias Swapi.Cli.UserInterface

  def start_app do
    welcome_message()

    UserInterface.start()
  end

  defp welcome_message do
    Shell.cmd("clear")
    Shell.info("--------- [Star Wars API] --------")
    Shell.prompt("Press Enter to continue")
    Shell.cmd("clear")
    Shell.info("Choose resource:")
  end
end
