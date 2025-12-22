/*
** Program to test the module 'other/checkaga'
*/

MODULE 'other/checkaga'

PROC main()
    IF checkaga()=TRUE  THEN WriteF('- AGA -\n')
    IF checkaga()=FALSE THEN WriteF('- NO AGA -\n')
ENDPROC
