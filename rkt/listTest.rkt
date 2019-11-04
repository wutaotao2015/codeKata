#lang racket
(require test-engine/racket-tests)
(require 2htdp/image)

; a ls is one of
;   '()
;   (cons string ls)
(define ls1 (cons "wtt" (cons "cll" (cons "wsl" '()))))
(define ls2 (cons "wtt" (cons "cll" (cons "wk" '()))))

;  ls string-> boolean
;    judge a name is on list
(define (judge lst target) (cond
                             [(empty? lst) #f]
                             [(string=? (first lst) target) #t]
                             [else (judge (rest lst) target)]
                             ))
(check-expect (judge ls1 "sss") #f)
(check-expect (judge ls1 "wsl") #t)
(check-expect (judge ls2 "cll") #t)
(check-expect (judge ls2 "sdl") #f)

; a monlist is one of
;  '()
;  (cons positiveNumber '())
(define m1 '())
(define m2 (cons 12 (cons 34 '())))
(define m3 (cons 34 (cons 56 '())))

; monlist -> positiveNumber
;  sum up the elements of money list
(define (sumMon ml) (cond
                      [(empty? ml) 0]
                      [(cons? ml) (+ (sumMon (rest ml)) (first ml))]
                      ))

(check-expect (sumMon m1) 0)
(check-expect (sumMon m2) 46)
(check-expect (sumMon m3) 90)


; a numlist is one of
; '()
; (cons number numlist)
(define nl1 (cons 23 '()))
(define nl2 (cons 23 (cons -23 '())))
(define nl3 (cons 35 (cons 45 '())))
(define nl4 '())
(define nl5 (cons -3 '()))

; numlist -> boolean
;  judge whether all numlist elements are positive or not
(define (pos? nl) (cond
                    [(empty? nl) #f]
                    [(empty? (rest nl)) (if (<= (first nl) 0) #f #t)]
                    [else (if (<= (first nl) 0) #f (pos? (rest nl)))]
                    ))

(check-expect (pos? nl1) #t)
(check-expect (pos? nl2) #f)
(check-expect (pos? nl3) #t)
(check-expect (pos? nl4) #f)
(check-expect (pos? nl5) #f)

; numlist -> number
;  if all numlist elements are positive, then calculate the sum, otherwise raise error
(define (checked-sum nl) (cond 
                           [(empty? nl) 0]
                           [(if (> (first nl) 0) (+ (first nl) (checked-sum (rest  nl))) 
                              (error "nums are not all positive"))]
                           ))

(check-expect (checked-sum nl3) 80)
;(check-expect (checked-sum nl2) (error "nums are not all positive"))

; boolList is one of
;  '()
;  (cons boolean '())
(define bl1 '())
(define bl2 (cons #t (cons #t '())))
(define bl3 (cons #f (cons #t '())))
(define bl4 (cons #f (cons #f '())))
(define bl5 (cons #t (cons #t (cons #f '()))))

; boolList -> boolean
;  judge whether all boolList elements are true, if so, return #t, otherwise return #f
(define (all-true bl) (cond
                        [(empty? bl) #f]
                        [(empty? (rest bl)) (if (first bl) #t #f)]
                        [else (if (first bl) (all-true (rest bl)) #f)]
                        ))

(check-expect (all-true bl1) #f)
(check-expect (all-true bl2) #t)
(check-expect (all-true bl3) #f)
(check-expect (all-true bl4) #f)
(check-expect (all-true bl5) #f)

; boolList -> boolean
;  judge whether at least one item is true
(define (one-true bl) (cond
                        [(empty? bl) #f]
                        [(empty? (rest bl)) (if (first bl) #t #f)]
                        [else (if (first bl) #t (one-true (rest bl)))]
                        ))

(check-expect (one-true bl1) #f)
(check-expect (one-true bl2) #t)
(check-expect (one-true bl3) #t)
(check-expect (one-true bl4) #f)
(check-expect (one-true bl5) #t)

; List-of-string -> String
; concatenates all strings in l into one long string
 
(check-expect (cat '()) "")
(check-expect (cat (cons "a" (cons "b" '()))) "ab")
(check-expect
  (cat (cons "ab" (cons "cd" (cons "ef" '()))))
  "abcdef")
 
(define (cat l)
  (cond
    [(empty? l) ""]
    [else (string-append (first l) (cat (rest l)))]))

; a imglist is one of
; '()
; (cons image imglist)
(define iml1 '())
(define iml2 (cons (rectangle 20 20 "solid" "red") '()))
(define iml3 (cons (rectangle 20 30 "solid" "red") '()))

; imglist number-> imgOrFalse
;  return the first image which is not n x n, if can't find such a image, return #f
; imgOrFalse is one of image and #f
(define (illsize iml n) (cond
                          [(empty? iml) #f]
                          [else (if (and (= (image-width (first iml)) n) 
                                    (= (image-height (first iml)) n))
                               (illsize (rest iml) n)
                               (first iml)
                             )]
                          ))

(check-expect (illsize iml1 20) #f) 
(check-expect (illsize iml2 20) #f) 
(check-expect (illsize iml3 20) (rectangle 20 30 "solid" "red")) 



(test)








