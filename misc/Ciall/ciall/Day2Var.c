/*
 * Day2Var.c : creates two environnement variables from the current date
 * and time -- needs V39 dos.library
 * Author : Dominique Lorre
 * $Id: Day2Var.c 1.1 1997/10/06 19:46:03 dlorre Exp dlorre $
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/datetime.h>
#include <dos/var.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void main(int argc, char **argv)
{
struct DateTime *dt ;
struct DateStamp *ds ;
char   date[40] ;
char   time[10] ;
char   *envdate ;
char   *envtime ;
ULONG  len ;

    if (argc < 2) {
        printf("usage: day2var <varname>\n") ;
        exit(0) ;
    }
    len = strlen(argv[1]) + 6 ;

    envdate = AllocVec(len, MEMF_CLEAR|MEMF_PUBLIC) ;
    if (envdate) {
        envtime = AllocVec(len, MEMF_CLEAR|MEMF_PUBLIC) ;
        if (envtime) {
            dt = (struct DateTime *)AllocVec(sizeof(struct DateTime),
                                                MEMF_CLEAR|MEMF_PUBLIC) ;
            if (dt) {
                ds = (struct DateStamp *)AllocVec(sizeof(struct DateStamp),
                                                MEMF_CLEAR|MEMF_PUBLIC) ;
                if (ds) {
                    DateStamp(ds) ;
                    dt->dat_Stamp = *ds ;
                    dt->dat_StrDate = date ;
                    dt->dat_StrTime = time ;
                    dt->dat_Format = FORMAT_DOS ;
                    DateToStr(dt) ;
                    strcpy(envdate, argv[1]) ;
                    strcat(envdate, "date") ;
                    strcpy(envtime, argv[1]) ;
                    strcat(envtime, "time") ;
                    SetVar(envdate, date, -1, GVF_GLOBAL_ONLY|GVF_SAVE_VAR) ;
                    SetVar(envtime, time, -1, GVF_GLOBAL_ONLY|GVF_SAVE_VAR) ;
                    FreeVec(ds) ;
                }
                FreeVec(dt) ;
            }
            FreeVec(envtime) ;
        }
        FreeVec(envdate) ;
    }
}