OPT PREPROCESS

MODULE '*ledfilter'

PROC show_state() IS
  Vprintf('LED now \s.\n', [IF led_status() THEN 'ON' ELSE 'OFF'])

PROC main()
  DEF led, m, n, o

  led := led_status()

->-------------------------------------

  set_led(TRUE) -> turn LED on
  show_state()
  Delay(50)

  set_led(FALSE) -> turn LED off
  show_state()
  Delay(50)

->-------------------------------------

  PutStr('Toggling LED cycles.\n')
  FOR o := 1 TO 5
    n := 50
    WHILE n > 0
      FOR m := 1 TO o DO WaitTOF()
      n := n - o
      toggle_led()
    ENDWHILE
  ENDFOR

->-------------------------------------

  set_led(led) -> restore original LED

ENDPROC
