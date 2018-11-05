--01 exp a table
	--current_session host
	select node_name from current_session;
	--exp a table
	SELECT EXPORT_TABLES('/tmp/tmp.sql ','store.store_orders_fact');
	--exp all table accessed to the users
	SELECT EXPORT_TABLES('/tmp/tmp.sql ','');

--02.exp objects of a schema
	--current_session host
	select node_name from current_session;
	--export tables 
	select export_objects('/tmp/bdw_adl.sql','bdw_adl');

--03.exp file convert ascii to UTF-8
	--iconv get the charector set
	iconv -l | grep ASCII
	ASCII//
	CSASCII//
	US-ASCII//
	iconv -l | grep UTF-8
	ISO-10646/UTF-8/
	UTF-8//
	--covert 
	conv -f iso-8859-1 -t UTF-8 < bdw_adl.sql  > utf8_bdw_adl.sql