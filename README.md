# ramazon package
Run your shiny App on Amazon AWS launching a function.
No setup no pain, just hit that run button!

A detailed tutorial is given [here](https://andreacirilloblog.wordpress.com/2015/08/18/deploy-your-shiny-app-on-aws-with-a-function/)
If you are already comfortable with Amazon AWS, find below a short tutorial.

##How to use it

0. Develop your Shiny App (http://shiny.rstudio.com)
1. Launch an instance on amazon AWS (see aws doc here: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-launch-instance_linux.html)
2. save your key pair into your shiny app folder
3. install ramazon package

   `install.packages("devtools")` if needed
   
   `library(devtools)` if needed
   
   `install_github("andreacirilloac/ramazon")`
   
4. run `ramazon(public_DNS, key_pair_name)`, where `public_DNS` is your ec2 instance public\_DNS and `key_pair_name` is the name of your key pair file.
5. watch your app on Amazon!

##What ramazon takes care of

* establish a connection
* modify sources.list to add R Cran Server
* Install an updated version of R
* Install R Studio Server
* Remove Example page from R studio Server
* Copy your shiny app on Amazon Server

You are not getting it?
No problem, just run ramazon()!
