/* Dblock.rexx - SAY EE selected-block dimensions. */

ADDRESS 'EE.0'
OPTIONS RESULTS

LockWindow
?BlockDimensions; bd=RESULT

PARSE VALUE bd WITH startLine startColumn endLine endColumn .

SAY "startLine  ="startLine
SAY "startColumn="startColumn
SAY "endLine    ="endLine
SAY "endColumn  ="endColumn

UnlockWindow
