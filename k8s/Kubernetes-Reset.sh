#
#   k8s/Kubernetes-Reset.sh
#
#   David Janes
#   Consensas
#   2020-11-14
#

if [ $# != 1 ]
then
    cat << EOF
usage: sh $0 <hosts>

This requires a parameter, as it's dangerous.
If you want to reset everything, use "master,worker" for <hosts>.
EOF
    exit 1
fi

FOLDER=$(dirname $0)
ANSIBLE_HOSTS=$1
ANSIBLE_INVENTORY=$FOLDER/../inventory.yaml

export ANSIBLE_HOST_KEY_CHECKING=False

set -x

ansible-playbook \
    --inventory "${ANSIBLE_INVENTORY}" \
    --verbose \
    --extra-vars "in_hosts=${ANSIBLE_HOSTS}" \
    /dev/stdin < $FOLDER/Kubernetes-Reset.yaml
