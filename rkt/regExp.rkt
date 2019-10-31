;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname regExp) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

(define AA "start matching with a")
(define BB "go on with b or c")
(define ER "wrong input")
(define DD "matched")

; ws is a string in one of 
;  AA, BB, ER, DD

; ws -> image
(define (render ws) (text ws 20 "black"))

; ws -> ws
;   key handler
(define (kh ws key) (cond
                      [(string=? ws AA) (cond
                                          [(string=? key "a") BB]
                                          [else ER])]
                      [(string=? ws BB) (cond 
                                          [(or (string=? key "b") (string=? key "c")) BB]
                                          [(string=? key "d") DD]
                                          [else ER]
                                          )]
                      [else ws]
                      ))
; main
(define (main ws) (big-bang AA 
                            [to-draw render]
                            [on-key kh]
                            ))
(main AA)


