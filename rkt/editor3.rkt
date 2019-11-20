#lang htdp/bsl

(require test-engine/racket-tests)
(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

; a editor is a structure
;  (make-editor lo1s lo1s)
;  lo1s is list of 1length string
; lo1s is one of 
;  '()
;  (cons 1string lo1s)
;   pre is the 1string list, meaning characters from the cursor to the beginning of word
;  post is the 1string list, meaning characters from the cursor to the end of word
(define-struct editor [pre post])

; string string -> editor
;   get a editor structure according to the pre string and post string
(define (create-editor prestr poststr) (make-editor (reverse (explode prestr)) (explode poststr)))
(check-expect (create-editor "wst" "cgl") (make-editor (list "t" "s" "w") (list "c" "g" "l")))








; this need to put at last line to ensure testing all test cases
(test)
