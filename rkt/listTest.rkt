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
                           [else (if (> (first nl) 0) (+ (first nl) (checked-sum (rest  nl))) 
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

; nenumlist is one of
;  (cons number '())
;  (cons number nenumlist)
(define nenl1 (cons -2 '()))
(define nenl2 (cons 2 (cons 3 '())))
(define nenl3 (cons 3 (cons 2 (cons 4 (cons 1 '())))))
(define nenl4 (cons 3 (cons 2 (cons 1 (cons 0 '())))))

; nenumlist -> boolean
;  judge whether the nenumlist is descending order 
(define (sorted>? nenl) (cond 
                          [(empty? (rest nenl)) #t]
                          [else (if (sorted>? (rest nenl)) 
                                    (> (first nenl) (first (rest nenl))) #f)]
                          ))

(check-expect (sorted>? nenl1) #t)
(check-expect (sorted>? nenl2) #f)
(check-expect (sorted>? nenl3) #f)
(check-expect (sorted>? nenl4) #t)

; a N is one of
; 0
; (add1 N)
(define a (add1 (add1 (add1 0))))
(define b (add1 (add1 0)))
(define c 0)

; N string -> list
;  get a N's string list
(define (replist n str) (cond
                          [(zero? n) '()]
                          [(positive? n) (cons str (replist (sub1 n) str))]
                          ))

(check-expect (replist a "wtt") (cons "wtt" (cons "wtt" (cons "wtt" '()))))
(check-expect (replist b "cll") (cons "cll" (cons "cll" '())))
(check-expect (replist c "ss") '())

; N -> number
;  calculate the sum of N and 3
(define (addpi n) (cond
                    [(zero? n) 3]
                    [(positive? n) (add1 (addpi (sub1 n)))]
                    ))
(check-expect (addpi 5) 8)
(check-expect (addpi 3) 6)

; N number -> number
;  adds N with any number x
(define (addpi2 n x) (cond
                    [(zero? n) x]
                    [(positive? n) (add1 (addpi2 (sub1 n) x))]
                    ))
(check-expect (addpi2 5 2) 7)
(check-expect (addpi2 3 4) 7)

; N number -> number
;  multiply N with any number x
(define (multi n x) (cond
                      [(zero? n) 0]
                      [(= n 1) x]
                      [(positive? n) (+ x (multi (sub1 n) x))]
                      ))
(check-expect (multi 3 5) 15)
(check-expect (multi 2 6) 12)

; N image -> list
;  copies of image in a column
(define (listImg n image) (cond
                        [(zero? n) '()]
                        [(positive? n) (cons image (listImg (sub1 n) image))]
                        ))

(define RECW 10)
(define rec (rectangle RECW RECW "outline" "black"))
(check-expect (listImg 3 rec) (cons rec (cons rec (cons rec '()))))
(check-expect (listImg 0 rec) '())

; list->image
;  get above image from non-empty list
(define (abvimg imglist) (cond
                            [(empty? (rest imglist)) (first imglist)]
                            [else (above (first imglist) (abvimg (rest imglist)))]
                            )) 

(check-expect (abvimg (cons rec (cons rec (cons rec '())))) (above rec rec rec))
(check-expect (abvimg (cons rec '())) rec)

; number image->image
;  render list of image to image
(define (col n image) (cond
                        [(empty? (listImg n image)) bg]
                        [(cons? (listImg n image)) 
                           (place-image (abvimg (listImg n image)) 
                                        (/ RECW 2) (/ (image-height (abvimg (listImg n image))) 2) bg)]
                        ))

(define bg (empty-scene 100 100))
(check-expect (col 0 rec) bg)
(check-expect (col 3 rec) (place-image (above rec rec rec) (/ RECW 2) 
                                        (/ (image-height (abvimg (listImg 3 rec))) 2)bg))


; list->image
;  get beside image from non-empty list
(define (besimg imglist) (cond
                            [(empty? (rest imglist)) (first imglist)]
                            [else (beside (first imglist) (besimg (rest imglist)))]
                            )) 

(check-expect (besimg (cons rec (cons rec (cons rec '())))) (beside rec rec rec))
(check-expect (besimg (cons rec '())) rec)

; number image->image
;  render list of image to image
(define (row n image) (cond
                        [(empty? (listImg n image)) bg]
                        [(cons? (listImg n image)) 
                           (place-image (besimg (listImg n image)) 
                                        (/ (image-width (besimg (listImg n image))) 2)
                                        (/ RECW 2) bg)]
                        ))

(check-expect (row 0 rec) bg)
(check-expect (row 3 rec) (place-image (beside rec rec rec) 
                            (/ (image-width (besimg (listImg 3 rec))) 2) (/ RECW 2) bg))

; number number -> image 
;  get a empty-scene rowNumNum width and colNum width
(define (gridbg rowNumNum colNum) (empty-scene (* RECW rowNumNum) (* RECW colNum)))

; number number-> image
;  draw a rectangle with rowNum width and colNum height, filled with RECW x RECW squares, lay on
;  the same size of empty-scene
;(define (grid rowNum colNum) (cond 
;                         [(or (zero? rowNum) (zero? colNum)) (gridbg rowNum colNum)]
;                         [(= rowNum 1) (row colNum rec)]
;                         [else (above (row colNum rec) (grid (sub1 rowNum) colNum))]
;                         ))
;



(test)
