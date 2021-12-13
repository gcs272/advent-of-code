defmodule Fold do
  def foldh(page, fold) do
    # Grab the ones over the fold
    folded =
      page
      |> Enum.filter(fn {x, _} -> x > fold end)
      |> Enum.map(fn {x, y} -> {fold - (x - fold), y} end)

    Enum.filter(page, fn {x, _} -> x < fold end) ++ folded
    |> Enum.sort
    |> Enum.uniq
  end

  def foldv(page, fold) do
    folded =
      page
      |> Enum.filter(fn {_, y} -> y > fold end)
      |> Enum.map(fn {x, y} -> {x, fold - (y - fold)} end)

    Enum.filter(page, fn {_, y} -> y < fold end) ++ folded
    |> Enum.sort
    |> Enum.uniq
  end

  def read() do
    {:ok, contents} = File.read("input")
    [points, instructions] = String.split(contents, "\n\n", trim: true)

    thermals = points
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",", trim: true)
      |> Enum.map(fn s ->
        {n, _} = Integer.parse(s)
        n
      end)
    end)
    |> Enum.map(fn [x, y] -> {x, y} end)

    folds = instructions
    |> String.split("\n", trim: true)
    |> Enum.map(fn inst ->
      [dim, ps] = String.replace(inst, "fold along ", "")
      |> String.split("=")

      {p, _} = Integer.parse(ps)
      {dim, p}
    end)

    [ thermals, folds ]
  end

  def one() do
    [thermals, [{dim, point} | _]] = read()
    new = case dim do
      "x" -> foldh(thermals, point)
      "y" -> foldv(thermals, point)
    end

    length(new)
  end

  def two() do
    [thermals, instructions] = read()
    display = instructions
    |> Enum.reduce(thermals, fn inst, acc ->
      {dim, point} = inst
      case dim do
        "x" -> foldh(acc, point)
        "y" -> foldv(acc, point)
      end
    end)

    # Grab the max dimensions of the display
    mx =
      display
      |> Enum.map(fn {x, _} -> x end)
      |> Enum.max

    my =
      display
      |> Enum.map(fn {_, y} -> y end)
      |> Enum.max

    results = Enum.map(0..my, fn(y) ->
      Enum.map(0..mx, fn(x) ->
        case {x, y} in display do
          true -> "X"
          false -> "."
        end
      end)
    end)

    Enum.map(results, fn row ->
      Enum.reduce(row, "", fn a, b -> a <> b end)
      |> String.reverse
    end)
    |> Enum.join("\n")
    |> IO.puts
  end
end
