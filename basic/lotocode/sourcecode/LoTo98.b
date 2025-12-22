{* 
** Welcome to the LoTo98 source code, this
** file is the main part of the source. By
** the way, this is writen in ACE Basic v2.
** In order to compile this program, you'll
** need ACE Basic fully installed, with all
** the appropriate assigns. You'll also
** need Module.o in the module path.
**
** This source is for my program called LoTo98,
** it hasn't got any comments but if you have
** any questions about it, them write to me:
**
** Malcolm Campbell <malcolm@workmail.com>
** Last changed:    28/2/1999
*}

DECLARE SUB _MAIN
DECLARE SUB _QUIT EXTERNAL
DECLARE SUB _WIPE EXTERNAL
DECLARE SUB _WIPE1 EXTERNAL
DECLARE SUB _WIPE2 EXTERNAL
DECLARE SUB _MENU
DECLARE SUB _MENU1 EXTERNAL
DECLARE SUB _LOGO(X1,Y1,X2,Y2) EXTERNAL
DECLARE SUB _BOTCLEAR
DECLARE SUB _WINDOW
DECLARE SUB _REMOVE EXTERNAL
DECLARE SUB _REMOVE1 EXTERNAL
DECLARE SUB _REMOVE2 EXTERNAL
DECLARE SUB _ABOUT
DECLARE SUB _NUMBER
DECLARE SUB _NUMBER1
DECLARE SUB _RANDOM
DECLARE SUB _RANDOM1(TEMP)
DECLARE SUB _BUTTON EXTERNAL
DECLARE SUB _BUTTON1(NN)
DECLARE SUB _BUTTON2
DECLARE SUB _BUTTON3
DECLARE SUB _BUTTON4(XY)
DECLARE SUB _BUTTON5
DECLARE SUB _BUTTON6 EXTERNAL
DECLARE SUB _BUTTON7 EXTERNAL
DECLARE SUB _BUTTON8 EXTERNAL
DECLARE SUB _BUTTON9 EXTERNAL
DECLARE SUB _BUTTON10
DECLARE SUB _BUTTON11 EXTERNAL
DECLARE SUB _BUTTON12 EXTERNAL
DECLARE SUB _BUTTON13 EXTERNAL
DECLARE SUB _PRINTER1(TEMP)
DECLARE SUB _COMPUTE(NUM)
DECLARE SUB _COMPUTE1(NUM)
DECLARE SUB _COMPUTE2(NUM)
DECLARE SUB _CONCALC(NN)
DECLARE SUB _DATABASE(TEMP)
DECLARE SUB _DATABASE1(TEMP)
DECLARE SUB _DATABASE2
DECLARE SUB _DATABASE4
DECLARE SUB _PERCENT(X1,Y1,A1,A2,PR) EXTERNAL
DECLARE SUB _CONVERT(A) EXTERNAL
DECLARE SUB _CONVERT1(A) EXTERNAL
COMMON B$
GLOBAL BC1
GLOBAL BC2
GLOBAL BC3
GLOBAL BC4
GLOBAL BC5
BC1=0
BC2=0
BC3=0
BC4=0
BC5=0
GLOBAL T
COMMON A6
GLOBAL Z$
RANDOMIZE TIMER
DIM Z1(8)
DIM Y1(8)
DIM B(36)
DIM B1$(36)
DIM ED$(6)
DIM C$(5)
DIM BOTS(70)
CALL _MAIN
SUB _CONCALC(NN)
  IF NN = 1 THEN
    BC1=2
    BC2=3
    BC3=4
    BC4=5
    BC5=6
    EXIT SUB
  END IF
  IF NN = 2 THEN
    BC1=1
    BC2=3
    BC3=4
    BC4=5
    BC5=6
    EXIT SUB
  END IF
  IF NN = 3 THEN
    BC1=1
    BC2=2
    BC3=4
    BC4=5
    BC5=6
    EXIT SUB
  END IF
  IF NN = 4 THEN
    BC1=1
    BC2=2
    BC3=3
    BC4=5
    BC5=6
    EXIT SUB
  END IF
  IF NN = 5 THEN
    BC1=1
    BC2=2
    BC3=3
    BC4=4
    BC5=6
    EXIT SUB
  END IF
  IF NN = 6 THEN
    BC1=1
    BC2=2
    BC3=3
    BC4=4
    BC5=5
    EXIT SUB
  END IF
END SUB
SUB _PRINTER1(TEMP)
  SHARED Z1()
  IF MSGBOX ("Sure you want to print?","Print","Cancel") THEN
    ERRZ=ERR
    OPEN "O",#6,"PRT:"
      IF ERR<>0 THEN EXIT SUB
      PRINT #6,""
      IF ERR<>0 THEN EXIT SUB
      PRINT #6,"O------------------------------------------------------------------O"
      IF ERR<>0 THEN EXIT SUB 
      PRINT #6,"| LOTO";"98";" - The Lottery Predictor And Checker Program From TickSoft |"
      IF ERR<>0 THEN EXIT SUB 
      PRINT #6,"| Web: www.ticksoft.free-online.co.uk email: ticksoft@workmail.com |
      IF ERR<>0 THEN EXIT SUB 
      PRINT #6,"O------------------------------------------------------------------O
      IF ERR<>0 THEN EXIT SUB 
      PRINT #6,""
      IF ERR<>0 THEN EXIT SUB
      IF TEMP = 1 THEN 
        PRINT #6,"The numbers last drawn were:";Z1(1);Z1(2);Z1(3);Z1(4);Z1(5);Z1(6);"BONUS";Z1(7)
        IF ERR<>0 THEN EXIT SUB 
      END IF
      IF TEMP = 2 THEN
        PRINT #6,"The numbers generated for ";Z$;" are:";Z1(1);Z1(2);Z1(3);Z1(4);Z1(5);"AND";Z1(6)
        IF ERR<>0 THEN EXIT SUB
      END IF
      IF TEMP = 3 THEN
        PRINT #6,"The numbers used by ";Z$;" are:";Z1(1);Z1(2);Z1(3);Z1(4);Z1(5);"AND";Z1(6)
        IF ERR<>0 THEN EXIT SUB
      END IF
      IF TEMP = 4 THEN
        PRINT #6,"The TickSoft winware form for LoTo98"
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,"===================================="
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,""
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,"Please send this print out and make cheques payable to:"
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,""
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,"Malcolm Campbell"
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,"28 Northbourne Street,"
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,"Deckham, Gateshead,"
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,"Tyne & Wear, NE8 4AH."
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,""
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,"I have just won more than one thousand pounds in the lottery"
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,"using LoTo98. I used the random number method (1/2/3/4/5) to"
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,"generate the numbers.  I have included ten pounds in this letter."
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,""
        IF ERR<>0 THEN EXIT SUB
        PRINT #6,"Note: you're only required to pay the ten pounds once."
        IF ERR<>0 THEN EXIT SUB
      END IF
      IF TEMP <> 0 THEN
        PRINT #6,""
        IF ERR<>0 THEN EXIT SUB
      END IF
      22
  END IF
