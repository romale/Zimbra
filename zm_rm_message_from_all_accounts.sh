#!/bin/bash
# Removes message from all Zimbra accounts
#
# zm_rm_message.sh user@domain.com subject
# or
# zm_rm_message.sh user@domain.com

if [ -z "$2" ]; then
addr=$1
for acct in `zmprov -l gaa | grep -E -v '(^admin@|^spam\..*@|^ham\..*@|^virus-quarantine.*@|^galsync.*@)'|sort` ; do
    echo "Searching $acct"
    for msg in `/opt/zimbra/bin/zmmailbox -z -m "$acct" s -l 999 -t message "from:$addr"|awk '{ if (NR!=1) {print}}' | grep -v -e Id -e "-" -e "^$" | awk '{ print $2 }'`
    do
	#echo "Removing "$msg" from "$acct""
	#/opt/zimbra/bin/zmmailbox -z -m $acct dm $msg
	echo "Moving "$msg" from "$acct" to Trash"
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
      #echo "Removing "$msg" from "$acct""
      #/opt/zimbra/bin/zmmailbox -z -m $acct dm $msg
      echo "Moving "$msg" from "$acct" to Trash"
      /opt/zimbra/bin/zmmailbox -z -m $acct mm $msg /Trash
    done
done
fi

