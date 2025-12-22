DECLARE SUB forminput$(fil%,a$)

REM *** Test *********
a$=forminput$(10,z$)
PRINT z$
REM ******************

SUB forminput$(fil%,a$)
'Replaces Input, for strings not exceeding the window width
'fil% = Maximum length, a$ = Old string content
  fiz%=CSRLIN
  fis%=POS(0)
  fis$=SPACE$(fil%)
  fip%=1
  fi$=""
  a$=LEFT$(LTRIM$(RTRIM$(a$)),fil%)
  WHILE fi$<>CHR$(13)
    a$=LEFT$(a$,fil%)
    LOCATE fiz%,fis%
    PRINT LEFT$(a$+fis$,fil%);
    LOCATE fiz%,fis%+fip%-1
    COLOR 0,1
    PRINT LEFT$(MID$(a$,fip%,1)+" ",1);
    COLOR 1,0
    fi:
    fi$=INKEY$
    IF fi$="" GOTO fi
    fia%=ASC(fi$)
    SELECT CASE fia%
    CASE 13
    CASE 30
      INCR fip%
    CASE 31
      DECR fip%
    CASE 8
      IF fip%>1
        a$=LEFT$(a$,fip%-2)+MID$(a$,fip%)
        DECR fip%
      END IF
    CASE 127
      a$=LEFT$(a$,fip%-1)+MID$(a$,fip%+1)
    CASE 27
      a$=""
      fip%=1
    CASE ELSE
      IF ((ASC(fi$) AND 127) > 31)
        a$=LEFT$(a$+fis$,fip%-1)+fi$+MID$(a$,fip%)
        INCR fip%
      END IF
    END SELECT
    IF fip%<1
      fip%=1
    END IF
    IF fip%>fil%
      fip%=fil%
    END IF
  WEND
  a$=LEFT$(a$,fil%)
  LOCATE fiz%,fis%
  PRINT LEFT$(a$+fis$,fil%);
END SUB
