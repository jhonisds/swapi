defmodule Swapi.HTTPClient do
  @moduledoc """
  Wrapper around HTTP client library (HTTPoison)
  """

  def get("" <> url) do
    url
    |> HTTPoison.get()
    |> response
  end

  defp response({:ok, %HTTPoison.Response{status_code: 200} = response}),
    do: {:ok, response}

  defp response({:ok, %HTTPoison.Response{status_code: status_code}})
       when is_integer(status_code) and status_code >= 300 do
    {:error, "Resource not found - status code: #{status_code}"}
  end

  defp response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
