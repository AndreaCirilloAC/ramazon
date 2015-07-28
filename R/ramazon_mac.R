###############################################################
#custom function to run shiny app on Amazon AWS instance
#Copyright 2015 Andrea Cirillo
#License: MIT license
###############################################################

ramazon <- function(Public_DNS, key_pair_name){

#set useful variables
cd = getwd()
key_pair_address = paste(cd,"/",key_pair_name,".pem", sep = "")
user_server = paste("ubuntu@",Public_DNS, sep = "")
#open file connection
connection         <-  file("bash_script.txt")
command = paste("chmod 400 ",key_pair_address,sep = "")
# establish a connection with amazon AWS instance
command = append(command, paste("ssh -o StrictHostKeyChecking=no -v -i ",key_pair_address, " ",user_server,sep = ""))
print ("connection end")

# modify sources.list file
command <- append(command,"sudo apt-get update")
command <- append(command,"sudo apt-get upgrade")

command <- append(command, "echo 'deb https://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list-new")
command <- append(command, "mv /etc/apt/sources.list-new /etc/apt/sources.list")

# install latest R version
command <- append(command, "sudo apt-get install -y r-base")

#install packages (LOOP)

# install latest Shiny server version
command <- append(command,"sudo apt-get install gdebi-core")
command <- append(command,"wget http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.3.0.403-amd64.deb")
command <- append(command,"sudo gdebi shiny-server-1.3.0.403-amd64.deb")

# delete standard example
command <- append(command,"rm -Rf /srv/shiny-server/example.R")
command <- append(command,"rm -Rf /srv/shiny-server/example.R")
command <- append(command,"rm -Rf /srv/shiny-server/example.R")
# MISSING CODE(specify files to be removed)

# paste shiny app files
files = list.files(getwd()) # list file within the current directory ( subdirectories not included)
for (i in 1:length(files)){ # loop files to copy file into the server instance
from_address = paste( getwd(),files[i],sep = "/")
to_address   = paste( user_server,"srv/shiny-server",files [i],sep = "/")
command      = append(command,paste("scp",from_address,to_address,sep = " "))
}
writeLines(command, connection)
close(connection)
# navigate the app in a browser
app_url = paste(Public_DNS,":3838",sep = "")
browseURL(app_url)
}
