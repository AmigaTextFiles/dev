-> easyrequest.e - Show the use of an easy requester.

OPT OSVERSION=37  -> Note: silently require V37

MODULE 'intuition/intuition'

-> Main routine to show the use of EasyRequestArgs()
PROC main()
  DEF answer, number, text

  number:=3125794  -> For use in the middle button

  -> The easy request strucutre uses many features of EasyRequestArgs(),
  -> including:
  ->     multiple lines of body text separated by '\n'.
  ->     variable substitution of a string (%s) in the body text.
  ->     multiple button gadgets separated by '|'.
  ->     variable substitution in a gadget (long decimal '%ld').

  -> NOTE in the variable substitution:
  ->     the string goes in the first open variable (in body text).
  ->     the number goes in the second open (gadget text).
  text:='Text for the request\n'+
        'Second line of %s text\n'+
        'Third line of text for the request'
  answer:=EasyRequestArgs(NIL,
                         [SIZEOF easystruct, 0, 'Request Window Name',
                          text,
                          'Yes|%ld|No']:easystruct,
                          NIL, ['(Variable)', number])
  -> Process the answer.  Note that the buttons are numbered in a strange
  -> order.  This is because the rightmost button is always a negative reply.
  -> The code can use this if it chooses, with a construct like:
  ->
  ->     IF EasyRequestArgs() THEN positive_response()
  SELECT answer
  CASE 1; WriteF('Selected "Yes"\n')
  CASE 2; WriteF('Selected "\d"\n', number)
  CASE 0; WriteF('Selected "No"\n')
  ENDSELECT
ENDPROC
