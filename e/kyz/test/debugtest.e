OPT PREPROCESS

-> define DEBUG for debugging, define PARDEBUG for parallel rather than serial
#define DEBUG
->#define PARDEBUG

#ifdef DEBUG
  #ifdef PARDEBUG
    MODULE '*ddebug'
    #define D(str,args) dPrintF(str, args)
  #endif
  #ifndef PARDEBUG
    MODULE '*debug'
    #define D(str,args) kPrintF(str, args)
  #endif
#endif
#ifndef DEBUG
  #define D(str,args) 0
#endif

DEF sum

PROC main()
  DEF x, y, num

D('Enter main()\n', NIL)
D('  Initial values: x=\d y=\d num=\d sum=\d\n', [x, y, num, sum])

  FOR y := 1 TO 5
    FOR x := 1 TO 5
      num := calc1proc(x, y) + x
D('x=\d y=\d num=\d\n', [x, y, num])
      WriteF('\d[4]', num)
    ENDFOR
    WriteF('\n')
  ENDFOR

D('Exit  main() with result \d\n', [sum])
ENDPROC

PROC calc1proc(part, fart)
  DEF ret
D('Enter calc1proc() with args part=\d fart=\d\n', [part, fart])

  ret := (part - fart) * 2 + (fart * part)

D('Exit  calc1proc() with result \d\n', [ret])
ENDPROC ret
