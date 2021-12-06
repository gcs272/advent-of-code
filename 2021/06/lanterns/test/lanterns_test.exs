defmodule LanternsTest do
  use ExUnit.Case
  doctest Lanterns

  test "reads input" do
    assert Lanterns.read("1,2,3,2,6") == %{1 => 1, 2 => 2, 3 => 1, 6 => 1}
  end

  test "update a day" do
    assert Lanterns.update(%{1 => 1}) == %{0 => 1}
    assert Lanterns.update(%{0 => 1}) == %{6 => 1, 8 => 1}
  end

  test "should simulate days" do
    assert Lanterns.simulate(%{1 => 1}, 1) == %{0 => 1}
    assert Lanterns.simulate(%{1 => 1}, 2) == %{6 => 1, 8 => 1}
  end
end
