#!/bin/bash

echo "Making directory"
sudo mkdir /usr/sbin/sshnotify

echo "Making file"
sudo touch sshnotifydiscord.sh

echo "Adding perms to file"
sudo chmod +x /usr/sbin/sshnotify
sudo chmod +x /usr/sbin/sshnotify/sshnotifydiscord.sh


echo '#!/bin/bash' >> /usr/sbin/sshnotify/sshnotifydiscord.sh
echo 'WEBHOOK_URL="http://botmanager.itkelvin.nl:5000/server-logins"' >> /usr/sbin/sshnotify/sshnotifydiscord.sh
echo 'case "$PAM_TYPE" in' >> /usr/sbin/sshnotify/sshnotifydiscord.sh

echo '    open_session)' >> /usr/sbin/sshnotify/sshnotifydiscord.sh
echo '        PAYLOAD=" {\"server_login_content\": \"$PAM_USER $PAM_RHOST $HOSTNAME\" }"' >> /usr/sbin/sshnotify/sshnotifydiscord.sh
echo '        ;;' >> /usr/sbin/sshnotify/sshnotifydiscord.sh
echo '    close_session)' >> /usr/sbin/sshnotify/sshnotifydiscord.sh
echo '        PAYLOAD=" {\"server_logout_content\": \"$PAM_USER $PAM_RHOST) $HOSTNAME\" }"' >> /usr/sbin/sshnotify/sshnotifydiscord.sh
echo '        ;;' >> /usr/sbin/sshnotify/sshnotifydiscord.sh
echo 'esac' >> /usr/sbin/sshnotify/sshnotifydiscord.sh
echo 'if [ -n "$PAYLOAD" ] ; then' >> /usr/sbin/sshnotify/sshnotifydiscord.sh
echo '    curl -X POST -H 'Content-Type: application/json' -d "$PAYLOAD" "$WEBHOOK_URL"' >> /usr/sbin/sshnotify/sshnotifydiscord.sh
echo 'fi' >> /usr/sbin/sshnotify/sshnotifydiscord.sh


echo "Adding to pam.d"
sudo echo "session optional pam_exec.so seteuid  /usr/sbin/sshnotify/sshnotifydiscord.sh" >> /etc/pam.d/sshd
