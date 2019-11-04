#lang racket
(require test-engine/racket-tests)

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








(test)
