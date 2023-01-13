defmodule SwapiWeb.V1.PlanetControllerTest do
  use SwapiWeb.ConnCase

  alias CleanArchitecture.Pagination
  alias SwapiWeb.V1.PlanetSerializer

  alias Swapi.Repo

  defp planet_fixture(attrs \\ %{}) do
    Factory.insert(:planet, attrs)
    |> Repo.preload([:films])
  end

  describe "index" do
    test "returns 200 with empty list when does not have planets created", %{conn: conn} do
      conn = get(conn, Routes.planet_path(conn, :index))
      body = response(conn, 200)

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      expected_body =
        %Pagination{entries: [], page_number: 1, page_size: 10, total_entries: 0, total_pages: 0}
        |> PlanetSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "returns 200 with planets list", %{conn: conn} do
      one = planet_fixture(%{name: "Planet one"})
      two = planet_fixture(%{name: "Planet two"})

      conn = get(conn, Routes.planet_path(conn, :index))

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      body = response(conn, 200)

      expected_body =
        %Pagination{
          entries: [two, one],
          page_number: 1,
          page_size: 10,
          total_entries: 2,
          total_pages: 1
        }
        |> PlanetSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "excludes deleted records from list", %{conn: conn} do
      one = planet_fixture(%{name: "A"})
      _deleted = planet_fixture(%{name: "B", deleted_at: DateTime.now!("Etc/UTC")})
      two = planet_fixture(%{name: "B"})

      conn = get(conn, Routes.planet_path(conn, :index))

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      body = response(conn, 200)

      expected_body =
        %Pagination{
          entries: [two, one],
          page_number: 1,
          page_size: 10,
          total_entries: 2,
          total_pages: 1
        }
        |> PlanetSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "returns 200 with paginated planets list", %{conn: conn} do
      one = planet_fixture(%{name: "Planet one"})
      _two = planet_fixture(%{name: "Planet two"})

      conn = get conn, Routes.planet_path(conn, :index), %{page: 2, page_size: 1}

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      body = response(conn, 200)

      expected_body =
        %Pagination{
          entries: [one],
          page_number: 2,
          page_size: 1,
          total_entries: 2,
          total_pages: 2
        }
        |> PlanetSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "returns 200 with filtered planets list by name", %{conn: conn} do
      one = planet_fixture(%{name: "A"})
      _two = planet_fixture(%{name: "B"})

      conn = get conn, Routes.planet_path(conn, :index), %{name: "A"}

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      body = response(conn, 200)

      expected_body =
        %Pagination{
          entries: [one],
          page_number: 1,
          page_size: 10,
          total_entries: 1,
          total_pages: 1
        }
        |> PlanetSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end
  end

  describe "show" do
    test "returns 200 with planet", %{conn: conn} do
      planet = planet_fixture()

      conn = get(conn, Routes.planet_path(conn, :show, planet.id))

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      body = response(conn, 200)

      expected_body =
        planet
        |> PlanetSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "returns 404 status error when planet id does not exist", %{conn: conn} do
      {_status, _headers, body} =
        assert_error_sent :not_found, fn ->
          get(conn, Routes.planet_path(conn, :show, Ecto.UUID.generate()))
        end

      json_body = Phoenix.json_library().decode!(body)
      assert json_body["errors"]["detail"] == "Not Found"
    end
  end

  describe "delete" do
    test "returns 204 without content and deletes the planet", %{conn: conn} do
      planet = planet_fixture()

      conn = delete(conn, Routes.planet_path(conn, :delete, planet.id))

      body = response(conn, 204)
      assert body == ""

      reloaded_planet = Repo.reload!(planet)

      current_timestamp = DateTime.now!("Etc/UTC")

      assert DateTime.diff(reloaded_planet.deleted_at, current_timestamp) < 10
    end

    test "returns 404 status error when planet id does not exist", %{conn: conn} do
      {_status, _headers, body} =
        assert_error_sent :not_found, fn ->
          delete(conn, Routes.planet_path(conn, :delete, Ecto.UUID.generate()))
        end

      json_body = Phoenix.json_library().decode!(body)
      assert json_body["errors"]["detail"] == "Not Found"
    end
  end
end
