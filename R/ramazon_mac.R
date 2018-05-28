###############################################################
#custom functions to run shiny app on Amazon AWS instance
#Copyright 2015 Andrea Cirillo
#License: MIT license
###############################################################

# ramazon function: deploy an application for the first time on Amazon AWS

ramazon <- function(Public_DNS, key_pair_name = NULL, test = FALSE){

  key_pair_address <- get_key_pair_address(key_pair_name)

# modify sources.list file to add cran repository

command <- ("sudo apt-get -y update")
command <- append(command,"sudo chown -R ubuntu /etc/apt")
command <- append(command,"sudo apt-key adv -keyserver keyserver.ubuntu.com -recv-keys E084DAB9")
command <- append(command,"sudo add-apt-repository 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/'")

# install latest R version
command <- append(command, "sudo apt-get -y update")
command <- append(command, "sudo apt-get install -y --force-yes r-base-core")

#write first part of bash_script
write(command,"bash_script.txt",append = TRUE)

#install packages

#detach all packages (except base and tools, handled below)
detach()
#source app files to load required packages
if (file.exists("ui.R")) {
source("ui.R")
source("server.R")
}else {
source("app.R")}
# cover the case of global.R existance
if (file.exists("global.R")) {
source("global.R")
}
# detect all packages loaded (even if not attached)
env          <- sessionInfo()
env_base     <- env$basePkgs
env_loaded   <- env$loadedOnly
env_loaded   <- attributes(env_loaded)
env_loaded   <- env_loaded$names
env_other    <- env$otherPkgs
env_other    <- attributes(env_other)
env_other    <- env_other$names
packages     <- c(env_loaded, env_base,env_other)
packages     <-  paste("'",packages,"'",sep = "")
packages     <-  paste(packages,",",collapse = "")
packages     <-  paste("c(",packages,sep = "")
packages     <-  substr(packages,1,(nchar(packages) - 1))
packages     <-  paste(packages, ")",sep = "")

#define command

sink("bash_script.txt", append = TRUE)
message <-  cat("sudo su -\\-c \"R -e \\\"install.packages(",packages,", repos = 'http://cran.rstudio.com/', dep = TRUE)\\\"\"")
sink()

#XML is needed for this next chunk:
#Here we parse the xml of download3.rstudio.org/
#Using the rootsize we can extract the last entry which is the latest version of shiny server

#added 'Import' to DESCRIPTION for XML
#if(!require(XML)){
#  install.packages("XML")
#  library(XML)
#}
xml.url <- 'http://download3.rstudio.org/'
xmlParsed <- XML::xmlParse(xml.url)
rootnode <- XML::xmlRoot(xmlParsed)
rootsize <- XML::xmlSize(rootnode)
latest_shiny_path <- XML::xmlValue(rootnode[[rootsize]][[1]])
shiny_version <- unlist(strsplit(latest_shiny_path,'/'))[3]

# install latest Shiny server version
command <- c("\necho 'R installed'")
command <- append(command,"sudo apt-get install -y gdebi-core")
command <- append(command,paste0("wget https://download3.rstudio.org/",latest_shiny_path))
command <- append(command,paste0("sudo gdebi --non-interactive ",shiny_version))

# add deleting permission
command <- append(command,"")
command <- append(command,"sudo chown -R ubuntu /srv/")

# delete standard example
command  <- append(command,"rm -Rf /srv/shiny-server/index.html")
command  <- append(command,"rm -Rf /srv/shiny-server/sample-apps")

copy_files_to_server(command, Public_DNS, key_pair_address, test)

}

######################################

# ramazon_update function: deploy an application for update a shiny app previously deployed on Amazon AWS

ramazon_update <- function(Public_DNS, key_pair_name = NULL,test = FALSE){
  
  key_pair_address <- get_key_pair_address(key_pair_name)
  
  command <- ("echo 'update shiny app'")
  
  command  <- append(command,paste0("rm -Rf /srv/shiny-server/",basename(getwd())) )
  
  copy_files_to_server(command, Public_DNS, key_pair_address, test)
  
}

######################################

copy_files_to_server <- function(command, Public_DNS, key_pair_address, test){
#write file
write(command,"bash_script.txt",append = TRUE)

#rename file
file.rename("bash_script.txt","bash_script.sh")

#set execute permission to the script

system("chmod 700 bash_script.sh")

user_server <- paste0("ubuntu@",Public_DNS)

#connect and run script on remote server
command <- paste0("ssh -o StrictHostKeyChecking=no -v -i '",key_pair_address,"' ",user_server," 'bash -s' < bash_script.sh")
if (test == FALSE) {
  system(command)

  system("exit")
  # paste shiny app files

  from_address <-  getwd()
  to_address   <-  paste0(user_server,":/srv/shiny-server/")

  #copy from folder recursively

  system(paste0("scp -v -i '",key_pair_address,"' -r '",from_address,"' '",to_address,"'"))

  # navigate the app in a browser
  app_url = paste0(Public_DNS,":3838/",basename(getwd()))
  message("WELL DONE!")
  message("YOU CAN FIND YOUR SHINY APP AT THE FOLLOWING URL:")
  message(app_url)

} else  {
  print("bash script saved in current working directory")
}

}

######################################

get_key_pair_address <- function(key_pair_name){
  #set useful variables
  current <- getwd()
  
  #automatically detect keypair file
  if(is.null(key_pair_name)){
    key_pair_name <- list.files(pattern = ".pem$")[1]
    
    if(is.na(key_pair_name)){
      stop("No key pair file (.pem) found in current directory")
    }
    
    message(paste("Using key pair file",key_pair_name))
    key_pair_name <- gsub(".pem$","",key_pair_name)
  }
  
  key_pair_address <- paste0(current ,"/",key_pair_name,".pem")
  
  if (!file.exists(key_pair_address)) {
    stop(paste("Unable to find key pair file at:", key_pair_address))
  }
  
  #open file connection
  
  system(paste0("chmod 400 '",key_pair_address,"'"))
  
  return(key_pair_address)
}
