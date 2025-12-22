/** Famicom DiskSystem Directory Viewer **********************/
/**                                                         **/
/**                        fdslist.c                        **/
/**                                                         **/
/** This program will list files contained in a Famicom     **/
/** DiskSystem disk image (.FDS file).                      **/
/**                                                         **/
/** Copyright (C) Marat Fayzullin 1998-1999                 **/
/**     You are not allowed to distribute this software     **/
/**     commercially. Please, notify me if you make any     **/
/**     changes to this file.                               **/
/*************************************************************/
/*************************************************************/
/**  FDS File Save & Disk & File Size added by Chris Covell **/
/**     ccovell@direct.ca     http://www.sfu.ca/~ccovell/   **/
/*************************************************************/
/**  FDS Format Conversion added by Chris Covell  5-16-2001 **/
/*************************************************************/
#include <stdio.h>
#include <string.h>

char *Separator = "-----------------------------------------------------";

int main(int argc,char *argv[])
{
  static unsigned char DiskHeader[] =
  {
    0x01,0x2A,0x4E,0x49,0x4E,0x54,0x45,0x4E,
    0x44,0x4F,0x2D,0x48,0x56,0x43,0x2A
  };
  unsigned char Buf[64];
  char S[16],T[16];
  char B[]="0A-000-00\0";
  int Header,Sides,Disk,Files,Start,Size,FileSum,Total,J,I,TempVar;
  FILE *F,*O,*O2;

  /* If no arguments given, print out help message */
  if(argc<2)
  {
    fprintf(stdout,"\n   FDSLIST .FDS File Processor v.1.2 by Marat Fayzullin & Chris Covell\n\n");
    fprintf(stdout,"   Usage: %s file.fds [-w] [-c file2.fds]\n",argv[0]);
    fprintf(stdout,"   An explanation of the commands:\n\n   -w Extracts the files from the FDS archive\n   -c Converts between iNES (no header) and FWNES (16 byte header) file formats\n      (You must specify a filename for the converted file.)\n\n");
    return(1);
  }

  /* Open the disk image */
  if(!(F=fopen(argv[1],"rb")))
  {
    fprintf(stdout,"%s: Can't open disk image '%s'\n",argv[0],argv[1]);
    return(2);
  }
  
  Header=0;
  
  /* Find total disk image size */
  fseek(F,0,SEEK_END);
  Total=ftell(F)/65500;
  J=ftell(F)%65500;

  rewind(F);
  if(J>=16)
  {
   /* Check for FWNES Header!ram:ramram:lc.err.out:lc.err.outlc.err.out*/ 
   TempVar=fgetc(F);
   if(TempVar=='F')
   {
    TempVar=fgetc(F);
    if(TempVar=='D')
    {
        TempVar=fgetc(F);
        if(TempVar=='S')
        {
            TempVar=fgetc(F);
            if(TempVar==26)
            {
                Header=16;
                fprintf(stdout,"   Disk is in FWNES Header Format\n",argv[0]);
                Sides=fgetc(F);
                J=J-Header;
                if(Total!=Sides) fprintf(stdout,"   Header Side Count (%d) does not match actual count (%d)!\n",Sides,Total);
                for(I=0;I<11;I++)
                {
                  TempVar=fgetc(F);
                }
                
            }                           
        }
    }
   }
   else
   {
     rewind(F);
   }
  }
 
  /* Check out if it is integer number of disks */
  if(J) fprintf(stdout,"   %d excessive bytes\n",J);

  /* Scan through disks */
  /* Don't need this anymore!!! rewind(F);  */
  for(Disk=0;Disk<Total;Disk++)
  {
    /* Seek to the next disk */
    fseek(F,Disk*65500+Header,SEEK_SET);

    /* Read the disk header */
    if(fread(Buf,1,58,F)!=58)
    {
      fprintf(stdout,"%s: Can't read disk header\n",argv[0]);
      return(3);
    }

    /* Check if disk header ID s valid */
    if(memcmp(Buf,DiskHeader,15))
    {
      fprintf(stdout,"%s: Invalid disk header\n",argv[0]);
      return(4);
    }

    /* Check if file number header ID is valid */
    if(Buf[56]!=2)
    {
      fprintf(stdout,"%s: Invalid file number header\n",argv[0]);
      return(5);
    }

    /* Show disk information */
    memcpy(S,Buf+16,4);S[4]='\0';
    Files=Buf[57];
    B[0]=(Disk/2)+'0';B[1]=(Buf[21]&1)+'A';
    FileSum=(Files*16)+58;
    printf
    (
      "DISK '%-4s'  Side %c  Files %d  Maker $%02X  Version $%02X\n%s\n",
      S,(Buf[21]&1)+'A',Files,Buf[15],Buf[20],Separator
    );

    /* Scan through the files */
    for(I=0;(I<Files)&&(fread(Buf,1,16,F)==16);I++)
    {
      /* Check if header block ID is valid */
      if(Buf[0]!=3)
      {
        fprintf(stdout,"%s: Invalid file header $%02X\n",argv[0],Buf[0]);
        return(6);
      }

      /* Get name, data location, and size */
      strncpy(S,Buf+3,8);S[8]='\0';
      Start=Buf[11]+256*Buf[12];
      Size=Buf[13]+256*Buf[14];
      FileSum=FileSum+Size;

      /* Check if data block ID is valid */
      J=fgetc(F);
      if(J!=4)
      {
        fprintf(stdout,"%s: Invalid file header $%02X\n",argv[0],J);
        return(7);
      }

      /* List the file */
      sprintf(T,"$%02X?",Buf[15]);
      printf
      (
        "%03d $%02X '%-8s' $%04X-$%04X (%5d) [%s]\n",
        Buf[1],Buf[2],S,Start,Start+Size-1,Size,
        Buf[15]>2? T:
        Buf[15]>1? "PICTURE":
        Buf[15]>0? "TILES":
                   "CODE"
      );

      if((argc>=3) && ((!strncmp(argv[2],"-w",2))) || ((!strncmp(argv[4],"-w",2))))
      {
        B[3]=(Buf[1]/100)+'0';B[4]=((Buf[1]%100)/10)+'0';B[5]=(Buf[1]%10)+'0';
        B[7]=(Buf[2]/16)+'0';B[8]=(Buf[2]%16)+'0';
        if(B[7]>'9') B[7]=B[7]+('A'-':');
        if(B[8]>'9') B[8]=B[8]+('A'-':');
        /* Does the file to save aready exist? */
        if(O=argc<2? stdout:fopen(S,"rb"))
        {
            J=1;
            fclose(O);
        }
        else J=0;
        if((J || (!(O=argc<2? stdout:fopen(S,"wb")))) && (!(O=argc<2? stdout:fopen(B,"wb"))))
        { 
          fprintf(stdout,"%s: Can't write file\n",argv[0]);
          fseek(F,Size,SEEK_CUR);
        }
        else 
        {
          while((Size>0) && ((J=fgetc(F))>=0))
          {
            fputc(J,O);
            Size=Size-1;
          }
          fclose(O);
        }
      }
      else fseek(F,Size,SEEK_CUR);
      /* Seek over the data */
    }

    /* Done with a disk */
    puts(Separator);
    printf("|  %5d Bytes Used,  %5d Bytes Free,  %3d\% Full  |\n",FileSum,65426-FileSum,(FileSum*100)/65426);
    puts(Separator);
    printf("\n");
  }


/* Now we Try and convert those disks!!!!!!!!!!!!! */

  if((argc>=4) && ((!strncmp(argv[2],"-c",2)) || (!strncmp(argv[3],"-c",2))))
  {
    rewind(F);
    fprintf(stdout,"%s: Converting Disk...",argv[0]);

/*Gotta load the proper filename from the proper place!!  */
    if(!(O2=argc<2? stdout:fopen(argv[3+(!strncmp(argv[3],"-c",2))],"wb")))
    { 
          fprintf(stdout," Can't write file\n");
          fseek(F,Size,SEEK_CUR);
    }
    else 
    {
        if(Header) for(I=0;I<16;I++) TempVar=fgetc(F);
        else
        {
            fputc('F',O2);
            fputc('D',O2);
            fputc('S',O2);
            fputc(26,O2);
            fputc(Total,O2);
            for(J=0;J<11;J++) fputc(0,O2);
        }    
          while((TempVar=fgetc(F))>=0)
          {
            fputc(TempVar,O2);
          }
          fclose(O2);
       fprintf(stdout," Done!\n");   
    }
   }
   else fseek(F,Size,SEEK_CUR);
    

  /* Done */
  return(0);
}
