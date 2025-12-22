/*

A first version of the keyboard object. By now only one command is
available: read(). Is reads from the keyboard. The pressed key(s) can
be read out of ivent:inputevent.

  V2.0  12.4.95   made it fit to 'Object'
                  should work
*/

OPT OSVERSION=37
OPT MODULE
OPT EXPORT

MODULE 'devices/keyboard','exec/io', 'devices/inputevent',
        'oomodules/library/device'

OBJECT keyboard OF device
  ievent:inputevent
ENDOBJECT

PROC name() OF keyboard IS 'Keyboard'

PROC init() OF keyboard
  self.name := 'keyboard.device'
ENDPROC

PROC read() OF keyboard

  IF self.io = NIL THEN self.open('keyboard.device',0,0)

  self.io::iostd.data := self.ievent
  self.io::iostd.length := SIZEOF inputevent
  self.io::iostd.command := KBD_READEVENT

  DoIO(self.io)

ENDPROC

PROC end() OF keyboard
  self.close()
ENDPROC

PROC openIfClosed() OF keyboard

  IF self.io = NIL THEN self.new(["name",'keyboard.device'])

ENDPROC
