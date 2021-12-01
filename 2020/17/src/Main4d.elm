module Main4d exposing (..)

import Browser
import Array
import Html exposing (Html, pre, text, div)
import List exposing (map, indexedMap, filterMap, concat, range, filter, head, length, member, drop)
import String exposing (split)
import Set

type alias Model = List Cell
type alias Cell = { x: Int, y: Int, z: Int, w: Int}

input = """.......#
....#...
...###.#
#...###.
....##..
##.#..#.
###.#.#.
....#..."""

readInput t =
  concat
    (indexedMap (\yidx line ->
      filterMap identity
        (indexedMap (\xidx c ->
          case c of
            "#" -> Just { x = xidx, y = yidx, z = 0, w = 0}
            x -> Nothing
        ) (split "" line))
    ) (split "\n" t))

-- get all neighbors of cells in the model (that aren't existing cells)
neighbors p =
  filter (\c -> c /= p)
  (concat (map (\x ->
    concat (map (\y ->
      concat (map (\z ->
        map (\w ->
          { x = x, y = y, z = z, w = w }
        ) (range (p.w - 1) (p.w + 1))
      ) (range (p.z - 1) (p.z + 1)))
    ) (range (p.y - 1) (p.y + 1)))
  ) (range (p.x - 1) (p.x + 1))))

liveNeighbors p model =
  filter (\n -> member n model) (neighbors p)

pointToString p =
  String.join "," ([p.x, p.y, p.z, p.w] |> map String.fromInt)

flatInt x =
  Maybe.withDefault 0 x

pointFromString s =
  case (String.split "," s |> map String.toInt) of
    [x, y, z, w] -> { x = flatInt x, y = flatInt y, z = flatInt z, w = flatInt w }
    _ -> { x = 0, y = 0, z = 0, w = 0 }

unique model =
  map pointToString model
  |> Set.fromList
  |> Set.toList
  |> map pointFromString

potentials model =
  filter (\p ->
    -- filter any existing cells
    not (member p model)
  ) (concat (map (\c -> neighbors c) model))
  |> unique

hasThreeNeighbors cell model =
  (length (filter (\c -> member c model) (neighbors cell))) == 3

stillAlive model =
  filter (\c ->
    let
      count = length (liveNeighbors c model)
    in
      count == 2 || count == 3
    ) model

round model =
  filter (\p -> hasThreeNeighbors p model) (potentials model) ++
  stillAlive model

init: Model
init =
  let
    initial = readInput input
  in
    round initial
    |> round
    |> round
    |> round
    |> round
    |> round

main =
  Browser.sandbox { init = init, update = update, view = view }

update msg model = model

toString model =
  String.join "\n"
    (map (\c -> String.join ", "
      ([c.x, c.y, c.z, c.w] |> map String.fromInt)
    ) model)

view model =
  pre []
    [ text ((toString model) ++ "\n\ntotal: " ++ (String.fromInt (length model))) ]
