#/bin/bash
ovs-vsctl add-br br-int
ovs-vsctl add-br br-ex
ovs-vsctl add-port br-ex eth0
ovs-vsctl add-br br-eth1
ovs-vsctl add-port br-eth1 eth1