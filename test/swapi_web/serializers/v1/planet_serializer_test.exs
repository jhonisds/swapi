defmodule SwapiWeb.V1.PlanetSerializerTest do
  use Swapi.DataCase

  alias Swapi.Repo
  alias SwapiWeb.V1.PlanetSerializer

  alias SwapiWeb.V1.FilmSerializer

  defp fixture(attrs \\ %{}) do
    Factory.insert(:planet, attrs)
  end

  describe "serialize/1" do
    test "returns serialized record with root key" do
      record = fixture() |> Repo.preload([:films])

      assert PlanetSerializer.serialize(record) == %{
               data: %{
                 id: record.id,
                 name: record.name,
                 climate: record.climate,
                 terrain: record.terrain,
                 films: FilmSerializer.serialize(record.films),
                 inserted_at: record.inserted_at,
                 updated_at: record.updated_at
               }
             }
    end

    test "returns serialized records with root key for pagination" do
      record_one = fixture() |> Repo.preload([:films])
      record_two = fixture() |> Repo.preload([:films])

      pagination = %CleanArchitecture.Pagination{
        entries: [record_one, record_two],
        page_number: 1,
        page_size: 10,
        total_entries: 2,
        total_pages: 1
      }

      assert PlanetSerializer.serialize(pagination) == %{
               data: [
                 %{
                   id: record_one.id,
                   name: record_one.name,
                   climate: record_one.climate,
                   terrain: record_one.terrain,
                   films: FilmSerializer.serialize(record_one.films),
                   inserted_at: record_one.inserted_at,
                   updated_at: record_one.updated_at
                 },
                 %{
                   id: record_two.id,
                   name: record_two.name,
                   climate: record_two.climate,
                   terrain: record_two.terrain,
                   films: FilmSerializer.serialize(record_two.films),
                   inserted_at: record_two.inserted_at,
                   updated_at: record_two.updated_at
                 }
               ],
               meta: %{
                 page_number: 1,
                 page_size: 10,
                 total_entries: 2,
                 total_pages: 1
               }
             }
    end
  end

  describe "serialize/2" do
    test "returns serialized record without root key" do
      record = fixture() |> Repo.preload([:films])

      assert PlanetSerializer.serialize(record, :without_root_key) == %{
               id: record.id,
               name: record.name,
               climate: record.climate,
               terrain: record.terrain,
               films: FilmSerializer.serialize(record.films),
               inserted_at: record.inserted_at,
               updated_at: record.updated_at
             }
    end

    test "returns nil" do
      assert PlanetSerializer.serialize(nil, :without_root_key) == nil
    end
  end
end
