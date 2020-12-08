-module(bags).
-export([a/0]).

toDefinition([]) -> dict:new();
toDefinition([H|T]) ->
  [K|V] = re:split(H, "\scontain\s?"),
  Vals = re:split(V, ", "),
  dict:store(K, Vals, toDefinition(T)).

inputLines(Contents) ->
  A = string:replace(Contents, "no other ", "", all),
  B = re:replace(A, "\sbags?", "", [global,{return,list}]),
  C = re:replace(B, "(\s[0-9]+)", "", [global,{return,list}]),
  string:split(C, ".\n", all).

find(_, <<>>, _) -> false;
find(Defs, Node, Target) ->
  Children = dict:fetch(Node, Defs),
  case Node of
    Target -> true;
    _ -> lists:any(fun(C) -> find(Defs, C, Target) end, Children)
  end.

a() ->
  {ok, Contents} = file:read_file("input"),
  Defs = toDefinition(inputLines(Contents)),
  Matches = lists:map(fun(K) ->
    case K of
      <<>> -> false;
      <<"shiny gold">> -> false;
      _ ->
        find(Defs, K, <<"shiny gold">>)
    end
  end, dict:fetch_keys(Defs)),
  length(lists:filter(fun(X) -> X end, Matches)).
