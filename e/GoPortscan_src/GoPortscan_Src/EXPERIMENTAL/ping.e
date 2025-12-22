/*
    Description: Experimental source on performing ICMP pings. This source is
                 actually quite functional and could easily be adapted into a
                 fully functional ping command.

                 By default pings localhost 30 times.
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
    ricmp:PTR TO icmp,
    sain:PTR TO sockaddr_in,
    hst:PTR TO hostent,
    rcvbuffer,
    sock,
    recvlen,
    readfds:fd_set,
    tv:compatible_timeval,
    loop,
    hostname[200]:STRING,
    mytimer:PTR TO softtimer

IF arg[]=0
    StrCopy(hostname, 'localhost')
ELSE
    StrCopy(hostname, arg)
ENDIF

IF (socketbase:=OpenLibrary('bsdsocket.library',NIL))<>NIL
    IF hst:=GetHostByName(hostname)
        IF (sock:=Socket(AF_INET, SOCK_RAW, IPPROTO_ICMP))<>-1
            sain:=New(SIZEOF sockaddr)
            sain.family:=AF_INET
            CopyMem(Long(hst.addr_list), sain.addr, hst.length)

            NEW mytimer.softtimer()

            FOR loop:=1 TO 30

                icmphdr:=New(SIZEOF icmp)
                iphdr:=New(SIZEOF ip)

                ->WriteF('SENDING ICMP PACKET\n-------------------\n\n')

                icmphdr.type:=ICMP_ECHO
                icmphdr.code:=0 ->3
                icmphdr.idseq.id:=ICMPIDNUM
                icmphdr.idseq.seq:=loop
                icmphdr.cksum:=cksum(icmphdr, SIZEOF icmp)

                /*
                WriteF('ICMP TYPE     =  $\h (\d)\n', icmphdr.type, icmphdr.type)
                WriteF('ICMP CODE     =  $\h (\d)\n', icmphdr.code, icmphdr.code)
                WriteF('ICMP IDNUM    =  $\h (\d)\n', icmphdr.idseq.id, icmphdr.idseq.id)
                WriteF('ICMP SEQNUM   =  $\h (\d)\n', icmphdr.idseq.seq, icmphdr.idseq.seq)
                WriteF('ICMP CHECKSUM =  $\h (\d)\n', icmphdr.cksum, icmphdr.cksum)
                */

                ->WriteF('PING!\n')

                SendTo(sock, icmphdr, SIZEOF icmp, NIL, sain, SIZEOF sockaddr_in)

            ->ENDFOR


            ->FOR loop:=1 TO 30

                fd_zero(readfds)
                fd_set(sock, readfds)
                tv.sec:=0
                tv.usec:=1

                WHILE WaitSelect(sock+1, readfds, NIL, NIL, tv, NIL)>0

                    rcvbuffer:=New((SIZEOF ip) + (SIZEOF icmp))
                    recvlen:=RecvFrom(sock, rcvbuffer, (SIZEOF ip) + (SIZEOF icmp), NIL, NIL, NIL)
                    ->WriteF('\n\nRECEIVED IP PACKET\n------------------\n\n')
                    iphdr:=rcvbuffer
                    ricmp:=rcvbuffer + (SIZEOF ip)

                    /*
                    WriteF('IP VERSION (V4 is $45) = $\h (\d)\n', iphdr.v_hl, iphdr.v_hl)
                    WriteF('IP SOURCE ADDRESS      = $\h (\s)\n', iphdr.src, Inet_NtoA(iphdr.src.addr))
                    WriteF('IP DESTINATION ADDRESS = $\h (\s)\n', iphdr.dst, Inet_NtoA(iphdr.dst.addr))
                    WriteF('IP TOS                 = $\h (\d)\n', iphdr.tos, iphdr.tos)
                    WriteF('IP LENGTH (DATA PART)  = $\h (\d)\n', iphdr.len, iphdr.len)
                    WriteF('IP IDNUM               = $\h (\d)\n', iphdr.id, iphdr.id)
                    WriteF('IP FRAGMENT OFFSET     = $\h (\d)\n', iphdr.off, iphdr.off)
                    WriteF('IP TIME TO LIVE        = $\h (\d)\n', iphdr.ttl, iphdr.ttl)
                    WriteF('IP PROTOCOL (1=ICMP)   = $\h (\d)\n', iphdr.p, iphdr.p)
                    WriteF('IP CHECKSUM            = $\h (\d)\n', iphdr.sum, iphdr.sum)
                    WriteF('  |\n')
                    WriteF('  ->\n')
                    WriteF('    ICMP TYPE     =  $\h (\d)\n', ricmp.type, ricmp.type)
                    WriteF('    ICMP CODE     =  $\h (\d)\n', ricmp.code, ricmp.code)
                    WriteF('    ICMP IDNUM    =  $\h (\d)\n', ricmp.idseq.id, ricmp.idseq.id)
                    WriteF('    ICMP SEQNUM   =  $\h (\d)\n', ricmp.idseq.seq, ricmp.idseq.seq)
                    WriteF('    ICMP CHECKSUM =  $\h (\d)\n', ricmp.cksum, ricmp.cksum)
                    */

                    WriteF('\d Bytes From \s: Sequence=\d: TTL=\d\n',recvlen, Inet_NtoA(iphdr.src.addr), ricmp.idseq.seq, iphdr.ttl)
                ->ELSE
                ->    WriteF('TIMED OUT\n')
                ->ENDIF

                ENDWHILE

                Delay(5)

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

