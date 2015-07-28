sudo apt-get update
sudo apt-get upgrade
echo 'deb https://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list-new
mv /etc/apt/sources.list-new /etc/apt/sources.list
sudo apt-get install -y r-base
sudo apt-get install gdebi-core
wget http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.3.0.403-amd64.deb
sudo gdebi shiny-server-1.3.0.403-amd64.deb
scp /Users/andrea_cirillo/Dropbox/R_projects/ramazon/R/bash_script.sh ubuntu@ec2-54-84-184-102.compute-1.amazonaws.com/srv/shiny-server/bash_script.sh
scp /Users/andrea_cirillo/Dropbox/R_projects/ramazon/R/keypair.pem ubuntu@ec2-54-84-184-102.compute-1.amazonaws.com/srv/shiny-server/keypair.pem
scp /Users/andrea_cirillo/Dropbox/R_projects/ramazon/R/ramazon_mac.R ubuntu@ec2-54-84-184-102.compute-1.amazonaws.com/srv/shiny-server/ramazon_mac.R
scp /Users/andrea_cirillo/Dropbox/R_projects/ramazon/R/scratch.R ubuntu@ec2-54-84-184-102.compute-1.amazonaws.com/srv/shiny-server/scratch.R
scp /Users/andrea_cirillo/Dropbox/R_projects/ramazon/R/temporary.txt ubuntu@ec2-54-84-184-102.compute-1.amazonaws.com/srv/shiny-server/temporary.txt
scp /Users/andrea_cirillo/Dropbox/R_projects/ramazon/R/test.R ubuntu@ec2-54-84-184-102.compute-1.amazonaws.com/srv/shiny-server/test.R