END SUB
SUB _BOTCLEAR
  SHARED BOTS()
  FOR N=1 TO 65
    BOTS(N)=0
  NEXT N
END SUB
SUB _BUTTON4
    SHARED BOTS()
    SHARED Z1()
    FOR N=0 TO 4
      FOR N1=1 TO 10
        CALL _CONVERT(((N*10)+N1)) 
        IF Z1(1)=((N*10)+N1) OR Z1(2)=((N*10)+N1) OR Z1(3)=((N*10)+N1) OR Z1(4)=((N*10)+N1) OR Z1(5)=((N*10)+N1) OR Z1(6)=((N*10)+N1) OR Z1(7)=((N*10)+N1) THEN
          IF BOTS((N*10)+N1)=0 OR BOTS((N*10)+N1)=2 THEN
            IF ((N*10)+N1)<>50 THEN
              IF BOTS((N*10)+N1)=2 THEN
                GADGET CLOSE (200+((N*10)+N1))
              END IF
              GADGET (200+((N*10)+N1)),OFF,B$,(((20*N1)+1),(63+(N*14)))-(((20*N1)+19),(75+(N*14))),BUTTON,1,"DICT.FONT",8,0
              BOTS((N*10)+N1)=1
            END IF
          END IF
        ELSE
          IF BOTS((N*10)+N1)=0 OR BOTS((N*10)+N1)=1 THEN
            IF ((N*10)+N1)<>50 THEN
              IF BOTS((N*10)+N1)=1 THEN
                GADGET CLOSE (200+((N*10)+N1))
              END IF
              GADGET (200+((N*10)+N1)),ON,B$,(((20*N1)+1),(63+(N*14)))-(((20*N1)+19),(75+(N*14))),BUTTON,1,"DICT.FONT",8,0
              BOTS((N*10)+N1)=2
            END IF
          END IF
        END IF
      NEXT N1
    NEXT N
    IF Z1(1)>0 OR Z1(2)>0 OR Z1(3)>0 OR Z1(4)>0 OR Z1(5)>0 OR Z1(6)>0 OR Z1(7)>0 THEN
      IF BOTS(50)=0 OR BOTS(50)=2 THEN
        IF BOTS(50)=2 THEN
           GADGET CLOSE (250)
        END IF   
        GADGET 250,ON,"<-",(201,119)-(219,131),BUTTON,1,"DICT.FONT",8,0
        BOTS(50)=1
      END IF
    ELSE
      IF BOTS(50)=0 OR BOTS(50)=1 THEN 
        IF BOTS(50)=1 THEN
          GADGET CLOSE (250)
        END IF 
        GADGET 250,OFF,"<-",(201,119)-(219,131),BUTTON,1,"DICT.FONT",8,0
        BOTS(50)=2
      END IF
    END IF
    GADGET 251,ON,"Cancel",(21,133)-(69,145),BUTTON,1,"DICT.FONT",8,0
    IF Z1(1)>0 OR Z1(2)>0 OR Z1(3)>0 OR Z1(4)>0 OR Z1(5)>0 OR Z1(6)>0 OR Z1(7)>0 THEN
      IF BOTS(60)<>1 THEN
        GADGET CLOSE 252
        GADGET 252,ON,"Clear",(71,133)-(119,145),BUTTON,1,"DICT.FONT",8,0
        BOTS(60)=1
      END IF
    ELSE
      IF BOTS(60)<>2 THEN
        GADGET CLOSE 252
        GADGET 252,OFF,"Clear",(71,133)-(119,145),BUTTON,1,"DICT.FONT",8,0
        BOTS(60)=2
      END IF
    END IF
    IF Z1(1)>0 AND Z1(2)>0 AND Z1(3)>0 AND Z1(4)>0 AND Z1(5)>0 AND Z1(6)>0 AND Z1(7)>0 THEN
      IF BOTS(59)<>1 THEN
        GADGET CLOSE 253
        GADGET 253,ON,"Print",(121,133)-(169,145),BUTTON,1,"DICT.FONT",8,0
        BOTS(59)=1
      END IF
    ELSE
      IF BOTS(59)<>2 THEN
        GADGET CLOSE 253
        GADGET 253,OFF,"Print",(121,133)-(169,145),BUTTON,1,"DICT.FONT",8,0
        BOTS(59)=2
      END IF
    END IF
    IF Z1(1)>0 AND Z1(2)>0 AND Z1(3)>0 AND Z1(4)>0 AND Z1(5)>0 AND Z1(6)>0 AND Z1(7)>0 THEN
      IF BOTS(58)<>1 THEN
        GADGET CLOSE 254
        GADGET 254,ON,"Accept",(171,133)-(219,145),BUTTON,1,"DICT.FONT",8,0
        BOTS(58)=1
      END IF
    ELSE
      IF BOTS(58)<>2 THEN
        GADGET CLOSE 254
        GADGET 254,OFF,"Accept",(171,133)-(219,145),BUTTON,1,"DICT.FONT",8,0
        BOTS(58)=2
      END IF
    END IF
    FONT "DICT.FONT",8 : STYLE 0
    PENUP : SETXY 32,40 : PRINT "The numbers drawn were:  Bonus"
  '  FONT "DICT.FONT",8 : STYLE 0
  '  PENUP : SETXY 46,47 : PRINT "With the bonus of:"
    FOR N=1 TO 6
      IF Z1(N)>0 THEN
        IF BOTS(50+N)<>Z1(N) THEN
          GADGET CLOSE (194+N)
          CALL _CONVERT(Z1(N))
          GADGET (194+N),ON,B$,(7+(N*25),43)-(27+(25*N),57),BUTTON,1,"DICT.FONT",8,0
          BOTS(50+N)=Z1(N)
        END IF
      ELSE
        GADGET CLOSE (194+N)
      END IF
    NEXT N
    IF Z1(7)>0 THEN
      IF BOTS(57)<>Z1(7) THEN
        GADGET CLOSE 255
        CALL _CONVERT(Z1(7))
        GADGET 255,ON,B$,(187,43)-(207,57),BUTTON,1,"DICT.FONT",8,0
        BOTS(57)=Z1(7)
      END IF
    ELSE
      GADGET CLOSE 255
    END IF
