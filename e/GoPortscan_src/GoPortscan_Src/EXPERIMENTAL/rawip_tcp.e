
/*
    Description: Experimental source on doing raw tcp over raw ip. Ie basically
                 constructing the datagrams yourself rather than letting the
                 stack do it.

                 This is basically how datagrams can be spoofed.
*/


MODULE  'socket_pragmas',
        'amitcp/sys/socket',
        'amitcp/sys/types',
        'amitcp/sys/time',
        'amitcp/sys/param',
        'amitcp/sys/errno',
        'amitcp/netinet/in',
        'amitcp/netinet/tcp',
        'amitcp/netinet/ip',
        'amitcp/netdb'

CONST SEQNUM=19901000, TH_OFFSET=5, TCP_WINDOW_SIZE=512

OBJECT intfold
    arr[100]:ARRAY OF INT
ENDOBJECT

OBJECT pseudo
src:in_addr
dst:in_addr
place:CHAR
protocol:CHAR
len:INT
ENDOBJECT

PROC main()
DEF tcphead:PTR TO tcphdr,
    iphdr:PTR TO ip,
    pseudohdr:PTR TO pseudo,
    sain:PTR TO sockaddr_in,
    hst:PTR TO hostent,
    sock,
    loop,
    hostname[200]:STRING,
    on:PTR TO CHAR


IF arg[]=0
    StrCopy(hostname, 'localhost')
ELSE
    StrCopy(hostname, arg)
ENDIF



IF (socketbase:=OpenLibrary('bsdsocket.library',NIL))<>NIL
    IF hst:=Gethostbyname(hostname)
        IF (sock:=Socket(AF_INET, SOCK_RAW, IPPROTO_RAW))<>-1
            on:=1
            Setsockopt(sock, IPPROTO_IP, IP_HDRINCL, {on}, 4 )
            sain:=New(SIZEOF sockaddr)
            sain.family:=AF_INET
            CopyMem(Long(hst.addr_list), sain.addr, hst.length)

            FOR loop:=1 TO 1

                iphdr:=New((SIZEOF ip) + (SIZEOF tcphdr))
                tcphead:=iphdr + (SIZEOF ip)
                pseudohdr:=New(SIZEOF pseudo)

                set_ip_hl(iphdr, 5)
                set_ip_v(iphdr, IPVERSION)
                iphdr.ttl:=128
                iphdr.len:=(SIZEOF ip) + (SIZEOF tcphdr)
                iphdr.id:=90
                iphdr.p:=IPPROTO_TCP
                iphdr.src.addr:=Inet_addr('192.168.10.6')
                iphdr.dst.addr:=Inet_addr('192.168.10.6')
                iphdr.sum:=cksum(iphdr, SIZEOF ip)
                
                pseudohdr.src.addr:=Inet_addr('192.168.10.6')
                pseudohdr.dst.addr:=Inet_addr('192.168.10.6')
                pseudohdr.place:=0
                pseudohdr.protocol:=IPPROTO_TCP
                pseudohdr.len:=(SIZEOF ip)

                tcphead.sport:=139
                tcphead.dport:=139
                tcphead.seq:=SEQNUM
                tcphead.ack:=0
                set_tcphdr_off(tcphead, TH_OFFSET)
                set_tcphdr_x2(tcphead, 0)
                tcphead.win:=TCP_WINDOW_SIZE
                tcphead.flags:=%00000010
                tcphead.urp:=0
                tcphead.sum:=tcpcksum(tcphead, (SIZEOF tcphdr), pseudohdr, (SIZEOF pseudo))

                Sendto(sock, iphdr, (SIZEOF ip) + (SIZEOF tcphdr) , NIL, sain, SIZEOF sockaddr_in)
                ->Delay(1)
            ENDFOR

        ELSE
            WriteF('Problem with creating the socket')
        ENDIF
    ELSE
        WriteF('Problem with host lookup\n')
    ENDIF

    CloseSocket(sock)
    CloseLibrary(socketbase)
ELSE
    WriteF('Unable to open bsdsocket.library\n')
ENDIF


ENDPROC

PROC cksum(hdr:PTR TO intfold, hdrsize:LONG)
DEF accumulator=0:LONG,
    loop

->WriteF('Using Headersize $\h (\d)\n',hdrsize, hdrsize)

FOR loop:=0 TO ((hdrsize-1)/2)
    accumulator:=accumulator+hdr.arr[loop]
ENDFOR

accumulator:=(Shr(accumulator, 16)) + (Eor(accumulator, $FFFF))
accumulator:=accumulator + (Shr(accumulator, 16))

->WriteF('IP Checksum = $\h (\d)\n',accumulator, accumulator)

ENDPROC accumulator



PROC tcpcksum(hdr1:PTR TO intfold, hdrsize1:LONG, hdr2:PTR TO intfold, hdrsize2:LONG)
DEF accumulator=0:LONG,
    loop

FOR loop:=0 TO ((hdrsize1-1)/2)
    accumulator:=accumulator+hdr1.arr[loop]
ENDFOR

FOR loop:=0 TO ((hdrsize2-1)/2)
    accumulator:=accumulator+hdr2.arr[loop]
ENDFOR

accumulator:=(Shr(accumulator, 16)) + (Eor(accumulator, $FFFF))
accumulator:=accumulator + (Shr(accumulator, 16))

->Im not entirely sure why this is needed, but it always seems to be 2 out.
->accumulator:=accumulator-2

->WriteF('len 1 \d           len 2 \d\n', hdrsize1, hdrsize2)
->WriteF('TCP Checksum = $\h (\d)\n',accumulator, accumulator)

ENDPROC accumulator

