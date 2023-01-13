defmodule Swapi.Cli.UserInterface do
  @moduledoc """
  This module provides user interface to load resources.
  """

  alias Mix.Shell.IO, as: Shell

  require Logger

  def options do
    ["planets", "exit"]
  end

  def start do
    options()
    |> ask_for_options()
    |> confirm()
  end

  def ask_for_options(options) do
    index = ask_for_index(options)

    case Enum.at(options, index) do
      nil ->
        display_invalid_option("Invalid option.")
        ask_for_options(options)

      result ->
        %{index: index, description: result}
    end
  end

  def ask_for_index(options) do
    answer =
      options
      |> display_options()
      |> operations()
      |> Shell.prompt()
      |> Integer.parse()

    case answer do
      :error ->
        display_invalid_option("Invalid option.")
        ask_for_index(options)

      {option, _} ->
        option - 1
    end
  end

  def display_options(options) do
    options
    |> Enum.with_index(1)
    |> Enum.each(fn {option, index} -> Shell.info("#{index} - #{option}") end)

    options
  end

  def operations(options) do
    options = Enum.join(1..Enum.count(options), ",")
    "Which resource? [#{options}]\n"
  end

  def display_invalid_option(message) do
    Shell.cmd("clear")
    Shell.error(message)
    Shell.cmd("exit")
    Shell.prompt("Press enter to try again.")
    Shell.cmd("clear")
    start()
  end

  defp confirm(mode) do
    Shell.cmd("clear")

    if Shell.yes?("Confirm option: #{mode.description}"),
      do: launch_choice(mode),
      else: start()
  end

  defp launch_choice(mode) do
    case mode[:index] do
      0 ->
        input(mode[:description])

      1 ->
        Shell.info("May the force be with you.")
        Shell.cmd("exit")
    end
  end

  defp input(resource) do
    Shell.cmd("clear")
    Shell.info("-------- [Load #{resource}] ----------")
    Shell.info("URL: https://swapi.dev/api/#{resource}/:id")

    integration_id = Shell.prompt("Enter the [:id]:")

    case Swapi.load_planet(%{resource: resource, integration_id: integration_id}) do
      {:ok, response} ->
        Logger.info(
          "#{String.capitalize(resource)} was successfully integrated! - #{inspect(response)}",
          module: __MODULE__,
          function_name: :input
        )

      {:error, reason} ->
        Logger.log(:error, reason, module: __MODULE__, function_name: :input)
        display_invalid_option(reason)
    end
  end
end
