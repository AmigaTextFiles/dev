/********************************************************************
 *                                                                  *
 *                 IPC Utilities module 89:4:17                     *
 *                                                                  *
 *                  Shared Library version                          *
 *                                                                  *
 ********************************************************************/

#include "IPCStruct.h"

/*
 *  -- MakeIPCId
 *
 *  turns a 4-character string into a 32-bit ID value.
 *  -- Note: a string of less than 4 characters will be LEFT
 *     justified (high bits)
 *  -- more than 4 will be truncated.
 */

ULONG __asm MakeIPCId(register __a0 char *name)
{
    ULONG temp=0;
    int i;
    for (i=4; i--; ) {
        temp = (temp<<8) | *name;
        if (*name) name++;
    }
    return temp;
}


/*
 *  -- FindIPCItem
 *
 *  returns a pointer to the first item it finds in 'msg' that matches 'id',
 *  starting at 'item'; if 'item' is NULL, it starts at the first item.
 *  (Remember, if you are resuming a search from the last item found for
 *  another of the same name, to INCREMENT 'item' from the previous value:
 *  otherwise it will find the same item again!)
 */

struct IPCItem * __asm FindIPCItem(
                register __a0 struct IPCMessage * msg,
                register __d0 ULONG id,
                register __a1 struct IPCItem * item)
{
    int i;
    if (item)
        i = msg->ipc_ItemCount -(item - msg->ipc_Items);
    else {
        i = msg->ipc_ItemCount;
        item = msg->ipc_Items;
    }
    for ( ;i--; item++ )
        if (item->ii_Id == id) return item;
    return NULL;
}

