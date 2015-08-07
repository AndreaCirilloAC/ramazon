\name{ramazon}
\alias{ramazon}
\title{ramazon()}
\usage{
ramazon(Public_DNS = "ec2.xx.xxx.xx.x", key_pair_name = "mykey")
}
\description{
this function provide an easy way to deploy a shiny app on an ubuntu ec instance taking as input a public ec2 DNS and the name of the keypair file.

When launched it run different command line commands in order to:

- install latest R version;

- install lates shiny server version;

- copy shiny app files on ec2 instance.

Each command is run on verbose mode to let you see things flowing and emerging issues.

WARNINGS:

be sure your key is stored at the same level of other shiny app files.

}
\warnings{

}
\examples{

Public_DNS    <-  "ec2-52-7-96-14.compute-1.amazonaws.com"
key_pair_name <-  "keypair"
ramazon(Public_DNS = Public_DNS, key_pair_name = key_pair_name)

}
