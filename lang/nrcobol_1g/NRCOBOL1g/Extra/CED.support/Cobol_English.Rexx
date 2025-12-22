/*
   Macro Arexx to control NrCobol from CygnusEd (4.2)
   © 1998 - By Bertuccio Saul
*/

Options Results

Call AddLib('rexxsupport.library',0,-30,0)
Call AddLib('rexxtricks.library',0,-30,0)

Operazione	   = UPPER(Arg(1))

Ret            = "0A"x
Port           = "COBOL"

Est.Sorgente   = "COB"
Est.Exe        = "INT"
Est.Lista      = "LST"
Est.Change     = "CNG"
Est.LastComp   = "RES"
Est.LastErr    = "ERR"

Msg.NoPort     = "Can't open the Port" Port
Msg.ErrNoSave  = "Save the file first"
Msg.ErrEst     = "The file must have" Est.Sorgente "extension"
Msg.ErrNoLista = "The list file don't exists"
Msg.ErrLista   = "The flag for producing" || RET || "listing must be set"
Msg.Comp       = "Compiling the file"
Msg.Wait       = "-- PLASE WAIT --"
Msg.NoErr      = "No Error"
Msg.NoNextErr  = "No other error"
Msg.Exe        = "Running the file"
Msg.Config     = "Preferences: (S) Save - (U) Use - (C) Cancel"
Msg.ErrSaveCfg = "Can't save the preferences"
Msg.Save       = "AutoSave the source file?"
Msg.Lista      = "Making a listing file?"
Msg.Debug      = "Making a debug linsting file?"

NRCOBOL        = 'Lavoro:Programmazione/Cobol/NrCobol' /* Path of the Compiler */
RUNCOB         = 'Lavoro:Programmazione/Cobol/RunCob'  /* Path of the executer :) */

Modifiche      = 0

CED.RESTNAME       = 21
CED.FILENAME       = 19
CED.NUMCHANGES     = 18
CED.CURSORLINE     = 47

/* DEFAULT SETUP */

Cfg.Nome          = "Cobol.prefs"    /* Name of preference file */
Cfg.Salvataggio   = 0
Cfg.Lista         = 1
Cfg.Debug         = 1


/* MAIN */

Call Carica_Configurazione

If Port ~= Left(ADDRESS(),Length(Port)) Then
   Say Msg.NoPort

Nome.Sorgente = Ottieni_Nome_File(CED.RESTNAME)
If Nome.Sorgente = '' Then
   Do
      'Save As'
      If RESULT = 0 Then
         Do
            'Okay1' Msg.ErrNoSave
            CALL Uscita(0)
         End
  End
Else
   Do
      'Status' CED.NUMCHANGES
      Modifiche = Result
      If Cfg.Salvataggio = 1 & Modifiche ~= 0 Then
         'Save'
   End

Nome.Sorgente = Ottieni_Nome_File(CED.FILENAME)
if UPPER(SuffixPart(Nome.Sorgente)) ~= Est.Sorgente Then
   Do
      'Okay1' Msg.ErrEst
      Call Uscita(0)
   End

Nome.File     = Strip(FilePart(MakeSuffix(Nome.Sorgente,'',R)),'T','.')
Nome.Change   = Nome.File || Est.Change
Nome.LastComp = Nome.File || Est.LastComp
Nome.LastErr  = Nome.File || Est.LastErr
Nome.Exe      = MakeSuffix(Nome.Sorgente, Est.Exe,'R')
Nome.Lista    = MakeSuffix(Nome.Sorgente, Est.Lista,'R')

SELECT
   When Operazione   = 'COMPILA'   Then
      CALL Compila
   When Operazione   = 'ESEGUI'    Then
      CALL Esegui
   When Operazione   = 'CONFIGURA' Then
      CALL Configura
   When Operazione   = 'ERRORI'    Then
      CALL Errori
   OtherWise
      NOP
End

CALL Uscita(0)

/* END MAIN */

Compila: Procedure Expose NRCOBOL RUNCOBOL Nome. Msg. Cfg. Ret Modifiche
   'DM' Msg.Comp Nome.Sorgente Msg.Wait
   If Cfg.Lista = 1 Then Opzioni = '-L'
   If Cfg.Debug = 1 Then Opzioni = Opzioni '-D'
   Opzioni = Opzioni '>' 'T:' || Nome.File
   CALL Compilazione(Nome.Sorgente, Opzioni)
   Risultato = VisualizzaRisultati('T:' || Nome.File)
   CALL SetEnv(Nome.LastComp, Risultato)
   CALL SetEnv(Nome.LastErr, 4)
   'DM'
Return Risultato

Esegui: Procedure Expose NRCOBOL RUNCOBOL Nome. Msg. Cfg. Ret Modifiche
   Run = GetEnv(Nome.LastComp)
   If Run = '' Then
      Run = 1
   ModifichePrecedenti    = GetEnv(Nome.Change)
   If ModifichePrecedenti = '' Then
      ModifichePrecedenti = Modifiche
   CALL SetEnv(Nome.Change, Modifiche)
   If ~Newer(Nome.Sorgente, Nome.Exe) | Modifiche ~= ModifichePrecedenti | Run = 0 Then
      Run = Compila()
   If Run = 1 Then
       Do
          'DM' Msg.Exe Nome.Exe
          CALL Esecuzione(Nome.Exe)
       End
  'Dm'
Return Run

Configura: Procedure Expose Ret Cfg. Msg.
    'Okay2' Msg.Save;    Salvataggio = Result
    'Okay2' Msg.Lista;   Lista       = Result
    'Okay2' Msg.Debug;   Debug       = Result
    Impostazioni = Salvataggio Lista Debug
    Continua = 1
    Do While Continua = 1
       'DM' Msg.Config
       Tasto = -1
       Do Until Tasto ~= -1
          'LASTKEY'
          Tasto = RESULT
       End
       Key = Word( Tasto, 1)
       SELECT
          When Key = 33 Then CALL Salva
          When Key = 22 Then CALL Usa
          When Key = 51 Then Continua = 0
          OtherWise NOP
       End
    End
    'DM'
