#lang racket

(define (duplicates c)
  ;; the number of times a letter has to occur
  (define target (length (string-split c "\n")))
  (define full (string->list (string-replace c "\n" "")))

  ;; Filter the list so it contains only letters that occur the correct number of times
  (length
    (filter
      (lambda (x)
        (equal? target
          (length
            (filter (lambda (y) (equal? x y)) full)
          )
        )
      )
      (string->list (first (string-split c)))
    )
  )
)

(define (uniques c)
  (length (remove-duplicates (string->list (string-replace c "\n" "")))))

;; part one
(foldl + 0
  (map uniques
    (string-split (file->string "input") "\n\n")))

;; part two
(foldl + 0
  (map duplicates
    (string-split (file->string "input") "\n\n")))
