
/*
 *  CONFIG.C
 *
 *  (C) Copyright 1989-1990 by Matthew Dillon,  All Rights Reserved.
 *
 *  Extract fields from UULIB:Config
 */

#include <clib/dos_protos.h>
#include <exec/types.h>
#include <exec/libraries.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include "config.h"

Prototype char *FindLocalVariable(const char *);
Prototype char *FindConfig(const char *);
Prototype char *GetConfig(const char *, char *);
Prototype char *GetConfigDir(char *);
Prototype char *GetConfigProgram(char *);
Prototype char *MakeConfigPath(const char *, const char *);
Prototype char *MakeConfigPathBuf(char *, const char *, const char *);
Prototype FILE *openlib(const char *);
Prototype FILE *openlib_write(const char *);

#define CTLZ    ('z'&0x1F)

static char *ConfBuf = NULL;

extern struct Library *SysBase;

typedef struct LVarNode {
    struct LVarNode *lv_Next;
    char *lv_Name;
    char lv_Buf[4];
} LVarNode;

char *
FindLocalVariable(field)
const char *field;
{
    char *res = NULL;
    static LVarNode *LVBase;

    {
        LVarNode *lvnode;

        for (lvnode = LVBase; lvnode; lvnode = lvnode->lv_Next) {
            if (stricmp(field, lvnode->lv_Name) == 0)
                return(lvnode->lv_Buf);
        }
    }
#ifdef INCLUDE_VERSION
#if INCLUDE_VERSION >= 36
    if (SysBase->lib_Version >= 37) {   /*  MUST be V37 or greater */
        char buf[2];

        if (GetVar(field, buf, sizeof(buf) - 1, 0) >= 0) {
            LVarNode *lvnode;
            long len = IoErr() + 1;

            /*
             *  probably do not need the +1 in the lvnode malloc due to
             *  the + 1 above, but why take chances?
             */

            lvnode = malloc(sizeof(LVarNode) + len + 1);
            lvnode->lv_Name = strcpy(malloc(strlen(field) + 1), field);
            lvnode->lv_Next = LVBase;
            LVBase = lvnode;
            GetVar(field, lvnode->lv_Buf, len, 0);
            return(lvnode->lv_Buf);
        }
    }
#endif
#endif
    return(res);
}


char *
FindConfig(field)
const char *field;
{
    char *str;
    short flen = strlen(field);

    /*
     *  If running under 2.0, check local variable overide
     */

    if (str = FindLocalVariable(field))
        return(str);

    /*
     *  load config file if not already loaded
     */

    if (ConfBuf == NULL) {
        FILE *fi;
        fi = fopen("S:UUConfig", "r");
        if (fi == NULL)
            fi = fopen("UULIB:Config", "r");
        if (fi) {
            long buflen;
            fseek(fi, 0L, 2);
            buflen = ftell(fi);
            fseek(fi, 0L, 0);
            if (buflen > 0 && (ConfBuf = malloc(buflen + 1))) {
                fread(ConfBuf, buflen, 1, fi);
                ConfBuf[buflen] = CTLZ;     /*  can't use \0 */
                for (str = ConfBuf; *str && *str != CTLZ; ++str) {
                    char *bup;
                    if (*str == '\n') {     /*  make separate strs */
                        *str = 0;
                                            /*  remove white space at end */
                        for (bup = str - 1; bup >= ConfBuf && (*bup == ' ' || *bup == 9); --bup)
                            *bup = 0;
                    }
                }
            } else {
                ConfBuf = NULL;
            }
            fclose(fi);
        } else {
            fprintf(stderr, "Couldn't open S:UUConfig or UULIB:Config\n");
        }
    }
    if (ConfBuf == NULL)
        return(NULL);

    /*
     *  Search ConfBuf for Field<space/tab>
     */

    for (str = ConfBuf; *str != CTLZ; str += strlen(str) + 1) {
        if (*str == 0 || *str == '#')
            continue;
        if (strnicmp(str, field, flen) == 0 && (str[flen] == ' ' || str[flen] == '\t')) {
            str += flen;
            while (*str == ' ' || *str == 9)
                ++str;
            return(str);
        }
    }
    return(NULL);
}

char *
GetConfig(field, def)
const char *field;
char *def;
{
    char *result = FindConfig(field);

    if (result == NULL)
        result = def;
    return(result);
}

char *
GetConfigDir(field)
char *field;
{
    char *result = FindConfig(field);

    if (result == NULL)
        result = field + strlen(field) + 1;
    return(result);
}

char *
GetConfigProgram(field)
char *field;
{
    char *result = FindConfig(field);
    if (result == NULL)
        result = field;
    return(result);
}

char *
MakeConfigPath(field, trailer)
const char *field;
const char *trailer;
{
    static char Buf[512];
    return(MakeConfigPathBuf(Buf, field, trailer));
}

char *
MakeConfigPathBuf(buf, field, trailer)
char *buf;
const char *field;
const char *trailer;
{
    char *result = GetConfigDir(field);
    short len = strlen(result) - 1;

    if (len > 0 && result[len] == '/' || result[len] == ':')
        sprintf(buf, "%s%s", result, trailer);
    else
        sprintf(buf, "%s/%s", result, trailer);
    return(buf);
}


FILE *
openlib(filename)
const char *filename;
{
    return (fopen(MakeConfigPath(UULIB, filename), "r"));
}

FILE *
openlib_write(filename)
const char *filename;
{
    return (fopen(MakeConfigPath(UULIB, filename), "w"));
}

