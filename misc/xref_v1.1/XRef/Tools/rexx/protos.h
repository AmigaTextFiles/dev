
/* rexxxref.asm */

/* rexxxref.c */
LibCall struct Library *LibInit ( REGD0 struct RexxXRefBase *rxb , REGA0 BPTR seglist , REGA6 struct Library *sysbase );
LibCall LONG LibOpen ( REGA6 struct RexxXRefBase *rxb );
LibCall LONG LibClose ( REGA6 struct RexxXRefBase *rxb );
LibCall LONG LibExpunge ( REGA6 struct RexxXRefBase *rxb );

/* rexxcmdparser.c */
LibCall ULONG RexxCmdParser ( REGA0 struct RexxMsg *rmsg , REGA6 struct RexxXRefBase *rxb );

/* findxref.c */
ULONG findxref ( struct ARexxFunction *func , struct RexxMsg *rmsg , STRPTR *argstr , struct RexxXRefBase *rxb );

/* expungexref.c */
ULONG expungexref ( struct ARexxFunction *func , struct RexxMsg *rmsg , STRPTR *argstr , struct RexxXRefBase *rxb );

/* loadxref.c */
ULONG loadxref ( struct ARexxFunction *func , struct RexxMsg *rmsg , STRPTR *argstr , struct RexxXRefBase *rxb );

/* endcode.asm */
