#!/bin/bash
export OS_SERVICE_TOKEN=ADMIN_TOKEN
export OS_SERVICE_ENDPOINT=http://controller:35357/v2.0
export OS_USERNAME=admin
export OS_PASSWORD={{ password }}
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://controller:35357/v2.0
glance image-create --name "cirros-0.3.2-x86_64" --file cirros-0.3.2-x86_64-disk.img --disk-format qcow2 --container-format bare --is-public True --progress