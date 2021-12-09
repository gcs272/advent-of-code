defmodule SmokeTest do
  use ExUnit.Case
  doctest Smoke

  test "reads the map" do
    assert Smoke.read("1234\n5678") == {{1, 2, 3, 4}, {5, 6, 7, 8}}
  end

  test "finds low points" do
    assert Smoke.low_points({
             {5, 5, 4, 5},
             {5, 2, 5, 5},
             {1, 5, 6, 5}
           }) == [{0, 2}, {1, 1}, {2, 0}]
  end

  test "expand basins" do
    map = {
      {1, 9, 2, 3},
      {2, 9, 9, 4},
      {9, 9, 5, 6}
    }

    assert Smoke.expand(map, {0, 0}) == [{0, 0}, {1, 0}]

    assert Enum.sort(Smoke.expand(map, {2, 3})) ==
             Enum.sort([{0, 2}, {0, 3}, {1, 3}, {2, 2}, {2, 3}])

    bigger = {
      {1, 1, 1, 1},
      {1, 9, 1, 1},
      {9, 1, 1, 1}
    }

    assert length(Smoke.expand(bigger, {2, 1})) == 10
  end

  test "find neighbors" do
    map = {
      {1, 2, 3},
      {4, 5, 6},
      {7, 8, 9}
    }

    assert Smoke.neighbors(map, {0, 0}) == [{1, 0}, {0, 1}]
  end

  test "find basins" do
    assert Smoke.basins({
             {1, 9, 2, 3},
             {2, 9, 9, 4},
             {9, 9, 5, 6}
           }) == [
             [{0, 0}, {1, 0}],
             [{0, 2}, {0, 3}, {1, 3}, {2, 3}, {2, 2}]
           ]
  end
end
