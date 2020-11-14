#
#   ansible/Kubernetes-KubeConfig.sh
#
#   David Janes
#   Consensas
#   2018-12-23
#

FOLDER=$(dirname $0)
ANSIBLE_HOSTS=$1
ANSIBLE_HOSTS=${ANSIBLE_HOSTS:=master}
ANSIBLE_INVENTORY=$FOLDER/../inventory.yaml

export ANSIBLE_HOST_KEY_CHECKING=False

set -x

ansible-playbook \
    --inventory "${ANSIBLE_INVENTORY}" \
    --verbose \
    --extra-vars "in_hosts=${ANSIBLE_HOSTS}" \
    $FOLDER/Kubernetes-KubeConfig.yaml

echo "---"
kubectl --kubeconfig $FOLDER/admin.conf get nodes
