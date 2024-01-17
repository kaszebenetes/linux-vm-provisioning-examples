import infra

def test_ssh_connection(host):
    try:
        infra.ssh(host, command="exit", timeout=5)
        print(f"==> INFO: ✔️ SSH connection to {host} is available for you.")
        return True
    except Exception as e:
        print(f"==> INFO: ❌ Something went wrong.. No access to {host}. {str(e)}")
        return False

def check_iptables(host):
    try:
        iptables_output = infra.ssh(host, command="sudo cat /etc/sysconfig/iptables")
        if not iptables_output.strip():
            print(f"==> INFO: ❌ {host} iptables haven't been stored.")
        else:
            print(f"==> INFO: ✔️ {host} iptables have been stored.")
    except Exception as e:
        print(f"==> INFO: ❌ Failed to check iptables on {host}. {str(e)}")

bastion_host = 'bastion'
web1_host = 'web-1'
web2_host = 'web-2'
weblb_host = 'web-lb'

# Testing SSH connection to bastion
test_ssh_connection(bastion_host)

# Testing SSH connection through bastion to other VMs
test_ssh_connection(web1_host)
test_ssh_connection(web2_host)
test_ssh_connection(weblb_host)

# Checking if iptables have been stored
check_iptables(bastion_host)
check_iptables(web1_host)
check_iptables(web2_host)
check_iptables(weblb_host)
