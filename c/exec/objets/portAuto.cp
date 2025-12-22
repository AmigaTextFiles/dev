// PortAuto: Dimanche 16-Août-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/portAuto.h>
#include <exec/tacMin.h>

PortAuto::PortAuto(TEXTE *nomPort, OCTET priPort):
                   (TrouveTache(NULLE), nomPort, priPort) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": PortAuto.PortAuto(\""<<Nom<<"\", "<<
          Pri<<") {\n";
   sode->vasY();
#endif
   SignalAssocie.alloue();
   if ( nomPort ) PortMsg::ajoute();
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<"}\n";
   sode->vasY();
#endif
}

PortAuto::~PortAuto() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": PortAuto.~PortAuto() \""<<Nom<<"\" {\n";
   sode->vasY();
#endif
   if ( Nom ) PortMsg::enleve();
   SignalAssocie.libere();
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<"}\n";
   sode->vasY();
#endif
}

