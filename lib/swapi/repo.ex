defmodule Swapi.Repo do
  use Ecto.Repo,
    otp_app: :swapi,
    adapter: Ecto.Adapters.Postgres
end
