// TblMod: Vendredi 23-Avr-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/tblMod.h>

TblMod::TblMod(Resident *mod1): Fin(NUL), Module1(mod1) {
#if DEBOGUE
   sode->puisJe();
   *sode<<this<<": TblMod.TblMod("<<long(mod1)<<") {}\n";
   sode->vasY();
#endif
}

NEANT TblMod::chaine(TblMod *tbl) {
#if DEBOGUE
   sode->puisJe();
   *sode<<this<<": TblMod.chaine("<<long(tbl)<<") {\n";
   sode->vasY();
#endif
   IterTblMod  iter(tbl); // l'itérateur est associé au tableau tbl

   tantQue( !iter.estFin() ) iter.avance();
   iter.courant()->fixeSaut(moiMeme);
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}
