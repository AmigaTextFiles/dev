// PortMsg: Dimanche 16-Août-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/portMsg.h>

PortMsg::PortMsg(TacMin *tacheAreveiller, TEXTE *np, OCTET pp,
                 Type_Action action):
                 (np, TN_PORTMSG, pp),
                 SignalAssocie(),
                 TacheAreveiller(tacheAreveiller),
                 ListeDesMsg(TN_MESSAGE) {
   SignalAssocie.bourre()= action; // classe Signal non hérité
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": PortMsg.PortMsg(\""<<Nom<<"\", "<<Pri<<
          ", "<<action<<") {}\n";
   sode->vasY();
#endif
}

