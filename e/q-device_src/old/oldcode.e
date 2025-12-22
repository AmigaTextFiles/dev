/*
** This procedure takes a SCSI command definition, then passes the results to
** a handler procedure, depending on the SCSI command sent.
*/
-> original query command. Keep as a backup.
PROC keep_query(device:PTR TO CHAR, unit, cmd:PTR TO cdb12, size, aflg) HANDLE
DEF myport=NIL:PTR TO mp, ioreq=NIL:PTR TO iostd, buffer=NIL, scsiio:scsicmd,
    command, error=-1, status, fh

    IF (myport:=CreateMsgPort())=NIL THEN Raise(ERR_MP)
    IF (ioreq:=createStdIO(myport))=NIL THEN Raise(ERR_IOR)
    IF (error:=OpenDevice(device, unit, ioreq, 0)) <> NIL THEN Raise(ERR_DEVICE)

    buffer:=New(BUFFSIZE)
    command:=cmd.opcode
    scsiio.data:=buffer
    scsiio.length:=BUFFSIZE
    scsiio.command:=cmd
    scsiio.cmdlength:=size
    scsiio.flags:=SCSIF_READ -> OR SCSIF_AUTOSENSE
    scsiio.senseactual:=0
    ioreq.command:=HD_SCSICMD
    ioreq.data:=scsiio
    ioreq.length:=SIZEOF scsicmd
    DoIO(ioreq)
    status:=ioreq.error

    IF aflg <> AFLG_CAPTURE

    SELECT $FF OF (scsiio.status AND %00111110)
        CASE 0
            IF command <> SCSI_REQUEST_SENSE THEN set(mui_status_tb, MUIA_Text_Contents, 'Target Response: GOOD')
            SELECT command
                CASE SCSI_CD_READ_TOC
                    process_toc(buffer)
                    ->process_atip(buffer)
                CASE SCSI_TEST_UNIT_READY
                    outlist_d('Unit Ready', device, unit)
                CASE SCSI_INQUIRY
                    IF aflg=AFLG_INQUIRY_SERIAL
                        process_serial(buffer)
                    ELSE
                        process_inquiry(device, unit, buffer, aflg)
                    ENDIF
                CASE SCSI_DA_READ_CAPACITY
                    process_capacity(buffer)
                CASE SCSI_CD_START_STOP_UNIT
                    IF cmd.param4=P_EJECT
                        outlist_d('Sent eject command', device, unit)
                    ELSEIF cmd.param4=P_INSERT
                        outlist_d('Sent insert command', device, unit)
                    ELSEIF cmd.param4=P_START
                        outlist_d('Sent power up command', device, unit)
                    ELSEIF cmd.param4=P_STOP
                        outlist_d('Sent power down command', device, unit)
                    ENDIF
                CASE SCSI_CD_PREVENT_ALLOW_MEDIUM_REMOVAL
                    IF cmd.param4=P_LOCK
                        outlist_d('Sent lock command', device, unit)
                    ELSE
                        outlist_d('Sent unlock command', device, unit)
                    ENDIF
                CASE SCSI_REQUEST_SENSE
                    process_sense(buffer)
                CASE SCSI_MODE_SENSE_6
                    process_modesense(buffer, size)
                CASE SCSI_MODE_SENSE_10
                    process_modesense(buffer, size)
                CASE SCSI_LOG_SENSE
                    SELECT $3F OF Char(buffer)
                        CASE $0
                            outlist('\ebLog Type:\en', 'List of supported log types')
                            process_log_support(buffer)
                        CASE $1
                            outlist('\ebLog Type:\en', 'Buffer over/under runs')
                            process_log_buffer(buffer)
                        CASE $2
                            outlist('\ebLog Type:\en', 'Write Errors')
                            process_log_errors(buffer)
                        CASE $3
                            outlist('\ebLog Type:\en', 'Read Errors')
                            process_log_errors(buffer)
                        CASE $4
                            outlist('\ebLog Type:\en', 'Reverse Read Errors')
                            process_log_errors(buffer)
                        CASE $5
                            outlist('\ebLog Type:\en', 'Verify Errors')
                            process_log_errors(buffer)
                        CASE $6
                            outlist('\ebLog Type:\en', 'Errors not related to media')
                            process_log_nmerrors(buffer)
                        CASE $7
                            outlist('\ebLog Type:\en', 'Last number of error events')
                            process_log_events(buffer)
                        CASE $2F
                            outlist('\ebLog Type:\en', 'SMART')
                            process_log_smart(buffer)
                        DEFAULT
                            outlist('\ebLog Type:\en', 'Vendor Specific Log')
                    ENDSELECT

                CASE SCSI_SEND_DIAGNOSTIC
                    outlist_d('Self Test Passed', device, unit)

            ENDSELECT
        CASE 2
            IF command <> SCSI_REQUEST_SENSE  -> Hopefully avoids recursive loops with bad devices/drivers which don't support request sense.
                set(mui_status_tb, MUIA_Text_Contents, 'Target Response: CHECK_CONDITION')
                outlist('\ebWarning:\en', 'Command generated an error response (see below)')
                query(device, unit, [SCSI_REQUEST_SENSE, 0, 0, 0, BUFFSIZE, 0]:cdb6, SIZEOF cdb6, NIL)
            ENDIF
        CASE 4
            set(mui_status_tb, MUIA_Text_Contents, 'Target Response: CONDITION_MET')
        CASE 8
            set(mui_status_tb, MUIA_Text_Contents, 'Target Response: BUSY')
        CASE 16
            set(mui_status_tb, MUIA_Text_Contents, 'Target Response: INTERMEDIATE')
        CASE 20
            set(mui_status_tb, MUIA_Text_Contents, 'Target Response: INTERMEDIATE_CONDITION_MET')
        CASE 24
            set(mui_status_tb, MUIA_Text_Contents, 'Target Response: RESERVATION_CONFLICT')
        CASE 34
            set(mui_status_tb, MUIA_Text_Contents, 'Target Response: COMMAND_TERMINATED')
        CASE 72
            set(mui_status_tb, MUIA_Text_Contents, 'Target Response: QUEUE_FULL')
        DEFAULT
            set(mui_status_tb, MUIA_Text_Contents, 'Target Response: UNKNOWN')
    ENDSELECT

    ELSE
    ->fh:=Open('RAM:DUMP', MODE_NEWFILE)
    ->Write(fh, buffer, BUFFSIZE)
    ->Close(fh)

    ENDIF

    SELECT status
        CASE 0
            ->Normal Return
        CASE HFERR_SELFUNIT
            outlist_d('<self issuing command error>', device, unit)
        CASE HFERR_DMA
            outlist_d('<DMA Failure>', device, unit)
        CASE HFERR_PHASE
            outlist_d('<illegal scsi phase>', device, unit)
        CASE HFERR_PARITY
            outlist_d('<parity error>', device, unit)
        CASE HFERR_SELTIMEOUT
            outlist_d('<device timed out>', device, unit)
    ENDSELECT

    EXCEPT DO
        IF error=NIL
            IF  CheckIO(ioreq)<>NIL
                AbortIO(ioreq)
                WaitIO(ioreq)
            ENDIF
        ENDIF

        CloseDevice(ioreq)
        IF ioreq <> NIL THEN deleteStdIO(ioreq)
        IF myport <> NIL THEN DeleteMsgPort(myport)

        SELECT exception
            CASE ERR_MP
                outlist('\ebError:\en', 'Unable to create message port')
            CASE ERR_IOR
                outlist('\ebError:\en', 'Unable to create IORequest')
            CASE ERR_DEVICE
                outlist_d('<no device>', device, unit)
        ENDSELECT

