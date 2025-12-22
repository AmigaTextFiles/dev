/*
    mkvcdfs: make a VCD image from several MPEG-1 files suitable
             for burning to CDR with cdrdao

    Usage:

      mkvcdfs mpegfile1 mpegfile2 ....

    mkvcdfs creates 2 files:

    vcd.toc          contains the table of contents of the VCD
    vcd_image.bin    contains the CD-Image itself


    Copyright (C) 2000 Rainer Johanni <Rainer@Johanni.de>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include "defaults.h"
#include "ecc.h"

static int maxrec = 0;
static int xa_fd;

static unsigned char outrec[2352];

static void write_record(int rec)
{
   int n;

   lseek(xa_fd,rec*2352,SEEK_SET);
   n = write(xa_fd,outrec,2352);

   if(n!=2352)
   {
      fprintf(stderr,"Error writing to binary MPEG output file\n");
      perror("write");
      exit(1);
   }
}

static void output_zero(int rec)
{
   /* Output a zero record */

   do_encode_L2(outrec, MODE_0, rec+150);
   write_record(rec);
}

void output_form1(int rec, unsigned char *data)
{
   int i;

   /* Output a CDROM XA Mode 2 Form 1 record,
      we fill gaps with zero records */

   if(rec+1>maxrec)
   {
      for(i=maxrec;i<rec;i++) output_zero(i);
      maxrec = rec+1;
   }

   /* We use the same subheader for all form 1 sectors,
      I dont know if this is completly correct */

   outrec[16] = outrec[20] = 0;
   outrec[17] = outrec[21] = 0;
   outrec[18] = outrec[22] = 8;
   outrec[19] = outrec[23] = 0;

   /* Copy the data to outrec */

   memcpy(outrec+24,data,2048);

   /* Adding of sync, header, ECC, EDC fields */

   do_encode_L2(outrec, MODE_2_FORM_1, rec+150);

   /* Output record */

   write_record(rec);
}

void output_form2(int rec, int h1, int h2, int h3, int h4, unsigned char *data)
{
   int i;

   /* Output a CDROM XA Mode 2 Form 1 record,
      we fill gaps with zero records */

   if(rec+1>maxrec)
   {
      for(i=maxrec;i<rec;i++) output_zero(i);
      maxrec = rec+1;
   }

   /* Subheader */

   outrec[16] = outrec[20] = h1;
   outrec[17] = outrec[21] = h2;
   outrec[18] = outrec[22] = h3;
   outrec[19] = outrec[23] = h4;

   /* Copy the data to outrec */

   memcpy(outrec+24,data,2324);

   /* Adding of sync, header, EDC */

   do_encode_L2(outrec, MODE_2_FORM_2, rec+150);

   /* Output record */

   write_record(rec);
}

#define EOF_INDICATOR 0xffffffff

static unsigned long tag;

static int read_tag(FILE *mpeg_file)
{
   int i, c;

   tag = 0;

   /* Fill tag with next 4 bytes from mpeg_file,
      skip 0's that might be before actual tag */

   for(i=0;i<4||(tag&0xffffff00)==0;i++)
   {
      c = getc(mpeg_file);
      if(c==EOF) return -1;
      tag = (tag<<8) | c;
   }

   return 0;
}

static void copy_tag(unsigned char *mpeg)
{
   /* Copy the tag into mpeg data */

   mpeg[0] = (tag>>24) & 0xff;
   mpeg[1] = (tag>>16) & 0xff;
   mpeg[2] = (tag>> 8) & 0xff;
   mpeg[3] =  tag      & 0xff;
}

/*
   read_mpeg_sec:

   Parse the MPEG file for the next VCD sector.

   returns:
      -1 if an Error occured
      the stream id of the last packet if this was
         a video or audio packet
      0 otherwise

   if tag is set to EOF_INDICATOR on return,
   reading is finished.
*/

