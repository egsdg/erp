#https://linode.com/docs/websites/cms/install-odoo-10-on-ubuntu-16-04/
#sudo git clone https://www.github.com/odoo/odoo --depth 1 --branch 11.0 --single-branch /home/ubuntu/workspace/odoo11
sudo service postgresql start
OE_USER="odoo"
OE_HOME="./$OE_USER"
OE_HOME_EXT="./$OE_USER/${OE_USER}"
INSTALL_WKHTMLTOPDF="True"
OE_PORT="8080"
OE_VERSION="10.0"
IS_ENTERPRISE="False"
OE_SUPERADMIN="admin"
OE_CONFIG="${OE_USER}"
sudo git clone https://www.github.com/odoo/odoo --depth 1 --branch 10.0 --single-branch /home/ubuntu/workspace/odoo
sudo pip install -r /home/ubuntu/workspace/odoo/doc/requirements.txt
sudo pip install -r /home/ubuntu/workspace/odoo/requirements.txt
sudo npm install -g less less-plugin-clean-css

WKHTMLTOX_X64=https://downloads.wkhtmltopdf.org/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb
WKHTMLTOX_X32=https://downloads.wkhtmltopdf.org/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-i386.deb

if [ $INSTALL_WKHTMLTOPDF = "True" ]; then
  echo -e "\n---- Install wkhtml and place shortcuts on correct place for ODOO 10 ----"
  #pick up correct one from x64 & x32 versions:
  if [ "`getconf LONG_BIT`" == "64" ];then
      _url=$WKHTMLTOX_X64
  else
      _url=$WKHTMLTOX_X32
  fi
  sudo apt-get install gdebi-core
  sudo wget $_url
  sudo gdebi --n `basename $_url`
  sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin
  sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin
else
  echo "Wkhtmltopdf isn't installed due to the choice of the user!"
fi

sudo adduser $OE_USER sudo

echo -e "\n---- Create Log directory ----"
sudo mkdir /var/log/$OE_USER
sudo chown $OE_USER:$OE_USER /var/log/$OE_USER

echo -e "\n---- Create custom module directory ----"
sudo su $OE_USER -c "mkdir $OE_HOME/custom"
sudo su $OE_USER -c "mkdir $OE_HOME/custom/addons"

echo -e "\n---- Setting permissions on home folder ----"
sudo chown -R $OE_USER:$OE_USER $OE_HOME/*

echo -e "* Create server config file"

sudo touch /etc/odoo/${OE_CONFIG}.conf
echo -e "* Creating server config file"

sudo su root -c "printf 'xmlrpc_port = ${OE_PORT}\n' >> /etc/odoo/${OE_CONFIG}.conf"
sudo su root -c "printf 'logfile = /var/log/${OE_USER}/odoo/${OE_CONFIG}\n' >> /etc/odoo/${OE_CONFIG}.conf"
sudo su root -c "printf 'addons_path=/home/ubuntu/workspace/backend_theme' >> /etc/${OE_CONFIG}.conf"


echo -e "* Start ODOO on Startup"
sudo service odoo stop && sudo service postgresql stop && sudo service odoo start && sudo service postgresql start


echo -e "* Starting Odoo Service"

echo "-----------------------------------------------------------"
echo "Done! The Odoo server is up and running. Specifications:"
echo "Port: $OE_PORT"
echo "User service: $OE_USER"
echo "User PostgreSQL: $OE_USER"
echo "Code location: $OE_USER"
echo "Addons folder: $OE_USER/$OE_CONFIG/addons/"
echo "Start Odoo service: sudo service $OE_CONFIG start"
echo "Stop Odoo service: sudo service $OE_CONFIG stop"
echo "Restart Odoo service: sudo service $OE_CONFIG restart"
echo "-----------------------------------------------------------"
