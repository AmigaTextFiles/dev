// Remanent: Vendredi 23-Avr-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/remanent.h>
#include <exec/execBase.h>

Remanent::Remanent(TEXTE *nomRem, TEXTE *chaineId, OCTETN type):
                   (nomRem, chaineId, type, 0),
//                   DesEnsMemRemanents(Type),
                   TabDuMod(moiMeme) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Remanent.Remanent(\""<<Nom<<
          "\",\n "<<ChaineId<<", "<<type<<") {}\n";
   sode->vasY();
#endif
}

NEANT Remanent::initialise() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Remanent.initialise() {}\n";
   sode->vasY();
#endif
}

NEANT Remanent::ajoute(EnsReqMem *ensMem) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Remanent.ajoute("<<long(ensMem)<<") {\n";
   sode->vasY();
#endif
/*   si ( SysBase->AdrDesEnsMemRemanents == NUL )
      SysBase->AdrDesEnsMemRemanents= &DesEnsMemRemanents;
   SysBase->AdrDesEnsMemRemanents->enQueue(ensMem); */

   SysBase->AdrDesEnsMemRemanents= ensMem;

   si ( SysBase->Remanents == NUL ) SysBase->Remanents= &TabDuMod;
   sinon TabDuMod.chaine(SysBase->Remanents);

   SumKickData();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

NEANT Remanent::enleve() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Remanent.enleve() {\n";
   sode->vasY();
#endif
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

