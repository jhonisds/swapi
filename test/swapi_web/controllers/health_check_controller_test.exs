defmodule SwapiWeb.HealthCheckControllerTest do
  use SwapiWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert response(conn, 200) =~ "ok"
  end
end
