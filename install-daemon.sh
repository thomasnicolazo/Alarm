####################################
# Script install:
# 
# - install alsa
# - install bluez-alsa-utils
# - add user to bluetooth group
# - install /etc/asound.conf
#
#
# options:
#TODO  -t run tests
# 
#  TODO:
#   - add some logs
# #################################

if [ -z $MAC_BLUETOOTH_SPEAKER ]; then
    echo " variable MAC_BLUETOOTH_SPEAKER is not defined"
    exit 1
fi
TEST=$1

DISTRIB_ID=$(cat /etc/*-release | grep DISTRIB_ID | cut -d'=' -f2)
DISTRIB_ID=$( echo $DISTRIB_ID | tr '[:upper:]' '[:lower:]')


if [ $DISTRIB_ID="ubuntu" ]; then
    sudo apt-get install -y alsa bluez-alsa-utils
    if [ -z $TEST ]; then
        alsa_packages=$(dpkg -l | grep -r "^alsa")
        if i ![ -n $alsa_packages ]; then
            echo "Alsa packages are not installed or not found check logs"
        fi
fi

sudo usermod -G bluetooth -a $USER
# check if the user is in bluetooth group
sudo tee /etc/asound.conf <<EOF
defaults.bluealsa {
    interface "hci0"
    device "$MAC_BLUETOOTH_SPEAKER"
    profile "a2dp"
}
EOF

SERVICE_NAME="bluealsa" 

if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "$SERVICE_NAME is active and running"
else
    echo "$SERVICE_NAME is not active or not installed"
    exit 1
fi
SERVICE_NAME="bluetooth" 

if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "$SERVICE_NAME is active and running"
else
    echo "$SERVICE_NAME is not active or not installed"
    exit 1
fi

echo "Deconnection in order to add user to group bluetooth"
logout
