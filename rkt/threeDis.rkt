;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname threeDis) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

;(define-struct 3dp [x y z])
;; a 3dp is a structure:
;;   (make-3dp number number number)
;; a 3dp is one 3 dimensional position 
;(define (dis p)
;   (sqrt (+ 
;           (sqr (3dp-x p))
;           (sqr (3dp-y p))
;           (sqr (3dp-z p))
;           ))
;  )
;(check-expect (dis (make-3dp 0 0 6)) 6)
;(check-expect (dis (make-3dp 6 -2 3)) 7)

;(define-struct time [h m s])
;; a Time is a structure:
;;  (make-time number number number)
;;  h is a integer [0, 24], m and s is a integer [0, 60]
;
;(define t1 (make-time 12 30 2))
;
;(define MS 60)
;(define HS (* 60 60))
;; time -> number
;; computes the seconds passed from midnight to t
;(define (pass t) 
;  (+ (* (time-h t) HS)
;     (* (time-m t) MS)
;     (time-s t)))
;
;(check-expect (pass t1) 45002)


;(define-struct w3 [l1 l2 l3])
;; A W3 is a structure:
;;  (make-w3 string/boolean string/boolean string/boolean)
;;   l1, l2, l3 are all 1-length string ["a" -> "z"] and #f
;
;(define w3a (make-w3 "a" "b" "c"))
;(define w3b (make-w3 "z" "f" "g"))
;(define w3c (make-w3 #f #f #f))
;(define w3d (make-w3 "z" "f" "g"))
;
;; string-> boolean
;; compare single letters, if agree return #t, else return #f
;(define (comp-letter m n) (if (string=? m n) #t #f))
;
;(check-expect (comp-letter "a" "b") #f)
;(check-expect (comp-letter "s" "s") #t)
;
;
;; w3 -> w3
;; compare two w3 words, if the same then return one of them, otherwise return (make-w3 #f #f #f)
;(define (compare-w3 a b)
;  (if (and 
;        (comp-letter (w3-l1 a) (w3-l1 b)) 
;        (comp-letter (w3-l2 a) (w3-l2 b)) 
;        (comp-letter (w3-l3 a) (w3-l3 b)) 
;  ) a (make-w3 #f #f #f)))
;
;(check-expect (compare-w3 w3b w3d) w3d)
;(check-expect (compare-w3 w3a w3b) (make-w3 #f #f #f))


(define-struct editor [pre post])
; An Editor is a structure: (make-editor string string)
; it means the text is (string-append pre post), and a cursor is between pre and post
(define e1 (make-editor "hello" "world"))
(define e2 (make-editor "hel" "loworld"))


(define BG (empty-scene 400 400))

; editor -> image
; render an editor to a image
(define (render ed) 
  (overlay/align "left" "center"
    (beside (text (editor-pre ed) 40 "black")
            (rectangle 1 40 "solid" "red")
            (text (editor-post ed) 40 "black")) BG))

(check-expect (render e1) (overlay/align "left" "center"
    (beside (text (editor-pre e1) 40 "black")
            (rectangle 1 40 "solid" "red")
            (text (editor-post e1) 40 "black")) BG))

(check-expect (render e2) (overlay/align "left" "center"
    (beside (text (editor-pre e2) 40 "black")
            (rectangle 1 40 "solid" "red")
            (text (editor-post e2) 40 "black")) BG))


(define (remove-last str) (substring str 0 (- (string-length str) 1))) 
(check-expect (remove-last "wtd") "wt")
(check-expect (remove-last "wsg") "ws")

(define (string-first str) (string-ith str 0))
(check-expect (string-first "sdg") "s")
(check-expect (string-first "wdg") "w")

(define (string-last str) (string-ith str (- (string-length str) 1)))
(check-expect (string-last "wsg") "g")
(check-expect (string-last "wsd") "d")

; editor string -> editor
; when pressed key, change editor according to it 
;  when key is "\b", delete the letter before cursor(if any), 
; other key add the key string to the pre
; \t and \r is ignored 
;  when key is "left" or "right", move cursor left or right(if any), other longer than 1 length
; string keys is ignored 
(define (edit ed key) 
   (cond
     [(string=? key "\b") ed]
     [(or (string=? key "\r") (string=? key "\t")) ed]
     [(= (string-length key) 1) ed]
     [(string=? key "left") ed]
     [(string=? key "right") ed]
     [else ed]))


