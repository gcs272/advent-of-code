defmodule Lanterns do
  def read(contents) do
    contents
      |> String.split(",", trim: true)
      |> Enum.map(fn(n) ->
        {val, _} = Integer.parse(n, 10)
        val
      end)
      |> Enum.frequencies
  end

  def update(fish) do
    Enum.reduce(Map.keys(fish), %{}, fn(k, upd) ->
      # If it's 0, add n to 6 and 8, else decrement the index
      case k do
        0 ->
          Map.put(upd, 6, Map.get(upd, 6, 0) + Map.get(fish, 0, 0))
          |> Map.put(8, Map.get(upd, 8, 0) + Map.get(fish, 0, 0))
        _ -> Map.put(upd, k - 1, Map.get(upd, k - 1, 0) + Map.get(fish, k, 0))
      end
    end)
  end

  def simulate(init, days) do
    Enum.reduce(0..days-1, init, fn(_, fish) ->
      update(fish)
    end)
  end

  def one() do
    {:ok, contents} = File.read("input")
    contents
      |> read
      |> simulate(80)
      |> Map.values
      |> Enum.sum
  end

  def two() do
    {:ok, contents} = File.read("input")
    contents
      |> read
      |> simulate(256)
      |> Map.values
      |> Enum.sum
  end
end
