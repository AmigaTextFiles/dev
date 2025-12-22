/* BINTAP version 1.0 */
/* By the infamous BLOOD! */
/* (C)1996 Cheese Freak Software */
/* This prog is most definitely FREEWARE! */
/* But please don't distribute updated versions without asking first...! */

#include <stdio.h>
#include <stdlib.h>
/* #include <io.h> */
#include <string.h>
#include "bintap.h"

void main(int argc, char *argv[])
{
    FILE *fp1, *fp2;
    BYTE header[21],checkbit=0,buffer[3];
    int count,result;
    unsigned int fl;
    BYTE high,low;

    printf("\n\nBINTAP version 1.0\n");
    printf("Written by the infamous BLOOD! (l.d.tonks@bra0202.wins.icl.co.uk)\n");
    printf("(C)1996 Cheese Freak Software\n");
    printf("This program is FREEWARE! Don't pay more than 2p for it!\n\n");

    if(argc!=5)
    {
        printf("Usage : BINTAP <bin. filename> <.tap filename> <speccy filename> <.org address>\n");
        printf("Example : BINTAP jetset.obj jetset.tap jetset 32000\n\n");
        exit(0);
    }
    else
    {
        printf("Converting %s to %s....\n",argv[1],argv[2]);
        fp1=fopen(argv[1],"rb");
        if(fp1==NULL)
        {
            printf("Error opening %s...!\n",argv[1]);
            exit(1);
        };
        fp2=fopen(argv[2],"wb");
        if(fp2==NULL)
        {
            printf("Error opening %s...!\n",argv[2]);
            fclose(fp1);
            exit(1);
        };

        /* CREATE HEADER */
        fl=getsize(fp1);
        getheader(header,argv[3],argv[4],fl);
        result=fwrite(header,21,1,fp2);
        if(result!=1)
        {
            printf("Can't write to %s...!\n",argv[2]);
            fclose(fp1);
            fclose(fp2);
            exit(1);
        };

        /* NOT RIGHT YET */
        conv(&high,&low,fl+2);
        buffer[0]=low;
        buffer[1]=high;
        buffer[2]=255;
        checkbit=(checkbit ^ buffer[2]);

        result=fwrite(buffer,3,1,fp2);
        if(result!=1)
        {
            printf("Write error in %s...!\n",argv[2]);
            fclose(fp1);
            fclose(fp2);
            exit(1);
        };

        for(count=0;count<fl;count++)
        {
            result=fread(buffer,1,1,fp1);
            if(result!=1)
            {
                printf("Read error in %s...!\n",argv[1]);
                fclose(fp1);
                fclose(fp2);
                exit(1);
            };
            result=fwrite(buffer,1,1,fp2);
            if(result!=1)
            {
                printf("Write error in %s...!\n",argv[2]);
                fclose(fp1);
                fclose(fp2);
                exit(1);
            };
            checkbit=(checkbit ^ buffer[0]);
        };

        buffer[0]=checkbit;
        result=fwrite(buffer,1,1,fp2);
        if(result!=1)
        {
            printf("Write error in %s...!\n",argv[2]);
            fclose(fp1);
            fclose(fp2);
            exit(1);
        };

        printf("\nConversion done...!\n");

        fclose(fp1);
        fclose(fp2);
    };
}


void getheader(BYTE header[21], char *filename, char *length, unsigned int fl)
{
    unsigned int count,len;
    BYTE checkbit=0;
    BYTE high,low;

    /* MANDATORY BIT */
    header[0]=19;
    header[1]=0;
    header[2]=0;
    header[3]=3;

    /* NEXT 10 BYTES ARE FILENAME */
    len=strlen(filename);
    if(len>10) len=10;
    for(count=0;count<len;count++)
        header[count+4]=filename[count];
    if(len<10)
        for(count=len;count<10;count++)
            header[count+4]=32;

    /* CODE DATA */
    conv(&high,&low,fl);
    header[14]=low;
    header[15]=high;
    len=atoi(length);
    conv(&high,&low,len);
    header[16]=low;
    header[17]=high;
    header[18]=0;
    header[19]=128;

    /* CHECK BIT */
    for(count=2;count<20;count++)
        checkbit=(checkbit ^ header[count]);
    header[20]=checkbit;
}


void conv(BYTE *high, BYTE *low, unsigned int number)
{
    int temp;

    *high=(BYTE) (number/256);
    temp=(int) (*high)*256;
    *low=(BYTE) (number-temp);
}


unsigned int getsize(FILE *fp)
{
    unsigned int size=0;
    BYTE buffer[2];

    /* Not a very friendly way of finding the file size */
    /* But I couldn't get FILESIZE to work with my compiler.... */

    while(fread(buffer,1,1,fp)==1)
        size++;

    /* reset file pointer */
    fseek(fp,0L,SEEK_SET);

    return size;
}

