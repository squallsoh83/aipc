all:
  hosts:
    myserver:
      ansible_host: ${ipv4}
      ansible_user: root
      ansible_connection: ssh
      ansible_private_key_file: ${private_key}