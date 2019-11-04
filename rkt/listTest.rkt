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
(test)


