defmodule Swapi.Cli.UserInterface do
  @moduledoc """
  Provides user interface to load resources.
  """

  alias Mix.Shell.IO, as: Shell

  require Logger

  @options ["Exit"]

  def options do
    {:ok, options} = Swapi.Integration.StarWarsAPI.list_resources()

    options
    |> Map.from_struct()
    |> Enum.into([], fn {k, _v} -> Atom.to_string(k) end)
    |> List.insert_at(-1, @options)
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
      x when x in 0..5 ->
        input(mode[:description])

      6 ->
        Shell.info("May the force be with you.")
        Shell.cmd("exit")
    end
  end

  defp input(resource) do
    Shell.cmd("clear")
    Shell.info("-------- [Load #{resource}] ----------")
    Shell.info("URL: https://swapi.dev/api/#{resource}/:id")

    integration_id = Shell.prompt("Enter the [:id]:")

    case Swapi.Integration.StarWarsAPI.get_resource(resource, integration_id) do
      {:ok, response} ->
        Logger.info(
          "#{String.capitalize(resource)} was successfully integrated! - #{inspect(response)}",
          module: __MODULE__,
          function_name: :input
        )

      {:error, reason} ->
        display_invalid_option(reason)
    end
  end
end
