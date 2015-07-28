chmod 400 C:/Users/2000333/Desktop/ramazon/R/keypair.pem
ssh -o StrictHostKeyChecking=no -v -i C:/Users/2000333/Desktop/ramazon/R/keypair.pem ubuntu@ec2-54-84-184-102.compute-1.amazonaws.com
sudo apt-get update
sudo apt-get upgrade
echo 'deb https://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list-new
mv /etc/apt/sources.list-new /etc/apt/sources.list
sudo apt-get install -y r-base
sudo apt-get install gdebi-core
wget http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.3.0.403-amd64.deb
sudo gdebi shiny-server-1.3.0.403-amd64.deb
rm -Rf /srv/shiny-server/example.R
rm -Rf /srv/shiny-server/example.R
rm -Rf /srv/shiny-server/example.R
scp C:/Users/2000333/Desktop/ramazon/R/keypair.pem ubuntu@ec2-54-84-184-102.compute-1.amazonaws.com/srv/shiny-server/keypair.pem
scp C:/Users/2000333/Desktop/ramazon/R/ramazon_mac.R ubuntu@ec2-54-84-184-102.compute-1.amazonaws.com/srv/shiny-server/ramazon_mac.R
scp C:/Users/2000333/Desktop/ramazon/R/temporary.txt ubuntu@ec2-54-84-184-102.compute-1.amazonaws.com/srv/shiny-server/temporary.txt
scp C:/Users/2000333/Desktop/ramazon/R/test.R ubuntu@ec2-54-84-184-102.compute-1.amazonaws.com/srv/shiny-server/test.R
