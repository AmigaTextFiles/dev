/* $VER: 1.5, ©1994 BURGHARD Eric.                            */
/*             Uncomment an entire block                      */

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'                        /* lock GUI, gain access   */
if rc then exit
options failat 6                            /* ignore warnings         */
signal on syntax                            /* ensure clean exit       */

'QUERY MARKED'
if result="FALSE" then 'REQUEST STATUS=" No block marked !"'
else do
    'QUERY ABSLINE COLUMN'
    parse var result line ' ' col
    'GOTO BLAST'
    'QUERY ABSLINE VAR LLINE'
    'GOTO BFIRST'
    'QUERY ABSLINE VAR FLINE'
    do l=fline for lline-fline+1
        'FIRST'
        'QUERY WORD'
        if result="/*" then do
            'GOTO EOL'
            'PREV'
            'QUERY WORD'
            if result="*/" then do
                'DEL'
                'DEL'
                'FIRST'
                'DEL'
                'DEL'
                'DEL'
            end
        end
        lne=l+1
        'GOTO LINE='lne''
    end
    'BLOCK HIDE'
    'GOTO COLUMN='col' LINE='line''
end
'UNLOCK'
exit

syntax:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit

