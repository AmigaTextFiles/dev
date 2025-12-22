// TâcheStd: Mercredi 20-Jan-93 par Gilles Dridi

#include <stdio.h>
#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/tacheStd.h>

extern NEANT CodeTerminal();

TacheStd::TacheStd(Procedure code, PortStd *portTerm,
         TEXTE *nom= NUL, OCTET pri= 0):
         (&PileTache, nom, pri),
         MessageTerm(moiMeme, nom, pri),
         AdrPortTerm(portTerm) {
   ajoute(code, CodeTerminal);
#if DEBOGUE_TACHESTD
   sode->puisJe();
   *sode<<long(this)<<": TacheStd.TacheStd("<<long(code)<<", \""<<
     Nom<<"\", "<<Pri<<")\n";
   sode->vasY();
#endif
#if DEBOGUE_TACHESTD
   sode->puisJe();
   *sode<<" vpAv "<<vpAv<<" vpAp "<<vpAp<<"\n";
   sode->vasY();
#endif
}

TacheStd::~TacheStd() {
#if DEBOGUE_TACHESTD
   sode->puisJe();
   *sode<<long(this)<<": TacheStd.~TacheStd()\n";
   sode->vasY();
#endif
   AdrPortTerm->attends();
   (((MsgTerm *)AdrPortTerm->prends())->adrExpediteur())->enleve();
   si ( ! ((AdrPortTerm->listeDesMsg()).estVide()) ) {
      EnsSig es_port((Signal)(AdrPortTerm->signalAssocie().numero()));
      es_port.signale(TrouveTache(NULLE));
   }
}
