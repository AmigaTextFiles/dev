1000    Dim code%(71),regs%(16)
1010    Restore 10000
1020    i% = 0: Read j$
1030    While Asc(j$) <> 126
1040        If Asc(j$) = 38 Then Poke_W VarPtr(code%(0)) + i%, Val(j$): i% = i% + 2
1050        Read j$
1060    WEnd
1070    BSave "MandelMung", VarPtr(code%(0)), 282
1999    End
1 '
1 ' MANDEL - calculate Mandelbrot set membership for a point
1 '
1 '          A point C (in the complex plane) belongs to the Mandelbrot set
1 '     if, after iteratively calculating the value Zn+1 = Zn2 + C (with Zo
1 '     being 0 + 0i) the value of Z converges or stabilizes.  In this
1 '     algorithm, we actually just test if the magnitude of Z reaches or
1 '     exceeds 2.
1 '
1 ' Arguments:
1 '
1 '     D0      Cr (real component) in 2's complement fixed point binary
1 '             notation with 2 bits in front, 30 behind the binary point
1 '
1 '     D1      Ci (imaginary component)
1 '
1 '     D2      maximum number of iterations, 16 bit unsigned integer
1 '             0 means 65536
1 '
1 ' Returns:
1 '
1 '     D2      number of iterations executed
1 '
1 '     creams all data registers
1 '
1 ' Stack and register usage:
1 '
1 '     A(A7)   saved maximum iteration count (integer word)
1 '
1 '     9(A7)   -1 if Cr is negative, 0 otherwise (boolean byte)
1 '
1 '     4(A7)   absolute value of Cr
1 '
1 '     (A7)    absolute value of Ci
1 '
1 '     D0,D1,D3 miscellaneous temporaries
1 '
1 '     D2      -1 if sign of Zr differs from sign of Cr, 0 otherwise
1 '
1 '     D4      absolute value of Zr (usually) - an unsigned longword
1 '             fixed point number with 1 or 2 (depending on when)
1 '             bits in front of the binary point
1 '
1 '     D5      absolute value of Zi (usually)
1 '
1 '     D6      sign of Zi or 2ZrZi (depending on what calculation
1 '             is pending).  0 for positive, -1 for negative
1 '
1 '     D7      iterations are counted down here using DBF.  The value
1 '             starts out one less than the maximum count input in D2,
1 '             because of the behaviour of DBF
1 '
1 ' Initialize stuff, set up stack frame
1 '
1 '                     MANDEL:
10000   Data &o051502        ," SUBQ.W  #1,D2           Adjust count for DBF"
10002   Data &o037402        ," MOVE.W  D2,-(A7)        Save count on stack"
10004   Data &o037002        ," MOVE.W  D2,D7           Move count to D7"
10006   Data &o045200        ," TST.L   D0              Check sign of Cr"
10010   Data &o055702        ," SMI     D2              Set D2 if negative"
10012   Data &h6A06          ," BPL     10$             Positive, no worry"
10014   Data &o042200        ," NEG.L   D0              Cr < 0, |Cr| = -Cr"
10016   Data &h6900,&hAA     ," BVS     DONE1           Cr was -2, done"
1 '
10022   Data &o045201   ," 10$: TST.L   D1              Check sign of Ci"
10024   Data &h6A06          ," BPL     20$             Already positive"
10026   Data &o042201        ," NEG.L   D1              Nope, make it +ive"
10030   Data &h6900,&hAC     ," BVS     DONE2           Ci was -2, done"
1 '
10034   Data &o037402   ," 20$: MOVE.W  D2,-(A7)        Stack sign of Cr"
10036   Data &o027400        ," MOVE.L  D0,-(A7)        Put |Cr| on stack"
10040   Data &o027401        ," MOVE.L  D1.-(A7)        Put |Ci| on stack"
10042   Data &o074000        ," MOVEQ   #0,D4           Clear Zr"
10044   Data &o075000        ," MOVEQ   #0,D5           and Zi"
10046   Data &o076000        ," MOVEQ   #0,D6           and sign of Zi"
1 '
1 ' Add Ci to 2ZrZi and Cr to Zr2-Zi2 to get new Zi and Zr, respectively
1 '
1 '                     MNDLUP:
10050   Data &o045006        ," TST.B   D6              Check sign of 2ZrZi"
10052   Data &h660C          ," BNE     10$             Go do -ive things"
10054   Data &o155227        ," ADD.L   (A7),D5         Add Ci to 2ZrZi"
10056   Data &h6500,&h92     ," BCS     DONE            Result >= 4, done"
10062   Data &h6B00,&h8E     ," BMI     DONE            Result >= 2, done"
10066   Data &h600E          ," BRA     20$             OK, go do real part"
1 '
10070   Data &o115227   ," 10$: SUB.L   (A7),D5         Add -Ci to 2ZrZi"
10072   Data &h6506          ," BCS     15$             Negative?"
10074   Data &h6B00,&h84     ," BMI     DONE            Result >= 2, done"
10100   Data &h6004          ," BRA     20$             OK, go do real part"
1 '
10102   Data &o042205   ," 15$: NEG.L   D5              Make Zi positive"
10104   Data &o043006        ," NOT.B   D6              Note change in sign"
1 '
10106   Data &o045002   ," 20$: TST.B   D2              sgn(Zr2-Zi2)<>Sgn(Cr)"
10110   Data &h660A          ," BNE     30$             Signs <>, subtract"
10112   Data &o154257,&h4    ," ADD.L   4(A7),D4        Add Cr to Zr2-Zi2"
10116   Data &h6572          ," BCS     DONE            Result >= 4, done"
10120   Data &h6B70          ," BMI     DONE            Result >= 2, done"
10122   Data &h600E          ," BRA     40$             Go square Z"
1 '
10124   Data &o114257,&h4,"30$: SUB.L   4(A7),D4        Add -Cr to Zr2-Zi2"
10130   Data &h6504          ," BCS     35$             Negative?"
10132   Data &h6B66          ," BMI     DONE            Result >= 2, done"
10134   Data &h6004          ," BRA     40$             |Cr|<|Zr2-Zi2|"
1 '
10136   Data &o042204   ," 35$: NEG.L   D4              Think positive"
10140   Data &o043002        ," NOT.B   D2              Sign changed"
1 '
10142   Data &o132057,&h9,"40$: CMP.B   9(A7),D2        Find sign of Zr"
10146   Data &h6702          ," BEQ     45$             Positive, go on"
10150   Data &o043006        ," NOT.B   D6              Note sign of 2ZrZi"
1 '
1 ' Square Z, i.e., calculate 2ZrZi and Zr2-Zi2
1 ' also, check magnitude of Z > 2 (Zr2+Zi2 > 4)
1 '
10152   Data &o161604   ," 45$: ASL.L   #1,D4           Align Zr"
10154   Data &o161605        ," ASL.L   #1,D5           and Zi for BIGMUL"
10156   Data &o027404        ," MOVE.L  D4,-(A7)        Push Zr"
10160   Data &o027405        ," MOVE.L  D5,-(A7)        Push Zi"
10162   Data &h6158          ," BSR     BIGMUL          Get ZrZi"
10164   Data &o023037        ," MOVE.L  (A7)+,D3        High end into D3"
10166   Data &o160727        ," ASL.W   (A7)            Get top of low end"
10170   Data &o161623        ," ROXL.L  #1,D3           Make 2ZrZi"
10172   Data &o045127        ," TST.W   (A7)            Check next bit"
10174   Data &h6A02          ," BPL     50$             Is is set?"
10176   Data &o051203        ," ADDQ.L  #1,D3           Yup, round up"
1 '
10200   Data &o027204   ," 50$: MOVE.L  D4,(A7)         Put Zr on stack"
10202   Data &h6176          ," BSR     BIGSQR          Get Zr2"
10204   Data &o027405        ," MOVE.L  D5,-(A7)        Push Zi"
10206   Data &h6172          ," BSR     BIGSQR          Get Zi2"
10210   Data &o046327,&h33   ," MOVEM.L (A7),<D0,D1,D4,D5>"
10214   Data &o151205        ," ADD.L   D5,D1           Add low parts"
10216   Data &o150604        ," ADDX.L  D4,D0           Add high parts"
10220   Data &h6522          ," BCS     DONE3           Zr2+Zi2 >= 4"
10222   Data &o46337,&h33    ," MOVEM.L (A7)+,<D0,D1,D4,D5>"
10226   Data &o012057,&h9    ," MOVE.B  9(A7),D2        Get sign of Cr"
10232   Data &o115201        ," SUB.L   D1,D5           Subtract Zi2"
10234   Data &o114600        ," SUBX.L  D0,D4           from Zr2"
10236   Data &h6406          ," BCC     60$             Positive?"
10240   Data &o042205        ," NEG.L   D5              No, make it"
10242   Data &o040204        ," NEGX.L  D4              positive"
10244   Data &o043002        ," NOT.B   D2              sgn(Zr2-Zi2)<>sgn(Cr)"
1 '
10246   Data &o045205   ," 60$: TST.L   D5              Check top of bottom"
10250   Data &h6A02          ," BPL     70$             If 0, don't round"
10252   Data &o051204        ," ADDQ.L  #1,D4           Round up Zr"
1 '
10254   Data &o143505   ," 70$: EXG     D3,D5           Move 2ZrZi to D5"
10256   Data &o050717,&hFF78 ," DBF     D7,MNDLUP       ReSlog"
10262   Data &h600E          ," BRA     DONE            Out of count, done"
1 '
1 ' Various ways out
1 '
1 '                      DONE3:
10264   Data &o047757,&h10   ," LEA     10(A7),A7       Pop off Zr2, Zi2"
10270   Data &H6008          ," BRA     DONE            Go finish up"
1 '                      DONE1:
10272   Data &o045201        ," TST.L   D1              Cr=-2, does Ci=0?"
10274   Data &h6608          ," BNE     DONE2           No, no big deal"
10276   Data &o077377        ," MOVEQ   #-1,D7          Pretend we DBFed"
10300   Data &h6004          ," BRA     DONE2           Go end it all"
1 '                       DONE:
10302   Data &o047757,&hA    ," LEA     A(A7),A7        Remove Ci, Cr, flags"
1 '                      DONE2:
10306   Data &o117527        ," SUB.W   D7,(A7)         Figure how many"
10310   Data &o032037        ," MOVE.W  (A7)+,D2        times, put in D2"
10312   Data &o047165        ," RTS                     POPJ"
1 '
1 ' BIGMUL - unsigned 32 bit multiply
1 '
1 ' Arguments:
1 '
1 '     2 unsigned longwords received on the stack
1 '
1 ' Returns:
1 '
1 '     1 unsigned quadword on the stack
1
1 '     creams D0, D1, D2 and D3
1 '
1 '                     BIGMUL:
10314   Data &o046257,&hF,&h4," MOVEM.W 4(A7),<D0,D1,D2,D3>"
10322   Data &o140302        ," MULU    D2,D0           Both high order parts"
10324   Data &o141303        ," MULU    D3,D1           Both low order parts"
10326   Data &o142357,&h6    ," MULU    6(A7),D2        High by low"
10332   Data &o143357,&h4    ," MULU    4(A7),D3        Low by high"
10336   Data &o027500,&h4    ," MOVE.L  D0,4(A7)        Store high back"
10342   Data &o027501,&h8    ," MOVE.L  D1,8(A7)        Store low back"
10346   Data &o152203        ," ADD.L   D3,D2           Combine middle parts"
1 '
10350   Data &h6404  ," BIGCMN: BCC     10$             Any carry?"
10352   Data &o051157,&h4    ," ADDQ.W  #1,4(A7)        Yup, incr. top word"
1 '
10356   Data &o152657,&h6,"10$: ADD.L   D2,6(A7)        Put middle in middle"
10362   Data &h6404          ," BCC     20$             Any carry?"
10364   Data &o051157,&h4    ," ADDQ.W  #1,4(A7)        Yup, incr. top word"
1 '
10370   Data &o047165    ,"20$: RTS                     Done, return"
1 '
1 ' BIGSQR - unsigned 32 bit square
1 '
1 ' Arguments:
1 '
1 '     1 unsigned longword on the stack
1 '
1 ' Returns:
1 '
1 '     1 unsigned quadword on the stack
1 '
1 '     creams D0, D1 and D2
1 '
1 '                     BIGSQR:
10372   Data &o027427        ," MOVE.L  (A7),-(A7)      Move ret. addr. up"
10374   Data &o030057,&h8    ," MOVE.W  8(A7),D0        High order into D0"
10400   Data &o031057,&hA    ," MOVE.W  A(A7),D1        Low order into D1"
10404   Data &o032000        ," MOVE.W  D0,D2           Copy high order to D0"
10406   Data &o140300        ," MULU    D0,D0           Mpy. high by high"
10410   Data &o141301        ," MULU    D1,D1           Mpy. low by low"
10412   Data &o142357,&hA    ," MULU    A(A7),D2        Mpy. high by low"
10416   Data &o027500,&h4    ," MOVE.L  D0,4(A7)        Store high back"
10422   Data &o027501,&h8    ," MOVE.L  D1,8(A7)        Store low back"
10426   Data &o152202        ," ADD.L   D2,D2           Double the middle"
10430   Data &h60CE          ," BRA     BIGCMN          Join up with BIGMUL"
29999   Data ~
