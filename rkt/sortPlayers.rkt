#lang htdp/bsl

(require test-engine/racket-tests)
(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

(define-struct gp [name score])
; a gp is a structure:
;  (make-gp String Number)
; (make-gp n s) is a game player n whose score is s 
(define GP1 (make-gp "a" 11))
(define GP2 (make-gp "b" 22))
(define GP3 (make-gp "c" 33))

; gp gp -> boolean 
;   return true if gp1's score bigger than gp2's score 
(define (biggerGp gp1 gp2) (if (> (gp-score gp1) (gp-score gp2)) 
                           #t #f))

(check-expect (biggerGp GP1 GP2) #f)
(check-expect (biggerGp GP2 GP1) #t)

; list of gps
;  a gp list is one of
;   '()
;   (cons gp '())
(define gps1 (list GP1 GP2))
(define gps2 (list GP2 GP1))
(define gps3 (list GP2 GP1 GP3))

; gplist -> gplist
;   sort gplist according to its element score, ascending
(define (sort< gps) (cond
                      [(empty? (rest gps)) gps]
                      [else (insert (first gps) (sort< (rest gps)))]
                      ))

(check-expect (sort< (list GP1)) (list GP1))
(check-expect (sort< gps1) gps1)
(check-expect (sort< gps2) gps1)
(check-expect (sort< gps3) (list GP1 GP2 GP3))

; gp gplist -> gplist
;  insert gp to a sorted list to get another sorted list
(define (insert gp gps) (cond
                          [(empty? gps) (list gp)]
                          [else (if (biggerGp gp (first gps)) 
                                  (cons (first gps) (insert gp (rest gps))) 
                                  (cons gp gps)) ]
                          ))

(check-expect (insert GP1 '()) (list GP1))
(check-expect (insert GP1 (list GP2)) (list GP1 GP2))
(check-expect (insert GP2 (list GP1)) (list GP1 GP2))
(check-expect (insert GP2 (list GP1 GP3)) (list GP1 GP2 GP3))

; this need to put at last line to ensure testing all test cases
(test)
