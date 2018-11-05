#!/bin/bash
cd ~/DBA

echo -e "Current `date +%Y'-'%m'-'%d' '%T` lock information of datatabase:\n"|tee -a log/kill_session.log
vsql -c "select s.user_name,s.session_id,s.transaction_description,s.current_statement,l.object_name,l.lock_mode from sessions s,locks l where s.transaction_id=l.transaction_id"|tee -a log/kill_session.log
echo "Do you want kill lock session?[Y|N]"|tee -a log/kill_session.log
read KILLY
echo -e "KILLY:$KILLY \n">> log/kill_session.log
if [ $KILLY == 'Y' ] ||[ $KILLY == 'y' ] ; then
	vsql -c "select s.session_id from sessions s,locks l where s.transaction_id=l.transaction_id"|grep bjxhm>sidlist 
	for SID in $(cat sidlist)
	do
	vsql -c "select close_session('$SID')";
	done
else
	echo "Please double confirm if you can kill locked session!"
fi
