PRIVATE int  SrcCodeListViewClicked( void );

IMPORT int  Z80SimLoadMI( void );
IMPORT int  Z80SimSaveMI( void );
IMPORT int  Z80SimSaveAsMI( void );
IMPORT int  Z80SimAboutMI( void );
IMPORT int  Z80SimQuitMI( void );
IMPORT int  Z80SimTranslateMI( void );
IMPORT int  Z80SimMacroMI( void );
IMPORT int  Z80SimAssembleMI( void );
IMPORT int  Z80SimPrtListMI( void );
IMPORT int  Z80SimFindCurrentMI( void );
IMPORT int  Z80SimDumpMI( void );
IMPORT int  Z80SimFillMI( void );
IMPORT int  Z80SimStackMI( void );
IMPORT int  Z80SimStepMI( void );
IMPORT int  Z80SimRestartMI( void );
IMPORT int  Z80SimNMI_MI( void );
IMPORT int  Z80SimInt_MI( void );
IMPORT int  Z80SimGoMI( void );
IMPORT int  Z80SimSetPC_MI( void );
IMPORT int  Z80SimSetBreakMI( void );
IMPORT int  Z80SimSetRegisterMI( void );
IMPORT int  Z80SimClearBreakMI( void );
IMPORT int  Z80SimShowBreaksMI( void );

PRIVATE int  SetupScreen( void );
PRIVATE void Z80SimRender( void );
PRIVATE int  HandleZ80SimIDCMP( void );
PRIVATE int  OpenZ80SimWindow( void );
PRIVATE void CloseZ80SimWindow( void );

VISIBLE void CloseDownScreen( void );
VISIBLE int  Z80SimCloseWindow();
