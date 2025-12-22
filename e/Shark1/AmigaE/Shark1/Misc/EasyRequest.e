OPT OSVERSION=37

MODULE 'intuition/intuition'

PROC main()
  DEF answer, number, text

  text:='ReqTools is best\n'+
        'Asl is best\n'+
        'and arp,req and another...'
  answer:=EasyRequestArgs(NIL,
                         [SIZEOF easystruct, 0, 'Requesterek',
                          text,
                          'WOW!|WHAT']:easystruct,
                          NIL,NIL)

  SELECT answer
  CASE 1; WriteF('Selected "WOW!"\n')
  CASE 2; WriteF('Selected "\d"\n', number)
  CASE 0; WriteF('Selected "WHAT"\n')
  ENDSELECT
ENDPROC
