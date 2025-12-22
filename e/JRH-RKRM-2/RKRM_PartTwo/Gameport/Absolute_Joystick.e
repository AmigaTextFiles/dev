-> Absolute_Joystick.e - Gameport device absolute joystick example

->>> Header (globals)
MODULE 'amigalib/ports',
       'amigalib/io',
       'devices/gameport',
       'devices/inputevent',
       'devices/timer',
       'exec/execbase',
       'exec/io',
       'exec/nodes',
       'exec/ports'

ENUM ERR_NONE, ERR_DEV, ERR_IO, ERR_PORT

RAISE ERR_DEV IF OpenDevice()<>0

CONST JOY_X_DELTA=1, JOY_Y_DELTA=1, TIMEOUT_SECONDS=10

DEF exec:PTR TO execbase
->>>

->>> PROC printInstructions()
-> Routine to print out some information for the user.
PROC printInstructions()
  WriteF('\n >>> gameport.device Absolute Joystick Demo <<<\n\n')

  IF exec.vblankfrequency=60
    WriteF(' Running on NTSC system (60 Hz).\n')
  ELSEIF exec.vblankfrequency=50
    WriteF(' Running on PAL system (50 Hz).\n')
  ENDIF

  WriteF(' Attach joystick to rear connector (A3000) and (A1000).\n' +
         ' Attach joystick to right connector (A2000).\n' +
         ' Attach joystick to left connector (A500).\n' +
         ' Then move joystick and click its button(s).\n\n' +
         ' To EXIT program press and release fire button 3 consecutive ' +
               'times.\n' +
         ' The program also exits if no activity occurs for 1 minute.\n\n')
ENDPROC
->>>

->>> PROC check_move(game_event:PTR TO inputevent)
-> Print out information on the event received.
PROC check_move(game_event:PTR TO inputevent)
  DEF xmove, ymove, timeout=FALSE
  xmove:=game_event.x
  ymove:=game_event.y

  IF xmove=1
    IF ymove=1
      WriteF('RIGHT DOWN\n')
    ELSEIF ymove=0
      WriteF('RIGHT\n')
    ELSEIF ymove=-1
      WriteF('RIGHT UP\n')
    ELSE
      WriteF('UNKNOWN Y\n')
    ENDIF
  ELSEIF xmove=-1
    IF ymove=1
      WriteF('LEFT DOWN\n')
    ELSEIF ymove=0
      WriteF('LEFT\n')
    ELSEIF ymove=-1
      WriteF('LEFT UP\n')
    ELSE
      WriteF('UNKNOWN Y\n')
    ENDIF
  ELSEIF xmove=0
    IF ymove=1
      WriteF('DOWN\n')
    ELSEIF ymove=0
      -> Note that 0,0 can be a timeout, or a direction release.
      IF game_event.timestamp.secs >= (exec.vblankfrequency*TIMEOUT_SECONDS)
        -> Under 1.3 (V34) and earlier versions of the Amiga OS, the
        -> timestamp.secs field used in the IF statement above is not
        -> correctly filled in.  Therefore, this program cannot tell the
        -> difference between a release event and a timeout under 1.3 (release
        -> events will be reported as timeouts).
        WriteF('TIMEOUT\n')
        timeout:=TRUE
      ELSE
        WriteF('RELEASE\n')
      ENDIF
    ELSEIF ymove=-1
      WriteF('UP\n')
    ELSE
      WriteF('UNKNOWN Y\n')
    ENDIF
  ELSE
    WriteF('UNKNOWN X ')
    IF ymove=1
      WriteF('unknown action\n')
    ELSEIF ymove=0
      WriteF('unknown action\n')
    ELSEIF ymove=-1
      WriteF('unknown action\n')
    ELSE
      WriteF('UNKNOWN Y\n')
    ENDIF
  ENDIF
ENDPROC timeout
->>>

->>> PROC send_read_request(game_event, game_io_msg:PTR TO iostd)
-> Send a request to the gameport to read an event.
PROC send_read_request(game_event, game_io_msg:PTR TO iostd)
  game_io_msg.command:=GPD_READEVENT
  game_io_msg.flags:=0
  game_io_msg.data:=game_event
  game_io_msg.length:=SIZEOF inputevent
  SendIO(game_io_msg)  -> Asynchronous - message will return later
ENDPROC
->>>

->>> PROC processEvents(game_io_msg:PTR TO iostd, game_msg_port:PTR TO mp)
-> Simple loop to process gameport events.
PROC processEvents(game_io_msg:PTR TO iostd, game_msg_port:PTR TO mp)
  DEF timeout, timeouts, button_count, not_finished, code,
      game_event:inputevent  -> Where input event will be stored
  -> From now on, just read input events into the event buffer,
  -> one at a time.  READEVENT waits for the preset conditions.
  timeouts:=0
  button_count:=0
  not_finished:=TRUE

  WHILE (timeouts<6) AND not_finished
    -> Send the read request
    send_read_request(game_event, game_io_msg)

    -> Wait for joystick action
    Wait(Shl(1, game_msg_port.sigbit))
    WHILE NIL<>GetMsg(game_msg_port)
      timeout:=FALSE
      code:=game_event.code
      SELECT code
      CASE IECODE_LBUTTON
        WriteF(' FIRE BUTTON PRESSED \n')
      CASE IECODE_LBUTTON OR IECODE_UP_PREFIX
        WriteF(' FIRE BUTTON RELEASED \n')
        button_count++
        IF 3=button_count THEN not_finished:=FALSE
      CASE IECODE_RBUTTON
        WriteF(' ALT BUTTON PRESSED \n')
        button_count:=0
      CASE IECODE_RBUTTON OR IECODE_UP_PREFIX
        WriteF(' ALT BUTTON RELEASED \n')
        button_count:=0
      CASE IECODE_NOBUTTON
        -> Check for change in position
        timeout:=check_move(game_event)
        button_count:=0
      DEFAULT
      ENDSELECT

      IF timeout
        INC timeouts
      ELSE
        timeouts:=0
      ENDIF
    ENDWHILE
  ENDWHILE
