#
#   ansible/Kubernetes-Master.sh
#
#   David Janes
#   Consensas
#   2018-12-23
#

FOLDER=$(dirname $0)
ANSIBLE_HOSTS=$1
ANSIBLE_HOSTS=${ANSIBLE_HOSTS:=master}
ANSIBLE_MASTER=aws-0001
ANSIBLE_INVENTORY=$FOLDER/../inventory.yaml

export ANSIBLE_HOST_KEY_CHECKING=False

set -x

ansible-playbook \
    --inventory "${ANSIBLE_INVENTORY}" \
    --verbose \
    --extra-vars "in_hosts=${ANSIBLE_HOSTS}" \
    --extra-vars "in_master=${ANSIBLE_MASTER}" \
    /dev/stdin < $FOLDER/Kubernetes-Master.yaml
