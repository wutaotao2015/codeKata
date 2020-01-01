#lang htdp/bsl

(require test-engine/racket-tests)
(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

; a ls is one of 
; '()
; (cons 1String '())
(define LS1 (list "a" "b" "c"))

; a lls is one of
;  '()
; (cons ls '())
(define LLS1 (list (list "a") (list "a" "b")))

; ls -> list of ls
;   get all the prefixes list of ls
(define (prefixes ls) (cond
                        [(empty? (rest ls)) (list (list (first ls)))]
                        [else (cons (list (first ls)) 
                                    (add-head (first ls) (prefixes (rest ls))))]
                        ))

(check-expect (prefixes LS1) (list (list "a") (list "a" "b") LS1))
(check-expect (prefixes (list "a")) (list (list "a")))

; 1String lls -> lls
;  add the head to each element of lls
(define (add-head head lls) (cond
                              [(empty? lls) lls]
                              [(empty? (first lls)) (list (list head))]
                              [else (cons (cons head (first lls)) 
                                          (add-head head (rest lls)))]
                              ))

(check-expect (add-head "x" LLS1) (list (list "x" "a") (list "x" "a" "b")))
(check-expect (add-head "x" (list (list "a"))) (list (list "x" "a")))
(check-expect (add-head "x" (list (list))) (list (list "x")))

; ls -> list of ls
;  get all suffixes list of ls
(define (suffixes ls) (prefixes (reverse ls)))

(check-expect (suffixes LS1) (list (list "c") (list "c" "b") (list "c" "b" "a")))

; this need to put at last line to ensure testing all test cases
(test)



