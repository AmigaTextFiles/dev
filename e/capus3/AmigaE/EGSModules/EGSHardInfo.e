->> MODULES
MODULE '*pragmas/egs_pragmas',         '*egs'
MODULE '*pragmas/egsblit_pragmas',     '*egsblit'
MODULE '*pragmas/egslayers_pragmas',   '*egslayers'
MODULE '*pragmas/egsgfx_pragmas',      '*egsgfx'
MODULE '*pragmas/egsintui_pragmas',    '*egsintui'
MODULE '*pragmas/egsgadbox_pragmas',   '*egsgadbox'
MODULE '*pragmas/egsrequest_pragmas',  '*egsrequest'
MODULE '*pragmas/gbmenuselect_pragmas','*egb/gbmenuselect'
MODULE '*pragmas/gbradio_pragmas',     '*egb/gbradio'
MODULE '*pragmas/gbscrollbox_pragmas', '*egb/gbscrollbox'
MODULE '*pragmas/gbselect_pragmas',    '*egb/gbselect'
MODULE '*pragmas/gbsets_pragmas',      '*egb/gbsets'
MODULE '*pragmas/gbtextinfo_pragmas',  '*egb/gbtextinfo'

MODULE '*EGSlib'

MODULE 'intuition/iobsolete'
MODULE 'exec/ports'
MODULE 'other/plist'
-><


PROC main()
    DEF liber
    DEF hinfo:PTR TO hardinfo
    liber:=openEGSLibraries()
    IF liber=-1
        hinfo:=Ee_GetHardInfo()
        WriteF('hardinfo address:$\h\n',hinfo)
        WriteF('----------------\n')
        WriteF('Product         :\s\n',hinfo.product)
        WriteF('Manufact        :\s\n',hinfo.manufact)
        WriteF('Version         :\d\n',hinfo.version)
        WriteF('MaxFreq         :\d\n',hinfo.maxfreq)
        WriteF('Flags           :$\h\n',hinfo.flags)
        WriteF('Modes           :$\h\n',hinfo.modes)
        writeFList(hinfo.modes)
        WriteF('ActPixClock     :\d\n',hinfo.actpixclock)
        WriteF('FrameTime       :\d\n',hinfo.frametime)
        WriteF('MemBase         :$\h\n',hinfo.membase)
        WriteF('MemSize         :\d\n',hinfo.memsize)
        WriteF('LibDate         :\h\n',hinfo.libdate)
        closeEGSLibraries()
    ENDIF
ENDPROC


