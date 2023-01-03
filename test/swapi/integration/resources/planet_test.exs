defmodule Swapi.Integration.Resources.PlanetTest do
  use Swapi.DataCase

  alias Swapi.Integration.Resources.Film
  alias Swapi.Integration.Resources.Planet

  describe "struct" do
    test "defaults attributes to nil" do
      response = %Planet{}

      assert nil == response.name
      assert nil == response.integration_id
      assert nil == response.climate
      assert nil == response.terrain
      assert nil == response.films
    end

    test "accepts attributes" do
      response = %Planet{
        name: "Tatooine",
        integration_id: "1",
        climate: "Arid",
        terrain: "Ocean",
        films: [
          %Film{
            title: "A New Hope",
            release_date: ~D[2000-01-01],
            integration_id: "1",
            director: "George Lucas"
          }
        ]
      }

      assert "Tatooine" == response.name
      assert "1" == response.integration_id
      assert "Arid" == response.climate
      assert "Ocean" == response.terrain

      assert [
               %Film{
                 title: "A New Hope",
                 release_date: ~D[2000-01-01],
                 integration_id: "1",
                 director: "George Lucas"
               }
             ] == response.films
    end
  end
end
