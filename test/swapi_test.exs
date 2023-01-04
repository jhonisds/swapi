defmodule SwapiTest do
  use Swapi.DataCase
  import Mock

  alias CleanArchitecture.Pagination

  alias Ecto.Changeset
  alias Swapi.Contracts
  alias Swapi.Interactors

  alias Swapi.Entities.Film
  alias Swapi.Entities.Planet

  # Film

  describe "list_films/1" do
    test "calls right interactor and handles output for empty list" do
      pagination = %Pagination{
        entries: [],
        page_number: 1,
        page_size: 1,
        total_entries: 0,
        total_pages: 1
      }

      with_mocks([
        {Interactors.Film.List, [], [call: fn _input -> pagination end]},
        {Contracts.Film.List, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{name: ""}
        assert pagination == Swapi.list_films(input)

        assert_called_exactly(Interactors.Film.List.call(input), 1)
        assert_called_exactly(Contracts.Film.List.validate_input(input), 1)
      end
    end

    test "calls right interactor and handles output for non empty list" do
      pagination = %Pagination{
        entries: [%Film{}],
        page_number: 1,
        page_size: 1,
        total_entries: 1,
        total_pages: 1
      }

      with_mocks([
        {Interactors.Film.List, [], [call: fn _input -> pagination end]},
        {Contracts.Film.List, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{name: ""}
        assert pagination == Swapi.list_films(input)

        assert_called_exactly(Interactors.Film.List.call(input), 1)
        assert_called_exactly(Contracts.Film.List.validate_input(input), 1)
      end
    end

    test "calls right interactor and raises when output is not a pagination" do
      not_pagination_output = %{
        entries: [%Film{}],
        page_number: 1,
        page_size: 1,
        total_entries: 1,
        total_pages: 1
      }

      with_mocks([
        {Interactors.Film.List, [], [call: fn _input -> not_pagination_output end]},
        {Contracts.Film.List, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{name: ""}

        assert_raise MatchError, fn ->
          Swapi.list_films(input)
        end

        assert_called_exactly(Interactors.Film.List.call(input), 1)
        assert_called_exactly(Contracts.Film.List.validate_input(input), 1)
      end
    end

    test "calls right interactor and handles invalid input" do
      with_mocks([
        {Interactors.Film.List, [], [call: fn _input -> :ok end]},
        {Contracts.Film.List, [], [validate_input: fn _attrs -> {:error, %Ecto.Changeset{}} end]}
      ]) do
        input = %{name: ""}

        assert {:error, %Ecto.Changeset{}} ==
                 Swapi.list_films(input)

        assert_not_called(Interactors.Film.List.call(input))
        assert_called_exactly(Contracts.Film.List.validate_input(input), 1)
      end
    end
  end

  describe "get_film!/1" do
    test "calls right interactor and handles output for Movie struct" do
      with_mocks([
        {Interactors.Film.Get, [], [call: fn _input -> %Film{} end]},
        {Contracts.Film.Get, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{id: ""}
        assert %Film{} == Swapi.get_film!(input)

        assert_called_exactly(Interactors.Film.Get.call(input), 1)
        assert_called_exactly(Contracts.Film.Get.validate_input(input), 1)
      end
    end

    test "calls right interactor and raises when output is not a Movie struct" do
      with_mocks([
        {Interactors.Film.Get, [], [call: fn _input -> "string" end]},
        {Contracts.Film.Get, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{id: ""}

        assert_raise MatchError, fn ->
          Swapi.get_film!(input)
        end

        assert_called_exactly(Interactors.Film.Get.call(input), 1)
        assert_called_exactly(Contracts.Film.Get.validate_input(input), 1)
      end
    end

    test "calls right interactor and handles invalid input" do
      with_mocks([
        {Interactors.Film.Get, [], [call: fn _input -> %Film{} end]},
        {Contracts.Film.Get, [], [validate_input: fn _attrs -> {:error, %Ecto.Changeset{}} end]}
      ]) do
        input = %{id: ""}

        assert {:error, %Ecto.Changeset{}} ==
                 Swapi.get_film!(input)

        assert_not_called(Interactors.Film.Get.call(input))
        assert_called_exactly(Contracts.Film.Get.validate_input(input), 1)
      end
    end
  end

  describe "upsert_film/1" do
    test "calls right interactor and handles :ok output" do
      with_mocks([
        {Interactors.Film.Upsert, [], [call: fn _input -> {:ok, %Film{}} end]},
        {Contracts.Film.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:ok, %Film{}} == Swapi.upsert_film(input)

        assert_called_exactly(Interactors.Film.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and handles :error output" do
      with_mocks([
        {Interactors.Film.Upsert, [], [call: fn _input -> {:error, %Changeset{}} end]},
        {Contracts.Film.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:error, %Changeset{}} == Swapi.upsert_film(input)

        assert_called_exactly(Interactors.Film.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and raises when output is not handled" do
      with_mocks([
        {Interactors.Film.Upsert, [], [call: fn _input -> %Film{} end]},
        {Contracts.Film.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert_raise WithClauseError, fn ->
          Swapi.upsert_film(input)
        end

        assert_called_exactly(Interactors.Film.Upsert.call(input), 1)
      end
    end
  end

  # Planet

  describe "list_planets/1" do
    test "calls right interactor and handles output for empty list" do
      pagination = %Pagination{
        entries: [],
        page_number: 1,
        page_size: 1,
        total_entries: 0,
        total_pages: 1
      }

      with_mocks([
        {Interactors.Planet.List, [], [call: fn _input -> pagination end]},
        {Contracts.Planet.List, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{name: ""}
        assert pagination == Swapi.list_planets(input)

        assert_called_exactly(Interactors.Planet.List.call(input), 1)
        assert_called_exactly(Contracts.Planet.List.validate_input(input), 1)
      end
    end

    test "calls right interactor and handles output for non empty list" do
      pagination = %Pagination{
        entries: [%Planet{}],
        page_number: 1,
        page_size: 1,
        total_entries: 1,
        total_pages: 1
      }

      with_mocks([
        {Interactors.Planet.List, [], [call: fn _input -> pagination end]},
        {Contracts.Planet.List, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{name: ""}
        assert pagination == Swapi.list_planets(input)

        assert_called_exactly(Interactors.Planet.List.call(input), 1)
        assert_called_exactly(Contracts.Planet.List.validate_input(input), 1)
      end
    end

    test "calls right interactor and raises when output is not a pagination" do
      not_pagination_output = %{
        entries: [%Planet{}],
        page_number: 1,
        page_size: 1,
        total_entries: 1,
        total_pages: 1
      }

      with_mocks([
        {Interactors.Planet.List, [], [call: fn _input -> not_pagination_output end]},
        {Contracts.Planet.List, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{name: ""}

        assert_raise MatchError, fn ->
          Swapi.list_planets(input)
        end

        assert_called_exactly(Interactors.Planet.List.call(input), 1)
        assert_called_exactly(Contracts.Planet.List.validate_input(input), 1)
      end
    end

    test "calls right interactor and handles invalid input" do
      with_mocks([
        {Interactors.Planet.List, [], [call: fn _input -> :ok end]},
        {Contracts.Planet.List, [],
         [validate_input: fn _attrs -> {:error, %Ecto.Changeset{}} end]}
      ]) do
        input = %{name: ""}

        assert {:error, %Ecto.Changeset{}} ==
                 Swapi.list_planets(input)

        assert_not_called(Interactors.Planet.List.call(input))
        assert_called_exactly(Contracts.Planet.List.validate_input(input), 1)
      end
    end
  end

  describe "get_planet!/1" do
    test "calls right interactor and handles output for Planet struct" do
      with_mocks([
        {Interactors.Planet.Get, [], [call: fn _input -> %Planet{} end]},
        {Contracts.Planet.Get, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{id: ""}
        assert %Planet{} == Swapi.get_planet!(input)

        assert_called_exactly(Interactors.Planet.Get.call(input), 1)
        assert_called_exactly(Contracts.Planet.Get.validate_input(input), 1)
      end
    end

    test "calls right interactor and raises when output is not a Planet struct" do
      with_mocks([
        {Interactors.Planet.Get, [], [call: fn _input -> "string" end]},
        {Contracts.Planet.Get, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{id: ""}

        assert_raise MatchError, fn ->
          Swapi.get_planet!(input)
        end

        assert_called_exactly(Interactors.Planet.Get.call(input), 1)
        assert_called_exactly(Contracts.Planet.Get.validate_input(input), 1)
      end
    end

    test "calls right interactor and handles invalid input" do
      with_mocks([
        {Interactors.Planet.Get, [], [call: fn _input -> %Planet{} end]},
        {Contracts.Planet.Get, [], [validate_input: fn _attrs -> {:error, %Ecto.Changeset{}} end]}
      ]) do
        input = %{id: ""}

        assert {:error, %Ecto.Changeset{}} ==
                 Swapi.get_planet!(input)

        assert_not_called(Interactors.Planet.Get.call(input))
        assert_called_exactly(Contracts.Planet.Get.validate_input(input), 1)
      end
    end
  end

  describe "upsert_planet/1" do
    test "calls right interactor and handles :ok output" do
      with_mocks([
        {Interactors.Planet.Upsert, [], [call: fn _input -> {:ok, %Planet{}} end]},
        {Contracts.Planet.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:ok, %Planet{}} == Swapi.upsert_planet(input)

        assert_called_exactly(Interactors.Planet.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and handles :error output" do
      with_mocks([
        {Interactors.Planet.Upsert, [], [call: fn _input -> {:error, %Changeset{}} end]},
        {Contracts.Planet.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:error, %Changeset{}} == Swapi.upsert_planet(input)

        assert_called_exactly(Interactors.Planet.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and raises when output is not handled" do
      with_mocks([
        {Interactors.Planet.Upsert, [], [call: fn _input -> %Planet{} end]},
        {Contracts.Planet.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert_raise WithClauseError, fn ->
          Swapi.upsert_planet(input)
        end

        assert_called_exactly(Interactors.Planet.Upsert.call(input), 1)
      end
    end
  end

  describe "load_planet/1" do
    test "calls right interactor and handles :ok output" do
      with_mocks([
        {Interactors.Planet.Load, [], [call: fn _input -> {:ok, %Planet{}} end]},
        {Contracts.Planet.Load, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:ok, %Planet{}} == Swapi.load_planet(input)

        assert_called_exactly(Interactors.Planet.Load.call(input), 1)
      end
    end

    test "calls right interactor and handles :error output" do
      with_mocks([
        {Interactors.Planet.Load, [], [call: fn _input -> {:error, %Changeset{}} end]},
        {Contracts.Planet.Load, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:error, %Changeset{}} == Swapi.load_planet(input)

        assert_called_exactly(Interactors.Planet.Load.call(input), 1)
      end
    end

    test "calls right interactor and handles not changeset :error output" do
      with_mocks([
        {Interactors.Planet.Load, [], [call: fn _input -> {:error, :invalid_response} end]},
        {Contracts.Planet.Load, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:error, :invalid_response} == Swapi.load_planet(input)

        assert_called_exactly(Interactors.Planet.Load.call(input), 1)
      end
    end

    test "calls right interactor and raises when output is not handled" do
      with_mocks([
        {Interactors.Planet.Load, [], [call: fn _input -> %Planet{} end]},
        {Contracts.Planet.Load, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert_raise WithClauseError, fn ->
          Swapi.load_planet(input)
        end

        assert_called_exactly(Interactors.Planet.Load.call(input), 1)
      end
    end
  end

  describe "delete_planet/1" do
    test "calls right interactor and handles :ok output" do
      with_mocks([
        {Interactors.Planet.Delete, [], [call: fn _input -> {:ok, %Planet{}} end]},
        {Contracts.Planet.Delete, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:ok, %Planet{}} == Swapi.delete_planet(input)

        assert_called_exactly(Interactors.Planet.Delete.call(input), 1)
      end
    end

    test "calls right interactor and handles :error output" do
      with_mocks([
        {Interactors.Planet.Delete, [], [call: fn _input -> {:error, %Changeset{}} end]},
        {Contracts.Planet.Delete, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:error, %Changeset{}} == Swapi.delete_planet(input)

        assert_called_exactly(Interactors.Planet.Delete.call(input), 1)
      end
    end

    test "calls right interactor and raises when output is not handled" do
      with_mocks([
        {Interactors.Planet.Delete, [], [call: fn _input -> %Planet{} end]},
        {Contracts.Planet.Delete, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert_raise WithClauseError, fn ->
          Swapi.delete_planet(input)
        end

        assert_called_exactly(Interactors.Planet.Delete.call(input), 1)
      end
    end
  end
end
