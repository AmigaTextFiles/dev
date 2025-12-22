// Message: Dimanche 16-Août-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/message.h>

Message::Message(PortMsg *portRep, TEXTE *nomMsg, OCTET pri):
                 (nomMsg, TN_MESSAGE, pri),
                 PortReponse(portRep), Longueur(tailleDe(*moiMeme)) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Message.Message("<<long(PortReponse)<<", \""<<
          Nom<<"\", "<<Pri<<") {}\n";
   sode->vasY();
#endif
}

