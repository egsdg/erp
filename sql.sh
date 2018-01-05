
echo -e "\n---- Creating the ODOO PostgreSQL User  ----"
sudo su - postgres -c "createuser -s $OE_USER" 2> /dev/null || true
sudo su - postgres -c "psql -c \"CREATE ROLE odoo WITH PASSWORD 'odoo' SUPERUSER;\""
sudo su - postgres -c "psql -c \"ALTER ROLE odoo WITH LOGIN;\""
sudo su - postgres -c "psql -c \"update pg_database set datallowconn = TRUE where datname = 'template0';\""
sudo su - postgres -c "psql -d template0 -c \"drop database template1;\""
sudo su - postgres -c "psql -d template0 -c \"create database template1 with template = template0 encoding = 'unicode';\""
sudo su - postgres -c "psql -d template0 -c \"update pg_database set datistemplate = TRUE where datname = 'template1';\""
sudo su - postgres -c "psql -c  \"\c template1;\""
sudo su - postgres -c "psql -d template0 -c \" vacuum freeze;\""
			