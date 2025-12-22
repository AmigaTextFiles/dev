
/*
    Description: Experimental source on doing raw ICMP with raw IP. Ie
                 constructing the datagrams yourself, rather than letting the
                 stack do it.

                 This is basically how datagrams can be spoofed, as the src
                 address is filled in by the programmer and not the stack.
*/





MODULE  'socket',
        'amitcp/sys/socket',
        'amitcp/sys/types',
        'amitcp/sys/time',
        'amitcp/sys/param',
        'amitcp/sys/errno',
        'amitcp/netinet/in',
        'amitcp/netinet/ip_icmp',
        'amitcp/netinet/ip',
        'amitcp/netdb',
        'oomodules/softtimer_oo'

CONST SEQNUM=29, ICMPIDNUM=1066

OBJECT intfold
    arr[100]:ARRAY OF INT
ENDOBJECT

PROC main()
DEF icmphdr:PTR TO icmp,
    iphdr:PTR TO ip,
    sain:PTR TO sockaddr_in,
    hst:PTR TO hostent,
    sock,
    loop,
    hostname[200]:STRING

IF arg[]=0
    StrCopy(hostname, 'localhost')
ELSE
    StrCopy(hostname, arg)
ENDIF

IF (socketbase:=OpenLibrary('bsdsocket.library',NIL))<>NIL
    IF hst:=GetHostByName(hostname)
        IF (sock:=Socket(AF_INET, SOCK_RAW, IPPROTO_RAW))<>-1
            WriteF('opt \d\n',SetSockOpt(sock, IPPROTO_IP, IP_HDRINCL, 1, SIZEOF LONG))
            ->sain:=New(SIZEOF sockaddr)
            ->sain.family:=AF_INET
            ->CopyMem(Long(hst.addr_list), sain.addr, hst.length)


            FOR loop:=1 TO 5

                
                iphdr:=New((SIZEOF ip) + (SIZEOF icmp))
                icmphdr:=iphdr+ (SIZEOF ip)

                set_ip_hl(iphdr, 5)
                set_ip_v(iphdr, IPVERSION)
                iphdr.ttl:=0
                iphdr.len:=(SIZEOF ip) + (SIZEOF icmp)
                iphdr.id:=90
                iphdr.p:=IPPROTO_ICMP
                iphdr.src.addr:=Inet_Addr('192.168.10.1')
                iphdr.dst.addr:=Inet_Addr('192.168.10.5')

                iphdr.sum:=cksum(iphdr, SIZEOF ip)


                icmphdr.type:=ICMP_ECHO
                icmphdr.code:=0
                icmphdr.idseq.id:=ICMPIDNUM
                icmphdr.idseq.seq:=loop
                icmphdr.cksum:=cksum(icmphdr, SIZEOF icmp)


                ->SendTo(sock, icmphdr, SIZEOF icmp, NIL, sain, SIZEOF sockaddr_in)
                WriteF('sent \d\n',SendTo(sock, iphdr, (SIZEOF ip) + (SIZEOF icmp), NIL, sain, SIZEOF sockaddr_in))


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

->WriteF('Calculated Checksum = $\h (\d)\n',accumulator, accumulator)

ENDPROC accumulator