END SUB
SUB _ABOUT
  WHILE 1=1
    REPEAT
      GADGET WAIT 0
      THEGADGET = GADGET(1)
    UNTIL THEGADGET <= 256
    IF THEGADGET = 256 OR THEGADGET = 254 THEN
      CALL _QUIT
    END IF
    IF THEGADGET = 255 THEN
      CALL _WIPE1
      CALL _REMOVE
      EXIT SUB
    END IF
  WEND
END SUB
SUB _NUMBER1
  SHARED BOTS()
  SHARED Z1()
  SHARED Y1()
  FOR N=1 TO 7
    Y1(N)=Z1(N)
  NEXT N
  4
  WHILE 1=1
    REPEAT
      GADGET WAIT 0
      THEGADGET = GADGET(1)
    UNTIL THEGADGET <= 256
    IF THEGADGET = 256 THEN
      CALL _QUIT
    END IF
    IF THEGADGET = 253 THEN
      CALL _PRINTER1(1)
      CLOSE #6
    END IF
    IF THEGADGET = 252 THEN
      FOR N=1 TO 7
        BOTS(50+N)=0
        Z1(N)=0
      NEXT N
      CALL _BUTTON4
      GOTO 4
    END IF
    IF THEGADGET = 254 THEN
      CALL _BOTCLEAR
      CALL _REMOVE1
      EXIT SUB
    END IF
    IF THEGADGET = 251 THEN
      FOR N=1 TO 7
        Z1(N)=Y1(N)
      NEXT N
      CALL _BOTCLEAR
      CALL _REMOVE1
      EXIT SUB
    END IF
    IF THEGADGET >= 201 AND THEGADGET <= 249 THEN
      FOR N=1 TO 7
        IF Z1(N) = 0 THEN
          Z1(N) = THEGADGET-200
          CALL _BUTTON4
          GOTO 4
        END IF
      NEXT N
    END IF
    IF THEGADGET = 250 THEN
      FOR N=7 TO 1 STEP -1
        IF Z1(N) > 0 THEN
          BOTS(50+N)=0
          Z1(N) = 0
          CALL _BUTTON4
          GOTO 4
        END IF
      NEXT N
    END IF
  WEND
END SUB
SUB _MAIN
  SHORTINT THEGADGET, n
  WINDOW 9,"LoTo98 from TickSoft",(191,34)-(438,196+SCREEN(6)),30,0 '9,4
'  BEVELBOX (14,8)-(225,64),2
'  BEVELBOX (14,68)-(225,155),2
  BEVELBOX (14,8)-(225,148),2
 ' BEVELBOX (5,4)-(234,159),1
  BEVELBOX (21,12)-(218,60),1 'TEST
  CALL _BOTCLEAR
  CALL _BUTTON
  CALL _LOGO(42,21,8,4)
  CALL _WINDOW
END SUB
SUB _COMPUTE2(LONGINT NUM)
  SHARED Z1()
  LONGINT TESTER
  FOR N = 1 TO 6
    Z1(N)=0
  NEXT N
  CALL _MENU1
  CALL _PERCENT(51,77,100,5,250)
  FOR N = 1 TO 6
    TESTER = NUM
      REPEAT
        REPEAT
          RANDOM = RND (49)
          RANDOM = RANDOM * 49
          RANDOM = FIX(RANDOM)
        UNTIL RANDOM >=1 AND RANDOM <= 49
        TESTER = TESTER - 1
        IF GADGET(0) = -1 THEN
          IF GADGET(1) = 254 THEN
            CALL _REMOVE
            FOR N = 1 TO 6
              Z1(N)=0
            NEXT N
            EXIT SUB
          ELSE
            CALL _QUIT
          END IF
        END IF
      UNTIL TESTER = 0 
      Z1(N) = RANDOM
      CALL _CONCALC(N)
      IF Z1(BC1) = Z1(N) or Z1(BC2) = Z1(N) or Z1(BC3) = Z1(N) or Z1(BC4) = Z1(N) or Z1(BC5) = Z1(N) THEN
        N = N - 1
      END IF
    CALL _PERCENT(51,77,100,5,(N/6)*100)
  NEXT N
  CALL _PERCENT(51,77,100,5,100)
  CALL _WIPE2
  CALL _REMOVE
  CALL _BUTTON10
  CALL _MENU
END SUB
SUB _COMPUTE1(LONGINT NUM)
  SHARED Z1()
  DIM LONGINT NUMB(50)
  FOR N = 1 TO 49
    NUMB(N)=0
  NEXT N
  FOR N = 1 TO 6
    Z1(N)=0
  NEXT N
  CALL _MENU1
  7
  CALL _PERCENT(51,77,100,5,250)
  REPEAT
    REPEAT
      RANDOM = RND (49)
      RANDOM = RANDOM * 49
      RANDOM = FIX(RANDOM)
    UNTIL RANDOM >=1 AND RANDOM <= 49
    NUMB(RANDOM) = NUMB(RANDOM)+1
    FOR NN = 1 TO 6
      CALL _CONCALC(NN)
      FOR N = 1 TO 49
        IF Z1(BC1) <> N AND Z1(BC2) <> N AND Z1(BC3) <> N AND Z1(BC4) <> N AND Z1(BC5) <> N THEN
          IF NUMB(Z1(NN)) < NUMB(N) THEN 
            Z1(NN) = N
          END IF
        END IF
      NEXT N
    NEXT NN
    PERT=(NUMB(Z1(6))/NUM)*100
    CALL _PERCENT(51,77,100,5,PERT)
    IF GADGET(0) = -1 THEN
      IF GADGET(1) = 254 THEN
        CALL _REMOVE
        FOR N = 1 TO 49
          NUMB(N)=0
        NEXT N
        FOR N = 1 TO 6
          Z1(N)=0
        NEXT N
        EXIT SUB
      ELSE
        CALL _QUIT
      END IF
    END IF
  UNTIL NUMB(Z1(6))=NUM
  CALL _PERCENT(51,77,100,5,100)
  FOR N = 1 TO 6
    IF Z1(N) = 0 THEN
      NUM = 6
      CALL _PERCENT(51,77,100,5,101)
      GOTO 7
    END IF
  NEXT N
  CALL _WIPE2
  CALL _REMOVE
  CALL _BUTTON10
  CALL _MENU
