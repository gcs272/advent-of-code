sbin :: (Integer, String) -> (Integer, String)
sbin (n, []) = (n, [])
sbin (n, s) =
  case (head s) of
    'B' -> sbin (n + 2 ^ (length s - 1), tail s)
    'R' -> sbin (n + 2 ^ (length s - 1), tail s)
    'F' -> sbin (n, tail s)
    'L' -> sbin (n, tail s)

parseInt :: String -> Integer
parseInt (s) = let (a, _) = sbin(0, s) in a

seat :: String -> Integer
seat (s) = let ((a, _), (b, _)) = (sbin(0, take 7 s), sbin(0, drop 7 s)) in a * 8 + b

main = do
    contents <- getContents
    print (maximum (map seat (lines contents)))
