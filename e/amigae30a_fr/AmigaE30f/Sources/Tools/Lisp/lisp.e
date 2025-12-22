-> Outils de listes!

OPT MODULE
OPT EXPORT

/*------quelques fonctions Lisp typiques--------*/

/* note: ce ne sont quasiment pas des fonctions efficientes et peuvent être
   beaucoup plus rapide en utilisant des implémetations destructifs. Elles
   par contre de très bon exemples de programmation Lisp */

-> concatène 2 listes

PROC append(x,y)
  DEF h,t
  IF x
    x <=> <h|t>
    RETURN <h|append(t,y)>
  ENDIF
ENDPROC y

-> 'naïf' : renverse un liste. Honorable : son efficience

PROC nrev(x)
  DEF h,t
  IF x
    x <=> <h|t>
    RETURN append(nrev(t),<h>)
  ENDIF
ENDPROC NIL

-> retourne une liste de résultats en appliquant fun aux éléments de l

PROC map(l,fun)
  DEF h,t
  IF l
    l <=> <h|t>
    RETURN <fun(h)|map(t,fun)>
  ENDIF
ENDPROC NIL

-> retourne une liste d'éléments de l pour lequel fun est vrai (true)

PROC filter(l,fun)
  DEF h,t,r
  IF l
    l <=> <h|t>
    r:=filter(t,fun)
    RETURN IF fun(h) THEN <h|r> ELSE r
  ENDIF
ENDPROC NIL

-> retourne 2 listes d'éléments de l pour lequel fun est vrai (true) et faux (false)

PROC partition(l,fun)
  DEF h,t,rt,rf
  IF l
    l <=> <h|t>
    rt,rf:=partition(t,fun)
    IF fun(h) THEN RETURN <h|rt>,rf ELSE RETURN rt,<h|rf>
  ENDIF
ENDPROC NIL,NIL

-> plie la fonction dans la liste, ie:
-> foldr(<1,2,3>,{add},0) = add(1,add(2,add(3,0)))

PROC foldr(l,fun,end)
  DEF h,t
  IF l
    l <=> <h|t>
    RETURN fun(h,foldr(t,fun,end))
  ENDIF
ENDPROC end

-> zip combine 2 listes dans une liste de paires.

PROC zip(x,y)
  DEF a,b,c,d
  IF x
    IF y
      x <=> <a|b>
      y <=> <c|d>
      RETURN <<a|c>|zip(b,d)>
    ENDIF
  ENDIF
ENDPROC NIL

-> longueur d'une liste

PROC length(x) IS IF x THEN length(Cdr(x))+1 ELSE 0


/*--------impression universelle de cellule---------*/

/* imprime n'importe quelle structure cellulaire en mémoire, proc(v) est
   appelé quand une valeur n'est pas une cellule. En dessous des fonctions
   prédéfinies pour les listes/arbres d'entiers et chaines  */

EXPORT PROC showcell(cell,proc)
  DEF a,c
  IF cell
    IF Cell(cell)
      WriteF('<')
      cell <=> <a|c>
      showcell(a,proc)
      IF c
        WHILE Cell(c) AND (c<>0)
          WriteF(',')
          c <=> <a|c>
          showcell(a,proc)
        ENDWHILE
        IF c
          WriteF('|')
          showcell(c,proc)
        ENDIF
        WriteF('>')
      ELSE
        WriteF('>')
      ENDIF
    ELSE
      proc(cell)
    ENDIF
  ELSE
    WriteF('<>')
  ENDIF
ENDPROC

PROC showcellint(cell) IS showcell(cell,{showint})
PROC showcellstr(cell) IS showcell(cell,{showstr})

PROC showint(x) IS WriteF('\d',x)
PROC showstr(x) IS WriteF('\s',x)

