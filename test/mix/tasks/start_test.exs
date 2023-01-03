defmodule Mix.Tasks.StartTest do
  use Swapi.DataCase

  alias Mix.Tasks.Start

  import Mock

  describe "run" do
    test "calls use case with the right parameters" do
      with_mock(
        Swapi,
        load_resource: fn _attrs ->
          "fake_response"
        end
      ) do
        # assert "fake_response" == Start.run()

        assert_called_exactly(
          Swapi.load_resource(%{resource: "planet", integration_id: "123"}),
          1
        )
      end
    end
  end
end