END SUB
SUB _COMPUTE(LONGINT NUM)
  SHARED Z1()
  DIM LONGINT NUMB(50)
  FOR N = 1 TO 49
    NUMB(N)=0
  NEXT N
  FOR N = 1 TO 6
    Z1(N)=0
  NEXT N
  CALL _MENU1
  6
  CALL _PERCENT(51,77,100,5,250)
  FOR X=1 TO NUM
    REPEAT
      RANDOM=RND(49)
      RANDOM=RANDOM*49
      RANDOM=FIX(RANDOM)
    UNTIL RANDOM >= 1 AND RANDOM <= 49
    NUMB(RANDOM) = NUMB(RANDOM)+1
    PERT=(X/NUM)*100
    CALL _PERCENT(51,77,100,5,PERT) 
    IF GADGET(0) = -1 THEN
      IF GADGET(1) = 254 THEN
        CALL _REMOVE
        FOR N = 1 TO 49
          NUMB(N)=0
        NEXT N
        FOR N = 1 TO 6
          Z1(N)=0
        NEXT N
        EXIT SUB
      ELSE
        CALL _QUIT
      END IF
    END IF
  NEXT X
  CALL _PERCENT(51,77,100,5,100) 
  FOR NN = 1 TO 6
    CALL _CONCALC(NN)
    FOR N = 1 TO 49
      IF Z1(BC1) <> N AND Z1(BC2) <> N AND Z1(BC3) <> N AND Z1(BC4) <> N AND Z1(BC5) <> N THEN
        IF NUMB(Z1(NN)) < NUMB(N) THEN 
            Z1(NN) = N
        END IF
      END IF
    NEXT N
  NEXT NN
  FOR N = 1 TO 6
    IF Z1(N) = 0 THEN
      NUM = 6
      CALL _PERCENT(51,77,100,5,101)
      GOTO 6
    END IF
  NEXT N
  CALL _WIPE2
  CALL _REMOVE
  CALL _BUTTON10
  CALL _MENU
END SUB
SUB _BUTTON10
  SHARED Z1()
  Z$="Someone"
  CALL _WIPE
  CALL _LOGO(80,17,4,2)
  BEVELBOX (21,63)-(218,130),1
  FONT "DICT.FONT",8 : STYLE 0
  GADGET 245,ON,Z$,(31,48)-(220,60),STRING,1,"DICT.FONT",8,0
  PENUP : SETXY 27,41 : PRINT "Enter a name followed by return"
  FONT "DICT.FONT",8 : STYLE 2
  PENUP : SETXY 31,72 : PRINT "The numbers generated include:"
  FONT "DICT.FONT",8 : STYLE 0
  FOR N=1 TO 6 STEP +1
    IF Z1(N)>0 THEN
      GADGET CLOSE (245+N)
      CALL _CONVERT(Z1(N))
      GADGET (245+N),ON,B$,(21+(N*25),75)-(41+(N*25),87),BUTTON,1,"DICT.FONT",8,0
    END IF
  NEXT N
  PENUP : SETXY 26,94 : PRINT "These numbers can now  be added
  PENUP : SETXY 26,102 : PRINT "to  the   database   ready  for"
  PENUP : SETXY 26,110 : PRINT "checking, by pressing, save it."
  PENUP : SETXY 26,118 : PRINT "They can  also  be  printed  by"
  PENUP : SETXY 26,126 : PRINT "pressing the print button  now."
  GADGET 255,ON,"Go Back",(21,133)-(69,145),BUTTON,1,"DICT.FONT",8,0
  GADGET 254,OFF,"Stop",(72,133)-(119,145),BUTTON,1,"DICT.FONT",8,0
  GADGET 253,ON,"Print",(121,133)-(169,145),BUTTON,1,"DICT.FONT",8,0
  GADGET 252,ON,"Save It",(171,133)-(219,145),BUTTON,1,"DICT.FONT",8,0
END SUB
SUB _MENU
  SHARED Z1()
  WHILE 1=1
    REPEAT
      GADGET WAIT 0
      THEGADGET = GADGET(1)
    UNTIL THEGADGET <= 256
    IF THEGADGET = 256 THEN
      CALL _QUIT
    END IF
    IF THEGADGET = 255 THEN
      FOR N = 0 TO 7
        Z1(N) = 0
      NEXT N
      CALL _WIPE
      CALL _WIPE1
      CALL _REMOVE2
      CALL _LOGO(42,21,8,4)
      EXIT SUB
    END IF
    IF THEGADGET = 253 THEN
      CALL _PRINTER1(2)
      CLOSE #6
    END IF
    IF THEGADGET = 252 THEN
      CALL _WIPE
      CALL _WIPE1
      CALL _REMOVE2
      CALL _LOGO(42,21,8,4)
      CALL _BUTTON1(0)
      CALL _DATABASE(1)
      CALL _WIPE
      CALL _BUTTON10
    END IF
    IF THEGADGET = 245 THEN
      N = LEN(CSTR(GADGET(2)))
      IF N <= 10 THEN
        Z$ = CSTR(GADGET(2))
      ELSE
        MSGBOX "Please use no more than 10 characters!","Okay, I'll do that."
      END IF
    END IF
  WEND
END SUB
SUB _RANDOM1(TEMP)
  DEFLNG NUM
  NUM=20
  WHILE 1=1
    REPEAT
      GADGET WAIT 0
      THEGADGET = GADGET(1)
    UNTIL THEGADGET <=256
    IF THEGADGET = 256 THEN
      CALL _QUIT
    END IF
    IF THEGADGET = 254 THEN
      CALL _WIPE1
      CALL _REMOVE
      EXIT SUB
    END IF
    IF THEGADGET = 255 THEN
      NUM=GADGET(2)
      IF NUM >= 6 AND NUM <= 2100000000 THEN
        GADGET CLOSE 253
        GADGET 253,ON,"Accept",(122,133)-(219,145),BUTTON,1,"DICT.FONT",8,0
      END IF
      IF NUM < 6 THEN
        GADGET CLOSE 253
        GADGET 253,OFF,"Accept",(122,133)-(219,145),BUTTON,1,"DICT.FONT",8,0
      END IF
    END IF
    IF THEGADGET = 253 THEN
      CALL _WIPE2
      CALL _REMOVE
      CALL _BUTTON9
      IF TEMP = 1 THEN
        CALL _COMPUTE(NUM)
      END IF
      IF TEMP = 2 THEN
        CALL _COMPUTE1(NUM)
      END IF
      IF TEMP = 3 THEN
        CALL _COMPUTE2(NUM)
      END IF
      CALL _WIPE1
      CALL _REMOVE
      EXIT SUB
    END IF
  WEND
