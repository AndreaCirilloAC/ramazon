sudo apt-get -y update
sudo apt-get -y upgrade
echo 'deb https://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
sudo apt-get install -y r-base
echo 'R installed'
sudo apt-get install -y gdebi-core
wget http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.3.0.403-amd64.deb
sudo gdebi --non-interactive shiny-server-1.3.0.403-amd64.deb
sudo chown -R ubuntu /srv/
rm -Rf /srv/shiny-server/index.html
rm -Rf /srv/shiny-server/sample-apps
