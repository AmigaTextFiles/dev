
/*
    Description: Some experimental procedures for doing SYN scans.
                 These procedures were part of the main GP source, but
                 were removed as they were never completed.

                 NOTE: The only way to listen for replies in a SYN
                 scan is by sniffing. It cannot be done directly through
                 the socket API
*/




PROC synscan(portptr:PTR TO portentry) HANDLE
DEF errbuf[PCAP_ERRBUF_SIZE]:STRING,
    dev[5]:STRING,
    ret,
    netp:PTR TO LONG,
    maskp:PTR TO LONG,
    descr,
    hdr:PTR TO pcap_pkthdr

IF (miamibase:=OpenLibrary('miami.library', NIL)) = NIL THEN Raise(ERR_NOMIAMI)
IF (miamipcapbase:=OpenLibrary('miamipcap.library', NIL)) = NIL THEN Raise(ERR_NOPCAP)

        hdr:=New(2500)

        MiamiPCapInit(miamibase, socketbase)
        StrCopy(dev,MiamiPCapLookupdev(errbuf))

        IF dev=NIL
            outlist(errbuf)
        ELSE
            outlist(dev)
            ret:=MiamiPCapLookupnet(dev, {netp}, {maskp}, errbuf)
            IF ret = -1
                outlist(errbuf)
            ELSE
                ->addr.addr := netp
                outlist(Inet_NtoA(netp))
                outlist(Inet_NtoA(maskp))
                descr:=MiamiPCapOpenLive(dev, 1500, NIL, -1, errbuf)
                IF (descr = NIL)
                    outlist(errbuf)
                ELSE
                    WriteF('Max Snaplen = \d\n', MiamiPCapSnapshot(descr))
                    /*
                    IF (MiamiPCapNext(descr, hdr) = NIL)
                        outlist('No packet capture')
                    ELSE
                        outlist('YAY')
                    ENDIF
                    */
                ENDIF
            ENDIF
        ENDIF
EXCEPT DO
    IF (miamipcapbase) THEN CloseLibrary(miamipcapbase)
    IF (miamibase) THEN CloseLibrary(miamibase)
SELECT exception
    CASE ERR_NOERROR
        -> Normal exception on exit
    CASE ERR_NOMIAMI
        outlist('THIS FUNCTION REQUIRES A HIGHLY ADVANCED TCP/IP STACK')
        outlist('For example, Miami or MiamiDX')
        outlist('miami.library V6+ cannot be found and/or opened')
    CASE ERR_NOPCAP
        outlist('THIS FUNCTION REQUIRES A HIGHLY ADVANCED TCP/IP STACK')
        outlist('Only Miami and Miami DX \ebREGISTERED\en are advanced enough')
        outlist('miamipcap.library cannot be found and/or opened')
    DEFAULT
        WriteF('Internal Exception in synscan() Code:(\d). Please report problem to author\n',exception)
ENDSELECT

ENDPROC

->Version 2

PROC synscan(portptr:PTR TO portentry) HANDLE
DEF port=0,
    tcphead:PTR TO tcphdr,
    iphdr:PTR TO ip,
    riphdr:PTR TO ip,
    rtcphead:PTR TO tcphdr,
    pseudohdr:PTR TO pseudo,
    sain:PTR TO sockaddr_in,
    hst:PTR TO hostent,
    sock,
    hostname[64]:STRING,
    on:PTR TO CHAR


StrCopy(hostname, site)

