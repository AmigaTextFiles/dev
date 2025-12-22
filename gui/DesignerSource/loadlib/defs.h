
/*
 *  DEFS.H
 */

/*
#define DEBUG
*/

#define INTERNAL

typedef struct Message Message;
typedef struct Library Library;

#define abs
#include <exec/types.h>
#include <exec/ports.h>
#include <exec/semaphores.h>
#include <exec/libraries.h>
#include <exec/memory.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <string.h>

#include <dos/dosextens.h>
#include <intuition/screens.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <diskfont/diskfont.h>
#include <utility/utility.h>
#include <graphics/gfxbase.h>
#include <workbench/workbench.h>
#include <graphics/scale.h>
#include <clib/wb_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/diskfont_protos.h>

#define LibCall __geta4 __regargs
#define Prototype extern

#define  id_des1 0x44455332
#define  id_wind 0x57494e44
#define  id_gadg 0x47414447
#define  id_bevl 0x4245564c
#define  id_imag 0x494d4147
#define  id_text 0x54455854
#define  id_info 0x494e464f
#define  id_pics 0x50494353
#define  id_pic1 0x50494331
#define  id_head 0x48454144
#define  id_data 0x44415441
#define  id_strn 0x5354524e
#define  id_strl 0x5354524c
#define  id_menu 0x4d454e55
#define  id_ttle 0x54544c45
#define  id_item 0x4954454d
#define  id_subi 0x53554249
#define  id_subs 0x53554253
#define  id_itms 0x49544d53
#define  id_ttls 0x54544c53
#define  id_loca 0x4c4f4341
#define  id_loci 0x4c4f4349
#define  id_scrn 0x5343524e
#define  id_scri 0x53435249
#define  id_scrc 0x53435243
#define  id_tagi 0x54414749
#define  id_tagd 0x54414744
#define  id_tags 0x54414753
#define  id_cmap 0x434d4150


#define  TagTypeLong            0
#define  TagTypeBoolean         1
#define  TagTypeString          2
#define  TagTypeArrayByte       3
#define  TagTypeArrayWord       4
#define  TagTypeArrayLong       5
#define  TagTypeArrayString     6
#define  TagTypeStringList      7
#define  TagTypeUser            8
#define  TagTypeVisualInfo      9
#define  TagTypeDrawInfo        10
#define  TagTypeIntuiText       11
#define  TagTypeImage           12
#define  TagTypeImageData       13
#define  TagTypeLeftCoord       14
#define  TagTypeTopCoord        15
#define  TagTypeWidth           16
#define  TagTypeHeight          17
#define  TagTypeGadgetID        18
#define  TagTypeFont            19
#define  TagTypeScreen          20
#define  TagTypeGadget          21
#define  TagTypeUser2           22


#define  MYBOOL_KIND            227
#define  MYOBJECT_KIND          198

#define  CurrentDesignerFileVersion 5

#include "ProducerNode.h"


/*
 *  include lib-protos.h AFTER our typedefs (though it doesn't matter in
 *  this particular test case)
 */

#include <lib-protos.h>

extern const char LibName[];
extern const char LibId[];



