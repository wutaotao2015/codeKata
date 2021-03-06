;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname door) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

; constants
(define LOCK "lock")
(define CLOSE "close")
(define CN (* 28 3))
(define OPEN CN)
(define BG (empty-scene 400 400))

; ws is a string

; ws -> ws
; on key event handler， door action
(define (kh ws key) 
       (cond
         [(and (eq? ws CLOSE) (string=? key "l")) LOCK]
         [(and (eq? ws LOCK) (string=? key "u")) CLOSE]
         [(and (eq? ws CLOSE) (string=? key " ")) OPEN]
         [else ws]))

; ws->ws
; auto close door, using ticks to change ws from open to close
(define (autoclose ws) 
    (cond 
      [(and (number? ws) (<= ws 0)) CLOSE]
      [(and (number? ws) (> ws 0)) (- ws 1)]
      [else ws]))

; helper function for show
(define (words ws) (place-image (text ws 100 "black") 200 100 BG))
; ws->image
; show the ws with image
(define (show ws) 
  (cond 
    [(number? ws) (words (number->string ws))]
    [else (words ws)]))

; main
(define (main ws)
  (big-bang LOCK 
            [to-draw show]
            [on-tick autoclose]
            [on-key kh]
            ))
(main 0)

(check-expect (kh CLOSE "l") LOCK)
(check-expect (kh CLOSE "q") CLOSE)
(check-expect (kh LOCK "l") LOCK)
(check-expect (kh LOCK "s") LOCK)
(check-expect (kh OPEN "l") OPEN)
(check-expect (kh OPEN "s") OPEN)
(check-expect (kh LOCK "u") CLOSE)
(check-expect (kh LOCK "s") LOCK)
(check-expect (kh CLOSE "u") CLOSE)
(check-expect (kh CLOSE "s") CLOSE)
(check-expect (kh OPEN "u") OPEN)
(check-expect (kh OPEN "s") OPEN)
(check-expect (kh CLOSE " ") OPEN)
(check-expect (kh CLOSE "s") CLOSE)
(check-expect (kh LOCK " ") LOCK)
(check-expect (kh LOCK "s") LOCK)
(check-expect (kh OPEN " ") OPEN)
(check-expect (kh OPEN "s") OPEN)

(check-expect (show LOCK) (words LOCK))
(check-expect (show OPEN) (words (number->string OPEN)))
