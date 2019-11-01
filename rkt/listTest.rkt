;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname listTest) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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
(judge ls1 "sss")
(judge ls1 "wsl")
(judge ls2 "cll")
(judge ls2 "sdl")
