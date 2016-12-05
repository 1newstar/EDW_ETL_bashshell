#! /bin/bash
su - oracle <<!
rman target /<<EOF
backup AS COMPRESSED BACKUPSET  database
include current controlfile format'/orabak/db_%d_%T_%s'
plus archivelog format'/orabak/arch_%d_%T_%s' delete allinput;
delete noprompt obsolete;
exit;
EOF