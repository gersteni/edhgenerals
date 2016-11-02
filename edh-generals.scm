#lang racket

;; required libraries

(require json)
(require racket/serialize)
(require net/uri-codec)
(require net/url)
(require web-server/servlet
         web-server/servlet-env)

(require "./boilerplate.scm")
(require "./utils.scm")

;; dispatch stuff

(define-values (site-dispatch site-url)
               (dispatch-rules
                 (("") main)
                 (("about") about-page)

                 (("white-blue-black-red-generals") wubr-gens)
                 (("blue-black-red-green-generals") ubrg-gens)
                 (("black-red-green-white-generals") brgw-gens)
                 (("red-green-white-blue-generals") rgwu-gens)
                 (("green-white-blue-black-generals") gwub-gens)

                 (("red-generals") red-gens)
                 (("green-generals") green-gens)
                 (("white-generals") white-gens)
                 (("blue-generals") blue-gens)
                 (("black-generals") black-gens)

                 (("colorless-generals") colorless-gens)
                 (("rainbow-generals") rainbow-gens)

                 (("black-red-green-generals") jund-gens)
                 (("green-white-blue-generals") bant-gens)
                 (("blue-black-red-generals") grixis-gens)
                 (("white-blue-black-generals") esper-gens)
                 (("red-green-white-generals") naya-gens)

                 (("blue-red-white-generals") jeskai-gens)
                 (("red-white-black-generals") mardu-gens)
                 (("black-green-blue-generals") sultai-gens)
                 (("green-blue-red-generals") temur-gens)
                 (("white-black-green-generals") abzan-gens)

                 (("white-blue-generals") azorius-gens)
                 (("blue-black-generals") dimir-gens)
                 (("black-red-generals") rakdos-gens)
                 (("red-green-generals") gruul-gens)
                 (("green-white-generals") selesnya-gens)

                 (("white-black-generals") orzhov-gens)
                 (("blue-red-generals") izzet-gens)
                 (("black-green-generals") golgari-gens)
                 (("red-white-generals") boros-gens)
                 (("green-blue-generals") simic-gens)


                 (("jund") jund-gens)
                 (("bant") bant-gens)
                 (("grixis") grixis-gens)
                 (("esper") esper-gens)
                 (("naya") naya-gens)
                 (("jeskai") jeskai-gens)
                 (("mardu") mardu-gens)
                 (("sultai") sultai-gens)
                 (("temur") temur-gens)
                 (("abzan") abzan-gens)
                 (("azorius") azorius-gens)
                 (("dimir") dimir-gens)
                 (("rakdos") rakdos-gens)
                 (("gruul") gruul-gens)
                 (("selesnya") selesnya-gens)
                 (("orzhov") orzhov-gens)
                 (("izzet") izzet-gens)
                 (("golgari") golgari-gens)
                 (("boros") boros-gens)
                 (("simic") simic-gens)
                 (("red") red-gens)
                 (("green") green-gens)
                 (("white") white-gens)
                 (("blue") blue-gens)
                 (("black") black-gens)
                 (("rainbow") rainbow-gens)
                 (("colorless") colorless-gens)
                 ))


(define (start req)
  (site-dispatch req))

(define (main req) (make-index-page req))

(define (about-page req) (make-about-page))

(define (jund-gens req) (make-gen-page "JUND" req))
(define (bant-gens req) (make-gen-page "BANT" req))
(define (grixis-gens req) (make-gen-page "GRIXIS" req))
(define (esper-gens req) (make-gen-page "ESPER" req))
(define (naya-gens req) (make-gen-page "NAYA" req))
(define (jeskai-gens req) (make-gen-page "JESKAI" req))
(define (mardu-gens req) (make-gen-page "MARDU" req))
(define (sultai-gens req) (make-gen-page "SULTAI" req))
(define (temur-gens req) (make-gen-page "TEMUR" req))
(define (abzan-gens req) (make-gen-page "ABZAN" req))
(define (azorius-gens req) (make-gen-page "AZORIUS" req))
(define (dimir-gens req) (make-gen-page "DIMIR" req))
(define (rakdos-gens req) (make-gen-page "RAKDOS" req))
(define (gruul-gens req) (make-gen-page "GRUUL" req))
(define (selesnya-gens req) (make-gen-page "SELESNYA" req))
(define (orzhov-gens req) (make-gen-page "ORZHOV" req))
(define (izzet-gens req) (make-gen-page "IZZET" req))
(define (golgari-gens req) (make-gen-page "GOLGARI" req))
(define (boros-gens req) (make-gen-page "BOROS" req))
(define (simic-gens req) (make-gen-page "SIMIC" req))
(define (red-gens req) (make-gen-page "RED" req))
(define (green-gens req) (make-gen-page "GREEN" req))
(define (white-gens req) (make-gen-page "WHITE" req))
(define (blue-gens req) (make-gen-page "BLUE" req))
(define (black-gens req) (make-gen-page "BLACK" req))
(define (rainbow-gens req) (make-gen-page "RAINBOW" req))
(define (colorless-gens req) (make-gen-page "COLORLESS" req))


(define (wubr-gens req) (make-gen-page "WUBR" req))
(define (ubrg-gens req) (make-gen-page "UBRG" req))
(define (brgw-gens req) (make-gen-page "BRGW" req))
(define (rgwu-gens req) (make-gen-page "RGWU" req))
(define (gwub-gens req) (make-gen-page "GWUB" req))


