#!/bin/bash
#
## change directory to the rrdtool script dir
cd /Users/kawate/kiRan/repos/checknet/
 
## Graph for last 24 hours 
/usr/local/bin/rrdtool graph latency_graph.png \
-w 785 -h 120 -a PNG \
-c CANVAS#231E1E \
-c FONT#C1F588 \
-c BACK#231E1E \
-c AXIS#C1F588 \
--slope-mode \
--start -86400 --end now \
--font DEFAULT:8: \
--title "ping google.com" \
--watermark "`date`" \
--vertical-label "latency(ms)" \
--right-axis-label "latency(ms)" \
--lower-limit 0 \
--right-axis 1:0 \
--x-grid MINUTE:10:HOUR:1:MINUTE:120:0:%R \
--alt-y-grid --rigid \
DEF:roundtrip=ping_db.rrd:rtt:MAX \
DEF:packetloss=ping_db.rrd:pl:MAX \
CDEF:PLNone=packetloss,0,0,LIMIT,UN,UNKN,INF,IF \
CDEF:PL10=packetloss,1,10,LIMIT,UN,UNKN,INF,IF \
CDEF:PL25=packetloss,10,25,LIMIT,UN,UNKN,INF,IF \
CDEF:PL50=packetloss,25,50,LIMIT,UN,UNKN,INF,IF \
CDEF:PL100=packetloss,50,100,LIMIT,UN,UNKN,INF,IF \
LINE1:roundtrip#99CC33:"latency(ms)" \
GPRINT:roundtrip:LAST:"Cur\: %5.2lf" \
GPRINT:roundtrip:AVERAGE:"Avg\: %5.2lf" \
GPRINT:roundtrip:MAX:"Max\: %5.2lf" \
GPRINT:roundtrip:MIN:"Min\: %5.2lf\t" \
COMMENT:"pkt loss\:" \
AREA:PLNone#231E1E:"0%":STACK \
AREA:PL10#FFC100:"1-10%":STACK \
AREA:PL25#FF7400:"10-25%":STACK \
AREA:PL50#FF4D00:"25-50%":STACK \
AREA:PL100#FF0000:"50-100%":STACK
 
## copy to the web directory
# cp latency_graph.png /var/www/htdocs/