ENDPROC (scsiio.status AND %00111110)
     ->netquery
PROC old_netquery(device:PTR TO CHAR, unit, cmd:PTR TO cdb12, size, aflg) HANDLE
DEF sock, sain:PTR TO sockaddr_in, buffer, command, received=0

    buffer:=New(BUFFSIZE)
    command:=cmd.opcode
    IF (socketbase:=OpenLibrary('bsdsocket.library', NIL)) = NIL THEN Raise(ERR_NOBSD)
    sain:=NewM(SIZEOF sockaddr_in, MEMF_PUBLIC OR MEMF_CLEAR)
    sain.family:=AF_INET
    sain.addr.addr:=Inet_addr('192.168.1.3')
    sain.port:=8001
    IF (sock:=Socket(AF_INET, SOCK_STREAM, 0)) = -1 THEN Raise(ERR_NOSOCK)
    IF (Connect(sock, sain, SIZEOF sockaddr_in)) = -1 THEN Raise(ERR_NOCONNECT)
    Send(sock, cmd, size, 0)
    IF ((received:=Recv(sock, buffer, BUFFSIZE, 0)) < 255) THEN Raise(ERR_NOCONNECT)


    IF command <> SCSI_REQUEST_SENSE THEN set(mui_status_tb, MUIA_Text_Contents, 'Target Response: GOOD')
        SELECT command
            CASE SCSI_CD_READ_TOC
                process_toc(buffer)
                ->process_atip(buffer)
            CASE SCSI_TEST_UNIT_READY
                outlist_d('Unit Ready', device, unit)
            CASE SCSI_INQUIRY
                IF aflg=AFLG_INQUIRY_SERIAL
                    process_serial(buffer)
                ELSE
                    process_inquiry(device, unit, buffer, aflg)
                ENDIF
            CASE SCSI_DA_READ_CAPACITY
                process_capacity(buffer)
            CASE SCSI_CD_START_STOP_UNIT
                IF cmd.param4=P_EJECT
                    outlist_d('Sent eject command', device, unit)
                ELSEIF cmd.param4=P_INSERT
                    outlist_d('Sent insert command', device, unit)
                ELSEIF cmd.param4=P_START
                    outlist_d('Sent power up command', device, unit)
                ELSEIF cmd.param4=P_STOP
                    outlist_d('Sent power down command', device, unit)
                ENDIF
            CASE SCSI_CD_PREVENT_ALLOW_MEDIUM_REMOVAL
                IF cmd.param4=P_LOCK
                    outlist_d('Sent lock command', device, unit)
                ELSE
                    outlist_d('Sent unlock command', device, unit)
                ENDIF
            CASE SCSI_REQUEST_SENSE
                process_sense(buffer)
            CASE SCSI_MODE_SENSE_6
                process_modesense(buffer, size)
            CASE SCSI_MODE_SENSE_10
                process_modesense(buffer, size)
            CASE SCSI_LOG_SENSE
                SELECT $3F OF Char(buffer)
                    CASE $0
                        outlist('\ebLog Type:\en', 'List of supported log types')
                        process_log_support(buffer)
                    CASE $1
                        outlist('\ebLog Type:\en', 'Buffer over/under runs')
                        process_log_buffer(buffer)
                    CASE $2
                        outlist('\ebLog Type:\en', 'Write Errors')
                        process_log_errors(buffer)
                    CASE $3
                        outlist('\ebLog Type:\en', 'Read Errors')
                        process_log_errors(buffer)
                    CASE $4
                        outlist('\ebLog Type:\en', 'Reverse Read Errors')
                        process_log_errors(buffer)
                    CASE $5
                        outlist('\ebLog Type:\en', 'Verify Errors')
                        process_log_errors(buffer)
                    CASE $6
                        outlist('\ebLog Type:\en', 'Errors not related to media')
                        process_log_nmerrors(buffer)
                    CASE $7
                        outlist('\ebLog Type:\en', 'Last number of error events')
                        process_log_events(buffer)
                    CASE $2F
                        outlist('\ebLog Type:\en', 'SMART')
                        process_log_smart(buffer)
                    DEFAULT
                        outlist('\ebLog Type:\en', 'Vendor Specific Log')
                ENDSELECT

             CASE SCSI_SEND_DIAGNOSTIC
                outlist_d('Self Test Passed', device, unit)

        ENDSELECT


    EXCEPT DO
        IF sock <> -1 THEN CloseSocket(sock)
        IF (socketbase) THEN CloseLibrary(socketbase)
        SELECT exception
            CASE ERR_NOBSD
                outlist('\ebError:\en', 'Unable to open bsdsocket.library')
            CASE ERR_NOSOCK
                outlist('\ebError:\en', 'Unable to create socket')
            CASE ERR_NOCONNECT
                outlist('\ebError:\en', 'Unable to connect')
        ENDSELECT


