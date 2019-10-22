;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname editor2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)


(define BGH 400)
(define BGW 200)
(define FS 30)
; 400BGW 40FS 22w 20CN 
; 600BGW 60FS 33w 20CN
; 200BGW 30FS 17w 12CN
(define CN (- (/ BGW (/ FS 2)) 1))
(define BG (empty-scene BGW BGH))


(define-struct editor [str idx])
; A Editor is a structure
;  (make-editor string number)
;    a editor a string with the cursor before the index-th character

(define e1 (make-editor "helloworld" 5))
(define e2 (make-editor "helloworld" 3))
(define e3 (make-editor "hello" 5))
(define e4 (make-editor "hello" 0))
(define e5 (make-editor "123456789abcd" 13))

(define ed1 (make-editor "wtt" 1))
(define ed2 (make-editor "wst" 0))
(define ed3 (make-editor "wst" 3))

; editor->string
; get the pre part string of editor
(define (pre-string ed) (substring (editor-str ed) 0 (editor-idx ed)))

; editor->string
; get the post part string of editor
(define (post-string ed) (substring (editor-str ed) (editor-idx ed) 
                                    (string-length (editor-str ed))))

(check-expect (pre-string ed1) "w")
(check-expect (pre-string ed2) "")
(check-expect (pre-string ed3) "wst")
(check-expect (post-string ed1) "tt")
(check-expect (post-string ed2) "wst")
(check-expect (post-string ed3) "")

; editor -> image
; render an editor to an image
(define (show ed) 
(overlay/align "left" "center"
    (beside (text (pre-string ed) FS "black")
            (rectangle 1 FS "solid" "red")
            (text (post-string ed) FS "black")) BG))

(check-expect (show ed1) 
(overlay/align "left" "center"
    (beside (text (pre-string ed1) FS "black")
            (rectangle 1 FS "solid" "red")
            (text (post-string ed1) FS "black")) BG))

(check-expect (show ed2) 
(overlay/align "left" "center"
    (beside (text (pre-string ed2) FS "black")
            (rectangle 1 FS "solid" "red")
            (text (post-string ed2) FS "black")) BG))


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
       (if (= (editor-idx ed) 0) ed 
      (make-editor (string-append (substring (editor-str ed) 0 (- (editor-idx ed) 1)) 
                                  (substring (editor-str ed) 
                                             (editor-idx ed) (string-length (editor-str ed)))) 
                   (- (editor-idx ed) 1)))]

     [(or (string=? key "\r") (string=? key "\t")) ed]

     [(= (string-length key) 1) 
      (if (>= (string-length (editor-str ed)) CN) ed 
      (make-editor (string-append (pre-string ed) key (post-string ed)) 
                   (+ 1 (editor-idx ed))))]

     [(string=? key "left")
       (if (= (editor-idx ed) 0) ed 
          (make-editor (editor-str ed) (- (editor-idx ed) 1)))]

     [(string=? key "right") 
       (if (= (editor-idx ed) (string-length (editor-str ed))) ed 
          (make-editor (editor-str ed) (+ (editor-idx ed) 1)))]

     [else ed]))

(check-expect (edit e1 "\b") (make-editor "hellworld" 4))
(check-expect (edit e2 "\b") (make-editor "heloworld" 2))
(check-expect (edit e3 "\b") (make-editor "hell" 4))
(check-expect (edit e4 "\b") (make-editor "hello" 0))

(check-expect (edit e1 "\r") (make-editor "helloworld" 5))
(check-expect (edit e2 "\r") (make-editor "helloworld" 3))
(check-expect (edit e3 "\r") (make-editor "hello" 5))
(check-expect (edit e4 "\r") (make-editor "hello" 0))

(check-expect (edit e1 "\t") (make-editor "helloworld" 5))
(check-expect (edit e2 "\t") (make-editor "helloworld" 3))
(check-expect (edit e3 "\t") (make-editor "hello" 5))
(check-expect (edit e4 "\t") (make-editor "hello" 0))

(check-expect (edit e1 "s") (make-editor "hellosworld" 6))
(check-expect (edit e2 "s") (make-editor "helsloworld" 4))
(check-expect (edit e3 "s") (make-editor "hellos" 6))
(check-expect (edit e4 "s") (make-editor "shello" 1))
(check-expect (edit e5 "s") e5)

(check-expect (edit e1 "left") (make-editor "helloworld" 4))
(check-expect (edit e2 "left") (make-editor "helloworld" 2))
(check-expect (edit e3 "left") (make-editor "hello" 4))
(check-expect (edit e4 "left") (make-editor "hello" 0))

(check-expect (edit e1 "right") (make-editor "helloworld" 6))
(check-expect (edit e2 "right") (make-editor "helloworld" 4))
(check-expect (edit e3 "right") (make-editor "hello" 5))
(check-expect (edit e4 "right") (make-editor "hello" 1))


; editor -> editor
; run the editor
(define (run pre)
  (big-bang (make-editor pre (string-length pre))
           [to-draw show] 
           [on-key edit]))

(run "begin")

