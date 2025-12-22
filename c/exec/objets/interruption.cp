// Interruption: Lundi 19-Avr-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/interruption.h>

extern NEANT asmPrologue();

Interruption::Interruption(TEXTE *nom, OCTET pri):
                           (nom, TN_INTERRUPTION, pri),
                           Code(asmPrologue), Donnee(moiMeme) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Interruption.Interruption(\""<<nom<<
          "\", "<<") {}\n";
   sode->vasY();
#endif
}

// attention: pas de debogage 
// pas en inline car interfacée avec de l'assembleur
NEANT Interruption::prologue() { interrompu(); }
