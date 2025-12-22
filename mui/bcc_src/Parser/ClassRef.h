#include "TextItem.h"
#include "ClassDef.h"

class ClassRef: public TextItem {

 ClassDef *cd;
 
public:

	ClassRef(  char *n, short len, ClassDef *cl ) : TextItem( n, len ) { cd = cl; }


};
