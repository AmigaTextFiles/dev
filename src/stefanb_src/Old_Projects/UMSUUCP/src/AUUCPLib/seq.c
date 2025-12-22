
/*
 *  SEQ.C
 *
 *  (C) Copyright 1989-1990 by Matthew Dillon,  All Rights Reserved.
 *
 *  Returns a unique sequence number
 */

#include <stdio.h>
#include <stdlib.h>
#include "config.h"

Prototype int GetSequence(int);

int
GetSequence(int bump)
{
    char *seqLockFile = "seq";
    FILE *fp;
    char *fileName = MakeConfigPath(UULIB, "seq");
    int seq;
    char buf[32];

    LockFile(seqLockFile);
    fp = fopen(fileName, "r");
    if (fp) {
        fgets(buf, 32, fp);
        seq = atoi(buf);
        fclose(fp);
    } else {
        perror(fileName);
        seq = -1;
    }

    if (bump && seq >= 0) {
        if (bump + seq > 0xFFFFF)
            seq = 1;

        fp = fopen(fileName, "w");
        if (fp) {
            fprintf(fp,"%d", seq + bump);
            fclose(fp);
        } else {
            perror(fileName);
            seq = -1;
        }
    }
    UnLockFile(seqLockFile);
    return(seq);
}

