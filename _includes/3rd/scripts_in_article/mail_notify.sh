#!/bin/sh

# Auteur:      Antoine Martin, stagiaire CDEI
# Date:        15 juin 2000
# usage:       cat <fichier_mail> | mail_notify.sh
# Description: envoie un accuse de reception a l'aide de mutt a partir d'un mail
#              contenant une demande d'accuse de reception
# Remarques:   normallement le BCC est inutile...

FILE=/tmp/mutt_notify.$$.$USER
#FILE2=/tmp/mutt_noti
formail | grep -v '^$' | grep -v ">From " > $FILE
#REFCAT=`cat $FILE| formail -R References: |formail -x References:`
#REFCAT2=`cat $FILE| formail -R Message-ID: |formail -x Message-ID:`
#REFNAME=${REFCAT}${REFCAT2}
NOTIFY_TO=`cat $FILE | formail -R Return-Receipt-To: Disposition-Notification-To: |formail -R X-Confirm-Reading-To: Disposition-Notification-To: | formail -x Disposition-Notification-To:`
if [ -n "$NOTIFY_TO" ] ; then
	   echo "正在向 $NOTIFY_TO 发送已读回执"
	    MESSAGE=/tmp/mutt_notify_message.$$.$USER
	    REALNAME=`finger $USER | head -1 | awk -F: '{printf "%s",$3}'`
	    TO=`formail -x To: < $FILE`
	    CC=`formail -x Cc: < $FILE`
	    BCC=`formail -x Bcc: < $FILE`
	    SUBJECT=`formail -x Subject: < $FILE`
	    REFERENCES=`formail -x References: < $FILE`
	  #REFCAT=$REFERENCES
	    MSGID=`formail -x Message-ID: < $FILE`
	    DATE_SENDER=`formail -x Date: < $FILE`
	    DATE_LOCALE=`date`
	    REFERENCES=${REFERENCES}$MSGID
	    echo "你于$DATE_SENDER">$MESSAGE
	    echo "发送到（To） :$TO" >> $MESSAGE
	    if [ -n "$CC" ] ; then
            echo "并抄送到（CC） to :$CC 的邮件" >> $MESSAGE
	    fi
	      if [ -n "$BCC" ] ; then
                 echo "Bcc to :$BCC" >> $MESSAGE
              fi
	    #REFNAME=`mutt "my_hdr References:$REFERENCES"`
           # echo "已经在 $DATE_LOCALE 被 $USER 打开和阅读。" >> $MESSAGE
            echo "已经在 $DATE_LOCALE 被打开和阅读。" >> $MESSAGE
            cat $MESSAGE | mutt -e "unmy_hdr Disposition-Notification-To:; my_hdr References:$REFERENCES" -s "已读:$SUBJECT" "$NOTIFY_TO"
            rm -f $MESSAGE
    	   else
               echo "No notification needed"
           fi
   	   sleep 1
	   rm -f $FILE


