#lang racket

;; header and footer boilerplate

(define insertGA
  `(script "(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
              (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
              m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
              })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

           ga('create', 'UA-79812873-1', 'auto');
           ga('send', 'pageview');"))


(define insertlegalfooter
  `(div ((class "row"))
        (div ((class "col-md-12"))
             (p "Wizards of the Coast, Magic: The Gathering, and their logos are trademarks of Wizards of the Coast LLC in the United States and other countries. Copyright 2009 Wizards. All Rights Reserved. This web site is not affiliated with, endorsed, sponsored, or specifically approved by Wizards of the the Coast LLC."))))


(define insertbootstrap
  `(link ((rel "stylesheet")
          (href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css")
          (integrity "sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7")
          (crossorigin "anonymous"))))


(define insertsharethis1
  `(script ((type "text/javascript")
            (src "http://w.sharethis.com/button/buttons.js"))))

(define insertsharethis2
  `(script ((type "text/javascript"))
           "stLight.options({publisher: \"3847deed-85ad-4cd3-8ecd-f274eb521635\", doNotHash: false, doNotCopy: false, hashAddressBar: false});"))



(provide (all-defined-out))
