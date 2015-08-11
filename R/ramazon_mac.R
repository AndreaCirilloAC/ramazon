###############################################################
#custom function to run shiny app on Amazon AWS instance
#Copyright 2015 Andrea Cirillo
#License: MIT license
###############################################################

ramazon <- function(Public_DNS, key_pair_name){

#set useful variables
current          <-  getwd()
key_pair_address <-  paste(current ,"/",key_pair_name,".pem", sep = "")
user_server      <-  paste("ubuntu@",Public_DNS, sep = "")
#open file connection
connection <-  file("bash_script.txt")
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

#install packages (LOOP)

command <- append(command,cat("sudo su -\\-c \"R -e \\\"install.packages('shiny', repos = 'http://cran.rstudio.com/', dep = TRUE)\\\"\""))

# install latest Shiny server version
command <- append(command,"echo 'R installed'")
command <- append(command,"sudo apt-get install -y gdebi-core")
command <- append(command,"wget http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.3.0.403-amd64.deb")
command <- append(command,"sudo gdebi --non-interactive shiny-server-1.3.0.403-amd64.deb")

# add deleting permission
command <- append(command,"sudo chown -R ubuntu /srv/")

# delete standard example
command  <- append(command,"rm -Rf /srv/shiny-server/index.html")
command  <- append(command,"rm -Rf /srv/shiny-server/sample-apps")

#write file

writeLines(command, connection)
close(connection)

#rename file
file.rename("bash_script.txt","bash_script.sh")

#set execute permission to the script

system("chmod 700 bash_script.sh")

#connect and run script on remote server
command <- paste("ssh -o StrictHostKeyChecking=no -v -i ",key_pair_address, " ",user_server," 'bash -s' < bash_script.sh",sep = "")
system(command)

system("exit")
# paste shiny app files

from_address <-  getwd()
to_address   <-  paste( user_server,":/srv/shiny-server/",sep = "")

#copy from folder recursively

system(paste("scp -v -i",key_pair_address, "-r",from_address,to_address,sep = " "))

# navigate the app in a browser
app_url = paste(Public_DNS,":3838",sep = "")
print("WELL DONE!")
print("you can find your shiny app at the following URL:")
print(app_url)
browseURL(app_url)
}
