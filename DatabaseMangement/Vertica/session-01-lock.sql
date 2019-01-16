SELECT s.user_name,
       s.session_id,
       s.transaction_description,
       s.current_statement,
       l.object_name,
       l.lock_mode
FROM sessions s,
     loc ks l
WHERE s.transaction_id=l.transaction_id;

