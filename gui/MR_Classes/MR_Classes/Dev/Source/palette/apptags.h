#ifndef APPTAGS_H
#define APPTAGS_H

#include <utility/tagitem.h>

#define APP(x)  (TAG_USER + (x))

#define APP_Red  APP( 1)
#define APP_Green  APP(2)
#define APP_Blue  APP( 3)
#define APP_RedText  APP( 4)
#define APP_GreenText  APP(5)
#define APP_BlueText  APP( 6)
#define APP_SwapMode  APP(7)
#define APP_CopyMode  APP(8)
#define APP_SpreadMode  APP(9)
#define APP_EditMode  APP( 10)
#define APP_Undo      APP(11)
#define APP_NoUndo      APP(12)

#endif /* APPTAGS_H */

