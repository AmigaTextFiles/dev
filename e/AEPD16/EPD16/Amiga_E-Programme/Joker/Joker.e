
/*************************************************************************

:Programm.      Joker
:Beschreibung.  Ein Programm, welches den MatchPattern-Befehl ersetzt durch
                einen '*'.
:Autor.         Jörg Wach (=JCL_POWER)
:EC-Version.    EC3.0e
:OS.            > 2.04
:PRG-Version.   1.0 -> Weils mal sein mußte
                       Noch ohne Kickversion
                1.1 -> Mit Kickversion

*************************************************************************/

OPT OSVERSION=37
MODULE 'dos/dosextens'


PROC main()
DEF t1 : PTR TO doslibrary, t2 : PTR TO rootnode

    t1 := dosbase
    t2 := t1.root
    t2.flags := RNF_WILDSTAR
ENDPROC

