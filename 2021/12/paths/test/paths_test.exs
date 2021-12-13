defmodule PathsTest do
  use ExUnit.Case
  doctest Paths

  test "generates a map" do
    contents = "start-A\nstart-b\nA-b\nA-end\nb-end"
    assert Paths.to_map(contents) == %{
      "start" => ["A", "b"],
      "A" => ["b", "end"],
      "b" => ["A", "end"]
    }
  end

  test "find paths" do
    # paths
    # start-A-end, start-A-b-A-end, start-A-b-end
    # start-b-end, start-b-A-End
    m = %{
      "start" => ["A", "b"],
      "A" => ["b", "end"],
      "b" => ["A", "end"]
    }

    count =
      Paths.find(m)
      |> List.flatten
      |> Enum.filter(&(&1 == "end"))
      |> Enum.count

    assert count == 5
  end
end
