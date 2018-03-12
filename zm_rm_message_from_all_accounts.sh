#!/bin/bash
# Removes message from all Zimbra accounts
#
# zm_rm_message_from_all_accounts.sh user@domain.com "subject"
# or
# zm_rm_message_from_all_accounts.sh user@domain.com

LOG_POSTFIX=`strings /dev/urandom | tr -dc _A-Z-a-z-0-9 | head -c10`
LOG_FILE="/tmp/zm_rm_message_from_all_accounts.$LOG_POSTFIX.log"
COUNTER=0

if [ -z "$2" ]; then
addr=$1
for acct in `zmprov -l gaa | grep -E -v '(^admin@|^spam\..*@|^ham\..*@|^virus-quarantine.*@|^galsync.*@)'|sort` ; do
    echo "Searching $acct"
    for msg in `/opt/zimbra/bin/zmmailbox -z -m "$acct" s -l 999 -t message "from:$addr"|awk '{ if (NR!=1) {print}}' | grep -v -e Id -e "-" -e "^$" | awk '{ print $2 }'`
    do
        echo "Moving "$msg" from "$acct" to Trash" | tee >> $LOG_FILE
        let COUNTER+=1
        echo "Total found: $COUNTER"
        /opt/zimbra/bin/zmmailbox -z -m $acct mm $msg /Trash
    done
done
else
addr=$1
subject=$2
for acct in `zmprov -l gaa | grep -E -v '(^admin@|^spam\..*@|^ham\..*@|^virus-quarantine.*@|^galsync.*@)'|sort` ; do
    echo "Searching $acct  for Subject:  $subject"
    for msg in `/opt/zimbra/bin/zmmailbox -z -m "$acct" s -l 999 -t message "from:$addr subject:$subject"|awk '{ if (NR!=1) {print}}' | grep -v -e Id -e "-" -e "^$" | awk '{ print $2 }'`
    do
        echo "Moving "$msg" from "$acct" to Trash" | tee >> $LOG_FILE
        let COUNTER+=1
        echo "Total found: $COUNTER"
        /opt/zimbra/bin/zmmailbox -z -m $acct mm $msg /Trash
    done
done
fi
