defmodule Dumbo do
  def step(octos) do
    Enum.map(octos, fn row ->
      Enum.map(row, &(&1 + 1))
    end)
  end

  def update(octos, {x, y}) do
    Enum.map(0..(length(octos) - 1), fn row ->
      Enum.map(0..(length(Enum.at(octos, 0)) - 1), fn col ->
        val = Enum.at(Enum.at(octos, row), col)

        cond do
          # already flashed
          val == 0 -> 0
          # the current point
          row == x and col == y -> 0
          # max energy
          val == 10 -> 10
          # a neighbor of the current point
          abs(row - x) < 2 and abs(col - y) < 2 -> val + 1
          true -> val
        end
      end)
    end)
  end

  def flash(octos) do
    flash(0, octos)
  end

  def flash(flashed, octos) do
    # if the current octo is 9, then inc all adjacent, update the counter and rerun
    rows = length(octos)
    cols = length(Enum.at(octos, 0))

    ready =
      Enum.flat_map(0..(rows - 1), fn row ->
        Enum.flat_map(0..(cols - 1), fn col ->
          case Enum.at(Enum.at(octos, row), col) do
            10 -> [{row, col}]
            _ -> []
          end
        end)
      end)

    if Enum.any?(ready) do
      flash(flashed + 1, update(octos, List.first(ready)))
    else
      {flashed, octos}
    end
  end

  def input() do
    {:ok, contents} = File.read("input")

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Enum.map(String.split(line, "", trim: true), fn c ->
        {n, _} = Integer.parse(c)
        n
      end)
    end)
  end

  def one() do
    octos = input()

    {answer, _} =
      Enum.reduce(1..100, {0, octos}, fn _, {flashed, octos} ->
        flash(flashed, step(octos))
      end)

    answer
  end

  def solve(round, octos) do
    if Enum.all?(List.flatten(octos), &(&1 == 0)) do
      round
    else
      {_, next} = flash(step(octos))
      solve(round + 1, next)
    end
  end

  def two() do
    octos = input()
    solve(0, octos)
  end
end
