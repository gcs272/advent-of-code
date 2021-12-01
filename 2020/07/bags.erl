-module(bags).
-export([a/0, b/0]).

lines(Contents) ->
  A = string:replace(Contents, "no other ", "", all),
  B = re:replace(A, "\sbags?", "", [global,{return,list}]),
  string:split(B, ".\n", all).

% build up a dict of key -> [[key,count], ...]
defs([""|_]) -> dict:new();
defs([H|T]) ->
  [K,V] = re:split(H, "\scontain\s?"),
  case V of
    <<>> -> defs(T);
    _ ->
      Children = lists:map(fun(Val) ->
        [Number, Description] = string:split(Val, " "),
        {INumber, _} = string:to_integer(Number),
        [Description, INumber]
      end, string:split(V, ", ", all)),
      case Children of
        [] -> defs(T);
        _ -> dict:store(K, Children, defs(T))
    end
  end.

find(Defs, Node, Target) ->
  Children = dict:fetch(Node, Defs),
  case Node of
    Target -> true;
    _ -> lists:any(fun(C) ->
      [K,_] = C,
      case dict:is_key(K, Defs) of
        true -> find(Defs, K, Target);
        false -> false
      end
    end, Children)
  end.

a() ->
  {ok, Contents} = file:read_file("input"),
  Defs = defs(lines(Contents)),
  Matches = lists:map(fun(K) ->
    case K of
      <<>> -> false;
      <<"shiny gold">> -> false;
      _ ->
        find(Defs, K, <<"shiny gold">>)
    end
  end, dict:fetch_keys(Defs)),
  length(lists:filter(fun(X) -> X end, Matches)).

bags(Node, Defs) ->
  case dict:is_key(Node, Defs) of
    false -> 0;
    true ->
      Children = dict:fetch(Node, Defs),
      lists:sum(
        lists:map(fun(Child) ->
          [Key, Count] = Child,
          Count + (Count * bags(Key, Defs))
        end, Children)
      )
  end.

b() ->
  {ok, Contents} = file:read_file("input"),
  Defs = defs(lines(Contents)),
  bags(<<"shiny gold">>, Defs).