static int read_mpeg_sec(FILE *mpeg_file, unsigned char *mpeg)
{
   int c, n, len;
   int retval = 0;

   /* If tag equals EOF_INDICATOR, the last read resulted in an EOF
      condition, this routine shouldn't be called any more */

   if (tag==EOF_INDICATOR)
   {
      fprintf(stderr,"... internal error 1 reading MPEG file\n");
      return -1;
   }

   /* If we are here the first time, we have to get and check the first tag.
      In all other cases, the tag has already been read */

   if (tag==0)
   {
      if(read_tag(mpeg_file))
      {
         fprintf(stderr,"... file is empty!!!\n");
         return -1;
      }
      if(tag != 0x1ba)
      {
         fprintf(stderr,"... this is not an MPEG system stream, starts with 0x%x\n",tag);
         return -1;
      }
   }

   memset(mpeg,0,2324);

   /* Copy the last tag into mpeg data */

   copy_tag(mpeg);

   /* If this tag is an end code, raise EOF_INDICATOR and return */

   if (tag==0x1b9)
   {
      tag = EOF_INDICATOR;
      return retval;
   }

   /* if we are here, the tag must be a pack start code 0x1ba */

   if (tag!=0x1ba)
   {
      fprintf(stderr,"... internal error 2 reading MPEG file\n");
      return -1;
   }

   /* Read the 8 bytes following the pack start code */

   if(fread(mpeg+4,1,8,mpeg_file)!=8)
   {
      fprintf(stderr,"... Unexpected EOF in MPEG file\n");
      tag = EOF_INDICATOR;
      return retval;
   }
   n = 12;

   while(1)
   {
      /* get next tag */

      if(read_tag(mpeg_file))
      {
         /* EOF reading tag */
         tag = EOF_INDICATOR;
         return retval;
      }

      if(tag<0x1b9 || tag>0x1ff)
      {
         /* Illegal tag */
         fprintf(stderr,"... file contains illegal MPEG tag 0x%x\n",tag);
         fprintf(stderr,"... terminating with this file!!!\n");
         tag = EOF_INDICATOR;
         return retval;
      }

      if(tag==0x1ba) return retval; /* found the next pack start */

      if(tag==0x1b9) /* found end tag */
      {
         if(n+4<=2324)
         {
            copy_tag(mpeg+n);
            tag = EOF_INDICATOR;
            return retval;
         }
         return retval; /* reading will be finished with next call */
      }

      /* Read length of next packet */

      c = getc(mpeg_file);
      len = c;
      c = getc(mpeg_file);
      len = (len<<8)|c;
      if(c==EOF)
      {
         fprintf(stderr,"... Unexpected EOF in MPEG file\n");
         tag = EOF_INDICATOR;
         return retval;
      }

      /* Check if next packet fits to buffer */

      if(n+4+2+len>2324)
      {
         fprintf(stderr,"... Record in MPEG file too long for VCD\n");
         fprintf(stderr,"... terminating with this file!!!\n");
         tag = EOF_INDICATOR;
         return retval;
      }

      /* copy this packet to buffer */

      copy_tag(mpeg+n);
      n+=4;

      mpeg[n++] = (len>>8)&0xff;
      mpeg[n++] =  len    &0xff;

      if(fread(mpeg+n,1,len,mpeg_file)!=len)
      {
         fprintf(stderr,"... Unexpected EOF in MPEG file\n");
         tag = EOF_INDICATOR;
         return retval;
      }

      /* if this packet is a system header for one single stream,
         set retval to the stream id */

      if(tag==0x1bb && len==9) retval = mpeg[n+6];

      /* if this packet is a video or audio stream,
         set retval to the stream id */

      if(tag>=0x1c0 && tag<=0x1ff) retval = tag&0xff;

      n += len;
   }
}

#define MAX_MPEG_FILES 32

static unsigned char data[2324];