ENDPROC
->>>

->>> PROC set_controller_type(type, game_io_msg:PTR TO iostd)
-> Allocate the controller if it is available.  You allocate the controller by
-> setting its type to something other than GPCT_NOCONTROLLER.  Before you
-> allocate the thing you need to check if anyone else is using it (it is free
-> if it is set to GPCT_NOCONTROLLER).
PROC set_controller_type(type, game_io_msg:PTR TO iostd)
  DEF success=FALSE, controller_type_addr
  controller_type_addr:=[0]:CHAR
  -> Begin critical section.
  -> We need to be sure that between the time we check that the controller is
  -> available and the time we allocate it, no one else steals it.
  Forbid()

  game_io_msg.command:=GPD_ASKCTYPE  -> Enquire current status
  game_io_msg.flags:=IOF_QUICK
  game_io_msg.data:=controller_type_addr  -> Put answer in here
  game_io_msg.length:=1
  DoIO(game_io_msg)

  -> No one is using this device unit, let's claim it
  IF controller_type_addr[]=GPCT_NOCONTROLLER
    game_io_msg.command:=GPD_SETCTYPE
    game_io_msg.flags:=IOF_QUICK
    game_io_msg.data:=[type]:CHAR
    game_io_msg.length:=1
    DoIO( game_io_msg)
    success:=TRUE
  ENDIF

  Permit()  -> Critical section end
ENDPROC success
->>>

->>> PROC set_trigger_conditions(gpt:PTR TO gameporttrigger, game_io_msg:...)
-> Tell the gameport when to trigger.
PROC set_trigger_conditions(gpt:PTR TO gameporttrigger,
                            game_io_msg:PTR TO iostd)
  -> Trigger on all joystick key transitions
  gpt.keys:=GPTF_UPKEYS OR GPTF_DOWNKEYS
  gpt.xdelta:=JOY_X_DELTA
  gpt.ydelta:=JOY_Y_DELTA
  -> Timeout trigger every TIMEOUT_SECONDS second(s)
  gpt.timeout:=exec.vblankfrequency*TIMEOUT_SECONDS

  game_io_msg.command:=GPD_SETTRIGGER
  game_io_msg.flags:=IOF_QUICK
  game_io_msg.data:=gpt
  game_io_msg.length:=SIZEOF gameporttrigger
  DoIO(game_io_msg)
ENDPROC
->>>

->>> PROC flush_buffer(game_io_msg:PTR TO iostd)
-> Clear the buffer.  Do this before you begin to be sure you start in a known
-> state.
PROC flush_buffer(game_io_msg:PTR TO iostd)
  game_io_msg.command:=CMD_CLEAR
  game_io_msg.flags:=IOF_QUICK
  game_io_msg.data:=NIL
  game_io_msg.length:=0
  DoIO(game_io_msg)
ENDPROC
->>>

->>> PROC free_gp_unit(game_io_msg:PTR TO iostd)
-> Free the unit by setting its type back to GPCT_NOCONTROLLER.
PROC free_gp_unit(game_io_msg:PTR TO iostd)
  DEF type=GPCT_NOCONTROLLER
  game_io_msg.command:=GPD_SETCTYPE
  game_io_msg.flags:=IOF_QUICK
  game_io_msg.data:=[type]:CHAR
  game_io_msg.length:=1;
  DoIO(game_io_msg)
ENDPROC
->>>

->>> PROC main()
-> Allocate everything and go.  On failure, free any resources that have been
-> allocated.
PROC main() HANDLE
  DEF joytrigger:gameporttrigger, game_io_msg=NIL:PTR TO iostd,
      game_msg_port=NIL, open_dev=FALSE
  -> E-Note: get the right type for exec
  exec:=execbase
  -> Create port for gameport device communications
  IF NIL=(game_msg_port:=createPort('RKM_game_port', 0))
    Raise(ERR_PORT)
  ENDIF
  -> Create message block for device IO
  IF NIL=(game_io_msg:=createExtIO(game_msg_port, SIZEOF iostd))
    Raise(ERR_IO)
  ENDIF

  game_io_msg.mn.ln.type:=NT_UNKNOWN
  -> Open the right/back (unit 1, number 2) gameport.device unit
  OpenDevice('gameport.device', 1, game_io_msg, 0)
  open_dev:=TRUE
  -> Set controller type to joystick
  IF set_controller_type(GPCT_ABSJOYSTICK, game_io_msg)
    -> Specify the trigger conditions
    set_trigger_conditions(joytrigger, game_io_msg)

    printInstructions()

    -> Clear device buffer to start from a known state.
    -> There might still be events left.
    flush_buffer(game_io_msg)

    processEvents(game_io_msg, game_msg_port)

    -> Free gameport unit so other applications can use it!
    free_gp_unit(game_io_msg)
  ENDIF
EXCEPT DO
  IF open_dev THEN CloseDevice(game_io_msg)
  IF game_io_msg THEN deleteExtIO(game_io_msg)
  IF game_msg_port THEN deletePort(game_msg_port)
  SELECT exception
  CASE ERR_DEV;   WriteF('Error: could not open gameport device\n')
  CASE ERR_IO;    WriteF('Error: could not create I/O\n')
  CASE ERR_PORT;  WriteF('Error: could not create port\n')
  ENDSELECT
ENDPROC
->>>