Return

Errori: Procedure Expose Nome. Msg. Cfg. CED. RET
   Res      = GetEnv(Nome.LastComp)
   LastLine = GetEnv(Nome.LastErr)
   If LastLine  = '' Then LastLine = 4
   Select
       When Cfg.Lista = 0       Then Messaggio = Msg.ErrLista
       When Res       = 1       Then Messaggio = Msg.NoErr
       When ~Exists(Nome.Lista) Then Messaggio = Msg.ErrNoLista
       OtherWise
          Fine = 0
          Do Until Fine = 1
             Line = SearchPattern(Nome.Lista, 'LINE', LastLine, 'L', 'N')
             If Line ~= -1 Then
                Do
                   Parse Var Result Dummy 'Line' Numero Errore
                   If DataType(Numero,'N') & Dummy ='' Then
                      Do
                         Messaggio = 'Error at Line:' Numero || Ret || Errore
                         LL Numero
                         'Dm' Errore
                         SetEnv(Nome.LastErr, Line + 1)
                         Fine = 1
                      End
                   Else
                      LastLine = Line + 1
                End
             Else
                Do
                   Messaggio = Msg.NoNextErr
                   Fine = 1
                End
          End
   End
   'Okay1' Messaggio
Return

Salva:
   If ~Open(Handle,'ENVARC:' || Cfg.Nome,'W') Then
       'Okay1' Msg.ErrSaveCfg
    Else
       Writeln(Handle, Impostazioni)
Usa:
   CALL SetEnv(Cfg.Nome, Impostazioni)
   Continua = 0
Return

Compilazione: Procedure Expose NRCOBOL
   ADDRESS COMMAND NRCOBOL '"' || Arg(1) || '"' Arg(2)
Return

Esecuzione: Procedure Expose RUNCOB
   ADDRESS COMMAND RUNCOB '"' || Arg(1) || '"'
Return

Ottieni_Nome_File: Procedure
   'Status' ARG(1)
Return RESULT

Newer: Procedure
   NomeFile1 = ARG(1)
   NomeFile2 = ARG(2)
   Parse Value Statef(NomeFile1) With . . . . GiorniFile1 Minuti CinquSec .
   SecondiFile1 = ( Minuti * 60 ) + ( CinquSec / 50 )
   If Exists(NomeFile2) Then
      Do
         Parse Value Statef(NomeFile2) With . . . . GiorniFile2 Minuti CinquSec .
         SecondiFile2 = ( Minuti * 60 ) + ( CinquSec / 50 )
         If GiorniFile1 <= GiorniFile2 & SecondiFile1 < SecondiFile2 Then
            Return 1
      End
Return 0

Carica_Configurazione: Procedure Expose Cfg.
   Configurazione = GetEnv(Cfg.Nome)
   If Configurazione ~= '' Then
       Parse Var Configurazione Cfg.Salvataggio Cfg.Lista Cfg.Debug
Return

VisualizzaRisultati: PROCEDURE Expose RET
   Ok            = 1
   TempFile      = ARG(1)
   Intestazione  =  'NRCOBOL V1.0d - cHArRiOTt97-98(c)'
   Pattern.0     = 5
   Pattern.1     = 'IDENTIFICATION DIVISION'
   Pattern.2     = 'ENVIRONMENT DIVISION'
   Pattern.3     = 'DATA DIVISION'
   Pattern.4     = 'PROCEDURE DIVISION'
   Pattern.5     = 'Ending at'
   Adj.1         = 27
   Adj.2         = 28
   Adj.3         = 34
   Adj.4         = 29
   Adj.5         = 0
   LCurr         = 1
   Do Pat = 1 To Pattern.0
       LPrec = SearchPattern(TempFile, Pattern.Pat, LCurr, 'L', 'N')
       IF LPrec = -1  Then
          Do
             LCurr = -1
             LPrec = 0
          End
       Else If Pat < Pattern.0 Then
          LCurr = SearchPattern(TempFile, Pattern.Pat, LPrec + 1, 'L', 'N')
       Else
          LCurr = LPrec
       If LCurr ~= -1 Then
          Do
             PARSE Var Result (Pattern.Pat) Risultato.Pat
             Risultato.Pat = Traduci(Strip(Risultato.Pat,'B','. '))
          End
       Else
          Do
             LCurr = LPrec + 1
             Risultato.Pat = 'omessa'
             Ok = 0
          End
   End
   Messaggio = Intestazione
   Do Pat = 1 For Pattern.0
      Messaggio = Messaggio || Copies(Ret,2) || Left(Pattern.Pat,Adj.pat,'.') || Risultato.Pat
   End
   'Okay1' Messaggio
Return Ok

Traduci: Procedure Expose OK
   Select
      When Arg(1) = 'passed'    Then Return Arg(1)
      When Arg(1) = 'failed'    Then Return Arg(1)
      When Arg(1) = 'not found' Then Return Arg(1)
      Otherwise
            Parse Upper Arg 'LINE' Num ',' 'THERE' . err 'ERRORS'
            Ret = 'Ending at line' Num
            If Upper(Err) = 'NO' Then
               Return Ret '- NO ERROR -'
            Else
               Do
                  Ok = 0
                  Return Ret ' - WITH' Err 'ERROR -'
               End
   End

Uscita: Procedure
   Call RemLib('rexxsupport.library')
   Call RemLib('rexxtricks.library')
   'CEDTOFRONT'
Exit ARG(1)
