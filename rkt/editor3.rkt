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
; helper function
(define (editor-from-str pre post) (make-editor (reverse (explode pre)) (explode post)))

(check-expect (editor-from-str "wt" "sg") (make-editor (list "t" "w") (list "s" "g")))
(check-expect (editor-from-str "" "sg") (make-editor '() (list "s" "g")))
(check-expect (editor-from-str "wt" "") (make-editor (list "t" "w") '()))

(define e1 (editor-from-str "hello" "world"))
(define e2 (editor-from-str "hel" "loworld"))
(define e3 (editor-from-str "hello" ""))
(define e4 (editor-from-str "" "hello"))

(define ed1 (editor-from-str "w" "tt"))
(define ed2 (editor-from-str "" "wst"))
(define ed3 (editor-from-str "wst" ""))


; string string -> editor
;   get a editor structure according to the pre string and post string
(define (create-editor prestr poststr) (make-editor (reverse (explode prestr)) (explode poststr)))
(check-expect (create-editor "wst" "cgl") (make-editor (list "t" "s" "w") (list "c" "g" "l")))

(define BGH 400)
(define BGW 200)
(define FS 30)
; 400BGW 40FS 22w 20CN 
; 600BGW 60FS 33w 20CN
; 200BGW 30FS 17w 12CN
(define CN (- (/ BGW (/ FS 2)) 1))
(define BG (empty-scene BGW BGH))
(define CURSOR (rectangle 1 FS "solid" "red"))

; editor string -> editor
; when pressed key, change editor according to it 
;  when key is "\b", delete the letter before cursor(if any), 
; other key add the key string to the pre
; \t and \r is ignored 
;  when key is "left" or "right", move cursor left or right(if any), other longer than 1 length
; string keys is ignored 
(define (edit ed key) 
  (cond
    [(string=? key "\b") 
     (if (= (length (editor-pre ed)) 0) ed 
       (make-editor (rest (editor-pre ed)) (editor-post ed)))]

    [(or (string=? key "\r") (string=? key "\t")) ed]

    [(= (string-length key) 1) 
     (if (>= (+ (length (editor-pre ed)) (length (editor-post ed))) CN) ed 
       (make-editor (cons key (editor-pre ed)) (editor-post ed)))]

    [(string=? key "left")
     (if (= (length (editor-pre ed)) 0) ed 
       (make-editor (rest (editor-pre ed)) (cons (first (editor-pre ed)) (editor-post ed))))]

    [(string=? key "right") 
     (if (= (length (editor-post ed)) 0) ed 
       (make-editor (cons (first (editor-post ed)) (editor-pre ed)) 
                    (rest (editor-post ed))))]

    [(string=? key "home") 
     (if (= (length (editor-pre ed)) 0) ed 
       (make-editor '() (append (reverse (editor-pre ed)) (editor-post ed))))]

    [(string=? key "end") 
     (if (= (length (editor-post ed)) 0) ed 
       (make-editor (append (reverse (editor-post ed)) (editor-pre ed)) '()))]

    [else ed]))

(check-expect (edit e1 "\b") (editor-from-str "hell" "world"))
(check-expect (edit e2 "\b") (editor-from-str "he" "loworld"))
(check-expect (edit e3 "\b") (editor-from-str "hell" ""))
(check-expect (edit e4 "\b") (editor-from-str "" "hello"))

(check-expect (edit e1 "\r") (editor-from-str "hello" "world"))
(check-expect (edit e2 "\r") (editor-from-str "hel" "loworld"))
(check-expect (edit e3 "\r") (editor-from-str "hello" ""))
(check-expect (edit e4 "\r") (editor-from-str "" "hello"))

(check-expect (edit e1 "\t") (editor-from-str "hello" "world"))
(check-expect (edit e2 "\t") (editor-from-str "hel" "loworld"))
(check-expect (edit e3 "\t") (editor-from-str "hello" ""))
(check-expect (edit e4 "\t") (editor-from-str "" "hello"))

(check-expect (edit e1 "s") (editor-from-str "hellos" "world"))
(check-expect (edit e2 "s") (editor-from-str "hels" "loworld"))
(check-expect (edit e3 "s") (editor-from-str "hellos" ""))
(check-expect (edit e4 "s") (editor-from-str "s" "hello"))

(check-expect (edit e1 "left") (editor-from-str "hell" "oworld"))
(check-expect (edit e2 "left") (editor-from-str "he" "lloworld"))
(check-expect (edit e3 "left") (editor-from-str "hell" "o"))
(check-expect (edit e4 "left") (editor-from-str "" "hello"))

(check-expect (edit e1 "right") (editor-from-str "hellow" "orld"))
(check-expect (edit e2 "right") (editor-from-str "hell" "oworld"))
(check-expect (edit e3 "right") (editor-from-str "hello" ""))
(check-expect (edit e4 "right") (editor-from-str "h" "ello"))

(check-expect (edit e1 "home") (editor-from-str "" "helloworld"))
(check-expect (edit e2 "home") (editor-from-str "" "helloworld"))
(check-expect (edit e3 "home") (editor-from-str "" "hello"))
(check-expect (edit e4 "home") (editor-from-str "" "hello"))

(check-expect (edit e1 "end") (editor-from-str "helloworld" ""))
(check-expect (edit e2 "end") (editor-from-str "helloworld" ""))
(check-expect (edit e3 "end") (editor-from-str "hello" ""))
(check-expect (edit e4 "end") (editor-from-str "hello" ""))

; editor -> image
; render an editor to an image
(define (show ed) 
  (overlay/align "left" "center"
                 (beside (text (implode (reverse (editor-pre ed))) FS "black")
                         CURSOR
                         (text (implode (editor-post ed)) FS "black")) BG))

(check-expect (show ed1) 
              (overlay/align "left" "center"
                             (beside (text (implode (reverse (editor-pre ed1))) FS "black")
                                     CURSOR
                                     (text (implode (editor-post ed1)) FS "black")) BG))

(check-expect (show ed2) 
              (overlay/align "left" "center"
                             (beside (text (implode (reverse (editor-pre ed2))) FS "black")
                                     CURSOR
                                     (text (implode (editor-post ed2)) FS "black")) BG) )


; editor -> editor
; run the editor
(define (run pre)
  (big-bang (editor-from-str pre "")
           [to-draw show] 
           [on-key edit]))

(run "begin")


; this need to put at last line to ensure testing all test cases
(test)
