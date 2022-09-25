#!/bin/bash
#
# crontab -l > mycron
# echo "#" >> mycron
# echo "# At every 2nd minute" >> mycron
# echo "*/1 * * * * /bin/bash /autofan.sh >> /tmp/cron.log" >> mycron
# crontab mycron
# rm mycron
# chmod +x /autofan.sh
#
PASSWORD="your password"
USERNAME="your username"
ILOIP="your ilo ip"
SSH_OPTIONS="-oKexAlgorithms=+diffie-hellman-group1-sha1 -oHostkeyAlgorithms=+ssh-rsa"

T1="$(sensors -Aj coretemp-isa-0000 | jq '.[][] | to_entries[] | select(.key | endswith("input")) | .value' | sort -rn | head -n1)"
T2="$(sensors -Aj coretemp-isa-0001 | jq '.[][] | to_entries[] | select(.key | endswith("input")) | .value' | sort -rn | head -n1)"

echo "CPU 1/2 Temp $T1°C / $T1°C"

if [[ $T1 > 67 ]]; then
    p3_max=255
    p4_max=255
    p5_max=255
elif [[ $T1 > 58 ]]; then
    p3_max=100
    p4_max=100
    p5_max=80

elif [[ $T1 > 54 ]]; then
    p3_max=85
    p4_max=85
    p5_max=70
elif [[ $T1 > 52 ]]; then
    p3_max=65
    p4_max=65
    p5_max=55
elif [[ $T1 > 50 ]]; then
    p3_max=55
    p4_max=55
    p5_max=45
else
    p3_max=40
    p4_max=40
    p5_max=30
fi

if [[ $T2 > 67 ]]; then
    p0_max=255
    p1_max=255
    p2_max=255
elif [[ $T2 > 58 ]]; then
    p0_max=80
    p1_max=80
    p2_max=100
elif [[ $T2 > 54 ]]; then
    p0_max=70
    p1_max=70
    p2_max=85
elif [[ $T2 > 52 ]]; then
    p0_max=55
    p1_max=55
    p2_max=65
elif [[ $T2 > 50 ]]; then
    p0_max=45
    p1_max=45
    p2_max=55
else
    p0_max=30
    p1_max=30
    p2_max=40
fi

echo Set Fan Max: 1: $((${p0_max} * 100 / 256))%
2: $((${p1_max} * 100 / 256))%
3: $((${p2_max} * 100 / 256))%
4: $((${p3_max} * 100 / 256))%
5: $((${p4_max} * 100 / 256))%
6: $((${p5_max} * 100 / 256))%

ssh $SSH_OPTIONS $USERNAME@$ILOIP "fan p 0 max ${p0_max}"
ssh $SSH_OPTIONS $USERNAME@$ILOIP "fan p 1 max ${p1_max}"
ssh $SSH_OPTIONS $USERNAME@$ILOIP "fan p 2 max ${p2_max}"
ssh $SSH_OPTIONS $USERNAME@$ILOIP "fan p 3 max ${p3_max}"
ssh $SSH_OPTIONS $USERNAME@$ILOIP "fan p 4 max ${p4_max}"
ssh $SSH_OPTIONS $USERNAME@$ILOIP "fan p 5 max ${p5_max}"
