ramazon( Public_DNS = "", key_pair_name = ""){

# establish a connection with amazon AWS instance

key_pair_address = paste(getwd(),key_pair_name,"pem", sep ="")
command = paste("chmod 400 ",key_pair_address,sep ="")
system(command,intern = TRUE)
command = paste("ssh -i -v ",key_pair_address,"ubuntu@",Public_DNS,sep ="")
system(command, intern = TRUE)

# modify sources.list file
system("sudo apt-get update", intern = TRUE)
system("sudo apt-get upgrade", intern = TRUE)
system("sudo nano /etc/apt/sources.list", intern = TRUE)
# MISSING CODE
# install latest R version
system("sudo apt-get install -y r-base", intern = TRUE)

#install packages (LOOP)

# install latest Shiny server version

system("sudo apt-get install gdebi-core", intern = TRUE)
system("wget http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.3.0.403-amd64.deb", intern =TRUE)
system("sudo gdebi shiny-server-1.3.0.403-amd64.deb", intern = TRUE)

# delete standard example

# paste shiny app files

# navigate the app in a browser

}
