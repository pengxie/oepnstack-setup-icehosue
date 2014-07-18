

#/bin/bash
#This script is to set base controller environment
su -s /bin/sh -c "keystone-manage db_sync" keystone
export OS_SERVICE_TOKEN=ADMIN_TOKEN
export OS_SERVICE_ENDPOINT=http://controller:35357/v2.0
keystone tenant-create --name admin --description "Admin Tenant"
keystone user-create --name admin --pass {{ ADMIN_PASS }} --email {{ EMAIL_ADDRESS }}
keystone role-create --name admin
keystone user-role-add --tenant admin --user admin --role admin
keystone user-role-add --tenant admin --user admin --role _member_

#Create a demo tenant and user for typical operations in your environment
keystone tenant-create --name demo --description "Demo Tenant"
keystone user-create --name demo --pass {{ DEMO_PASS }} --email {{ EMAIL_ADDRESS }}
keystone user-role-add --tenant demo --user demo --role _member_

#create a user in the service tenant for each service 
keystone tenant-create --name service --description "Service Tenant"

#To create the service entity and API endpoint
keystone service-create --name keystone --type identity --description="OpenStack Identity"
#create API endpoint
keystone endpoint-create \
  --service-id=$(keystone service-list | awk '/ identity / {print $2}') \
  --publicurl=http://controller:5000/v2.0 \
  --internalurl=http://controller:5000/v2.0 \
  --adminurl=http://controller:35357/v2.0

#unset OS_SERVICE_TOKEN OS_SERVICE_ENDPOINT
unset OS_SERVICE_TOKEN OS_SERVICE_ENDPOINT

# Create and source the OpenStack RC file
export OS_USERNAME=admin
export OS_PASSWORD={{ ADMIN_PASS }}
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://controller:35357/v2.0

#Create the glance service
keystone user-create --name=glance --pass={{ glance_pass }} --email={{ EMAIL_ADDRESS }}
keystone user-role-add --user=glance --tenant=service --role=admin
keystone service-create --name=glance --type=image --description="OpenStack Image Service"
keystone endpoint-create \
  --service-id=$(keystone service-list | awk '/ image / {print $2}') \
  --publicurl=http://controller:9292 \
  --internalurl=http://controller:9292 \
  --adminurl=http://controller:9292

#glance 
export http_proxy=http://192.168.1.62:3128
wget http://cdn.download.cirros-cloud.net/0.3.2/cirros-0.3.2-x86_64-disk.img
unset http_proxy

# nova
keystone user-create --name=nova --pass={{ nova_pass }} --email={{ EMAIL_ADDRESS }}
keystone user-role-add --user=nova --tenant=service --role=admin
keystone service-create --name=nova --type=compute --description="OpenStack Compute"
keystone endpoint-create \
  --service-id=$(keystone service-list | awk '/ compute / {print $2}') \
  --publicurl=http://controller:8774/v2/%\(tenant_id\)s \
  --internalurl=http://controller:8774/v2/%\(tenant_id\)s \
  --adminurl=http://controller:8774/v2/%\(tenant_id\)s

#neutron
keystone user-create --name neutron --pass {{ neutron_pass }} --email {{ EMAIL_ADDRESS  }}
keystone user-role-add --user neutron --tenant service --role admin
keystone service-create --name neutron --type network --description "OpenStack Networking"
keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ network / {print $2}') \
  --publicurl http://controller:9696 \
  --adminurl http://controller:9696 \
  --internalurl http://controller:9696