END SUB
SUB _RANDOM
  WHILE 1=1
    REPEAT
      GADGET WAIT 0
      THEGADGET = GADGET(1)
    UNTIL THEGADGET <= 256
    IF THEGADGET = 256 OR THEGADGET = 249 THEN
      CALL _QUIT    
    END IF
    IF THEGADGET = 250 THEN
      CALL _REMOVE
      EXIT SUB
    END IF
    IF THEGADGET = 255 THEN
      CALL _REMOVE
      CALL _BUTTON7
      CALL _BUTTON8
      CALL _RANDOM1(1)
      CALL _BUTTON6
    END IF
    IF THEGADGET = 254 THEN
      CALL _REMOVE
      CALL _BUTTON7
      CALL _BUTTON11
      CALL _RANDOM1(2)
      CALL _BUTTON6
    END IF
    IF THEGADGET = 253 THEN
      CALL _REMOVE
      CALL _BUTTON7
      CALL _BUTTON12
      CALL _RANDOM1(3)
      CALL _BUTTON6
    END IF
  WEND
END SUB
SUB _WINDOW
  SHARED Z1()
  WHILE 1=1
    REPEAT
      GADGET WAIT 0
      THEGADGET = GADGET(1)
    UNTIL THEGADGET <= 256
    IF THEGADGET = 256 OR THEGADGET = 249 THEN
      CALL _QUIT
    END IF
    IF THEGADGET = 255 THEN
      CALL _REMOVE
      CALL _BUTTON6
      CALL _RANDOM
      CALL _BUTTON
    END IF
    IF THEGADGET = 254 THEN
      CALL _REMOVE
      CALL _BUTTON1(0)
      CALL _DATABASE(0)
      CALL _BUTTON
    END IF
    IF THEGADGET = 252 THEN
      CALL _REMOVE
      CALL _BUTTON1(1)
      CALL _DATABASE2
      CALL _BUTTON
    END IF
    IF THEGADGET = 250 THEN
      CALL _REMOVE
      CALL _BUTTON13
      CALL _ABOUT
      CALL _BUTTON
    END IF
    IF THEGADGET = 251 THEN
      CALL _PRINTER1(4)
      CLOSE #6
    END IF
    IF THEGADGET = 253 THEN
      OPEN "I",#1,"SYS:S/LOTTO-CHECK1.DATA"
        FOR N=1 TO 7 STEP +1
          INPUT #1,A
          Z1(N)=A
        NEXT N
      CLOSE #1
      CALL _REMOVE
      CALL _WIPE
      CALL _BUTTON4
      CALL _LOGO(80,16,4,2) 'LOGO ADDED BECAUSE NO ROOM ANYWHERE
      CALL _NUMBER1
      OPEN "O",#1,"SYS:S/LOTTO-CHECK1.DATA"
      FOR N=1 TO 7 STEP +1
        PRINT #1,Z1(N)
        Z1(N)=0
      NEXT N
      CLOSE #1
      CALL _WIPE
      CALL _LOGO(42,21,8,4)
      CALL _BUTTON
    END IF
  WEND
