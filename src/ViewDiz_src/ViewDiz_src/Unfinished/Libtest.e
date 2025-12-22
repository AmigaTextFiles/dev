MODULE  '*emods/viewdizlib', '*emods/match', '*emods/external',
        'dos/dos', 'dos/var', 'dos/rdargs', 'dos/dostags', 'dos/dosasl'


PROC main()
  DEF lock=0, finf=0:PTR TO vdFileInfo, cfg:PTR TO vdConfig, i=0,
      cmd[200]:STRING

  IF lock:=Lock( 't:', SHARED_LOCK )
    IF cfg:=vdStartup(lock)
      IF finf:=vdAllocObject(VDO_FILEINFO)

        vdExamine( 'testfiles/test.xpk', finf, cfg )
        vdRunModule( finf, VDCMD_READ )

        ->vdLoadWizards( '"Wrap Width=20"', cfg )
        ->vdRunWizards( finf )
        ->vdUnloadWizards( cfg )

        PrintF('Modul: \s\n', finf.cfg.module[finf.configitem].module )

        vdFreeObject(VDO_FILEINFO, finf)
      ENDIF

      vdFreeStartup(cfg)
    ENDIF
    UnLock(lock)
  ENDIF

ENDPROC