main(int argc, char **argv)
{
   int num_MPEG_files;
   int MPEG_size   [MAX_MPEG_FILES]; /* in blocks */
   int MPEG_extent [MAX_MPEG_FILES];
   FILE *MPEG_file;
   FILE *fd_toc;
   int n, extent, m, s, f, i, n1, n2, id;

   if(argc<2)
   {
      fprintf(stderr,"Usage: %s MPEG-files ....\n",argv[0]);
      exit(1);
   }

   if(argc>MAX_MPEG_FILES+1)
   {
      fprintf(stderr,"Maximum of %d MPEG files exceeded!\n",MAX_MPEG_FILES);
      exit(1);
   }

   num_MPEG_files = argc-1;

   /* Open binary output file */

   xa_fd = open(BINARY_OUTPUT_FILE, O_WRONLY|O_CREAT|O_TRUNC, 0644);
   if(xa_fd<0)
   {
      fprintf(stderr,"Can not open %s\n",BINARY_OUTPUT_FILE);
      perror("open");
      exit(1);
   }

   /* open VCD_TOC_FILE */

   fd_toc = fopen(VCD_TOC_FILE,"w");
   if(fd_toc==0)
   {
      fprintf(stderr,"Can not open VCD toc file %s\n",VCD_TOC_FILE);
      perror("fopen");
      exit(1);
   }

   /* Write the toc file */

   fprintf(fd_toc,"CD_ROM_XA\n\n");
   fprintf(fd_toc,"// Track 1: Header with ISO 9660 file system\n");
   fprintf(fd_toc,"TRACK MODE2_RAW\n");
   f = ISO_FS_BLOCKS + 150;
   s = f/75;
   f = f%75;
   m = s/60;
   s = s%60;
   fprintf(fd_toc,"DATAFILE \"%s\" %2.2d:%2.2d:%2.2d\n\n",BINARY_OUTPUT_FILE,m,s,f);

   extent = ISO_FS_BLOCKS;

   for(n=0;n<num_MPEG_files;n++)
   {
      printf("Copying file %s\n",argv[n+1]);

      MPEG_file = fopen(argv[n+1],"rb");
      if(MPEG_file==0)
      {
         fprintf(stderr,"Can not open file %s\n",argv[n+1]);
         perror("open");
         fprintf(stderr,"Fatal Error --- exiting\n");
         close(xa_fd);
         remove(BINARY_OUTPUT_FILE);
         fclose(fd_toc);
         remove(VCD_TOC_FILE);
         exit(1);
      }

      /* Pre gap  */

      memset(data,0,2324);
      for(i=0;i<150;i++) output_form2(extent++,0,0,0x20,0,data);

      MPEG_extent[n] = extent;

      /* 30 empty form 2 blocks at the beginning */

      memset(data,0,2324);
      for(i=0;i<30;i++) output_form2(extent++,n+1,0,0x60,0,data);

      /* Output the file itself */

      tag = 0; /* new file starts */

      for(i=0;;i++)
      {
         id=read_mpeg_sec(MPEG_file,data);

         if(tag==EOF_INDICATOR && i<150)
         {
            fprintf(stderr,"Not enough MPEG data\n");
            id = -1;
         }

         if(id<0)
         {
            fprintf(stderr,"Fatal Error --- exiting\n");
            close(xa_fd);
            remove(BINARY_OUTPUT_FILE);
            fclose(fd_toc);
            remove(VCD_TOC_FILE);
            exit(1);
         }

         /* Subheader stuff, I don't know exactly for what some flags are */

         n1 = 0x60;
         n2 = 0;

         if(id == 0xe0)
         {
            /* Video data */
            n1 = 0x62;
            n2 = 0x0f;
         }
         else if(id == 0xc0)
         {
            /* Audio data */
            n1 = 0x64;
            n2 = 0x7f;
         }

         if(tag==EOF_INDICATOR) n1 |= 1;

         output_form2(extent++,n+1,1,n1,n2,data);

         if(tag==EOF_INDICATOR)
         {
            fprintf(stderr,"Done with %s, got %d sectors\n",argv[n+1],i+1);
            break;
         }
      }

      MPEG_size[n] = i+75;

      /* 45 empty form 2 blocks at the end */

      memset(data,0,2324);
      for(i=0;i<40;i++) output_form2(extent++,n+1,0,0x60,0,data);
      output_form2(extent++,n+1,0,0xe1,0,data);
      for(i=0;i<4;i++) output_form2(extent++,0,0,0x20,0,data);

      /* Update TOC file */

      fprintf(fd_toc,"// Track %d: MPEG data from %s\n",n+2,argv[n+1]);
      fprintf(fd_toc,"TRACK MODE2_RAW\n");
      f = MPEG_size[n];
      if(n!=num_MPEG_files-1) f += 150;
      s = f/75;
      f = f%75;
      m = s/60;
      s = s%60;
      fprintf(fd_toc,"DATAFILE \"%s\" #%d %2.2d:%2.2d:%2.2d\n\n",
                     BINARY_OUTPUT_FILE,MPEG_extent[n]*2352,m,s,f);

      /* Finally close MPEG file */

      fclose(MPEG_file);
   }

   /* Finally make the first Track with the ISO file system */

   mk_vcd_iso_fs(num_MPEG_files, MPEG_extent, MPEG_size);
}
