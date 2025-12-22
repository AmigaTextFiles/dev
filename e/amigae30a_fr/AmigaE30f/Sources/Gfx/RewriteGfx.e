/* Utilisant un script de description d'image (de type Forth)
   pour afficher des graphiques récursivement (tortues)

   Proche des grammaires normales de type s->ASA,
   les commandes tortues (de type forth) suivantes peuvent être utilisés :

   up                 stylo levé
   down               stylo baissé
   <x> <y> set        fixe la position absolue
   <d> move           déplace relativement a partir des dernières coordonnées
                      d'un distance <d> en direction del'<angle>,
                      trace une ligne si le stylo est baissé
   <angle> degr       fixe l'angle initial
   <angle> rol        tourne relativement dans le sens contraires
                      des aiguilles d'une montre (gauche)
   <angle> rol        tourne relativement dans le sens des aiguilles
                      d'une montre (droite)
   <nr> col           fixe la couleur
   push               sauve l'état de x/y/angle/stylo à ce point sur le pile
   pop                restaure létat
   dup                double le dernier contenu sur la pile
   <int> <int> add    additionne 2 entiers
   <int> <int> sub    soustrait 2 entiers (premier - second)
   <int> <int> mul    multiplie 2 entiers
   <int> <int> div    divise 2 entiers
   <int> <int> eq     regarde si 2 entiers sont égaux
   <int> <int> uneq   regarde si 2 entiers sont inégaux
   <bool> if <s> end  condition

   Traduction : Olivier ANH (BUGSS)   */

CONST CURGR=0     /* FIXEZ CECI A 0-2 POUR D'AUTRES GRAMMAIRES */

MODULE 'MathTrans'

ENUM S=1000, A,B,C,D,E,F,G, Z
CONST R=20

DEF gr[10]:ARRAY OF LONG,win,stack[5000]:ARRAY OF LONG,sp=NIL:PTR TO LONG,
    penf=TRUE,x=50.0,y=60.0,col=2,degr=0.0

/* ne construisez pas votre propre gramaire, si vous ne savez pas exactement
   ce que vous faites. Il n'y a pas de vérification d'erreurs. */

PROC initgrammar()
  gr[0]:=[[S,   A,A,A],                               /* lotsa triangles */
          [A,   25,"ror",D,D,D,D,D,D,"up",50,"move","down"],
          [D,   F,G,F,G,F,G,E],
          [E,   "up",R,"move",30,"rol",5,"move",30,"rol","down"],
          [F,   R,"move"],
          [G,   120,"rol"]]
  gr[1]:=[[S,   100,20,"set",30,A],                   /* shell */
          [A,   "dup","move",1,"sub","dup",0,"uneq","if",B,"end"],
          [B,   "dup","dup",90,"ror","move",180,"ror","up","move",
                90,"ror","down",20,"ror",A]]          /* quelques figures */
  gr[2]:=[[S,   B,B,B,B,B,B,B,B,B,B,B,B,B,B,B],
          [B,   A,A,A,A,A,A,A,A,-10,"move"],
          [A,   "down",80,"move",183,"rol"]]
ENDPROC

PROC main()
  mathtransbase:=OpenLibrary('mathtrans.library',0)
  IF mathtransbase=NIL
    WriteF('Ne peut ouvrir la "mathtrans.library".\n')
  ELSE
    win:=OpenW(20,20,600,200,$200,$F,'Rewrite Graphics',NIL,1,NIL)
    IF win=NIL
      WriteF('Ne peut ouvrir la fenêtre !\n')
    ELSE
      initgrammar()
      sp:=stack+400      /* temp */
      dorewrite(S)
      IF sp<>(stack+400) THEN WriteF('ATTENTION : la pile n''est pas propre\n')
      WaitIMessage(win)
      CloseW(win)
    ENDIF
    CloseLibrary(mathtransbase)
  ENDIF
ENDPROC

PROC dorewrite(startsym)
  DEF i:PTR TO LONG
  ForAll({i},gr[CURGR],`IF i[0]=startsym THEN dolist(i) ELSE 0)
ENDPROC

PROC dolist(list:PTR TO LONG)
  DEF r=1,sym,rada,cosa,sina,xd,yd,xo,yo,a
  WHILE r<ListLen(list)
    sym:=list[r++]
    IF sym<S
      sp[]++:=sym
    ELSE
      IF sym>Z
        SELECT sym
          CASE "down"; penf:=TRUE
          CASE "up";   penf:=FALSE
          CASE "set";  y:=sp[]--|; x:=sp[]--|
          CASE "col";  col:=sp[]--
          CASE "rol";  degr:=sp[]--|+degr
          CASE "ror";  degr:=-sp[]--|+degr
          CASE "degr"; degr:=sp[]--|
          CASE "push"; sp[]++:=x; sp[]++:=y; sp[]++:=degr; sp[]++:=penf
          CASE "pop";  sp[]--:=penf; sp[]--:=degr; sp[]--:=y; sp[]--:=x
          CASE "dup";  a:=sp[]--; sp[]++:=a; sp[]++:=a
          CASE "add";  sp[]++:=sp[]--+sp[]--
          CASE "sub";  a:=sp[]--; sp[]++:=sp[]---a
          CASE "mul";  sp[]++:=sp[]--*sp[]--
          CASE "div";  a:=sp[]--; sp[]++:=sp[]--/a
          CASE "eq";   sp[]++:=sp[]--=sp[]--
          CASE "uneq"; sp[]++:=sp[]--<>sp[]--
          CASE "end";  NOP
          CASE "if";   IF sp[]--=FALSE THEN WHILE list[r++]<>"end" DO NOP
          CASE "move"
            xo:=x; yo:=y; x:=sp[]--|+x
            rada:=|degr/180.0*3.14159
            cosa:=SpCos(rada); sina:=SpSin(rada)
            xd:=|x-xo; yd:=|y-yo
            x:=|xo+(xd*cosa)-(yd*sina)
            y:=|yo+(yd*cosa)-(xd*sina)
            IF penf THEN Line(|xo|*2,|yo|,|x|*2,|y|,col)
          DEFAULT; WriteF('ATTENTION : opcode inconnu\n')
        ENDSELECT
      ELSE
        dorewrite(sym)
      ENDIF
    ENDIF
  ENDWHILE
ENDPROC
