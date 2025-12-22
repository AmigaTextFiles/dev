/* String85.c - Converts a binary file into a .85s file suitable for ZShell 
 * on the TI-85 calculator.  Adds the checksum byte automatically, but does
 * not add the neccessary stuff to the beinging ($00FD<DescLen><Desc>00)
 *
 * Copyright ©1997 Shawn D'Alimonte - This program is freeware
 * Please don't charge more than media costs for it
 * If you modify it than please give me credit and clearly show what you
 * changed.
 *
 * Note to PC users: This code assumes Motorolla word ordering
 * although you should be able to use it if you change fputw()
 * I think that is all the changes that it should need
 * Also the data type UBYTE is the same as unsigned char
 *
 * Sorry that the code is uncommented, but I wrote it in a hurry and don't
 * feel like going back over it.
 */

#include<stdio.h>
#include<stdlib.h>
#include<exec/types.h> 
#include<string.h>

/* Write a word to the file in correct order for TI85*/
void fputw(int c, FILE *f) 
{
  fputc((c)&0x00ff,(f));
  fputc(((c)&0xff00)>>8,(f));
}

void print_usage(void)
{
  printf("String85 for Amiga\nConverts binary files to TI85 type strings for ZShell\nUsage: string85 File Name Desc\n");
  exit(5);
}

int main(int argc, char **argv)
{
  const char Ident[]="**TI85**";          /*TI85 File ID string*/
  const char Sig[]  ={0x1a,0x0c,0x00};    
  const char Comment[]="ZShell string file                        ";

  int FLength, DLength;
  UBYTE Name_length;
  int Skip_len, checksum, i;
  char OutName[8+4+1];
  
  FILE *infile, *outfile;
  
  UBYTE *buffer;

  UBYTE ZSChk;
  
  if(argc != 3)
    {
      print_usage();
    }
  
  if(strlen(argv[2])>12) 
    {
      printf("Variable name too long!\n");
      abort();
    }
  
  if(!(infile=fopen(argv[1],"r")))
    {
      printf("Error opening %s for reading\n", argv[1]);
      abort();
    }
  
  
  strcpy(OutName, argv[2]);
  strcat(OutName, ".85s");
  
  if(!(outfile=fopen(OutName,"w")))
    {
      printf("Error opening %s for writing\n", OutName);
      fclose(infile);
      abort();
    }

  
  fputs(Ident, outfile);
  fputs(Sig, outfile);
  fputc(0x00, outfile);
  fputs(Comment,outfile);
  
  DLength=0;
  while(fgetc(infile)!=EOF)
    DLength++;

  DLength += 2;
  DLength ++;

  rewind(infile);
  
  FLength = DLength+strlen(argv[2])+8;
  fputw(FLength, outfile);
  
  Skip_len = 2+1+1+strlen(argv[2]);
  fputw(Skip_len, outfile);
  
  fputw(DLength,outfile);
  
  fputc(0x0c, outfile);
  
  fputc(strlen(argv[2]),outfile);
  
  fputs(argv[2],outfile);
  
  fputw(DLength, outfile);
  
  fputw(DLength-2, outfile);

  ZSChk=0;
  for(i=0;i<(DLength-3);i++)
    {
      int temp=fgetc(infile);
      fputc(temp,outfile);
      ZSChk+=temp;
    }
  
  fputc((ZSChk-0xfd)&0xff, outfile);

  fclose(outfile);
  outfile=fopen(OutName,"r");

  fseek(outfile , 0x37, SEEK_SET);

  checksum=0;
  while (!feof(outfile))
    checksum+=fgetc(outfile);
  checksum++;

  fclose(outfile);
  outfile=fopen(OutName,"a");

  fputw(checksum,outfile);

  fclose(infile);fclose(outfile);
}






