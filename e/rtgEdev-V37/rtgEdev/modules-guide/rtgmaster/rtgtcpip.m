ShowModule v1.10 (c) 1992 $#%!
now showing: "rtgtcpip.m"
NOTE: don't use this output in your code, use the module instead.

(----) OBJECT rtg_socket
(   0)   s:LONG
(   4)   num:LONG
(   8)   list:PTR TO rtg_socket
(  12)   peer:PTR TO sockaddr_in
(  16)   mode:INT
(  18)   server:INT
(----) ENDOBJECT     /* SIZEOF=20 */

(----) OBJECT ip_opts
(   0)   ip_dst:PTR TO in_addr
(   4)   ip_opts[40]:ARRAY OF CHAR
(----) ENDOBJECT     /* SIZEOF=44 */

(----) OBJECT sockaddr_in
(   0)   sin_len:INT
(   2)   sin_family:INT
(   4)   sin_port:INT
(   6)   sin_addr:PTR TO in_addr
(  10)   sin_zero[8]:ARRAY OF CHAR
(----) ENDOBJECT     /* SIZEOF=18 */

(----) OBJECT in_addr
(   0)   s_addr:LONG
(----) ENDOBJECT     /* SIZEOF=4 */

(----) OBJECT rtg_buff
(   0)   sock[1024]:ARRAY OF CHAR
(1024)   num[12]:ARRAY OF CHAR
(1036)   in_size:LONG
(1040)   out_size:LONG
(----) ENDOBJECT     /* SIZEOF=1044 */