IF (miamibase:=OpenLibrary('miami.library', NIL)) = NIL THEN Raise(ERR_NOMIAMI)
IF (miamipcapbase:=OpenLibrary('miamipcap.library', NIL)) = NIL THEN Raise(ERR_NOPCAP)

        MiamiPCapInit(miamibase, socketbase)
        WriteF('\s\n',MiamiPCapLookupdev(hostname))

        IF hst:=Gethostbyname(hostname)
            IF (sock:=Socket(AF_INET, SOCK_RAW, IPPROTO_RAW))<>-1
                on:=1
                Setsockopt(sock, IPPROTO_IP, IP_HDRINCL, {on}, 4 )
                sain:=New(SIZEOF sockaddr)
                sain.family:=AF_INET
                CopyMem(Long(hst.addr_list), sain.addr, hst.length)
                ->Bind( sock, sain, SIZEOF sockaddr_in)

                WHILE (portptr <> NIL)
                    FOR port:=portptr.lower TO portptr.upper

                        iphdr:=New((SIZEOF ip) + (SIZEOF tcphdr))
                        tcphead:=iphdr + (SIZEOF ip)
                        pseudohdr:=New(SIZEOF pseudo)

                        set_ip_hl(iphdr, 5)
                        set_ip_v(iphdr, IPVERSION)
                        iphdr.ttl:=128
                        iphdr.len:=(SIZEOF ip) ->+ (SIZEOF tcphdr)
                        iphdr.id:=90
                        iphdr.p:=IPPROTO_TCP
                        iphdr.src.addr:=Inet_addr('191.168.10.1')
                        iphdr.dst.addr:=Inet_addr('192.168.10.2')
                        iphdr.sum:=cksum(iphdr, SIZEOF ip)

                        pseudohdr.src.addr:=Inet_addr('191.168.10.1')
                        pseudohdr.dst.addr:=Inet_addr('192.168.10.2')
                        pseudohdr.place:=0
                        pseudohdr.protocol:=IPPROTO_TCP
                        pseudohdr.len:=(SIZEOF ip)

                        tcphead.sport:=1024
                        tcphead.dport:=port
                        tcphead.seq:=TCPSEQNUM
                        tcphead.ack:=0
                        set_tcphdr_off(tcphead, TH_OFFSET)
                        set_tcphdr_x2(tcphead, 0)
                        tcphead.win:=TCP_WINDOW_SIZE
                        tcphead.flags:=%00000010
                        tcphead.urp:=0
                        tcphead.sum:=tcpcksum(tcphead, (SIZEOF tcphdr), pseudohdr, (SIZEOF pseudo))

                        Sendto(sock, iphdr, (SIZEOF ip) + (SIZEOF tcphdr) , NIL, sain, SIZEOF sockaddr_in)

                        riphdr:=New((SIZEOF ip) + (SIZEOF tcphdr) + 1500)
                        ->Recv(sock, riphdr, (SIZEOF ip) + (SIZEOF tcphdr) + 1500 , NIL)
                        ->rtcphead:=riphdr + riphdr.len

                    ENDFOR
                    portptr:=portptr.next
                ENDWHILE
            ELSE
                WriteF('Problem with creating the socket')
            ENDIF
        ELSE
            WriteF('Problem with host lookup\n')
        ENDIF

        CloseSocket(sock)

EXCEPT DO
    IF miamipcapbase THEN CloseLibrary(miamipcapbase)
    IF miamibase THEN CloseLibrary(miamibase)
SELECT exception
    CASE ERR_NOERROR
        -> Normal exception on exit
    CASE ERR_NOMIAMI
        outlist('THIS FUNCTION REQUIRES A HIGHLY ADVANCED TCP/IP STACK')
        outlist('For example, Miami or MiamiDX')
        outlist('miami.library V6+ cannot be found and/or opened')
    CASE ERR_NOPCAP
        outlist('THIS FUNCTION REQUIRES A HIGHLY ADVANCED TCP/IP STACK')
        outlist('Only Miami and Miami DX \ebREGISTERED\en are advanced enough')
        outlist('miamipcap.library cannot be found and/or opened')
    DEFAULT
        WriteF('Internal Exception in synscan() Code:(\d). Please report problem to author\n',exception)
ENDSELECT

ENDPROC

->

#ifdef TCPCKSUM
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

    ->Im not sure why, but with certain sequence numbers the checksum
    ->is always out by a fixed amount
    ->accumulator:=accumulator-2

    ->WriteF('len 1 \d           len 2 \d\n', hdrsize1, hdrsize2)
    ->WriteF('TCP Checksum = $\h (\d)\n',accumulator, accumulator)

ENDPROC accumulator
#endif
