\name{ramazon_update}
\alias{ramazon_update}
\title{ramazon_update()}
\usage{
ramazon(Public_DNS = "ec2.xx.xxx.xx.x", key_pair_name = "mykey", test = FALSE)
}
\description{
this function provide an easy way to update a shiny app previously deployed on an ubuntu ec2 instance taking as input a public ec2 DNS and the name of the keypair file.

if test argument = TRUE the function results in a bash script not run.

WARNINGS:

be sure your key is stored at the same level of other shiny app files.

}
\warnings{

}
\examples{

Public_DNS    <-  "ec2-52-7-96-14.compute-1.amazonaws.com"
key_pair_name <-  "keypair"
ramazon_update(Public_DNS = Public_DNS, key_pair_name = key_pair_name)

}
