resource "openstack_compute_instance_v2" "jumphost" {
  count           = "${var.jumphost_count}"
  name            = "${var.project}-jumphost${format("%02d", count.index+1)}"
  image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor_name}"
  key_pair        = "${openstack_compute_keypair_v2.keypair.name}"
  security_groups = [
    "${openstack_compute_secgroup_v2.secgrp_jmp.name}"
  ]

  network {
    uuid = "${openstack_networking_network_v2.network.id}"
    access_network = true
  }
}

resource "openstack_compute_floatingip_associate_v2" "fip" {
  count       = "${var.jumphost_count}"
  floating_ip = "${element(openstack_networking_floatingip_v2.fip.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.jumphost.*.id, count.index)}"
}
