module "ansible" {
  source = "../../../provision/ansible"
}

resource "null_resource" "ansible_playbooks_copy" {
  count = var.provision_count

  triggers = {
    triggers = var.triggers[count.index]
  }

  connection {
    host        = var.bastion_host_ips[count.index]
    user        = var.user_name
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = module.ansible.local_playbook_path
    destination = module.ansible.remote_playbook_path
  }
}

resource "null_resource" "ansible" {
  depends_on = [null_resource.ansible_playbooks_copy]

  triggers = {
    triggers = join(",", var.triggers)
  }

  provisioner "local-exec" {
    command     = "ansible-playbook -u ${var.user_name} -i ${join(",", var.bastion_host_ips)}, bastion-server.yml --extra-vars='enable_tdagent=${var.enable_tdagent ? 1 : 0}'"
    working_dir = module.ansible.local_playbook_path
  }
}
