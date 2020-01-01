#lang htdp/bsl

(require test-engine/racket-tests)
(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

; a number list is one of
;  '()
;  (cons Number '())
(define LS1 (list 2 3 4 5 8 9))
(define LS2 (list 2 3 4))

; number -> number 
;  return floor of the middle number 
(define (mid num) (floor (/ num 2)))

(check-expect (mid 3) 1)
(check-expect (mid 6) 3)

; numlist number number -> numlist
; get the sublist from index start(include) to index end (exclude)
(define (sublist start end ls) (cond
                                 [(empty? ls) ls]
                                 [(>= start end) '()]
                                 [(<= start 0) (cons (first ls) 
                                                    (sublist 0 (sub1 end) (rest ls)))]
                                 [else (sublist (sub1 start) (sub1 end) (rest ls))]
                                 ))

(check-expect (sublist -3 2 LS1) (list 2 3))
(check-expect (sublist 0 2 LS1) (list 2 3))
(check-expect (sublist 3 4 LS1) (list 5))
(check-expect (sublist 3 5 LS1) (list 5 8))
(check-expect (sublist 2 9 LS1) (list 4 5 8 9))

;  numlist -> numlist
;   get the first half sublist of sorted list, using floor to make 1.5 go to 1
;   exclude the middle number
(define (pre ls) (sublist 0 (mid (length ls)) ls))

(check-expect (pre LS1) (list 2 3 4))
(check-expect (pre LS2) (list 2))

;  numlist -> numlist
;   get the second half sublist of sorted list, using floor to make 1.5 go to 1
; include the middle number
(define (post ls) (sublist (mid (length ls)) (length ls) ls))

(check-expect (post LS1) (list 5 8 9))
(check-expect (post LS2) (list 3 4))


; number numberList -> boolean
;  binary search in a sorted list
(define (bs num ls) (cond
                      [(empty? (rest ls)) (if (= num (first ls)) #t #f)]
                      [(= num (list-ref ls (mid (length ls)))) #t]
                      [(< num (list-ref ls (mid (length ls)))) (bs num (pre ls))]
                      [else (bs num (post ls))]
                      ))

(check-expect (bs 3 LS1) #t)
(check-expect (bs 5 LS1) #t)
(check-expect (bs 6 LS1) #f)
(check-expect (bs 10 LS1) #f)
(check-expect (bs 1 LS1) #f)






; this need to put at last line to ensure testing all test cases
(test)