ENDPROC exception


PROC query2(device:PTR TO CHAR, unit, cmd:PTR TO cdb12, size, aflg)
DEF myport=NIL:PTR TO mp, ioreq=NIL:PTR TO iostd, buffer=NIL, scsiio:scsicmd,
    command, error=-1, status, fh

    buffer:=New(BUFFSIZE)
    command:=cmd.opcode
    fh:=Open('SODAPOP:DUMP', MODE_OLDFILE)
    Read(fh, buffer, BUFFSIZE)
    Close(fh)

            IF command <> SCSI_REQUEST_SENSE THEN set(mui_status_tb, MUIA_Text_Contents, 'Target Response: GOOD')
            SELECT command
                CASE SCSI_CD_READ_TOC
                    process_toc(buffer)
                    ->process_atip(buffer)
                CASE SCSI_TEST_UNIT_READY
                    outlist_d('Unit Ready', device, unit)
                CASE SCSI_INQUIRY
                    IF aflg=AFLG_INQUIRY_SERIAL
                        process_serial(buffer)
                    ELSE
                        process_inquiry(device, unit, buffer, aflg)
                    ENDIF
                CASE SCSI_DA_READ_CAPACITY
                    process_capacity(buffer)
                CASE SCSI_CD_START_STOP_UNIT
                    IF cmd.param4=P_EJECT
                        outlist_d('Sent eject command', device, unit)
                    ELSEIF cmd.param4=P_INSERT
                        outlist_d('Sent insert command', device, unit)
                    ELSEIF cmd.param4=P_START
                        outlist_d('Sent power up command', device, unit)
                    ELSEIF cmd.param4=P_STOP
                        outlist_d('Sent power down command', device, unit)
                    ENDIF
                CASE SCSI_CD_PREVENT_ALLOW_MEDIUM_REMOVAL
                    IF cmd.param4=P_LOCK
                        outlist_d('Sent lock command', device, unit)
                    ELSE
                        outlist_d('Sent unlock command', device, unit)
                    ENDIF
                CASE SCSI_REQUEST_SENSE
                    process_sense(buffer)
                CASE SCSI_MODE_SENSE_6
                    process_modesense(buffer, size)
                CASE SCSI_MODE_SENSE_10
                    process_modesense(buffer, size)
                CASE SCSI_LOG_SENSE
                    SELECT $3F OF Char(buffer)
                        CASE $0
                            outlist('\ebLog Type:\en', 'List of supported log types')
                            process_log_support(buffer)
                        CASE $1
                            outlist('\ebLog Type:\en', 'Buffer over/under runs')
                            process_log_buffer(buffer)
                        CASE $2
                            outlist('\ebLog Type:\en', 'Write Errors')
                            process_log_errors(buffer)
                        CASE $3
                            outlist('\ebLog Type:\en', 'Read Errors')
                            process_log_errors(buffer)
                        CASE $4
                            outlist('\ebLog Type:\en', 'Reverse Read Errors')
                            process_log_errors(buffer)
                        CASE $5
                            outlist('\ebLog Type:\en', 'Verify Errors')
                            process_log_errors(buffer)
                        CASE $6
                            outlist('\ebLog Type:\en', 'Errors not related to media')
                            process_log_nmerrors(buffer)
                        CASE $7
                            outlist('\ebLog Type:\en', 'Last number of error events')
                            process_log_events(buffer)
                        CASE $2F
                            outlist('\ebLog Type:\en', 'SMART')
                            process_log_smart(buffer)
                        DEFAULT
                            outlist('\ebLog Type:\en', 'Vendor Specific Log')
                    ENDSELECT

                CASE SCSI_SEND_DIAGNOSTIC
                    outlist_d('Self Test Passed', device, unit)

            ENDSELECT
ENDPROC 0
