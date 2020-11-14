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

## admin.conf wants to give you an internal AWS IP
sed -e '1,$ s|server:.*6443|server: https://aws-0001:6443|' < $FOLDER/admin.conf > $FOLDER/admin.conf.tmp &&
mv $FOLDER/admin.conf.tmp $FOLDER/admin.conf

echo "---"
kubectl --kubeconfig $FOLDER/admin.conf get nodes
