#
#   ubuntu/Ubutu-Initialize.sh
#
#   David Janes
#   Consensas
#   2018-12-22
#

FOLDER=$(dirname $0)
ANSIBLE_HOSTS=$1
ANSIBLE_HOSTS=${ANSIBLE_HOSTS:=master,worker}
ANSIBLE_INVENTORY=$FOLDER/../inventory.yaml

export ANSIBLE_HOST_KEY_CHECKING=False

set -x

## bootstrap
ansible "${ANSIBLE_HOSTS}" \
    --inventory "${ANSIBLE_INVENTORY}" \
    --verbose \
    --become -m raw -a "apt-get update && apt-get upgrade -y && apt-get install -y python"

## vim, curl and node.js
ansible-playbook \
    --inventory "${ANSIBLE_INVENTORY}" \
    --verbose \
    --extra-vars "in_hosts=${ANSIBLE_HOSTS}" \
    /dev/stdin < $FOLDER/Ubuntu-Initialize.yaml
