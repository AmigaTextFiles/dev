-> simpletask.e - Uses the amigalib function createTask() to create a simple
-> subtask.  See the Includes and Autodocs manual for createTask() source code.

MODULE 'amigalib/tasks',
       'other/ecode',
       'dos/dos'

ENUM ERR_NONE, ERR_ECODE, ERR_TASK

CONST STACK_SIZE=1000

-> Task name, pointers for allocated task struct and stack
DEF task=NIL, simpletaskname, sharedvar

PROC main() HANDLE
  DEF taskcode
  simpletaskname:='SimpleTask'

  sharedvar:=0

  -> E-Note: eCodeTask() protects an E function so you can call it from other
  ->         tasks and have access to the global variables of this program
  IF NIL=(taskcode:=eCodeTask({simpletask})) THEN Raise(ERR_ECODE)
  IF NIL=(task:=createTask(simpletaskname, 0, taskcode, STACK_SIZE))
    Raise(ERR_TASK)
  ENDIF

  WriteF('This program initialised a variable to zero, then started a\n')
  WriteF('separate task which is incrementing that variable right now,\n')
  WriteF('while this program waits for you to press RETURN.\n')
  WriteF('Press RETURN now: ')
  -> E-Note: WriteF() opens a window if necessary, so use stdout if no stdin
  Inp(IF stdin THEN stdin ELSE stdout)

  WriteF('The shared variable now equals \d\n', sharedvar)

EXCEPT DO
  IF task
    -> We can simply remove the task we added because our simpletask does
    -> not make any system calls which could cause it to be awakened or
    -> signalled later.
    Forbid()
    deleteTask(task)
    Permit()
  ENDIF
  SELECT exception
  CASE ERR_ECODE;  WriteF('Ran out of memory in eCodeTask()\n')
  CASE ERR_TASK;   WriteF('Can''t create task\n')
  ENDSELECT
ENDPROC IF exception<>ERR_NONE THEN RETURN_FAIL ELSE RETURN_OK

PROC simpletask()
  WHILE sharedvar<$8000000 DO sharedvar++
  -> Wait forever because main() is going to RemTask() us
  Wait(NIL)
ENDPROC
