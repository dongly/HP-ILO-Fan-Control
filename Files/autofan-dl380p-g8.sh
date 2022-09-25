
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

echo "==============="
echo "CPU 1 Temp $T1 C"
echo "==============="

if [[ $T1 > 67 ]]
   then
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 3 max 255'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 4 max 255'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 5 max 255'
elif [[ $T1 > 58 ]]
    then
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 3 max 100'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 4 max 100'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 5 max 80'

elif [[ $T1 > 54 ]]
    then
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 3 max 85'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 4 max 85'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 5 max 70'
elif [[ $T1 > 52 ]]
    then
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 3 max 65'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 4 max 65'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 5 max 55'
elif [[ $T1 > 50 ]]
    then
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 3 max 55'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 4 max 55'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 5 max 45'
else
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 3 max 40'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 4 max 40'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 5 max 30'
fi

echo "==============="
echo "CPU 2 Temp $T2 C"
echo "==============="

if [[ $T2 > 67 ]]
   then
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 0 max 255'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 1 max 255'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 2 max 255'

elif [[ $T2 > 58 ]]
    then
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 0 max 80'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 1 max 80'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 2 max 100'
elif [[ $T2 > 54 ]]
    then
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 0 max 70'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 1 max 70'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 2 max 85'
elif [[ $T2 > 52 ]]
    then
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 0 max 55'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 1 max 55'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 2 max 65'
elif [[ $T2 > 50 ]]
    then
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 0 max 45'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 1 max 45'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 2 max 55'
else
        echo Set Fan 0 ~ 2 speed max 30
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 0 max 30'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 1 max 30'
        sshpass -p $PASSWORD ssh $SSH_OPTIONS $USERNAME@$ILOIP 'fan p 2 max 40'
fi