###############################################################
#custom function to run shiny app on Amazon AWS instance
#Copyright 2015 Andrea Cirillo
#License: MIT license
###############################################################

ramazon <- function( Public_DNS = "", key_pair_name = ""){

# establish a connection with amazon AWS instance

cd = getwd()
key_pair_address = paste(cd,key_pair_name,"pem", sep ="")
user_server = paste(key_pair_address,"ubuntu@",Public_DNS, sep ="")

command = paste("chmod 400 ",key_pair_address,sep ="")
system(command,intern = TRUE)
command = paste("ssh -i -v ",user_server,sep ="")
system(command, intern = TRUE)

# modify sources.list file
system("sudo apt-get update", intern = TRUE)
system("sudo apt-get upgrade", intern = TRUE)
system("sudo nano /etc/apt/sources.list", intern = TRUE)
# MISSING CODE (append text to sources.list)

# install latest R version
system("sudo apt-get install -y r-base", intern = TRUE)

#install packages (LOOP)

# install latest Shiny server version
system("sudo apt-get install gdebi-core", intern = TRUE)
system("wget http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.3.0.403-amd64.deb", intern =TRUE)
system("sudo gdebi shiny-server-1.3.0.403-amd64.deb", intern = TRUE)

# delete standard example
system("rm -Rf /srv/shiny-server/example.R", intern = TRUE)
system("rm -Rf /srv/shiny-server/example.R", intern = TRUE)
system("rm -Rf /srv/shiny-server/example.R", intern = TRUE)
# MISSING CODE(specify files to be removed)

# paste shiny app files
files = list.files(getwd()) # list file within the current directory ( subdirectories not included)
for (i in 1:length(files)){ # loop files to copy file into the server instance
from_address = paste( getwd(),files = i,sep = "/")
to_address   = paste( user_server,"srv/shiny-server",files = i,sep = "/")
command      = paste("scp",from_address,to_address,sep =" ")
}

# navigate the app in a browser
app_url = paste(Public_DNS,":3838",sep ="")
browseURL(app_url)
}
