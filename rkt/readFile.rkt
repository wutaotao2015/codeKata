#lang htdp/bsl

(require test-engine/racket-tests)
(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

; list of strings, separated by \n
; list of words, separated by whitespace
; list of lists, using \n to separate lists, using whitespace to separate words.


; lls -> list of numbers
;   get the words count for each line
(define (line-words lls) (cond
                           [(empty? lls) '()]
                           [else (cons (cwfl (first lls)) (line-words (rest lls)))]
                           ))

; list of strings -> number
;  count the words number for each line 
(define (cwfl ls) (cond
                    [(empty? ls) 0]
                    [else (add1 (cwfl (rest ls)))]
                    ))

(check-expect (cwfl '()) 0)
(check-expect (cwfl (cons "w" (cons "s" '()))) 2)
(check-expect (line-words '()) '())
(check-expect (line-words (read-words/line "a.txt")) (cons 5 (cons 0 (cons 2 '()))))

; this need to put at last line to ensure testing all test cases
(test)

(read-words/line "a.txt")
