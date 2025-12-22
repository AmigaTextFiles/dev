/* Myendcli.c - a C language replacement for ENDCLI
Compile and link with Manx 3.4:
  cc myendcli
  ln myendcli.o bcpllib.o -lc
By Bill Kinnersley - Dec 18, 1987
Mail:   Physics Dept.
        Montana State University
        Bozeman, MT 59717
BITNET: iphwk@mtsunix1
INTERNET: iphwk%mtsunix1.bitnet@cunyvm.cuny.edu
UUCP: ...psuvax1!mtsunix1.bitnet!iphwk
*/
#include <stdio.h>
#include <libraries/dosextens.h>
#include <functions.h>
#define DOSTRUE -1

struct Process *task;
struct CommandLineInterface *cli;
struct FileHandle *mystdin;
struct DosLibrary *doslib;
struct RootNode *root;
struct DosInfo *dosinfo;
struct foo {
        BPTR    next;
        long    count;
        BPTR    seg;
        char    length;
        char    name[1];
};
struct foo *list;

main() {
        short i;
        if (!(doslib = (struct DosLibrary *)OpenLibrary("dos.library",0L)))
                error("Can't open library\n");
        /*printf("doslib=%lx\n",doslib);*/
        root = (struct RootNode *)doslib->dl_Root;
        /*printf("root=%lx\n",root);*/
        dosinfo = (struct DosInfo *)BADDR(root->rn_Info);
        /*printf("dosinfo=%lx\n",dosinfo);*/
        list = (struct foo *)BADDR(dosinfo->di_NetHand);
        task = (struct Process *)FindTask(0L);
        cli = (struct CommandLineInterface *)BADDR(task->pr_CLI);
        mystdin = (struct FileHandle *)BADDR(cli->cli_StandardInput);
        mystdin->fh_End = 0;
        cli->cli_CurrentInput = cli->cli_StandardInput;
        cli->cli_Background = DOSTRUE;
        if (cli->cli_Interactive)
                printf("Task %ld ending\n", task->pr_TaskNum);
        Forbid();
        while (list) {
/*printf("list=%lx\n",list);printf("next=%lx\n",BADDR(list->next));
printf("count=%ld\n",list->count);printf("seg=%lx\n",BADDR(list->seg));
puts(list->name);*/
                if (strcmp("CLI",list->name)==0) break;
                list = (struct foo *)BADDR(list->next);
        }
        if (list) {
/*printf("list=%lx\n",list);printf("next=%lx\n",BADDR(list->next));
printf("count=%ld\n",list->count);printf("seg=%lx\n",BADDR(list->seg));
puts(list->name);*/
                if (list->count>0) list->count--;
        }
        Permit();
}

error(s) char *s; {puts(s); exit(0);}