END SUB
SUB _BUTTON3
  SHARED BOTS()
  SHARED Z1()
  FOR N=0 TO 4
    FOR N1=1 TO 10
      CALL _CONVERT(((N*10)+N1))
      IF Z1(1)=((N*10)+N1) OR Z1(2)=((N*10)+N1) OR Z1(3)=((N*10)+N1) OR Z1(4)=((N*10)+N1) OR Z1(5)=((N*10)+N1) OR Z1(6)=((N*10)+N1) THEN
        IF BOTS((N*10)+N1)=0 OR BOTS((N*10)+N1)=2 THEN
          IF ((N*10)+N1) <> 50 THEN
            IF BOTS((N*10)+N1)=2 THEN
              GADGET CLOSE (200+((N*10)+N1))
            END IF
            GADGET (200+((N*10)+N1)),OFF,B$,(((20*N1)+1),(63+(N*14)))-(((20*N1)+19),(75+(N*14))),BUTTON,1,"DICT.FONT",8,0
            BOTS((N*10)+N1)=1
          END IF
        END IF
      ELSE
        IF BOTS((N*10)+N1)=0 OR BOTS((N*10)+N1)=1 THEN
          IF ((N*10)+N1) <> 50 THEN
            IF BOTS((N*10)+N1)=1 THEN
              GADGET CLOSE (200+((N*10)+N1))
            END IF
            GADGET (200+((N*10)+N1)),ON,B$,(((20*N1)+1),(63+(N*14)))-(((20*N1)+19),(75+(N*14))),BUTTON,1,"DICT.FONT",8,0
            BOTS((N*10)+N1)=2
          END IF
        END IF
      END IF
    NEXT N1
  NEXT N
  IF Z1(1)>0 OR Z1(2)>0 OR Z1(3)>0 OR Z1(4)>0 OR Z1(5)>0 OR Z1(6)>0 THEN
    IF BOTS(50)=0 OR BOTS(50)=2 THEN
      IF BOTS(50)=2 THEN
        GADGET CLOSE 250
      END IF
      GADGET 250,ON,"<-",(201,119)-(219,131),BUTTON,1,"DICT.FONT",8,0
      BOTS(50)=1
    END IF
  ELSE
    IF BOTS(50)=0 OR BOTS(50)=1 THEN
      IF BOTS(50)=1 THEN
        GADGET CLOSE 250
      END IF
      GADGET 250,OFF,"<-",(201,119)-(219,131),BUTTON,1,"DICT.FONT",8,0
      BOTS(50)=2
    END IF
  END IF
  GADGET 251,ON,"Cancel",(21,133)-(69,145),BUTTON,1,"DICT.FONT",8,0
  IF Z1(1)>0 OR Z1(2)>0 OR Z1(3)>0 OR Z1(4)>0 OR Z1(5)>0 OR Z1(6)>0 THEN
    IF BOTS(60)<>1 THEN
      GADGET CLOSE 252
      GADGET 252,ON,"Clear",(71,133)-(119,145),BUTTON,1,"DICT.FONT",8,0
      BOTS(60)=1
    END IF
  ELSE
    IF BOTS(60)<>2 THEN
      GADGET CLOSE 252
      GADGET 252,OFF,"Clear",(71,133)-(119,145),BUTTON,1,"DICT.FONT",8,0
      BOTS(60)=2
    END IF
  END IF
  IF Z1(1)>0 AND Z1(2)>0 AND Z1(3)>0 AND Z1(4)>0 AND Z1(5)>0 AND Z1(6)>0 THEN
    IF BOTS(59)<>1 THEN
      GADGET CLOSE 253
      GADGET 253,ON,"Print",(121,133)-(169,145),BUTTON,1,"DICT.FONT",8,0
      BOTS(59)=1
    END IF
  ELSE
    IF BOTS(59)<>2 THEN
      GADGET CLOSE 253
      GADGET 253,OFF,"Print",(121,133)-(169,145),BUTTON,1,"DICT.FONT",8,0
      BOTS(59)=2
    END IF
  END IF
  IF Z1(1)>0 AND Z1(2)>0 AND Z1(3)>0 AND Z1(4)>0 AND Z1(5)>0 AND Z1(6)>0 THEN
    IF BOTS(58)<>1 THEN
      GADGET CLOSE 254
      GADGET 254,ON,"Accept",(171,133)-(219,145),BUTTON,1,"DICT.FONT",8,0
      BOTS(58)=1
    END IF
  ELSE
    IF BOTS(58)=1 THEN
      GADGET CLOSE 254
      GADGET 254,OFF,"Accept",(171,133)-(219,145),BUTTON,1,"DICT.FONT",8,0
      BOTS(58)=2
    END IF
    IF Z1(1)=0 THEN
      IF BOTS(58)<>1 THEN
        GADGET CLOSE 254
        GADGET 254,ON,"Accept",(171,133)-(219,145),BUTTON,1,"DICT.FONT",8,0
        BOTS(58)=1
      END IF
    END IF
  END IF
  FONT "DICT.FONT",8 : STYLE 0
  GADGET 255,ON,Z$,(31,48)-(220,60),STRING,1,"DICT.FONT",8,0
  PENUP : SETXY 27,41 : PRINT "Enter a name followed by return"
 ' PENUP : SETXY 30,49 : PRINT "and then click on the 6 numbers:"
  FOR N=1 TO 6 STEP +1
    IF Z1(N)>0 THEN
      IF BOTS(50+N)<>Z1(N) THEN
        GADGET CLOSE (194+N)
        CALL _CONVERT(Z1(N))
        GADGET (194+N),ON,B$,(21+(N*25),17)-(41+(N*25),31),BUTTON,1,"DICT.FONT",8,0
        BOTS(50+N)=Z1(N)
      END IF
    ELSE
      GADGET CLOSE (194+N)
    END IF
  NEXT N
END SUB
SUB _NUMBER
  SHARED BOTS()
  SHARED Z1()
  SHARED Y1()
  Y$=Z$
  FOR N=0 TO 6
    Y1(N)=Z1(N)
  NEXT N
  3
  WHILE 1=1
    REPEAT
      GADGET WAIT 0
      THEGADGET = GADGET(1)
    UNTIL THEGADGET <= 256
    IF THEGADGET = 254 THEN
      CALL _BOTCLEAR
      CALL _REMOVE1
      IF Z1(0) = 0 THEN
        Z$ = "Someone"
      END IF
      EXIT SUB
    END IF
    IF THEGADGET = 251 THEN
      Z$=Y$
      FOR N=0 TO 6
        Z1(N)=Y1(N)
      NEXT N
      CALL _BOTCLEAR
      CALL _REMOVE1
      EXIT SUB
    END IF
    IF THEGADGET = 256 THEN
      CALL _QUIT
    END IF
    IF THEGADGET = 255 THEN
      N=LEN(CSTR(GADGET(2)))
      IF N <=10 THEN
        Z$ = CSTR(GADGET(2))
      ELSE
        MSGBOX "Please use no more than 10 characters!","Okay, I'll do that."
      END IF
      CALL _BUTTON3
      GOTO 3
    END IF
    IF THEGADGET = 253 THEN
      CALL _PRINTER1(3)
      CLOSE #6
    END IF
    IF THEGADGET = 252 THEN
      Z$ = "Someone"
      Z1(0) = 0
      FOR N=1 TO 6 STEP +1
        BOTS(50+N)=0
        Z1(N) = 0
      NEXT N
      CALL _BUTTON3
      GOTO 3
    END IF
    IF THEGADGET = 250 THEN
      FOR N=6 TO 2 STEP -1
        IF Z1(N) > 0 THEN
          BOTS(50+N)=0
          Z1(N) = 0
          CALL _BUTTON3
          GOTO 3
        END IF
      NEXT N
      IF Z1(1) > 0 THEN
        BOTS(51)=0
        Z1(0) = 0
        Z1(1) = 0
        CALL _BUTTON3
        GOTO 3
      END IF
    END IF
    IF Z1(1)<1 OR Z1(2)<1 OR Z1(3)<1 OR Z1(4)<1 OR Z1(5)<1 OR Z1(6)<1 THEN
      IF THEGADGET >=201 AND THEGADGET <=249 THEN 
        FOR N = 1 TO 5 STEP +1
          IF Z1(N) = 0 THEN
            Z1(N) = THEGADGET-200)
            CALL _BUTTON3
            GOTO 3
          END IF
        NEXT N
        IF Z1(6) = 0 THEN
          Z1(6) = THEGADGET-200
          CALL _BUTTON3
          Z1(0)=1
          GOTO 3
        END IF
      END IF
    END IF
  WEND
