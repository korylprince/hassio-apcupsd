#!/bin/bash
set -e

CONFIG_PATH=/data/options.json
UPS_CONFIG_PATH=/etc/apcupsd/apcupsd.conf

VALID_SCRIPTS=(annoyme changeme commfailure commok doreboot doshutdown emergency failing loadlimit powerout onbattery offbattery mainsback remotedown runlimit timeout startselftest endselftest battdetach battattach)

NAME=$(jq --raw-output ".name" $CONFIG_PATH)
CABLE=$(jq --raw-output ".cable" $CONFIG_PATH)
TYPE=$(jq --raw-output ".type" $CONFIG_PATH)
DEVICE=$(jq --raw-output ".device" $CONFIG_PATH)

if [[ ! -z "$NAME" ]]; then
    sed -i "s/^#\?UPSNAME\( .*\)\?\$/UPSNAME $NAME/g" $UPS_CONFIG_PATH
fi

if [[ ! -z "$CABLE" ]]; then
    sed -i "s/^#\?UPSCABLE\( .*\)\?\$/UPSCABLE $CABLE/g" $UPS_CONFIG_PATH
fi

if [[ ! -z "$TYPE" ]]; then
    sed -i "s/^#\?UPSTYPE\( .*\)\?\$/UPSTYPE $TYPE/g" $UPS_CONFIG_PATH
fi

if [[ ! -z "$DEVICE" ]]; then
    sed -i "s/^#\?UPSNAME\( .*\)\?\$/UPSDEVICE $DEVICE/g" $UPS_CONFIG_PATH
else
    sed -i "s/^#\?DEVICE\( .*\)\?\$//g" $UPS_CONFIG_PATH
fi

keys=`jq --raw-output ".extra[].key" $CONFIG_PATH`
IFS=$'\n'
keys=($keys)

for key in "${keys[@]}"; do
    val=`jq --raw-output ".extra[] | select(.key == \"$key\").val" $CONFIG_PATH`

    if [ ! -z "$val" ]; then
        if grep -xq "#\?$key\( .*\)\?" $UPS_CONFIG_PATH; then
            #replace in config
            sed -i "s/^#\?$key\( .*\)\?\$/$key $val/g" $UPS_CONFIG_PATH
        else
            #add to bottom
            echo "$key $val" >> $UPS_CONFIG_PATH
        fi
    else
        #remove from config
        sed -i "s/^#\?$key\( .*\)\?\$//g" $UPS_CONFIG_PATH
    fi
done

for script in "${VALID_SCRIPTS[@]}"; do
    if [ -f "/share/apcupsd/scripts/$script" ]; then
        cp "/share/apcupsd/scripts/$script" "/etc/apcupsd/$script"
        chmod a+x "/etc/apcupsd/$script"
        echo "copied custom $script script"
    fi
done

syslogd -n -O - &

exec /sbin/apcupsd -b
