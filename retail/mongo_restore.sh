#drop the zoomdata mongodbs
mongo <<EOF
use zoom
db.runCommand( { dropDatabase: 1 } )
use zoom-scheduler
db.runCommand( { dropDatabase: 1 } )
exit
EOF

mongorestore /dump
