#!/bin/bash

#please set the following vars:

UOPATH=
#example: OU=Unix,OU=Computers,DC=Contoso,DC=com

FQDN=
#example: ad.contoso.com

ADUSER=
#example: bill

DNPATH=
#example: OU=Unix,OU=Groups,DC=Contoso,DC=com


########
#Do not edit

SERVER=$(HOSTNAME)

if [[ -z $UOPATH || -z $FQDN || -z $ADUSER || -z $DNPATH ]]; then
      echo 'ERROR: Please define variables'
        exit 1
fi

if grep -q '#PBIS Groups' /etc/sudoers
then
    echo 'This host host is already joined. Exiting.'
    exit 0
else
    cat <<EOF >> /etc/sudoers
#PBIS Groups
%srv_${HOSTNAME}_sudo ALL=(ALL) ALL
%ux_unix_admin ALL=(ALL) ALL
EOF
fi

/opt/pbis/bin/domainjoin-cli --notimesync --ou $UOPPATH join $FQDN $ADUSER
echo "Domain joined"

/opt/pbis/bin/adtool -a new-group --dn $DNPATH --pre-win-2000-name=SRV_${HOSTNAME}_AUTH --name=SRV_${HOSTNAME}_AUTH
/opt/pbis/bin/adtool -a new-group --dn $DNPATH --pre-win-2000-name=SRV_${HOSTNAME}_SUDO --name=SRV_${HOSTNAME}_SUDO
echo "AD Group added"

/opt/pbis/bin/config AssumeDefaultDomain true
/opt/pbis/bin/config UserNotAllowedError "You are not authorized to log on to this system. Contact your system administrator for more information."
/opt/pbis/bin/config RequireMembershipOf "${DOMAIN}\\srv_${HOSTNAME}_auth" "${DOMAIN}\\ux_unix_admin"
/opt/pbis/bin/config UserDomainPrefix "$DOMAIN"
/opt/pbis/bin/config LoginShellTemplate "/bin/bash"
/opt/pbis/bin/config HomeDirPrefix "/home"
echo "PBIS Configuered. Please reboot"
#######
