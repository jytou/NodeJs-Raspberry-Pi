#!/bin/bash
# written by Richard Stanley (audstanley); edited by JY Toumit to install other versions than the latest
PICHIP=$(uname -m);
if [ "$EUID" -ne 0 ]
        then echo "You need to install as root by using sudo ./Install-Node.sh";
        exit
else
        if [ -z "$1" ] ;
        then
                NODEVER=latest-v9.x;
                LINKTONODE=$(curl -G https://nodejs.org/dist/latest-v9.x/ | awk '{print $2}' | grep -P 'href=\"node-v9\.\d{1,}\.\d{1,}-linux-'$PICHIP'\.tar\.gz' | sed 's/href="//' | sed 's/<\/a>//' | sed 's/">.*//');
        else
                NODEVER=v$1
                LINKTONODE=node-$NODEVER-linux-armv7l.tar.gz
        fi
        NODEFOLDER=$(echo $LINKTONODE | sed 's/.tar.gz/\//');

        # Next, Creates directory for downloads, and downloads node 8.x
        cd ~/ && mkdir tempNode && cd tempNode && wget https://nodejs.org/dist/$NODEVER/$LINKTONODE
        tar -xzf $LINKTONODE;

        # Remove the tar after extracting it.
        rm $LINKTONODE;
        # remove older version of node:
        rm -R -f /opt/nodejs/;
        # remove symlinks
        rm /usr/bin/node /usr/sbin/node /sbin/node /sbin/node /usr/local/bin/node /usr/bin/npm /usr/sbin/npm /sbin/npm /usr/local/bin/npm 2> /dev/null;
        # This next line will copy Node over to the appropriate folder.
        mv /root/tempNode/$NODEFOLDER /opt/nodejs/;
        # This line will remove the nodeJs tar we downloaded.
        rm -R -f /root/tempNode/$LINKTONODE/;

        # Create symlinks to node && npm
        sudo ln -s /opt/nodejs/bin/node /usr/bin/node; sudo ln -s /opt/nodejs/bin/node /usr/sbin/node;
        sudo ln -s /opt/nodejs/bin/node /sbin/node; sudo ln -s /opt/nodejs/bin/node /usr/local/bin/node;
        sudo ln -s /opt/nodejs/bin/npm /usr/bin/npm;
        sudo ln -s /opt/nodejs/bin/npm /usr/sbin/npm; sudo ln -s /opt/nodejs/bin/npm /sbin/npm;
        sudo ln -s /opt/nodejs/bin/npm /usr/local/bin/npm;
        rm -R -f /root/tempNode/;
fi
