module Main exposing (..)

import Browser
import Array
import Html exposing (Html, pre, text, div)
import List exposing (map, indexedMap, filterMap, concat, range, filter, head, length, member, drop)
import String exposing (split)
import Set

type alias Model = List Cell
type alias Cell = { x: Int, y: Int, z: Int }

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
            "#" -> Just { x = xidx, y = yidx, z = 0 }
            x -> Nothing
        ) (split "" line))
    ) (split "\n" t))

-- get all neighbors of cells in the model (that aren't existing cells)
neighbors p =
  filter (\c -> c /= p)
  (concat (map (\x ->
    concat (map (\y ->
      map (\z ->
        { x = x, y = y, z = z }
      ) (range (p.z - 1) (p.z + 1))
    ) (range (p.y - 1) (p.y + 1)))
  ) (range (p.x - 1) (p.x + 1))))

liveNeighbors p model =
  filter (\n -> member n model) (neighbors p)

fromListPoint l =
  let
    (x, y, z) = l
  in
  { x = x, y = y, z = z }

unique model =
  map (\c -> (c.x, c.y, c.z)) model
  |> Set.fromList
  |> Set.toList
  |> map fromListPoint

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
      ([c.x, c.y, c.z] |> map String.fromInt)
    ) model)

view model =
  pre []
    [ text ("total: " ++ (String.fromInt (length model))) ]
