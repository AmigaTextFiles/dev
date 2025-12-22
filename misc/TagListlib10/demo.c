/*
** $File: demo.c$
**
**
*/

#include <exec/types.h>
#include <exec/libraries.h>
#include <exec/initializers.h>
#include <utility/tagitem.h>
#include <intuition/intuition.h>
#include <libraries/taglist.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/utility_protos.h>
#include <proto/taglist.h>

#define DA_Byte		TAG_USER+0
#define DA_Word		TAG_USER+1
#define DA_Long		TAG_USER+2
#define DA_Flag1	TAG_USER+3
#define DA_Flag2	TAG_USER+4
#define DA_Flag3	TAG_USER+5
#define DA_Flag4	TAG_USER+6
#define DA_Flag5	TAG_USER+7

/*
** The is a function using a taglist for it's arguments.
*/
VOID
DemoTagList(
		/* The only argument is a pointer to the taglist */
	struct TagItem *taglist
)
{
		/* Variables */
	ULONG missing;

		/* Define the structure to store the arguments into */
	struct Args {
		BYTE		Byte;
		WORD		Word;
		LONG		Long;

		BYTE		Flags;
	} args;

	static struct TagMapItem tagmap[] = {
			/* 3 integers are maped into a BYTE, WORD, and LONG */
		TAGMAP(DA_Byte, Args, Byte, 0, INT, BYTE, DEFAULT, 0),
		TAGMAP(DA_Word, Args, Word, 0, INT, WORD, DEFAULT, 0),
		TAGMAP(DA_Long, Args, Long, 0, INT, LONG, DEFAULT, 0),

			/* Flags are maped into a BYTE */
		TAGMAP(DA_Flag1, Args, Flags, 0, BOOL, BYTE, default, 1),
		TAGMAP(DA_Flag2, Args, Flags, 0, BOOL, BYTE, default, 2),
		TAGMAP(DA_Flag3, Args, Flags, 0, BOOL, BYTE, default, 4),

			/* If these tagitems are missing miss flags will be set */
		TAGMAP(DA_Flag4, Args, Flags, 1, BOOL, BYTE, NODEFAULT, NULL),
		TAGMAP(DA_Flag5, Args, Flags, 2, BOOL, BYTE, NODEFAULT, NULL),

			/* Put and end to it all */
		TAG_DONE
	};

		/* Convert the taglist into a normal structure */
	missing=TL_MapTagList(tagmap, &args, taglist);

		/* Print arguments */
	printf("DA_Byte  0x%x\n", args.Byte);
	printf("DA_Word  0x%x\n", args.Word);
	printf("DA_Long  0x%x\n", args.Long);
	printf("DA_Flag1 %s\n", args.Flags & 1 ? "True" : "False");
	printf("DA_Flag2 %s\n", args.Flags & 2 ? "True" : "False");
	printf("DA_Flag3 %s\n", args.Flags & 4 ? "True" : "False");
	printf("DA_Flag4 %s\n", missing & 1 ? "Missing" : (args.Flags & 8 ? "True" : "False"));
	printf("DA_Flag5 %s\n", missing & 2 ? "Missing" : (args.Flags & 16 ? "True" : "False"));

		/* Return */
}

struct Library *TagListBase;

int main(void) {
	struct TagItem tags[] = {
		DA_Byte, 1,
		DA_Word, 2,
		DA_Long, 3,
		DA_Flag1, TRUE,
		DA_Flag2, FALSE,
		DA_Flag3, FALSE,
		DA_Flag4, TRUE,
		TAG_DONE
	};

	if(TagListBase = OpenLibrary("taglist.library", 0)) {
		DemoTagList(tags);
		CloseLibrary(TagListBase);
	}
	else {
		printf("No taglist.library!");
	}
}

