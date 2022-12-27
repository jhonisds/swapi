defmodule SwapiWeb.HealthCheckController do
  use Phoenix.Controller, namespace: SwapiWeb

  import Plug.Conn

  def index(conn, _params) do
    send_resp(conn, 200, "ok")
  end
end
