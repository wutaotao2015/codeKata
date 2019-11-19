#lang htdp/bsl

(require test-engine/racket-tests)
(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

; list of strings, separated by \n
; list of words, separated by whitespace
; list of line-word lists, using \n to separate lists, using whitespace to separate words.

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

;(read-words/line "a.txt")
;(empty? null)
;(list 2 4 6)
;(length (cons 2 (cons 3 (cons 4 '()))))
;(member? 2 (cons 2 '()))
;(make-list 4 "wtt")
;(reverse (list 1 2 3))

(define line1 (list "i" "am" "a" "boy"))
(define line2 '())
(define line3 (list "the" "game" "is" "over"))
(define lls1 (list line1 line2 line3))

; lls -> string 
;   convert list of line words to a big string 
(define (claps lls) (cond
                      [(empty? lls) ""]
                      [else (string-append (line-claps (first lls)) "\n" (claps (rest lls)))]
                      ))
(check-expect (claps '()) "")
(check-expect (claps lls1) "i am a boy\n\nthe game is over\n")

; line words list -> string
;   using " " to concatnate the words in a line
(define (line-claps line) (cond
                            [(empty? line) ""]
                            [else (if (empty? (rest line)) (first line) 
                                    (string-append (first line) " " (line-claps (rest line))))]
                            ))
(check-expect (line-claps line1) "i am a boy")
(check-expect (line-claps line2) "")
(check-expect (line-claps line3) "the game is over")

;(write-file "newA.txt" (claps (read-words/line "a.txt")))

; string->boolean
;  if str is one of a, an, the, return "", otherwise return the original str
(define (article? str) (if (or (string=? str "a") 
                               (string=? str "an") 
                               (string=? str "the")) #t #f))
(check-expect (article? "a") #t)
(check-expect (article? "an") #t)
(check-expect (article? "the") #t)
(check-expect (article? "go") #f)

; line words list -> string
;   using " " to concatnate the words in a line, remove the articles
; if the word is article, bypass it and keep handling rest words
; if the word is the last one, then just return it to be appended, avoding unnecessary space character
(define (line-claps.v2 line) (cond
                               [(empty? line) ""]
                               [else  
                                 (if (article? (first line)) (line-claps.v2 (rest line)) 
                                   (if (empty? (rest line)) (first line) 
                                     (string-append (first line) " " (line-claps.v2 (rest line)))))]
                               ))
(check-expect (line-claps.v2 line1) "i am boy")
(check-expect (line-claps.v2 line2) "")
(check-expect (line-claps.v2 line3) "game is over")
; lls -> string 
;   convert list of line words to a big string, remove the article 
(define (claps.v2 lls) (cond
                         [(empty? lls) ""]
                         [else (string-append (line-claps.v2 (first lls)) "\n" (claps.v2 (rest lls)))]
                         ))
(check-expect (claps.v2 lls1) "i am boy\n\ngame is over\n")

; wd is a structure
;  (make-wd number number number)
(define-struct wd [onestr word line])

; lls -> wd
;  simulate the wc command helper 
(define (wcl lls) (cond
                    [(empty? lls) (make-wd 0 0 0)]
                    [else (wd-add (line-onestr (first lls)) (length (first lls)) 1 (wcl (rest lls)))]))
(check-expect (wcl lls1) (make-wd 20 8 3))

; string->wd
;   helper function
(define (wdf file) (wcl (read-words/line file)))

; string->string
;  simulate wc command
(define (wc file) (string-append (number->string (wd-onestr (wdf file)))
                                 " "
                                 (number->string (wd-word (wdf file)))
                                 " "
                                 (number->string (wd-line (wdf file)))
                                 ))
(check-expect (wc "a.txt") "21 7 3")

; number number number wd -> wd
;  get a new wd from wd's property adding up with parameter numbers 
(define (wd-add op wp lp wd) (make-wd (+ op (wd-onestr wd)) 
                                      (+ wp (wd-word wd))
                                      (+ lp (wd-line wd))
                                      ))
(check-expect (wd-add 1 2 3 (make-wd 0 0 0)) (make-wd 1 2 3))

; line -> number
;  calculate the 1string numbers in a line
(define (line-onestr line) (cond
                             [(empty? line) 0]
                             [else (+ (length (explode (first line))) (line-onestr (rest line)))]
                             ))
(check-expect (line-onestr line1) 7)
(check-expect (line-onestr line2) 0)
(check-expect (line-onestr line3) 13)





; this need to put at last line to ensure testing all test cases
(test)
