defmodule Paths do
  def to_map(contents) do
    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-", trim: true))
    |> Enum.map(fn [k, v] -> [[k, v], [v, k]] end)
    |> Enum.reduce([], fn a, b -> a ++ b end)
    |> Enum.filter(fn [k, v] -> k != "end" && v != "start" end)
    |> Enum.group_by(fn [k, _] -> k end)
    |> Enum.map(fn {k, vals} ->
      %{k => Enum.sort(Enum.map(vals, fn [_, v] -> v end))}
    end)
    |> Enum.reduce(%{}, &Enum.into/2)
  end

  defp lower?(s) do
    String.at(s, 0) == String.downcase(String.at(s, 0))
  end

  def find(m, path) do
    [last | _ ] = path
    if last == "end" do
      path
    else
      # Get all the paths available to us from here
      valid = Enum.filter(Map.get(m, last, []), fn nxt ->
        not lower?(nxt) or nxt not in path
      end)

      Enum.map(valid, &find(m, [&1 | path]))
    end
  end

  def find_two(m, path) do
    [last | _ ] = path
    if last == "end" do
      path
    else
      # Have we already visited a duplicate?
      lowers = Enum.filter(path, &lower?/1)
      duped = length(lowers) != length(Enum.uniq(lowers))

      valid = Enum.filter(Map.get(m, last, []), fn n ->
        # if lowercase & already visited & not duped
        not lower?(n) or n not in path or not duped
      end)

      Enum.map(valid, &find_two(m, [&1 | path]))
    end
  end

  def find_two(m) do find_two(m, ["start"]) end
  def find(m) do find(m, ["start"]) end

  def solve(f) do
    {:ok, contents} = File.read("input")
    contents
    |> to_map
    |> f.()
    |> List.flatten
    |> Enum.filter(&(&1 == "end"))
    |> Enum.count
  end

  def one() do
    solve(&find/1)
  end

  def two() do
    solve(&find_two/1)
  end
end
