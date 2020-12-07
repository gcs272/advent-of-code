sbin :: (Integer, String) -> (Integer, String)
sbin (n, []) = (n, [])
sbin (n, s) =
  case (head s) of
    'B' -> sbin (n + 2 ^ (length s - 1), tail s)
    'R' -> sbin (n + 2 ^ (length s - 1), tail s)
    'F' -> sbin (n, tail s)
    'L' -> sbin (n, tail s)

seat :: String -> Integer
seat (s) = let ((a, _), (b, _)) = (sbin(0, take 7 s), sbin(0, drop 7 s)) in a * 8 + b

main = do
  contents <- getContents

  -- day one
  print (maximum (map seat (lines contents)))

  -- part two
  print (let (all, seats) = ([1..127*8+7], map seat (lines contents)) in
    head (filter (\sid ->
      (elem (sid - 1) seats) &&
      (not (elem sid seats)) &&
      (elem (sid + 1) seats)
      ) all
    ))