END SUB
SUB _BUTTON1(NN)
  DIM A1(5)
  DIM B2$(5)
  OPEN "I",#1,"SYS:S/LOTTO-CHECK.DATA"
  OPEN "I",#2,"SYS:S/LOTTO-CHECK2.DATA"
  OPEN "I",#3,"SYS:S/LOTTO-CHECK3.DATA"
  OPEN "I",#4,"SYS:S/LOTTO-CHECK4.DATA"
  OPEN "I",#5,"SYS:S/LOTTO-CHECK5.DATA"
  FOR N = 1 TO 5
    INPUT #N,A1(N)
    INPUT #N,A1(0)
    A1(N)=A1(N)+A1(0)
    INPUT #N,A1(0)
    A1(N)=A1(N)+A1(0)
    INPUT #N,A1(0)
    A1(N)=A1(N)+A1(0)
    INPUT #N,A1(0)
    A1(N)=A1(N)+A1(0)
    CLOSE #N
  NEXT N
  {* B1$ = "Edit 01 To 05 (" *}
  B3$ = "/5 USED)" 
  FOR N = 1 TO 5
    CALL _CONVERT(A1(N))
    B2$(N)=B$
    IF NN=0 THEN
      CAR$="Edit"
    ELSE
      CAR$="View"
    END IF
    B2$(N)=B2$(N)+B3$
  NEXT N
  GADGET 251,ON,CAR$+" 01 To 05 ("+B2$(1),(21,63)-(219,75),BUTTON,1,"DICT.FONT",8,0
  GADGET 252,ON,CAR$+" 09 To 10 ("+B2$(2),(21,77)-(219,89),BUTTON,1,"DICT.FONT",8,0
  GADGET 253,ON,CAR$+" 11 To 15 ("+B2$(3),(21,91)-(219,103),BUTTON,1,"DICT.FONT",8,0
  GADGET 254,ON,CAR$+" 16 To 20 ("+B2$(4),(21,105)-(219,117),BUTTON,1,"DICT.FONT",8,0
  GADGET 255,ON,CAR$+" 21 To 25 ("+B2$(5),(21,119)-(219,131),BUTTON,1,"DICT.FONT",8,0
  GADGET 250,ON,"Go Back",(21,133)-(118,145),BUTTON,1,"DICT.FONT",8,0
  GADGET 249,ON,"Quit",(122,133)-(219,145),BUTTON,1,"DICT.FONT",8,0
END SUB
SUB _DATABASE(TEMP)
  WHILE 1=1
    REPEAT
      GADGET WAIT 0
      THEGADGET = GADGET(1)
    UNTIL THEGADGET <= 256
    IF THEGADGET = 249 OR THEGADGET = 256 THEN
      CALL _QUIT
    END IF
    IF THEGADGET = 250 THEN
      CALL _REMOVE
      EXIT SUB
    END IF
    IF THEGADGET >= 251 AND THEGADGET <=255 THEN
      IF TEMP = 0 THEN
        T = THEGADGET
        CALL _REMOVE
        CALL _BUTTON2
        CALL _DATABASE1(0)
        CALL _BUTTON1(0)
      ELSE
        T = THEGADGET
        CALL _REMOVE
        CALL _BUTTON2
        CALL _DATABASE1(1)
        CALL _BUTTON1(1)
      END IF
    END IF
  WEND
END SUB
SUB _DATABASE4
  SHARED C$()
  SHARED ED$()
  WHILE 1=1
    REPEAT
      GADGET WAIT 0
      THEGADGET = GADGET(1)    
    UNTIL THEGADGET <= 256
    IF THEGADGET = 249 OR THEGADGET = 256 THEN
      CALL _QUIT
    END IF
    IF THEGADGET >= 251 AND THEGADGET <= 255 THEN
      CALL _PRINTER1(0)
      PRINT #6,"As a result of the recent draw ";C$(THEGADGET-250);" got ";ED$(THEGADGET-250);"."
      PRINT #6,""
      CLOSE #6
    END IF
    IF THEGADGET = 250 THEN
      CALL _REMOVE
      EXIT SUB
    END IF
  WEND
END SUB
SUB _DATABASE2
  WHILE 1=1
    REPEAT
      GADGET WAIT 0
      THEGADGET = GADGET(1)
    UNTIL THEGADGET <= 256
    IF THEGADGET = 249 OR THEGADGET = 256 THEN
      CALL _QUIT
    END IF
    IF THEGADGET = 250 THEN
      CALL _REMOVE
      EXIT SUB
    END IF
    IF THEGADGET >= 251 AND THEGADGET <= 255 THEN
      T = THEGADGET
      CALL _REMOVE
      CALL _BUTTON5
      CALL _DATABASE4
      CALL _REMOVE
      CALL _BUTTON1(1)
    END IF
  WEND
END SUB
SUB _BUTTON5
  SHARED B()
  SHARED B1$()
  SHARED C$()
  SHARED ED$()
  DIM D1(8)
  DIM E(6)
  FOR N=0 TO 5
    D1(N)=0
    E(N)=0
    ED$(N)=""
  NEXT N
  E(6)=0
  E(7)=0
  IF T = 251 THEN
    OPEN "I",#1,"SYS:S/LOTTO-CHECK.DATA"
  END IF
  IF T = 252 THEN
    OPEN "I",#1,"SYS:S/LOTTO-CHECK2.DATA"
  END IF
  IF T = 253 THEN
    OPEN "I",#1,"SYS:S/LOTTO-CHECK3.DATA"
  END IF
  IF T = 254 THEN
    OPEN "I",#1,"SYS:S/LOTTO-CHECK4.DATA"
  END IF
  IF T = 255 THEN
    OPEN "I",#1,"SYS:S/LOTTO-CHECK5.DATA"
  END IF
  OPEN "I",#2,"SYS:S/LOTTO-CHECK1.DATA"
  FOR N=0 TO 6
    INPUT #1,B(N)
    INPUT #1,B(N+7)
    INPUT #1,B(N+14)
    INPUT #1,B(N+21)
    INPUT #1,B(N+28)
  NEXT N
  FOR N=1 TO 5
    INPUT #1,C$(N)
    NN=LEN(C$(N))
    IF NN > 10 THEN
      C$(N)="Long Name"
    END IF
  NEXT N
  FOR N=1 TO 7
    INPUT #2,D1(N)
  NEXT N
  CLOSE #1
  CLOSE #2
  FOR Y=1 TO 6
    FOR N=1 TO 6
      FOR A=0 TO 4
        IF B(Y+(A*7))=D1(N) THEN
          E(A+1)=E(A+1)+1
        END IF
      NEXT A
    NEXT N
  NEXT Y
  FOR Y=1 TO 6
    FOR A=0 TO 4
      IF E(A+1)=5 THEN
        IF B(Y+(A*7))=D1(7) THEN
          E(A+1)=7
        END IF
      END IF
    NEXT A
  NEXT Y
  FOR N = 1 TO 5
    CALL _CONVERT1(E(N))
    ED$(N)=B$
  NEXT N
  FOR N=0 TO 4
    IF B(N*7) = 1 THEN
      GADGET (250+(N+1)),ON,C$(N+1)+" Got "+ED$(N+1),(21,63+(N*14))-(219,75+(N*14)),BUTTON,1,"DICT.FONT",8,0
    ELSE
      GADGET (250+(N+1)),OFF,"This Board Was Not Used",(21,63+(N*14))-(219,75+(N*14)),BUTTON,1,"DICT.FONT",8,0
    END IF
  NEXT N
  GADGET 250,ON,"Go Back",(21,133)-(118,145),BUTTON,1,"DICT.FONT",8,0
  GADGET 249,ON,"Quit",(122,133)-(219,145),BUTTON,1,"DICT.FONT",8,0
