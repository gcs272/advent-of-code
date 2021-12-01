(use '[clojure.string :only (split)])

(defn validPassport [p]
  (every? #(contains? p %) ["byr" "ecl" "eyr" "hcl" "hgt" "iyr" "pid"])
)

(defn between [ystr start end]
  (try
    (let [year (bigint ystr)]
      (and (>= year start) (<= year end))
    )
  )
)

(defn reallyValidPassport [p]
  (and
    (validPassport p)
    (between (get p "byr") 1920 2002)
    (between (get p "iyr") 2010 2020)
    (some #(= (get p "ecl") %) ["amb" "blu" "brn" "gry" "grn" "hzl" "oth"])
    (between (get p "eyr") 2020 2030)
    (re-find #"^#[0-9a-f]{6}$", (get p "hcl"))
    (let [hstr (get p "hgt")]
      (let [hnum (bigint (re-find #"\d+" hstr))]
        (case (re-find #"cm$|in$" hstr)
          "in" (and (>= hnum 59) (<= hnum 76))
          "cm" (and (>= hnum 150) (<= hnum 193))
          false
        )
      )
    )
    (re-find #"^\d{9}$", (get p "pid"))
  )
)

(defn toPassport [s]
  (apply hash-map
    (flatten
      (map #(split % #":")
        (split s #"\s")
      )
    )
  )
)

(println
  ;; part one
  (count
    (filter validPassport
      (map toPassport
        (split (slurp "input") #"\n\n")
      )
    )
  )

  ;; part two
  (count
    (filter reallyValidPassport
      (map toPassport
        (split (slurp "input") #"\n\n")
      )
    )
  )
)
