MODULE '*external', 'dos/var'

PROC main()
  DEF longval:PTR TO LONG, args:PTR TO vdExternalArgs, str[200]:STRING,
      ustr[200]:STRING, fh

  IF StrToLong( arg, {longval} )<>-1
    args:=^longval

    IF args.command=VDCMD_READ
      IF fh:=Open( args.finf.filename, OLDFILE )
        Fgets( fh, str, StrMax(str) )
        Close(fh)

        IF StrLen(str)>0
          StrCopy( ustr, str, 6 )
          IF StrCmp( UpperStr( ustr ), 'SHORT:', 6 )
            IF fh:=Open( args.finf.cfg.descfile, NEWFILE )
              Fputs( fh, TrimStr(str+6) )
              Close(fh)
            ENDIF
          ENDIF  
        ENDIF
      ENDIF
    ENDIF
  ELSE
    StringF( str, '\s r 0 "" (#?.readme) "Aminet Readme"', arg)
    SetVar( 'viewdiz/.minf', str, -1, GVF_GLOBAL_ONLY )
  ENDIF
ENDPROC

CHAR '$VER: ViewDiz-XPK.module 1.3 (11.11.98) Mikael Lund'
