#lang racket

;; collection of random functions that was used to grab data and things like that
;; nothing in here is used for the running of the actual page

(require json)
(require racket/serialize)
(require net/uri-codec)
(require net/url)
(require web-server/servlet
         web-server/servlet-env)




(div ((class "col-md-2"))
     (div ((class "colorlink")) (a ((href "/green-white-blue-generals")) 
                                   (img ((src "/img/green.png")))
                                   (img ((src "/img/white.png")))
                                   (img ((src "/img/blue.png")))
                                   (br)


                                   "Green-White-Blue")))




(define (make-color-link3 a b c)
  `(div ((class "colorlink"))
        (a ((href ,(string-append "/" a "-" b "-" c "-generals")))
           (img ((src ,(string-append "/img/" a))))
           (img ((src ,(string-append "/img/" b))))
           (img ((src ,(string-append "/img/" c))))
           (br)
           ,(string-append a "-" b "-" c))))





(define (add-tag t name)
  (hash-set! (hash-ref edhdb name) t #t))

(hash-set! c 'frenchban '("TRUE"))

(define (set-color! c color)
  (hash-set! c 'colorid `(,color)))

(define (add-ex name)
  (define c (hash-ref edhdb name))
  (if (hash-has-key? c 'exclude)
    (hash-set! c 'exclude '("TRUE"))
    "missing exclude key"))

(define (set-allstar name)
  (hash-set! (hash-ref edhdb name) 'allstar #t))




(define (get-port-from-url url)
  ((compose get-pure-port string->url) url))


(define (repeater f count)
  (for ([x (in-range count)])
       (f)))


(define (get-mtg-json cardname)
  (read-json ((compose get-pure-port string->url) (string-append "http://api.deckbrew.com/mtg/cards?name="
                                                                 (uri-encode cardname)))))

(define (get-multiverseid-from-json json)
  (hash-ref (car (hash-ref (car json) 'editions)) 'multiverse_id))

(define (get-multiverseid card)
  (get-multiverseid-from-json (get-mtg-json card)))



;; get a card that is missing an MID


(define (missing-mid? card)
  (if (hash-has-key? card 'mid) #f #t))


(define (find-card-with-missing-mid db)
  (car (remove* '(#f) 
                (map
                  (lambda (x)
                    (if (missing-mid? (hash-ref db x)) x #f))
                  (hash-keys db)))))

(define (add-mid-to-card str id db)
  (hash-set! (hash-ref db str) 'mid id))


;; various checks of the mids statuses ....

(define (number-of-cards-with-mids db)
  (length (remove* '(#f)
                   (map
                     (lambda (x)
                       (if (missing-mid? (hash-ref db x)) #f #t))
                     (hash-keys db)))))

(define (number-of-cards-without-mids db)
  (length (remove* '(#t)
                   (map
                     (lambda (x)
                       (if (missing-mid? (hash-ref db x)) #f #t))
                     (hash-keys db)))))

(define (midstats db)
  (display (string-append 
             "cards with mids: " (number->string (number-of-cards-with-mids db)) 
             " cards without mids: " (number->string (number-of-cards-without-mids db)))))

(define (list-cards-with-mids db)
  (remove* '(#f)
           (map (lambda (x)
                  (if (missing-mid? (hash-ref db x)) #f x))
                (hash-keys db))))



;; add MID to a card


(define (add-mid-to-card-via-api db)
  (define c (find-card-with-missing-mid db))
  (add-mid-to-card c (get-multiverseid c) db))



;; script the getting of lots of card images

(define (add-n-mids db n)
  (midstats db)
  (sleep 5)
  (repeater 
    (lambda () (add-mid-to-card-via-api db))
    n)
  (midstats db))
   

;; grab image from MID, save it
;; todo - clean up this fn, make it more readable


(define (save-image-from-mid mid)
  (call-with-output-file (string-append cardimgagespath "/" (number->string mid) ".png")
                         (lambda (out)
                           (copy-port (get-port-from-url (string-append 
                                                           "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=" 
                                                           (number->string mid) 
                                                           "&type=card"))
                                      out))
                         #:exists 'replace))
                           
;; find a card that doesn't have an image


(define (missing-img? card)
  (if (hash-has-key? card 'has-img?) #f #t))

(define (find-card-with-missing-img db)
  (car (remove* '(#f) 
                (map
                  (lambda (x)
                    (if (missing-img? (hash-ref db x)) x #f))
                  (hash-keys db)))))


;; add img to card, save it, update hash table


(define (add-image db)
  (define cardname (find-card-with-missing-img db))
  (define cardhash (hash-ref db cardname))
  (define cardnamemid (hash-ref cardhash 'mid))
  (save-image-from-mid cardnamemid)
  (hash-set! cardhash 'has-img? #t))



;; check image infos ...

(define (imgstats db)
  (define img? (map 
                 (lambda (name)
                   (if (hash-has-key? (hash-ref db name) 'has-img?) #t #f))
                 (hash-keys db)))
  (define num-with-img (length (remove* '(#f) img?)))
  (define num-without-img (length (remove* '(#t) img?)))
  (display (string-append "Cards with images: " (number->string num-with-img) "\nCards without images: " (number->string num-without-img) "\n")))

;; script the getting of lots of card images

(define (add-n-imgs db n)
  (imgstats db)
  (sleep 5)
  (repeater 
    (lambda () (add-image db))
    n)
  (imgstats db))

;; get a list of all the cards that have mid = 0

(define (getzeros db)
  (remove* '(#f) 
           (map 
             (lambda (name)
               (if (eq? 0 (hash-ref (hash-ref db name) 'mid)) name #f))
             (hash-keys db))))


(define (setmid name mid)
  (hash-set! (hash-ref edhdb name) 'mid mid))


;; (interleave " + " "red" "green") -> "red + green"

(define (interleave divider . strings)
  (string-append
    (if (eq? 1 (length strings))
      (car strings)
      (string-append (car strings)
                     divider
                     (apply interleave divider (cdr strings))))))















