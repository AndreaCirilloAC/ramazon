###############################################################
#custom functions to run shiny app on Amazon AWS instance
#Copyright 2015 Andrea Cirillo
#License: MIT license
###############################################################

# ramazon function: deploy an application for the first time on Amazon AWS

ramazon <- function(Public_DNS, key_pair_name,test = FALSE){

#set useful variables
current          <-  getwd()
key_pair_address <-  paste(current ,"/",key_pair_name,".pem", sep = "")
user_server      <-  paste("ubuntu@",Public_DNS, sep = "")
#open file connection

command    <-  paste("chmod 400 ",key_pair_address,sep = "")
system(command)
# modify sources.list file to add cran repository

command <- ("sudo apt-get -y update")
command <- append(command,"sudo chown -R ubuntu /etc/apt")
command <- append(command,"sudo apt-key adv -keyserver keyserver.ubuntu.com -recv-keys E084DAB9")
command <- append(command,"sudo add-apt-repository 'deb http://star-www.st-andrews.ac.uk/cran/bin/linux/ubuntu trusty/'")

# install latest R version
command    <- append(command, "sudo apt-get -y update")
command    <- append(command, "sudo apt-get install -y --force-yes r-base-core")

#write first part of bash_script
write(command,"bash_script.txt",append = TRUE)

#install packages

#source ui.R and server.R
source("ui.R")
source("server.R")
# detect all packages loaded
environ      <- data.frame("envs" = (search()),stringsAsFactors = FALSE)
# we don't want tools
environ <- environ[grepl("package",environ[,1]),]
packages     <-  gsub("package:","",environ)
packages     <-  paste("'",packages,"'",sep ="")
packages     <-  paste(packages,",",collapse = "")
packages     <-  paste("c(",packages,sep ="")
packages     <-  substr(packages,1,(nchar(packages)-1))
packages     <-  paste(packages, ")",sep ="")

#define command

sink("bash_script.txt", append = TRUE)
message <-  cat("sudo su -\\-c \"R -e \\\"install.packages(",packages,", repos = 'http://cran.rstudio.com/', dep = TRUE)\\\"\"")
sink()

# install latest Shiny server version
command <- c("\echo 'R installed'")
command <- append(command,"sudo apt-get install -y gdebi-core")
command <- append(command,"wget http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.3.0.403-amd64.deb")
command <- append(command,"sudo gdebi --non-interactive shiny-server-1.3.0.403-amd64.deb")

# add deleting permission
command <- append(command,"")
command <- append(command,"sudo chown -R ubuntu /srv/")

# delete standard example
command  <- append(command,"rm -Rf /srv/shiny-server/index.html")
command  <- append(command,"rm -Rf /srv/shiny-server/sample-apps")

#write file
write(command,"bash_script.txt",append = TRUE)

#rename file
file.rename("bash_script.txt","bash_script.sh")

#set execute permission to the script

system("chmod 700 bash_script.sh")

#connect and run script on remote server
command <- paste("ssh -o StrictHostKeyChecking=no -v -i ",key_pair_address, " ",user_server," 'bash -s' < bash_script.sh",sep = "")
if (test == FALSE) {
  system(command)

  system("exit")
  # paste shiny app files

  from_address <-  getwd()
  to_address   <-  paste( user_server,":/srv/shiny-server/",sep = "")

  #copy from folder recursively

  system(paste("scp -v -i",key_pair_address, "-r",from_address,to_address,sep = " "))

  # navigate the app in a browser
  app_url = paste(Public_DNS,":3838/",basename(getwd()),sep = "")
  message("WELL DONE!")
  message("YOU CAN FIND YOUR SHINY APP AT THE FOLLOWING URL:")
  message(app_url)
  browseURL(app_url)
} else  {
  print("bash script saved in current working directory")
}

}
######################################

# ramazon_update function: deploy an application for update a shiny app previously deployed on Amazon AWS

ramazon_update <- function(Public_DNS, key_pair_name,test = FALSE){

  #set useful variables
  current          <-  getwd()
  key_pair_address <-  paste(current ,"/",key_pair_name,".pem", sep = "")
  user_server      <-  paste("ubuntu@",Public_DNS, sep = "")
  #open file connection

  command    <-  paste("chmod 400 ",key_pair_address,sep = "")
  system(command)
  # modify sources.list file to add cran repository

  command <- ("echo 'update shiny app'")

  command  <- append(command,paste("rm -Rf /srv/shiny-server/",basename(getwd()),sep ="") )

  #write file
  write(command,"bash_script.txt",append = TRUE)

  #rename file
  file.rename("bash_script.txt","bash_script.sh")

  #set execute permission to the script

  system("chmod 700 bash_script.sh")

  #connect and run script on remote server
  command <- paste("ssh -o StrictHostKeyChecking=no -v -i ",key_pair_address, " ",user_server," 'bash -s' < bash_script.sh",sep = "")
  if (test == FALSE) {
    system(command)

    system("exit")
    # paste shiny app files

    from_address <-  getwd()
    to_address   <-  paste( user_server,":/srv/shiny-server/",sep = "")

    #copy from folder recursively

    system(paste("scp -v -i",key_pair_address, "-r",from_address,to_address,sep = " "))

    # navigate the app in a browser
    app_url = paste(Public_DNS,":3838/",basename(getwd()),sep = "")
    message("WELL DONE!")
    message("YOU CAN FIND YOUR UPDATED SHINY APP AT THE FOLLOWING URL:")
    message(app_url)
    browseURL(app_url)
  } else  {
    print("bash script saved in current working directory")
  }

}
