(def sections
  (string/split "\n\n"
    (string/trim
      (file/read stdin :all))))

# Grab all the ranges for values as [[min, max], ...]
(def pairs
  (mapcat (fn [line]
    (map (fn [pair]
      (map int/s64 (string/split "-" pair))
    ) (string/split " or " (get (string/split ": " line) 1)))
  ) (string/split "\n" (get sections 0))))

(defn valid [num]
  (any? (map (fn [p]
    (<= (get p 0) num (get p 1))
  ) pairs)))

(def invalid
  (filter (fn [num] (not (valid num)))
    (mapcat (fn [line]
      (map int/s64 (string/split "," line))
    ) (slice (string/split "\n" (array/pop sections)) 1))))

(print (reduce + 0 invalid))
