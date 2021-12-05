defmodule Smoker do
  def read(content) do
    content
      |> String.split("\n", trim: true)
      |> Enum.map(fn (line) ->
        line
          |> String.split(" -> ")
          |> Enum.map(&String.split(&1, ","))
          |> Enum.map(fn (pt) ->
            Enum.map(pt, fn (n) ->
              {val, _} = Integer.parse(n, 10)
              val
            end)
          end)
      end)
  end

  def points([[ax, ay], [bx, by]]) do
    additional = cond do
      ax < bx && ay < by -> points([[ax + 1, ay + 1], [bx, by]])
      ax < bx && ay > by -> points([[ax + 1, ay - 1], [bx, by]])
      ax > bx && ay > by -> points([[ax - 1, ay - 1], [bx, by]])
      ax > bx && ay < by -> points([[ax - 1, ay + 1], [bx, by]])
      ax > bx -> points([[ax - 1, ay], [bx, by]])
      ax < bx -> points([[ax + 1, ay], [bx, by]])
      ay > by -> points([[ax, ay - 1], [bx, by]])
      ay < by -> points([[ax, ay + 1], [bx, by]])
      true -> []
    end

    [[ax, ay] | additional]
  end

  def lines() do
    {:ok, content} = File.read("./input")
    read(content)
  end

  def one() do
    straight = Enum.filter(lines(), fn [[ax, ay], [bx, by]] ->
      ax == bx || ay == by
    end)

    points = Enum.flat_map(straight, &points(&1))
    length(Enum.uniq(points -- Enum.uniq(points)))
  end

  def two() do
    points = Enum.flat_map(lines(), &points(&1))
    length(Enum.uniq(points -- Enum.uniq(points)))
  end
end
