open Printf
open List

let rec indexof x lst =
  match lst with
  | [] -> 0
  | h :: t -> if h = x then 0 else 1 + indexof x t

let rec drop n lst =
  match n with
  | 0 -> lst
  | _ -> drop (n - 1) (tl lst)

let rec distance x lst =
  let first = indexof x lst in
  1 + first - (indexof x (drop first lst))

let rec play limit numbers =
  if length numbers mod 10000 = 0 then printf "\n%d" (length numbers);
  let nval = match find_opt (fun x -> x = (hd numbers)) (tl numbers) with
  | None -> 0
  | _ -> distance (hd numbers) (tl numbers) in

  if length numbers = limit then hd numbers
  else play limit (nval :: numbers)

let () =
  printf "\none=%d" (play 2020 (rev [8;0;17;4;1;12]));
  printf "\ntwo=%d" (play 30000000 (rev [8;0;17;4;1;12]))
