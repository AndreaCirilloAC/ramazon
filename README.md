# RAmazon
run your shiny App on Amazon AWS launching a function.

0. Develop your Shiny App
1. Launch an instance on amazon AWS
2. save your key pair into you shiny app folder
3. run `Ramazon(public_DNS : "", key_pair_name = "")`
4. watch your app on Amazon!

##What Ramazon takes care of

* establish a connection
* modify .txt to add R Cran Server
* Install an update version of R
* Install R Studio Server
* Remove Example page from R studio Server
* Copy your shiny app on Amazon Server

You are not getting it?
No problem, just run Ramazon!
