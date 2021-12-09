defmodule Smoke do
  def read(contents) do
    contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(fn n ->
        {n, _} = Integer.parse(n)
        n
      end)
      |> List.to_tuple()
    end)
    |> List.to_tuple()
  end

  def low_points(map) do
    rows = tuple_size(map)
    cols = tuple_size(elem(map, 0))

    Enum.flat_map(0..(rows - 1), fn row ->
      Enum.flat_map(0..(cols - 1), fn col ->
        v = elem(elem(map, row), col)

        low =
          Enum.all?(neighbors(map, {row, col}), fn {x, y} ->
            elem(elem(map, x), y) > v
          end)

        case low do
          true -> [{row, col}]
          _ -> []
        end
      end)
    end)
  end

  def neighbors(map, {x, y}) do
    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    |> Enum.flat_map(fn {dx, dy} ->
      valid =
        x + dx >= 0 && x + dx < tuple_size(map) &&
          y + dy >= 0 && y + dy < tuple_size(elem(map, 0))

      case valid do
        true -> [{x + dx, y + dy}]
        _ -> []
      end
    end)
  end

  def expand(map, {x, y}) do
    expand(map, [], [{x, y}])
  end

  def expand(_, _, []) do
    []
  end

  def expand(map, basin, [point | queue]) do
    # Grab all of the neighbors of point and add them to the queue
    next =
      Enum.filter(neighbors(map, point), fn {x, y} ->
        {x, y} not in basin and {x, y} not in queue and elem(elem(map, x), y) != 9
      end)

    [point | expand(map, [point | basin], queue ++ next)]
  end

  def basins(map) do
    # If we see a point under 9 that isn't currently in a basin, expand it
    search =
      Enum.flat_map(0..(tuple_size(map) - 1), fn row ->
        Enum.map(0..(tuple_size(elem(map, 0)) - 1), fn col -> {row, col} end)
      end)
      |> Enum.filter(fn {x, y} -> elem(elem(map, x), y) != 9 end)

    basins(map, search)
  end

  def basins(_, []) do
    []
  end

  def basins(map, [src | tail]) do
    basin = expand(map, src)
    [basin | basins(map, tail -- basin)]
  end

  def one() do
    {:ok, contents} = File.read("input")

    map =
      contents
      |> read

    Enum.map(low_points(map), fn {row, col} ->
      elem(elem(map, row), col) + 1
    end)
    |> Enum.sum()
  end

  def two() do
    {:ok, contents} = File.read("input")
    map = contents |> read

    [a, b, c | _] =
      basins(map)
      |> Enum.map(&length(&1))
      |> Enum.sort(:desc)

    a * b * c
  end
end