(define (make-gen-page color req)

  (define titletext
    (if (eqv? "RAINBOW" color)
      "EDH Generals"
      (string-append color " EDH Generals")))


  (response/xexpr 
    `(html
       (head
        (title ,titletext)      
        (meta ((charset "utf-8")))

         ;; using the viewport recommendation from https://developers.google.com/speed/docs/insights/ConfigureViewport
         (meta ((name "viewport")
                (content "width=device-width, initial-scale=1")))

         (meta ((http-equiv "X-UA-Compatible")
                (content "IE=edge")))

         ;; removing sharethis stuff for now, it will better to have it on the bottom
         ,insertbootstrap ;;,insertsharethis1 ,insertsharethis2

         (link ((rel "stylesheet") (href "style.css")))

         ,insertGA)

       (body
         (div ((class "container"))

              (div ((class "row"))
                   (div ((class "col-md-12"))
                        (h1 ((id "header")) 
                            (a ((href "/")) "EDH Generals")
                            " > "
                            ,(string-append color " Generals"))))


              (h2 ,(string-append "There are  " 

                                 (number->string (length (get-cards-by-cid color)))
                                 " "
                                 color " commander generals."))

              ,(print-color color)

              ,insertlegalfooter

              )))))

(define (make-about-page)


  (response/xexpr 
    `(html
       (head
        (title "About EDH Generals")      
        (meta ((charset "utf-8")))

         ;; using the viewport recommendation from https://developers.google.com/speed/docs/insights/ConfigureViewport
         (meta ((name "viewport")
                (content "width=device-width, initial-scale=1")))

         (meta ((http-equiv "X-UA-Compatible")
                (content "IE=edge")))

         
    

         ;; removing sharethis stuff for now, it will better to have it on the bottom
         ,insertbootstrap ;;,insertsharethis1 ,insertsharethis2

         (link ((rel "stylesheet") (href "style.css")))

         ,insertGA)

       (body
         (div ((class "container"))

              (div ((class "row"))
                   (div ((class "col-md-12"))
                        (h1 ((id "header")) 
                            "About EDH Generals")
                        (p "The idea behind EDH Generals is simple - to provide a complete listing of all the generals / commanders for the EDH / Commander Magic The Gathering format. Every legendary creature and five planeswalkers are in the list, sorted by color identity.")
                        (p "This website is run by Idoh Gersten, who has played MTG since 1995."))))))))




;; (interleave " + " "red" "green") -> "red + green"

(define (interleave divider . strings)
  (string-append
    (if (eq? 1 (length strings))
      (car strings)
      (string-append (car strings)
                     divider
                     (apply interleave divider (cdr strings))))))


(define (make-color-link . colors)
  `(a ((href ,(string-append "/"
                             (apply interleave "-" colors)
                             "-generals")))
      (span ((class "label label-primary colorlink"))

            ,@(map (lambda (color)
                     `(img ((src ,(string-append "/img/" color ".png")))))
                   colors))))



(define (make-color-link5)
  `(a ((href "/rainbow-generals"))
      (span ((class "label label-primary colorlink"))
            (img ((src "/img/white.png")))
            (img ((src "/img/blue.png")))
            (img ((src "/img/black.png")))
            (img ((src "/img/red.png")))
            (img ((src "/img/green.png")))
            )))

                ;; "rainbow")))

(define color-ids
  '(("white")
    ("blue")
    ("black")
    ("red")
    ("green")

    ("white" "blue")
    ("blue" "black")
    ("black" "red")
    ("red" "green")
    ("green" "white")


    ("white" "black")
    ("blue" "red")
    ("black" "green")
    ("red" "white")
    ("green" "blue")

    ("green" "white" "blue")
    ("white" "blue" "black")
    ("blue" "black" "red")
    ("black" "red" "green")
    ("red" "green" "white")

    ("white" "black" "green")
    ("blue" "red" "white")
    ("black" "green" "blue")
    ("red" "white" "black")
    ("green" "blue" "red")


    ("white" "blue" "black" "red")
    ("blue" "black" "red" "green")
    ("black" "red" "green" "white")
    ("red" "green" "white" "blue")
    ("green" "white" "blue" "black")

    ("colorless")))


(define (make-index-page req)
  (response/xexpr
    `(html
       (head

         ,charset ,viewport ,http-equiv ,insertbootstrap  ,insertGA ,stylesheet

         (title "EDH Generals"))

       (body (div ((class "container main"))

                  (div ((class "row"))
                       (div ((class "col-md-12"))

                            (h1 "EDH Generals")
                            (p "Every EDH General ever printed from Alpha to Commander 2016. Tap on the links to find generals by their color identity.")


                            ,@(map (lambda (x)
                                     (apply make-color-link x))
                                   color-ids)

                            ,(make-color-link5)

                            (h2 ,(string-append "There are  " 

                                                (number->string (length (get-cards-by-cid "COLORLESS")))
                                                " "
                                                "COLORLESS commander generals."))

                            ,(print-color "COLORLESS")))

                  ,index-footer)))))


(define (gogo) 
  (serve/servlet start
                 #:servlet-regexp #rx""
                 #:servlet-path "/"
                 #:listen-ip #f
                 #:command-line? #t
                 ;; if you run on port 80 then you need to "sudo racket" first
                 #:port 80
                 ;; #:log-file "./log.txt"

                 ;; to-do: fix this, should not be reading from the root directory

                 #:extra-files-paths (list  (build-path "./"))
                 ))

(provide (all-defined-out))
