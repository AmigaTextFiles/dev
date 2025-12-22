/*********************************************\
*                                             *
*  Autor     : G.M.A.                         *
*  Datum     : 13. 03. 1994                   *
*  Funktion  : Demonstriert Requesternutzung  *
*                                             *
\*********************************************/

PROC main()
  WriteF(' Ihre Wahl : \d\n',
          EasyRequestArgs(0, [20, 0, 0,
            'Hallo Leute !\n'          +
            'Erster Requestertest !\n' +
            'written by G.M.A.',
            'Ok|a|b|c|d|e|f|g|Cancel'], 0, NIL)  )
ENDPROC

