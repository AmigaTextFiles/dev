OPT PREPROCESS
MODULE '*queuestack'

#define SIGNALS

#ifdef SIGNALS
MODULE 'other/signal'
#endif

OBJECT test1
 a
ENDOBJECT

OBJECT test2 OF test1
 b
ENDOBJECT

OBJECT test3 OF test2
 c
ENDOBJECT


DEF queuestack_ctrlc

RAISE "^C" IF CtrlC() = TRUE

PROC speak() OF test1
 WriteF('I''m from test1!\n')
ENDPROC

PROC speak() OF test2
 WriteF('I''m from test2 of test1!\n')
ENDPROC

PROC speak() OF test3
 WriteF('I''m from test3 of test2 of test1!\n')
ENDPROC 

PROC isEven(i) IS Even(i)

PROC print(i)
 WriteF('item = \d\n',i)
 RETURN i
ENDPROC

PROC write(i)
 WriteF('-> \s\n',i)
ENDPROC

PROC isNegative(i) IS i<0

PROC subtractFour(i) IS i - 4

#ifdef SIGNALS
PROC pause() HANDLE
 WriteF('<Press ^D to continue>')
 WHILE ctrlD() = NIL
 CtrlC()
 ENDWHILE
 WriteF('\n')
EXCEPT
 WriteF('\n')
 Raise(exception)
ENDPROC
#endif

#ifndef SIGNALS
PROC pause() HANDLE
 WriteF('Press ^C to continue>')
 LOOP
  CtrlC()
 ENDLOOP
EXCEPT
 WriteF('\n')
ENDPROC
#endif

PROC eh(i,j)
 RETURN i+j
ENDPROC

