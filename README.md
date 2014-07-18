## what this ansible do

 install icehouse on ubuntu 12.04

## useage
+ 根据实际的情况修改`group_vars` 下面的参数，将`ansible key` 放到相应机器上，实现无密码登录。

+   ansible-playbook -i hosts playbook-controller.yml -u root
   
+   ansible-playbook -i hosts playbook-network.yml -u root

*   ansible-playbook -i hosts playbook-compute.yml -u root

*  登录到`controller`机器

```
 source admin-openrc.sh
 keystone tenant-get service |awk '/ id / {print $4}' 记录下id
 vim /etc/neutron/neutron.conf
   nova_admin_tenant_id = {{ SERVICE_TENANT_ID }}  # 将上面的id号替换 {{ SERVER_TENANT_ID}}
   
 bash ovsctrl-add.sh #添加网络
 

```

*  登录到`compute`机器

```
 bash ovsctrl-add.sh #添加网络
 
```