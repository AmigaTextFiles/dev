

/*
 *
 *  DEAD.C
 */

#include <local/typedefs.h>

int
DeadKeyConvert(msg,buf,bufsize,keymap)
struct IntuiMessage *msg;
UBYTE *buf;
int bufsize;
struct KeyMap *keymap;
{
    static struct InputEvent ievent = { NULL, IECLASS_RAWKEY };
    if (msg->Class != RAWKEY)
	return(-2);
    ievent.ie_Code = msg->Code;
    ievent.ie_Qualifier = msg->Qualifier;
    ievent.ie_position.ie_addr = *((APTR *)msg->IAddress);
    return(RawKeyConvert(&ievent,buf,bufsize,keymap));
}

