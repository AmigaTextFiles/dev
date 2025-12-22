
OPT MODULE
OPT EXPORT

OBJECT rtg_buff
   sock[1024]:ARRAY OF CHAR
   num[12]:ARRAY
   in_size:LONG
   out_size:LONG
ENDOBJECT

OBJECT in_addr
   s_addr:LONG
ENDOBJECT

OBJECT sockaddr_in
   sin_len:INT
   sin_family:INT
   sin_port:INT
   sin_addr:PTR TO in_addr
   sin_zero[8]:ARRAY
ENDOBJECT

OBJECT ip_opts
   ip_dst:PTR TO in_addr
   ip_opts[40]:ARRAY
ENDOBJECT

OBJECT rtg_socket
    s:LONG
    num:LONG
    list:PTR TO rtg_socket
    peer:PTR TO sockaddr_in
    mode:INT
    server:INT
ENDOBJECT