PROC main() HANDLE
 DEF in:PTR TO queuestack,i,j=0,out:PTR TO queuestack,one:PTR TO test1,
     two:PTR TO test2,three:PTR TO test3,moo:PTR TO test1

 NEW in.new()
 NEW out.new()
 NEW one
 NEW two
 NEW three

 queuestack_ctrlc:=TRUE -> Turn on CtrlC() ability in queuestacks.

 WriteF('note: There are four general possible combinations of use.\n')
 WriteF('They''ll influence whether queuestack acts as a queue or a stack.\n')
 WriteF('#1: addFirst/getFirst\n')
 WriteF('addFirsting...\n')
 FOR i:=5 TO 10
  in.addFirst(i)
  WriteF('value = \d\n',i)
  CtrlC()
 ENDFOR
 WriteF('getFirsting...\n')
 WHILE in.getSize()
  WriteF('value = \d\n',in.getFirst())
  CtrlC()
 ENDWHILE
 pause()
 WriteF('#2: addFirst/getLast\n')
 WriteF('addFirsting...\n')
 FOR i:=5 TO 10
  in.addFirst(i)
  WriteF('value = \d\n',i)
  CtrlC()
 ENDFOR
 WriteF('getLasting...\n')
 WHILE in.getSize()
  WriteF('value = \d\n',in.getLast())
  CtrlC()
 ENDWHILE
 pause()
 WriteF('#3: addLast/getFirst\n')
 WriteF('addLasting...\n')
 FOR i:=5 TO 10
  in.addLast(i)
  WriteF('value = \d\n',i)
  CtrlC()
 ENDFOR
 WriteF('getFirsting...\n')
 WHILE in.getSize()
  WriteF('value = \d\n',in.getFirst())
  CtrlC()
 ENDWHILE
 pause()
 WriteF('#4: addLast/getLast\n')
 WriteF('addLasting...\n')
 FOR i:=5 TO 10
  in.addLast(i)
  WriteF('value = \d\n',i)
  CtrlC()
 ENDFOR
 WriteF('getLasting...\n')
 WHILE in.getSize()
  WriteF('value = \d\n',in.getLast())
  CtrlC()
 ENDWHILE
 pause()
 WriteF('Of course, one could do an alternating weirdness...\n')
 WriteF('input:\n')
 j:=FALSE
 FOR i:=10 TO 20
  IF j
   in.addFirst(i)
   j:=FALSE
  ELSE
   in.addLast(i)
   j:=TRUE
  ENDIF
  WriteF('value = \d\n',i)
  CtrlC()
 ENDFOR
 WriteF('output:\n')
 in.do({print})
 WriteF('deallocation:\n')
 END in
 NEW in.new()
 out.new()
 pause()
 WriteF('addFirstQS example:\n')
 FOR i:=1 TO 5
  in.addLast(i)
  out.addLast(i+20)
 ENDFOR
 in.addFirstQS(out)
 WriteF('in:\n')
 in.do({print})
 WriteF('out:\n(should get nothing)\n')
 out.do({print})
 in.new()
 out.new()
 pause()
 WriteF('addLastQS example:\n')
 FOR i:=1 TO 5
  in.addLast(i)
  out.addLast(i+20)
 ENDFOR
 in.addLastQS(out)
 WriteF('in:\n')
 in.do({print})
 WriteF('out:\n(should get nothing)\n')
 out.do({print})
 pause()
 WriteF('Now for something twisted..\n')
 in.inject({eh},10)
 out.addFirstQS(in)
 out.do({print})
 END in
 END out
 pause()
 WriteF('We need some numbers first....\n')
 NEW in.new()
 FOR i:=1 TO 10
  in.addLast(i)
  WriteF('entered \d.\n',i)
 ENDFOR
 WriteF('Make a new list of even numbers from the old list we just made.\n')
 out:=in.select({isEven})
 out.do({print})
 END out
 pause()
 WriteF('Another one...of odd numbers.\n')
 out:=in.rejectBackwards({isEven})
 out.doBackwards({print})
 END in
 pause()
 WriteF('Subtract four from the above:\n')
 in:=out.collect({subtractFour})
 in.doBackwards({print})
 pause()
 WriteF('True or False: all of the above negative?\n')
 IF in.conform({isNegative}) THEN WriteF('True\n') ELSE WriteF('False\n')
 WriteF('True or False: any of the above negative?\n')
 IF in.detect({isNegative}) THEN WriteF('True\n') ELSE WriteF('False\n')
 WriteF('The first value found that is negative is \d.\n',in.detectBackwards({isNegative}))
 pause()
 WriteF('Hmmmm... Let''s do something peculiar...\n')
 END out
 END in
 NEW out.new()
 WriteF('We''ll make a list from 1 to 5, then add each element to the other\n')
 WriteF('as we traverse the queuestack. The last element should be the sum\n')
 WriteF('of all the elements.\n')
 FOR i:=1 TO 5
  out.addLast(i)
 ENDFOR
 out.inject({eh})
 out.do({print})
 pause()
 
 WriteF('But wait.. there''s MORE!\n')
 WriteF('Let''s watch queuestack turn a list into a queuestack!\n')
 NEW in.new()
 in.asQueueStack(['This is the way we wash the weasel,',
 		  'We wash the weasel,',
		  'We wash the weasel,',
		  'This is the way we wash the weasel,',
		  'So early in the evening.',0])

 in.do({write})
 WriteF('\nIsn''t that amazing?\n')
 pause()
 WriteF('It should be possible to convert it back to a regular list again:\n\n')
 j:=in.asList()
 FOR i:=0 TO ListLen(j)-1
  WriteF('\s\n',ListItem(j,i))
 ENDFOR
 pause()
 WriteF('Lastly, let''s look at a polymorphic example.\n')
 WriteF('Three different objects derived from test1 will be entered into the\n')
 WriteF('QueueStack... all of them have their own ''speak()'' method.\n')
 WriteF('Let''s read what they have to say.\n\n')
 END out
 NEW out.new()
 out.addFirst(one)
 out.addFirst(two)
 out.addFirst(three)
 WHILE out.getSize()
  moo:=out.getLast()
  moo.speak()
 ENDWHILE
 WriteF('\nEnd of example.\n')
EXCEPT
 IF exception = "^C" THEN WriteF('*** Break\n')
 IF exception = "GURU" THEN WriteF('Guru.\n')
ENDPROC
