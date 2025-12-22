/* Myendcli.c - A C Language Replacement For ENDCLI
/* No BCPL calls in here at all */
/*
/* Compile and link using Manx 3.4a
/* 	cc myendcli.c
/*	ln myendcli.o -lc
/*
/* Author: Bill Kinnersley
/* Date: Mar 12, 1988
/* Mail: Physics Dept.
/*	Montana State University
/*	Bozeman, MT 59717
/* BITNET: iphwk@mtsunix1
/* INTERNET: iphwk%mtsunix1.bitnet@cunyvm.cuny.edu
/* USENET: lll-crg!umt!mts-cs!uphwk
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
	BPTR	next;
	long	count;
	BPTR	seg;
	char	length;
	char	name[1];
};
struct foo *list;

main() {
	short i;
	if (!(doslib = (struct DosLibrary *)OpenLibrary("dos.library",0L)))
		error("Can't open library\n");
	root = (struct RootNode *)doslib->dl_Root;
	dosinfo = (struct DosInfo *)BADDR(root->rn_Info);
	list = (struct foo *)BADDR(dosinfo->di_NetHand);
	task = (struct Process *)FindTask(0L);
	cli = (struct CommandLineInterface *)BADDR(task->pr_CLI);
	mystdin = (struct FileHandle *)BADDR(cli->cli_StandardInput);
	mystdin->fh_End = 0;
	cli->cli_CurrentInput = cli->cli_StandardInput;
	cli->cli_Background = DOSTRUE;
/* This was basically all we had to do! */
	if (cli->cli_Interactive)
		printf("Task %ld ending\n", task->pr_TaskNum);
	Forbid();
	while (list) {
		if (strcmp("CLI",list->name)==0) break;
		list = (struct foo *)BADDR(list->next);
	}
	if (list) {
		if (list->count>0) list->count--;
	}
	Permit();
}

error(s) char *s; {puts(s); exit(0);}
