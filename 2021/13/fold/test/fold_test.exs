defmodule FoldTest do
  use ExUnit.Case
  doctest Fold

  test "horizontal fold" do
    assert Fold.foldh([{0, 1}, {2, 0}], 1) ==
      [{0, 0}, {0, 1}]

    assert Fold.foldh([{0, 0}, {3, 0}, {4, 1}], 2) ==
      [{0, 0}, {0, 1}, {1, 0}]
  end

  test "vertical fold" do
    assert Fold.foldv([{0, 0}, {2, 2}], 1) ==
      [{0, 0}, {2, 0}]

    assert Fold.foldv([{0, 13}], 7) == [{0, 1}]
  end
end
