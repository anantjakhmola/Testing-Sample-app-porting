#I have used ubuntu 20.04 on AWS EC2 for this practical
#Note All traffic was on for this particulart instance
sudo apt update -y
sudo apt-get install apache2 git -y 
sudo git clone https://github.com/anantjakhmola/Testing-Sample-app-porting.git
sudo cp -vrf Testing-Sample-app-porting/* /var/www/html/
sudo systemctl restart apache2



sudo echo "# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 8080
Listen 8081

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet" > /etc/apache2/ports.conf

#Now we have to update the virtual host of the file to accept connection on port 8080,8081
#A simple script would be creating a temp file
#This will create a new file and then using sed will copy the content of main file to temp file 
#then we we will copy all the content of temp file to mainfile

 sudo echo '<VirtualHost *:8080 *:8081>' > /etc/apache2/sites-enabled/tempfile.conf
 sed '1d;' /etc/apache2/sites-enabled/000-default.conf >> /etc/apache2/sites-enabled/tempfile.conf
 cat /etc/apache2/sites-enabled/000-default.conf >> /etc/apache2/sites-enabled/tempfile.conf
 sudo cp /etc/apache2/sites-enabled/tempfile.conf /etc/apache2/sites-enabled/000-default.conf 


#I have redirected port range 8082- 65535 to port 8080 but we can change that also
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 8082:65535 -j REDIRECT --to-port 8080
sudo iptables-save
sudo systemctl restart apache2


#LINK TO THE website
#http://13.232.227.173:8080/
