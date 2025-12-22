/* $VER: 2.0, ©1994 BURGHARD Eric. Original by Leon Woestenberg 1993 */
/*                  Fold all unfolded PROCEDURES                     */

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'                        /* lock GUI, gain access   */
if rc then exit
options failat 6                            /* ignore warnings         */
signal on syntax                            /* ensure clean exit       */

'QUERY ANYTEXT'
if (result = 'TRUE') then do
  'QUERY COLUMN ABSLINE FIND'
  parse var result column ' ' line ' ' fstr
  'FOLD ALL OPEN="FALSE"'
  'FIND STRING="PROC " WORDS="FALSE" CASE="TRUE" FIRST QUIET'
  do while (rc=0)
    'QUERY COLUMN VAR COL'
    'UP'
    'FIRST'
    'QUERY WORD VAR TESTPROC'
    'DOWN'
    'GOTO COLUMN='col''
    if (testproc~=='/*FOLDER') then do
      'QUERY WORD VAR TESTPROC'
      if (testproc='PROC') then do
        'QUERY BUFFER'
        parse var result "PROC" procname "(" varuse ")"
        procname=space(procname,0)
        'INSERT LINE'
        'FIRST'
        'TEXT T="/**FOLDER "'
        'CODE SET 34'
        'TEXT T="'procname'('varuse')"'
        'CODE SET 34'
        'TEXT T="**/"'
        'FIND STRING=ENDPROC WORDS="FALSE" CASE="TRUE" NEXT'
        'GOTO EOL'
        'RIGHT'
        'CR'
        'TEXT T="/**FEND**/"'
        'UP'
        'FOLD OPEN="FALSE"'
      end
    end
    else do
        'FIND STRING=ENDPROC WORDS="FALSE" CASE="TRUE" NEXT'
        'GOTO EOL'
    end
    'FIND STRING=PROC WORDS="FALSE" CASE="TRUE" NEXT QUIET'
  end
  'GOTO LINE='line' COLUMN='column''
  'FIND STRING="'fstr'"'
end
else 'REQUEST STATUS="Text buffer is empty ?!"'
'UNLOCK'
exit

syntax:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit

