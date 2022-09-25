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
# PASSWORD="your password"
# USERNAME="your username"
# ILOIP="your ilo ip"

source /etc/autofan.conf

SSH_OPTIONS="-oKexAlgorithms=+diffie-hellman-group1-sha1 -oHostkeyAlgorithms=+ssh-rsa"

T1="$(sensors -Aj coretemp-isa-0000 | jq '.[][] | to_entries[] | select(.key | endswith("input")) | .value' | sort -rn | head -n1)"
T2="$(sensors -Aj coretemp-isa-0001 | jq '.[][] | to_entries[] | select(.key | endswith("input")) | .value' | sort -rn | head -n1)"

echo "CPU 1/2 Temp $T1°C / $T1°C"

if [[ $T1 > 67 ]]; then
    p3_max=100
    p4_max=100
    p5_max=100
elif [[ $T1 > 58 ]]; then
    p3_max=60
    p4_max=60
    p5_max=50

elif [[ $T1 > 54 ]]; then
    p3_max=55
    p4_max=55
    p5_max=45
elif [[ $T1 > 52 ]]; then
    p3_max=45
    p4_max=45
    p5_max=35
elif [[ $T1 > 50 ]]; then
    p3_max=40
    p4_max=40
    p5_max=32
else
    p3_max=25
    p4_max=25
    p5_max=20
fi

if [[ $T2 > 67 ]]; then
    p0_max=100
    p1_max=100
    p2_max=100
elif [[ $T2 > 58 ]]; then
    p0_max=50
    p1_max=50
    p2_max=60
elif [[ $T2 > 54 ]]; then
    p0_max=55
    p1_max=45
    p2_max=45
elif [[ $T2 > 52 ]]; then
    p0_max=40
    p1_max=40
    p2_max=45
elif [[ $T2 > 50 ]]; then
    p0_max=32
    p1_max=32
    p2_max=40
else
    p0_max=20
    p1_max=20
    p2_max=25
fi

fan0_max=$((${p0_max} * 255 / 100))
fan1_max=$((${p1_max} * 255 / 100))
fan2_max=$((${p2_max} * 255 / 100))
fan3_max=$((${p3_max} * 255 / 100))
fan4_max=$((${p4_max} * 255 / 100))
fan5_max=$((${p5_max} * 255 / 100))
echo Set Fan Max:
echo "Fan1: $p0_max%($fan0_max)"
echo "Fan2: $p1_max%($fan1_max)"
echo "Fan3: $p2_max%($fan2_max)"
echo "Fan4: $p3_max%($fan3_max)"
echo "Fan5: $p4_max%($fan4_max)"
echo "Fan6: $p5_max%($fan5_max)"

ssh $SSH_OPTIONS $USERNAME@$ILOIP "fan p 0 max ${fan0_max}"
ssh $SSH_OPTIONS $USERNAME@$ILOIP "fan p 1 max ${fan1_max}"
ssh $SSH_OPTIONS $USERNAME@$ILOIP "fan p 2 max ${fan2_max}"
ssh $SSH_OPTIONS $USERNAME@$ILOIP "fan p 3 max ${fan3_max}"
ssh $SSH_OPTIONS $USERNAME@$ILOIP "fan p 4 max ${fan4_max}"
ssh $SSH_OPTIONS $USERNAME@$ILOIP "fan p 5 max ${fan5_max}"
