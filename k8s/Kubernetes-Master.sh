#
#   ansible/Kubernetes-Master.sh
#
#   David Janes
#   Consensas
#   2018-12-23
#

FOLDER=$(dirname $0)

set -x

ansible-playbook \
    --inventory $FOLDER/inventory.yaml \
    --verbose \
    --extra-vars "in_hosts=master" \
    $FOLDER/Kubernetes-Master.yaml
