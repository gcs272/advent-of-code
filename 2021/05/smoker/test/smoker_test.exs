defmodule SmokerTest do
  use ExUnit.Case
  doctest Smoker

  test "plots straight lines" do
    assert Smoker.points([[0, 0], [2, 0]]) == [[0, 0], [1, 0], [2, 0]]
    assert Smoker.points([[0, 0], [0, 2]]) == [[0, 0], [0, 1], [0, 2]]
  end

  test "plots diagonal lines" do
    assert Smoker.points([[0, 0], [2, 2]]) == [[0, 0], [1, 1], [2, 2]]
    assert Smoker.points([[2, 2], [0, 0]]) == [[2, 2], [1, 1], [0, 0]]
    assert Smoker.points([[2, 2], [4, 0]]) == [[2, 2], [3, 1], [4, 0]]
    assert Smoker.points([[2, 2], [0, 4]]) == [[2, 2], [1, 3], [0, 4]]
  end
end
