#include <exec/types.h>
#include <exec/tasks.h>
#include <dos/dos.h>

#include <clib/exec_protos.h>

#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "encrypt.h"

INT8 *currFile;
static const INT8 sc[] = "./"
                         "01234567890"
                         "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                         "abcdefghijklmnopqrstuvwxyz";

INT16 progdisp(INT16 perc)
{
	struct Task *tcb = FindTask(NULL);
	INT16 brkFlag = (tcb -> tc_SigRecvd) & SIGBREAKF_CTRL_C;

	if (perc >= 0) printf("File: %s - currently %ld%% done ...\r",currFile,perc);

	return brkFlag;
}

int main(int argc, char **argv)
{
	INT8 salt[3], *msg;
	INT16 err;

	if (argc == 2)	/* pw only */
	{
		srand(time(NULL));
		salt[0] = sc[(rand() & 0x7e) >> 1];
		salt[1] = sc[(rand() & 0x7e) >> 1];
		salt[2] = '\0';
		printf("%s\n",cryptpass(argv[1],salt));
		return NULL;
	}
	if (argc == 3)	/* salt + pw */
	{
		salt[0] = '\0';
		strncat(salt,argv[1],2);
		printf("%s\n",cryptpass(argv[2],salt));
		return NULL;
	}
	if (argc == 4)	/* dat + pw + flag */
	{
		currFile = argv[1];
		if (!atoi(argv[3]))
		{
			err = encryptfile(argv[1],argv[2],progdisp);
		}
		else
		{
			err = decryptfile(argv[1],argv[2],progdisp);
		}
		switch (err)
		{
			case WARN_USERBREAK:
				msg = "USER BREAK";
				break;
			case WARN_NOTCRYPTED:
				msg = "FILE NOT CRYPTED";
				break;
			case ERROR_NONE:
				msg = "FILE SUCCESSFULLY DONE";
				break;
			case ERROR_NOACCESS:
				msg = "NO ACCESS TO FILE";
				break;
			case ERROR_NOPASS:
				msg = "NO PASSWORD GIVEN";
				break;
			case ERROR_BADCHUNK:
				msg = "EXPECTED CHUNK NOT FOUND";
				break;
			case ERROR_TRUNCATED:
				msg = "FILE IS DAMAGED/TRUNCATED";
				break;
			case ERROR_WRONGCRC:
				msg = "CHECKSUM ERROR";
				break;
			case ERROR_FILEOP:
				msg = "FILE OPERATION FAILED";
				break;
			case ERROR_FILEREAD:
				msg = "FILE READ ERROR";
				break;
			case ERROR_FILEWRITE:
				msg = "FILE WRITE ERROR";
				break;
			case ERROR_LOWMEM:
				msg = "OUT OF MEMORY";
				break;
			default:
				msg = "UNKNOWN ERROR";
				break;
		}
		printf("\n*** ");
		printf(msg);
		printf(" (Err: %ld) ***\n",err);
		return NULL;
	}
	fprintf (stderr, "usage: %s passwd\n"
	                 "       %s salt passwd\n"
	                 "       %s file passwd 0|1 (0-encrypt/1-decrypt)\n", argv[0], argv[0], argv[0]);
	return NULL;
}

