#! /bin/bash
echo "[Info] Installing necessary packages..."
if [[ `which yum` ]]; then
    yum install rrdtool gawk
elif [[ `which apt-get` ]]; then
   apt-get install rrdtool gawk
elif [[ `which brew` ]]; then
   brew install rrdtool gawk
else
   echo "Unknown OS"
fi
sleep 3
echo "[Info] Initializing database..."
/bin/sh initialize_db.sh
sleep 3
echo "[Info] Setting up cron..."
crontab -l > mycron
echo "* * * * * /bin/sh ~/checknet/update_rrd" >> mycron
echo "* * * * * /bin/sh ~/checknet/create_graph.sh" >> mycron
crontab mycron
rm mycron
