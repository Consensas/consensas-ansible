#
#   ansible/Kubernetes-Worker.sh
#
#   David Janes
#   Consensas
#   2018-12-23
#

FOLDER=$(dirname $0)
ANSIBLE_HOSTS=$1
ANSIBLE_HOSTS=${ANSIBLE_HOSTS:=worker}
ANSIBLE_INVENTORY="$FOLDER/../inventory.yaml"
ANSIBLE_JOIN_FILE=".join.sh" 

export ANSIBLE_HOST_KEY_CHECKING=False
## export ANSIBLE_DEBUG=1

set -x

ansible-playbook \
    --inventory "${ANSIBLE_INVENTORY}" \
    --verbose \
    --extra-vars "in_hosts=master" \
    --extra-vars "in_join=${ANSIBLE_JOIN_FILE}" \
    $FOLDER/Kubernetes-JoinMaster.yaml

ansible-playbook \
    --inventory "${ANSIBLE_INVENTORY}" \
    --verbose \
    --extra-vars "in_hosts=${ANSIBLE_HOSTS}" \
    --extra-vars "in_join=${ANSIBLE_JOIN_FILE}" \
    $FOLDER/Kubernetes-JoinWorker.yaml

rm -f "${ANSIBLE_JOIN_FILE}"