END SUB
SUB _BUTTON2
  SHARED B()
  SHARED B1$()
  SHARED C$()
  IF T = 251 THEN
    OPEN "I",#1,"SYS:S/LOTTO-CHECK.DATA"
  END IF
  IF T = 252 THEN
    OPEN "I",#1,"SYS:S/LOTTO-CHECK2.DATA"
  END IF
  IF T = 253 THEN
    OPEN "I",#1,"SYS:S/LOTTO-CHECK3.DATA"
  END IF
  IF T = 254 THEN
    OPEN "I",#1,"SYS:S/LOTTO-CHECK4.DATA"
  END IF
  IF T = 255 THEN
    OPEN "I",#1,"SYS:S/LOTTO-CHECK5.DATA"
  END IF
  FOR N=0 TO 6
    INPUT #1,B(N)
    B1$(N)=STR$(B(N))
    INPUT #1,B(N+7)
    B1$(N+7)=STR$(B(N+7))
    INPUT #1,B(N+14)
    B1$(N+14)=STR$(B(N+14))
    INPUT #1,B(N+21)
    B1$(N+21)=STR$(B(N+21))
    INPUT #1,B(N+28)
    B1$(N+28)=STR$(B(N+28))
  NEXT N
  FOR N=1 TO 5
    INPUT #1,C$(N)
    NN=LEN(C$(N))
    IF NN > 10 THEN
      C$(N)="Long Name"
    END IF
  NEXT N
  CLOSE #1
  FOR N=0 TO 4
    IF B(N*7) = 1 THEN
      GADGET (251+N),ON,C$(N+1)+":"+B1$(1+(7*N))+B1$(2+(7*N))+B1$(3+(7*N))+B1$(4+(7*N))+B1$(5+(7*N))+B1$(6+(7*N)),(21,63+(N*14))-(219,75+(N*14)),BUTTON,1,"DICT.FONT",8,0
    ELSE
      GADGET (251+N),ON,"Click Here To Use This Board",(21,63+(14*N))-(219,75+(14*N)),BUTTON,1,"DICT.FONT",8,0
    END IF
  NEXT N
  GADGET 250,ON,"Go Back",(21,133)-(118,145),BUTTON,1,"DICT.FONT",8,0
  GADGET 249,ON,"Quit",(122,133)-(219,145),BUTTON,1,"DICT.FONT",8,0
END SUB
SUB _DATABASE1(TEMP)
  SHARED B()
  SHARED B1$()
  SHARED C$()
  SHARED Z1()
  WHILE 1=1
    REPEAT
      GADGET WAIT 0
      THEGADGET = GADGET(1)
    UNTIL THEGADGET <= 256
    IF THEGADGET = 249 OR THEGADGET = 256 THEN
      CALL _QUIT
    END IF
    IF THEGADGET = 250 THEN
      CALL _REMOVE
      EXIT SUB
    END IF
    IF THEGADGET >= 251 AND THEGADGET <= 255 THEN
      IF TEMP = 1 THEN
        C$(THEGADGET-250)=Z$
        B(((THEGADGET-250)*7)-7)=1
        FOR N=1 TO 6 STEP +1
          B(((THEGADGET-250)*7)-(7-N))=Z1(N)
        NEXT N      
      ELSE
        CALL _REMOVE
        CALL _WIPE
        IF C$(THEGADGET-250)="" THEN
          C$(THEGADGET-250)="Someone"
        END IF
        Z$=C$(THEGADGET-250)
        Z1(0)=B(((THEGADGET-250)*7)-7)
        IF Z1(0) = 1 THEN
          FOR N=1 TO 6 STEP +1
            Z1(N)=B(((THEGADGET-250)*7)-(7-N))
          NEXT N
        END IF
        CALL _BUTTON3
        CALL _NUMBER
        C$(THEGADGET-250)=Z$
        B(((THEGADGET-250)*7)-7)=Z1(0)
        IF Z1(0) = 1 THEN
          FOR N=1 TO 6 STEP +1
            B(((THEGADGET-250)*7)-(7-N))=Z1(N)
          NEXT N
        END IF
        Z$="Someone"
        FOR N=0 TO 6 STEP +1
          Z1(N)=0
        NEXT N
        CALL _WIPE
      END IF
      IF T = 251 THEN
        OPEN "O",#1,"SYS:S/LOTTO-CHECK.DATA"
      END IF
      IF T = 252 THEN
        OPEN "O",#1,"SYS:S/LOTTO-CHECK2.DATA"
      END IF
      IF T = 253 THEN
        OPEN "O",#1,"SYS:S/LOTTO-CHECK3.DATA"
      END IF
      IF T = 254 THEN
        OPEN "O",#1,"SYS:S/LOTTO-CHECK4.DATA"
      END IF
      IF T = 255 THEN
        OPEN "O",#1,"SYS:S/LOTTO-CHECK5.DATA"
      END IF
      FOR N=0 TO 6
        PRINT #1,B(N)
        PRINT #1,B(N+7)
        PRINT #1,B(N+14)
        PRINT #1,B(N+21)
        PRINT #1,B(N+28)
      NEXT N
      FOR N=1 TO 5
        WRITE #1,C$(N)
      NEXT N
      CLOSE #1
      CALL _REMOVE
      IF TEMP <> 1 THEN
        CALL _LOGO(42,21,8,4)
      END IF
      CALL _BUTTON2
    END IF
  WEND
END SUB
