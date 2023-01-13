defmodule Swapi.Integration.Resources.FilmTest do
  use Swapi.DataCase

  alias Swapi.Integration.Resources.Film

  describe "struct" do
    test "defaults attributes to nil" do
      response = %Film{}

      assert nil == response.title
      assert nil == response.release_date
      assert nil == response.director
      assert nil == response.integration_id
    end

    test "accepts attributes" do
      response = %Film{
        title: "A New Hope",
        release_date: ~D[2000-01-01],
        integration_id: "1",
        director: "George Lucas"
      }

      assert "A New Hope" == response.title
      assert ~D[2000-01-01] == response.release_date
      assert "George Lucas" == response.director
      assert "1" == response.integration_id
    end
  end
end
