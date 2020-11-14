#
#   ubuntu/Ubutu-Full.sh
#
#   David Janes
#   Consensas
#   2020-11-14
#

FOLDER=$(dirname $0)
ANSIBLE_HOSTS=$1
ANSIBLE_HOSTS=${ANSIBLE_HOSTS:=master,worker}
ANSIBLE_INVENTORY=$FOLDER/../inventory.yaml

export ANSIBLE_HOST_KEY_CHECKING=False

set -x

ansible-playbook \
    --inventory "${ANSIBLE_INVENTORY}" \
    --verbose \
    --extra-vars "in_hosts=${ANSIBLE_HOSTS}" \
    /dev/stdin < $FOLDER/Ubuntu-Full.yaml
