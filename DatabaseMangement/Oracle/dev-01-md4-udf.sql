-- select * from user_source where name='MD5_MIBAO'

FUNCTION MD5_MIBAO(idno IN VARCHAR2) RETURN VARCHAR2
IS
retval varchar2(32);
BEGIN
retval := utl_raw.cast_to_raw(DBMS_OBFUSCATION_TOOLKIT.MD5(INPUT_STRING =>idno)) ;
retval := utl_raw.cast_to_raw(DBMS_OBFUSCATION_TOOLKIT.MD5(INPUT_STRING => retval)) ;
RETURN retval;
END;