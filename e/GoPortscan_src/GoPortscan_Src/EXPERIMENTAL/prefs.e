OPT MODULE

/*
    Description: Functions for dealing with preferences
*/


MODULE 'dos/dos'

DEF fh,
    ports,
    log,
    telnet,
    time,
    read,
    verbose,
    wakeup,
    trojan,
    ftp,
    web,
    other,
    ping,
    ser

EXPORT PROC loadprefs()
ports:=String(200)
log:=String(150)
telnet:=String(150)
time:=String(5)
read:=String(5)
verbose:=String(5)
wakeup:=String(5)
trojan:=String(5)
ftp:=String(150)
web:=String(150)
other:=String(150)
ping:=String(5)
ser:=String(5)

->Spaces at the end of strings are important

IF (fh:=Open('envarc:goportscan.prefs', MODE_OLDFILE))<>0
    IF (Fgets(fh, ports, 200))=NIL THEN StrCopy(ports, '7,9,11,13,15,17,19-21,23,25,37,79-80,110,137-139 ')
    IF (Fgets(fh, log, 150))=NIL THEN StrCopy(log, 'ram:goportscan.log ')
    IF (Fgets(fh, telnet, 150))=NIL THEN StrCopy(telnet, 'miamitelnet %h %p ')
    IF (Fgets(fh, time, 5))=NIL THEN StrCopy(time, '2 ')
    IF (Fgets(fh, read, 5))=NIL THEN StrCopy(read, '0 ')
    IF (Fgets(fh, verbose, 5))=NIL THEN StrCopy(verbose, '1 ')
    IF (Fgets(fh, wakeup, 5))=NIL THEN StrCopy(wakeup, '0 ')
    IF (Fgets(fh, trojan, 5))=NIL THEN StrCopy(trojan, '0 ')
    IF (Fgets(fh, ftp, 150))=NIL THEN StrCopy(ftp, 'miamiftp %h %p ')
    IF (Fgets(fh, web, 150))=NIL THEN StrCopy(web, 'aweb %h %p ')
    IF (Fgets(fh, other, 150))=NIL THEN StrCopy(other, 'other %h %p ')
    IF (Fgets(fh, ping, 5)) = NIL THEN StrCopy(ping, '16 ')
    IF (Fgets(fh, ser, 5)) = NIL THEN StrCopy(ser, '1 ')
    Close(fh)
ELSE
    StrCopy(ports, '7,9,11,13,15,17,19-21,23,25,37,79-80,110,137-139 ')
    StrCopy(log, 'ram:goportscan.log ')
    StrCopy(telnet, 'miamitelnet %h %p ')
    StrCopy(time, '2 ')
    StrCopy(read, '0 ')
    StrCopy(verbose, '1 ')
    StrCopy(wakeup, '0 ')
    StrCopy(trojan, '0 ')
    StrCopy(ftp, 'miamiftp %h %p ')
    StrCopy(web, 'aweb-ii URL=http://%h:%p ')
    StrCopy(other, 'vva H=%h P=%p ')
    StrCopy(ping, '16 ')
    StrCopy(ser, '1 ')
ENDIF

ports[StrLen(ports)-1]:=NIL
log[StrLen(log)-1]:=NIL
telnet[StrLen(telnet)-1]:=NIL
time[StrLen(time)-1]:=NIL
read[StrLen(read)-1]:=NIL
verbose[StrLen(verbose)-1]:=NIL
wakeup[StrLen(wakeup)-1]:=NIL
trojan[StrLen(trojan)-1]:=NIL
ftp[StrLen(ftp)-1]:=NIL
web[StrLen(web)-1]:=NIL
other[StrLen(other)-1]:=NIL
ping[StrLen(ping)-1]:=NIL
ser[StrLen(ser)-1]:=NIL
ENDPROC

EXPORT PROC getprefs_ports()
ENDPROC ports

EXPORT PROC getprefs_log()
ENDPROC log

EXPORT PROC getprefs_telnet()
ENDPROC telnet

EXPORT PROC getprefs_time()
ENDPROC Val(time)

EXPORT PROC getprefs_read()
ENDPROC Val(read)

EXPORT PROC getprefs_verbose()
ENDPROC Val(verbose)

EXPORT PROC getprefs_wakeup()
ENDPROC Val(wakeup)

EXPORT PROC getprefs_trojan()
ENDPROC Val(trojan)

EXPORT PROC getprefs_ftp()
ENDPROC ftp

EXPORT PROC getprefs_web()
ENDPROC web

EXPORT PROC getprefs_other()
ENDPROC other

EXPORT PROC getprefs_ping()
ENDPROC ping

EXPORT PROC getprefs_service()
ENDPROC Val(ser)


EXPORT PROC saveprefs(o_ports, o_log, o_telnet, o_time, o_read, o_verbose, o_wakeup, o_trojan, o_ftp, o_web, o_other, o_ping, o_service)
DEF envarcfh,
    temp

    temp:=String(5)

    IF (envarcfh:=Open('envarc:goportscan.prefs', MODE_NEWFILE))<>0

        Write(envarcfh, o_ports, StrLen(o_ports))
        Write(envarcfh,'\n',1)

        Write(envarcfh, o_log, StrLen(o_log))
        Write(envarcfh,'\n',1)

        Write(envarcfh, o_telnet, StrLen(o_telnet))
        Write(envarcfh,'\n',1)

        StringF(temp,'\d\n',o_time)
        Write(envarcfh, temp, StrLen(temp))

        StringF(temp,'\d\n',o_read)
        Write(envarcfh, temp, StrLen(temp))

        StringF(temp,'\d\n',o_verbose)
        Write(envarcfh, temp, StrLen(temp))

        StringF(temp,'\d\n',o_wakeup)
        Write(envarcfh, temp, StrLen(temp))

        StringF(temp,'\d\n', o_trojan)
        Write(envarcfh, temp, StrLen(temp))

        Write(envarcfh, o_ftp, StrLen(o_ftp))
        Write(envarcfh,'\n',1)

        Write(envarcfh, o_web, StrLen(o_web))
        Write(envarcfh,'\n',1)

        Write(envarcfh, o_other, StrLen(o_other))
        Write(envarcfh,'\n',1)

        Write(envarcfh, o_ping, StrLen(o_ping))
        Write(envarcfh,'\n',1)

        StringF(temp,'\d\n',o_service)
        Write(envarcfh, temp, StrLen(temp))

        Close(envarcfh)
    ELSE
        WriteF('Unable to save preferences to ENVARC:\n')
    ENDIF

ENDPROC

