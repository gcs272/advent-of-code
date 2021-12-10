defmodule Syntax do
  @closing [?), ?], ?>, ?}]
  @opening [?(, ?[, ?<, ?{]

  # Check the closing tags
  def check([], [curr | _]) when curr in @closing do {:error, curr} end
  def check([exp], [curr | _]) when curr in @closing do
    case exp == curr do
      true -> {:ok, []}
      false -> {:error, curr}
    end
  end

  def check([exp | exptail], [curr | rest]) when curr in @closing do
    case exp == curr do
      true -> check(exptail, rest)
      false -> {:error, curr}
    end
  end

  def check(prev, [curr | tail]) when curr in @opening do
    case curr do
      ?( -> check([?) | prev], tail)
      ?[ -> check([?] | prev], tail)
      ?{ -> check([?} | prev], tail)
      ?< -> check([?> | prev], tail)
    end
  end

  def check(exp, []) do {:ok, exp} end

  def check(s) do
    check([], to_charlist(s))
  end

  def score({:ok, _}) do 0 end
  def score({:error, c}) do
    case c do
      ?) -> 3
      ?] -> 57
      ?} -> 1197
      ?> -> 25137
    end
  end

  def score_tail(t) do
    Enum.reduce(t, 0, fn (c, acc) ->
      (acc * 5) + case c do
        ?) -> 1
        ?] -> 2
        ?} -> 3
        ?> -> 4
      end
    end)
  end

  def one() do
    {:ok, contents} = File.read("input")
    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&check(&1))
    |> Enum.map(&score(&1))
    |> Enum.sum
  end

  def two() do
    {:ok, contents} = File.read("input")
    scores = contents
    |> String.split("\n", trim: true)
    |> Enum.map(&check(&1))
    |> Enum.filter(fn({res, rem}) -> res == :ok and length(rem) > 0 end)
    |> Enum.map(fn({:ok, rem}) -> rem end)
    |> Enum.map(&score_tail(&1))
    |> Enum.sort

    Enum.at(scores, div(length(scores), 2))
  end
end
