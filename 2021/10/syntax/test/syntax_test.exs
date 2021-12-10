defmodule SyntaxTest do
  use ExUnit.Case
  doctest Syntax

  test "basic syntax" do
    assert Syntax.check(")") == {:error, ?)}
    assert Syntax.check("()") == {:ok, []}
    assert Syntax.check("()()") == {:ok, []}
    assert Syntax.check("{()}") == {:ok, []}
    assert Syntax.check("{()](") == {:error, ?]}
  end

  test "unfinished should return the remainder" do
    assert Syntax.check("(") == {:ok, [?)]}
    assert Syntax.check("[<{()") == {:ok, [?}, ?>, ?]]}
  end

  test "should score things" do
    assert Syntax.score_tail(to_charlist("])}>")) == 294
    assert Syntax.score_tail(to_charlist("]]}}]}]}>")) == 995444
  end
end
