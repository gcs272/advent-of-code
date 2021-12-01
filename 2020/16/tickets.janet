(def sections
  (string/split "\n\n"
    (string/trim
      (file/read stdin :all))))

(defn read_pairs [l]
  (def [name rules] (string/split ": " l))
  [name (map
    (fn [p]
      (map int/s64 (string/split "-" p)))
    (string/split " or " rules))])

# Grab all the ranges for values as [[min, max], ...]
(def vpairs
  (mapcat (fn [l] (get (read_pairs l) 1))
    (string/split "\n" (get sections 0))))

(def tickets
  (map (fn [l] (map int/s64 (string/split "," l)))
    (slice
      (string/split "\n" (array/pop sections)) 1)))

(defn valid_value [v]
  (any? (map (fn [p] (<= (get p 0) v (get p 1))) vpairs)))

(def invalid_values
  (filter (fn [v] (not (valid_value v))) (flatten tickets)))

(printf "one=%q" (reduce + 0 invalid_values))

(def valid_tickets
  (filter
    (fn [t] (every? (map valid_value t)))
  tickets))

(defn satisfies [v ps]
  (any? (map (fn [p] (<= (get p 0) v (get p 1))) ps)))

(def rules
  (map read_pairs
    (string/split "\n" (get sections 0))))

(defn column_satisfies [idx ps]
  (every?
    (map (fn [t]
      (satisfies (get t idx) ps))
      valid_tickets)))

# get all the matching fields for the columns
(defn eligible_rules [cidx]
  (filter (fn [rule] (column_satisfies cidx (get rule 1))) rules))

(def indexes (range 0 (length rules)))

(def mapping
  (map
    (fn [_]
      (def index
        (first
          (filter
            (fn [idx]
              (= 1 (length (eligible_rules idx))))
            indexes)))

      (def rule
        (first
          (eligible_rules index)))

      # remove the index from the indexes and the rule from the remaining rules
      (array/remove indexes (find-index (fn [i] (= i index)) indexes))
      (array/remove rules (find-index (fn [r] (= r rule)) rules))
      [(get rule 0) index]
    )
    (range (length indexes))
  )
)

(def fields
  (map
    (fn [v] (get v 1))
    (filter (fn [m] (string/has-prefix? "departure" (get m 0))) mapping)))

(def ticket
  (map int/s64 (string/split "," (get (string/split "\n" (get sections 1)) 1))))

(printf "two=%q"
  (reduce * 1
    (map (fn [i] (get ticket i)) fields)))
