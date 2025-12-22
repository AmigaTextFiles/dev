/*

   vcdmplex - MPEG system stream multiplexer for video CDs

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
#include <unistd.h>
#include <sys/stat.h>

#define AUDIO_BUFFER_SIZE 4096

/* Maximum size of a MPEG frame, actually a frame should be much smaller */

#define MAX_MPEG_FRAME (512*1024)

/* Sector size for multiplexed output - don't change, it is the sector
   size of a Video CD */

#define SECTOR_SIZE 2324

/* Maximum time of the video buffer in MPEG clock ticks:
   The standard 46 KB MPEG-1 Buffer is sufficient for about
   1/3 second of Video (at 1152KBit/s = 144 KByte/s), which is
   about 30000 clock ticks. We make the standard buffer a little
   bigger here since most VCD players should have sufficient memory today */

#define MAX_VBUFFER_TIME 45000

// #define AUDIO_BYTES (SECTOR_SIZE-25)
#define AUDIO_BYTES 2279

/* Markers for MPEG System, timestamps */

#define MARKER_DTS               1
#define MARKER_SCR               2 
#define MARKER_JUST_PTS          2
#define MARKER_PTS               3

#define FIRST_BYTE(x) ( ((x)>>24)&0xff )

/* File descriptors */

static FILE *mpegin;
static FILE *audioin;
static FILE *sysout;

/* Data returned by get_m1v_frame() */

static unsigned char MPEGvbuff[MAX_MPEG_FRAME];

static long MPEG_frame_no;
static long MPEG_frame_seq;
static long MPEG_frame_type;
static long MPEG_frame_len;

/* Internal data for get_m1v_frame() */

static long lasttag, gop_start_frame, frame_no, seqhdr_seen;

/* Packet data and Number of bytes in packet   */

static unsigned char packet[SECTOR_SIZE];
static long npb;

/* The MPEG system clock counter */

static long system_clock;

/* Bitrates */

static int AudioBitRate; /* in Kbit/s */
static int VideoBitRate; /* in units of 400 bit/s */
static int MuxRate;      /* in units of 400 bit/s */


static double rates[16] = { 0, 23.976, 24.0, 25.0, 29.97, 30.0, 50.0, 59.94, 60.0, 0, 0, 0, 0, 0, 0, 0 };

static int FrameRate, mpeg2, twofields;

static unsigned char SeqHdr[256], SeqExt[10];
static int SeqHdrLen;

static unsigned long getbits(unsigned char *data, int bitpos, int len)
{
   unsigned long res = 0;
   int byte, bit, i;

   for(i=0;i<len;i++,bitpos++)
   {
      res  = res<<1;
      byte = bitpos>>3;
      bit  = bitpos&7;

      if(data[byte]&(0x80>>bit)) res |=1;
   }

   return res;
}

void check_buffer_size(int n)
{
   if(n>=MAX_MPEG_FRAME)
   {
      fprintf(stderr,"MPEG buffer overflow - is that really a MPEG file?\n");
      exit(1);
   }
}

/*
   openm1v: Open a MPEG 1 video stream, check params,
            save SeqHdr and SeqExt (for MPEG-2)
 */

void open_m1v(char *filename)
{
   int HorSize, VerSize, AspectRatio, marker_bit, VBVBufferSize;
   int CSPF, ProgSeq;
   int c, i, tag, pos;

   mpegin = fopen(filename,"r");
   if(!mpegin)
   {
      fprintf(stderr,"Error opening %s\n",filename);
      perror("open");
      exit(1);
   }

   /* read Sequence header */

   if( fread(SeqHdr,1,12,mpegin) != 12 )
   {
      fprintf(stderr,"Error reading %s\n",filename);
      exit(1);
   }

   /* Check if file contains sequence header */

   if(SeqHdr[0]!=0 || SeqHdr[1]!=0 || SeqHdr[2]!=1 || SeqHdr[3]!=0xb3)
   {
      fprintf(stderr,"Error: File %s is not a MPEG 1 video stream\n",filename);
      exit(1);
   }

   printf("Opened MPEG 1 file %s\n\n",filename);

   pos = 32;
   HorSize      = getbits(SeqHdr,pos,12); pos += 12;
   VerSize      = getbits(SeqHdr,pos,12); pos += 12;
   AspectRatio  = getbits(SeqHdr,pos, 4); pos +=  4;
   FrameRate    = getbits(SeqHdr,pos, 4); pos +=  4;
   VideoBitRate = getbits(SeqHdr,pos,18); pos += 18;
   marker_bit   = getbits(SeqHdr,pos, 1); pos +=  1;
   VBVBufferSize= getbits(SeqHdr,pos,10); pos += 10;
   CSPF         = getbits(SeqHdr,pos, 1);

   printf("Horizontal size: %5d\n",HorSize);
   printf("Vertical size:   %5d\n",VerSize);
   printf("Aspect ratio:    %5d\n",AspectRatio);
   printf("Frame rate:      %5d = %.3f Pictures/sec\n",FrameRate,rates[FrameRate]);
   printf("bitrate:         %5d = %d bits/sec\n",VideoBitRate,VideoBitRate*400);
   if(VideoBitRate==0x3ffff) printf("*** This is variable bitrate ***\n");
   printf("marker bit:      %5d\n",marker_bit);
   printf("VBV buffer size: %5d\n",VBVBufferSize);
   printf("CSPF:            %5d\n",CSPF);

   /* check if we have to load intra or non intra quantizer matrices */

   SeqHdrLen = 12;
   c = SeqHdr[SeqHdrLen-1];
   if(c&2) /* Load intra */
      for(i=0;i<64;i++) SeqHdr[SeqHdrLen++] = getc(mpegin);

   c = SeqHdr[SeqHdrLen-1];
   if(c&1) /* Load non intra */
      for(i=0;i<64;i++) SeqHdr[SeqHdrLen++] = getc(mpegin);

   lasttag = 0;
   gop_start_frame = 0;
   frame_no = 0;
   MPEG_frame_len = 0;

   twofields = 0;
   mpeg2 = 0;

   /* Search for MPEG-2 sequence extension header */

   tag = 0xffffffff;
   while(1)
   {
      c = getc(mpegin);
      if(c==EOF)
      {
         fprintf(stderr,"Unexpected EOF in header\n");
         exit(1);
      }
      tag = (tag<<8) | c;
      /* Break if first frame or seq. ext. header is reached */
      if(tag == 0x100 || tag ==0x1b5) break;
   }

   if(tag==0x1b5)
   {
      printf("*** this is a MPEG-2 stream ***\n");
      mpeg2 = 1;
      SeqExt[0] = 0x00;
      SeqExt[1] = 0x00;
      SeqExt[2] = 0x01;
      SeqExt[3] = 0xb5;
      if( fread(SeqExt+4,1,6,mpegin) != 6 )
      {
         fprintf(stderr,"Unexpected EOF in header\n");
         exit(1);
      }
      ProgSeq = getbits(SeqExt,44,1);
      printf("Progressive:     %5d\n",ProgSeq);
      twofields = (ProgSeq==0);
      for(i=0;i<10;i++) SeqHdr[SeqHdrLen++] = SeqExt[i];
   }

   /* Rewind file */

   fseek(mpegin,0,SEEK_SET);
}

int get_m1v_frame()
{
   int c, i, nvb;
   char *picture_header;

   if(lasttag == 0)
   {
      /* First time called, do some intializations */

      /* Fill up lasttag */

      c = getc(mpegin);
      lasttag = c;
      c = getc(mpegin);
      lasttag = (lasttag<<8) | c;
      c = getc(mpegin);
      lasttag = (lasttag<<8) | c;
      c = getc(mpegin);
      lasttag = (lasttag<<8) | c;

      /* Number of bytes in video buffer */

      nvb = 0;

      seqhdr_seen = 0;

      /* search for start of first frame */

      do
      {
         MPEGvbuff[nvb++] = FIRST_BYTE(lasttag);
         check_buffer_size(nvb);

         c = getc(mpegin);
         if(c==EOF)
         {
            fprintf(stderr,"Unexpected EOF when searching for 1st frame\n");
            exit(1);
         }
         lasttag = (lasttag<<8) | c;
      }
      while (lasttag != 0x100);
   }
   else if (lasttag == 0x1b7)
   {
      /* We are at the end */
      return 1;
   }
   else
   {
      /* Number of bytes in video buffer */

      nvb = 0;
   }

   /* At this point we are just before a new frame is put into the buffer,
      remember buffer position */

   picture_header = MPEGvbuff + nvb;

   MPEG_frame_no = frame_no;
   frame_no++;
   MPEG_frame_seq = gop_start_frame; /* Real seq no calculated later */

   /* Search up to the start of the next frame (or end of MPEG) */

   do
   {
      MPEGvbuff[nvb++] = FIRST_BYTE(lasttag);
      check_buffer_size(nvb);

      c = getc(mpegin);
      if(c==EOF)
      {
         fprintf(stderr,"Unexpected EOF in MPEG video stream\n");
         return -1;
      }
      lasttag = (lasttag<<8) | c;

      /* check lasttag */

      /* If the file contains allready sequence headers within the
         MPEG stream, set seqhdr_seen to avoid duplicate seq headers */

      if(lasttag == 0x1b3) seqhdr_seen = 1;

      /* If we encounter a GOP header, we have to remember the
         number of the next frame to come and we will insert
         a sequence header just before the GOP header */

      if(lasttag == 0x1b8)
      {
         gop_start_frame = frame_no;

         if(!seqhdr_seen)
         {
            for(i=0;i<SeqHdrLen;i++)
            {
               MPEGvbuff[nvb++] = SeqHdr[i];
               check_buffer_size(nvb);
            }
         }

         seqhdr_seen = 0;
      }

   }
   while (lasttag != 0x100 && lasttag != 0x1b7 );

   /* Extract temporal reference and frame type from picture header */

   MPEG_frame_seq += getbits(picture_header,32,10);
   MPEG_frame_type = getbits(picture_header,42, 3);
   MPEG_frame_len  = nvb;

   return 0;
}

static unsigned int bitrate_index [3][16] =
    {{0,32,64,96,128,160,192,224,256,288,320,352,384,416,448,0},
     {0,32,48,56,64,80,96,112,128,160,192,224,256,320,384,0},
     {0,32,40,48,56,64,80,96,112,128,160,192,224,256,320,0}};

static double frequency_index [4] = {44.1, 48, 32, 0};
static unsigned int slots [4] = {12, 144, 0, 0};
static unsigned int samples [4] = {384, 1152, 0, 0};

static char mode_index [4][15] =
    { "stereo", "joint stereo", "dual channel", "single channel" };
static char copyright_index [2][20] =
    { "no copyright","copyright protected" };
static char original_index [2][10] =
    { "copy","original" };
static char emphasis_index [4][20] =
    { "none", "50/15 microseconds", "reserved", "CCITT J.17" };


open_mp2(char *filename)
{
   unsigned long header;
   int layer, protection, bit_rate, frequency, padding, mode,
       mode_extension, copyright, original_copy, emphasis;
   int numwarn;

   audioin = fopen(filename,"r");
   if(audioin==0)
   {
      perror("Open audio file");
      exit(1);
   }

   header = getc(audioin);
   header = (header<<8) | getc(audioin);
   header = (header<<8) | getc(audioin);
   header = (header<<8) | getc(audioin);

   if( (header&0xfff80000) != 0xfff80000)
   {
      fprintf(stderr,"Audio input file is not a 11172-3 Audio stream\n");
      exit(1);
   }

   layer          = (header>>17) & 3;
   protection     = (header>>16) & 1;
   bit_rate       = (header>>12) & 0xf;
   frequency      = (header>>10) & 3;
   padding        = (header>> 9) & 1;
   /* ??? */
   mode           = (header>> 6) & 3;
   mode_extension = (header>> 4) & 3;
   copyright      = (header>> 3) & 1;
   original_copy  = (header>> 2) & 1;
   emphasis       =  header      & 3;

   AudioBitRate = bitrate_index[3-layer][bit_rate];

   printf("\nAudio input file properties:\n\n");
   printf("layer:               %3d\n",3-layer+1);
   printf("protection:          %3d\n",protection);
   printf("bit_rate:            %3d = %d KB/s\n",bit_rate,AudioBitRate);
   printf("frequency:           %3d = %2.1f kHz\n",frequency,
                                   frequency_index[frequency]);
   printf("mode:                %3d = %s\n",mode,mode_index[mode]);
   printf("mode_extension:      %3d\n",mode_extension);
   printf("copyright:           %3d = %s\n",copyright,
                                   copyright_index[copyright]);
   printf("original_copy:       %3d = %s\n",original_copy,
                                   original_index[original_copy]);
   printf("emphasis:            %3d = %s\n",emphasis,
                                   emphasis_index[emphasis]);
   printf("\n");

   if(layer!=2)
   {
      fprintf(stderr,"*** Can not handle layer %d files!\n",3-layer+1);
      exit(1);
   }
   if(AudioBitRate == 0)
   {
      fprintf(stderr,"*** Audio bitrate not supported!\n");
      exit(1);
   }

   numwarn = 0;
   if(bit_rate!=11)
   {
      fprintf(stderr,"Warning: Bitrate for VCD should be 224 KBit/sec!\n");
      numwarn++;
   }
   if(frequency!=0)
   {
      fprintf(stderr,"Warning: Frequency for VCD should be 44.1 kHz!\n");
      numwarn++;
   }
   if(mode!=0)
   {
      fprintf(stderr,"Warning: Mode for VCD should be Stereo!\n");
      numwarn++;
   }

   if(numwarn)
   {
      fprintf(stderr,"*** The audio file does not comply with VCD requirements ***\n");
      fprintf(stderr,"*** Resulting output might not be readable everywhere ***\n");
   }
}

static void buffer_timecode (unsigned long time, unsigned char marker,
                             unsigned char *buffer)
{
   buffer[0] = (marker << 4) | ((time >> 29) & 0x6) | 1;
   buffer[1] =  (time & 0x3fc00000) >> 22;
   buffer[2] = ((time & 0x003f8000) >> 14) | 1;
   buffer[3] =  (time & 0x7f80) >> 7;
   buffer[4] = ((time & 0x007f) << 1) | 1;
}

static void make_pack_header()
{
   /* zero packet */

   memset(packet,0,SECTOR_SIZE);

   /* PACK header is 0x1ba */

   packet[0] = 0;
   packet[1] = 0;
   packet[2] = 1;
   packet[3] = 0xba;

   buffer_timecode (system_clock, MARKER_SCR, packet+4 );

   packet[ 9] = (0x80 | (MuxRate >>15));
   packet[10] = (0xff & (MuxRate >> 7));
   packet[11] = (0x01 | ((MuxRate & 0x7f)<<1));

   npb = 12;
}

static void make_system_header(int audio)
{
   int fixed = 0;
   int CSPS  = 0;
   int audio_lock = 0;
   int video_lock = 0;
   int audio_bound;
   int video_bound;
   int stream_id;
   int buffer_scale;
   int buffer_size;

   if(audio)
   {
      stream_id    = 0xc0;
      audio_bound  = 1;
      video_bound  = 0;
      buffer_scale = 0;
      buffer_size  = 32;
   }
   else
   {
      stream_id    = 0xe0;
      audio_bound  = 0;
      video_bound  = 1;
      buffer_scale = 1;
      buffer_size  = 46;
   }

   /* SYSTEM header is 0x1bb */

   packet[npb++] = 0;
   packet[npb++] = 0;
   packet[npb++] = 1;
   packet[npb++] = 0xbb;

   /* Length is 9 */

   packet[npb++] = 0;
   packet[npb++] = 9;

   packet[npb++] = (0x80 | (MuxRate >>15));
   packet[npb++] = (0xff & (MuxRate >> 7));
   packet[npb++] = (0x01 | ((MuxRate & 0x7f)<<1));
   packet[npb++] = ((audio_bound << 2)|(fixed << 1)|CSPS);
   packet[npb++] = ((audio_lock << 7)| (video_lock << 6)|0x20|video_bound);
   packet[npb++] = 0xff;

   packet[npb++] = stream_id;
   packet[npb++] = (0xc0 | (buffer_scale << 5) | (buffer_size >> 8));
   packet[npb++] = (buffer_size & 0xff);

}

/*
 * write_pack_packet: write out a sector consisting of a pack header
 *                    and a packet, add length entries for packet
 *                    and add a pad packet if wanted
 */

static void write_pack_packet(int add_pad)
{
   int i, len;

   /* Safety first */

   if(npb>SECTOR_SIZE)
   {
      fprintf(stderr,"Internal error: sector size exceeded!\n");
      exit(1);
   }

   len = npb - 18;
   if(len>0)
   {
      packet[16] = len>>8;
      packet[17] = len&0xff;
   }

   /* Pad packet to neccesary length of SECTOR_SIZE */

   if( add_pad && npb <= SECTOR_SIZE-8)
   {
      /* There is space for a PAD packet */

      /* PAD header is 0x1be */

      packet[npb++] = 0;
      packet[npb++] = 0;
      packet[npb++] = 1;
      packet[npb++] = 0xbe;

      len = SECTOR_SIZE - npb - 2;

      packet[npb++] = (len>>8);
      packet[npb++] = (len&0xff);

      packet[npb++] = 0xf; /* No timestamp for this package */

      while(npb<SECTOR_SIZE) packet[npb++] = 0xff;
   }

   if(fwrite(packet,1,SECTOR_SIZE,sysout) != SECTOR_SIZE)
   {
      fprintf(stderr,"Can not write to output file\n");
      exit(1);
   }
}

main(int argc, char **argv)
{
   int num_packs, i, n, remlen;
   int bytes_out = 0;
   long video_start_time, audio_start_time;
   long last_buffer_time;
   long audio_time;
   long max_time_diff = 0;
   int num_audio_packs = 0;
   int audio_eof = 0;
   int need_padding = 0;
   unsigned char MPEGvbuff_save[SECTOR_SIZE];
   int tpf, nfields, nsecps, tpsect;
   int last_message_time = 0;
   int use_padding_sectors;
   struct stat stat_buf;

   if(argc!=4)
   {
      fprintf(stderr,"Usage:\n   %s in.m1v in.mp2 out.mpg\n",argv[0]);
      exit(1);
   }

   /* Check if the output file exists and quit in that case */

   if(stat(argv[3],&stat_buf) == 0)
   {
      fprintf(stderr,"Output file %s already exists - will not delete it!\n",argv[3]);
      fprintf(stderr,"Please delete file by hand and start again\n");
      exit(1);
   }

   /* Open output file */

   sysout = fopen(argv[3],"w");
   if(sysout==0)
   {
      perror("Open output file");
      exit(1);
   }

   video_start_time = audio_start_time = 72000;
   last_buffer_time = video_start_time;

   open_m1v(argv[1]);

   if(VideoBitRate==0 || VideoBitRate==0x3ffff)
   {
      fprintf(stderr,"Variable Bitrate not supported!\n");
      exit(1);
   }

   if (FrameRate==3)
      tpf = 3600;  /* PAL */
   else if (FrameRate==4)
      tpf = 3003;  /* NTSC */
   else
   {
      fprintf(stderr,"Picture rate not supported!\n");
      exit(1);
   }
   nfields = twofields ? 2 : 1;
   printf("MPEG clock ticks/frame: %d, fields/frame: %d\n",tpf,nfields);

   open_mp2(argv[2]);

   if(VideoBitRate==2880 && AudioBitRate==224)
   {
      printf("Input has VCD Bitrates - Creating 75 sectors/sec with padding\n");
      nsecps = 75;
      use_padding_sectors = 1;
   }
   else
   {
      /* Calculate Number of sectors per second assuming
         2300 used bytes (= 18400 bits) per sector */

      nsecps = (VideoBitRate*400 + AudioBitRate*1000)/18400 + 1;

      /* Round up to a multiple of 5 */

      nsecps = (nsecps+4)/5;
      nsecps = nsecps*5;
      use_padding_sectors = 0;

      printf("Creating %d sectors/sec without padding\n",nsecps);
   }

   /* Mux Rate (a sector has 2352 raw bytes) */

   MuxRate = nsecps*2352/50;
   printf("Muxrate = %d Bit/s\n",MuxRate*400);

   /* Ticks per sector */

   tpsect = 90000/nsecps;

   system_clock = 36000;

   make_pack_header();
   make_system_header(1);
   write_pack_packet(1);

   system_clock += tpsect;
   make_pack_header();
   make_system_header(0);
   write_pack_packet(1);

   num_packs = 2;

   while(1)
   {
      system_clock += tpsect;
      num_packs++;

      make_pack_header();

      if(need_padding)
      {
         /* Write a padding sector */

         write_pack_packet(1);
         fprintf(stderr,"Inserted padding sector %d\n",num_packs);
         need_padding = 0;
         continue;
      }

      /*
       * Look if we have to output a audio packet.
       * We do that at start (actually the 6th Packet) and every
       * time when another packet fits into the (imaginary) 4 KB audio buffer
       */

      audio_time = (num_audio_packs*AUDIO_BYTES/(AudioBitRate/8))*90 + audio_start_time;

      if( !audio_eof &&
          ((num_audio_packs==0 && num_packs==6) ||
           (audio_time-system_clock <=
              (AUDIO_BUFFER_SIZE-AUDIO_BYTES)*90/(AudioBitRate/8))))
      {
         /* Audio packet header */

         packet[npb++] = 0;
         packet[npb++] = 0;
         packet[npb++] = 1;
         packet[npb++] = 0xc0;

         npb += 2; /* For length */

         packet[npb++] = 0x40;
         packet[npb++] = 0x20;

         buffer_timecode(audio_time, MARKER_JUST_PTS, packet+npb);
         npb+=5;

         n = fread(packet+npb,1,AUDIO_BYTES,audioin);
         npb+=n;

         if(n<AUDIO_BYTES) audio_eof = 1;
         if(audio_eof) printf("------ Audio EOF at %d secs %d bytes -------\n",
                              num_audio_packs*AUDIO_BYTES/(1000*AudioBitRate/8),
                              num_audio_packs*AUDIO_BYTES+n);

         write_pack_packet(0);

         num_audio_packs++;
         continue;
      }

      /* video packet  header is 0x1e0 */

      packet[npb++] = 0;
      packet[npb++] = 0;
      packet[npb++] = 1;
      packet[npb++] = 0xe0;

      npb += 2; /* For length */

      /*
       * The maximum length of a video packet is SECTOR_SIZE-18 bytes.
       * For starting a new packet we need (at most) 16 additional bytes.
       * So we can fill the current MPEG data into the buffer if
       * more than SECTOR_SIZE-34 bytes are present
       */

      remlen = MPEG_frame_len-bytes_out;

      if(remlen > SECTOR_SIZE-34)
      {
         n = (remlen>SECTOR_SIZE-18) ? SECTOR_SIZE-18 : remlen;

         packet[npb++] = 0xf; /* No timestamp */

         for(i=0;i<n-1;i++) packet[npb++] = MPEGvbuff[bytes_out++];

         write_pack_packet(0);
         continue;
      }

      /*
       * If we come here, we have to start a new frame in this sector.
       * The tricky thing is that we don't know yet how big the timecode
       * will be. Save the current MPEG buffer and read an new frame
       * to see what we get
       */

      memcpy(MPEGvbuff_save,MPEGvbuff+bytes_out,remlen);

      if(get_m1v_frame())
      {
         /* The End */

         packet[npb++] = 0xf; /* No timestamp */
         for(i=0;i<remlen;i++) packet[npb++] = MPEGvbuff_save[i];

         /* Add a SEQUENCE_END code for MPEG */

         packet[npb++] = 0;
         packet[npb++] = 0;
         packet[npb++] = 1;
         packet[npb++] = 0xb7;

         write_pack_packet(0);

         /* Add an empty sector starting with ISO11172_END */

         fputc(0x00,sysout);
         fputc(0x00,sysout);
         fputc(0x01,sysout);
         fputc(0xb9,sysout);
         for(i=0;i<SECTOR_SIZE-4;i++) fputc(0x00,sysout);

         printf("Max buffer required: %d KB\n",max_time_diff/1200*SECTOR_SIZE/1024);
         exit(0);
      }
      bytes_out = 0;

      if(last_buffer_time<=system_clock)
         fprintf(stderr,"***** BUFFER underrun - output may not play correctly *****\n");

      if(MPEG_frame_type==1 || MPEG_frame_type==2)
      {
         /* I or P frame */

         packet[npb++] = 0x60;
         packet[npb++] = 0x2e;
         buffer_timecode(MPEG_frame_seq*tpf/nfields+video_start_time,
                         MARKER_PTS,packet+npb);
         npb+=5;
         buffer_timecode(MPEG_frame_no *tpf/nfields+video_start_time,
                         MARKER_DTS,packet+npb);
         npb+=5;
         last_buffer_time = MPEG_frame_no *tpf/nfields+video_start_time;
      }
      else
      {
         buffer_timecode(MPEG_frame_seq*tpf/nfields+video_start_time,
                         MARKER_JUST_PTS,packet+npb);
         npb+=5;
         last_buffer_time = MPEG_frame_seq*tpf/nfields+video_start_time;
      }

      /* Inform the waiting user */

      if(MPEG_frame_seq*tpf/nfields/90000 > last_message_time+10)
      {
         last_message_time += 10;
         printf("%4d seconds done\n",last_message_time);
      }

      for(i=0;i<remlen;i++) packet[npb++] = MPEGvbuff_save[i];

      while(npb<SECTOR_SIZE && bytes_out<MPEG_frame_len)
         packet[npb++] = MPEGvbuff[bytes_out++];

      write_pack_packet(0);

      if(last_buffer_time-system_clock > max_time_diff)
         max_time_diff = last_buffer_time-system_clock;

      need_padding = last_buffer_time-system_clock > MAX_VBUFFER_TIME;
      if(need_padding && !use_padding_sectors)
      {
         /* We don't insert padding sectors, we just skip one sector
            (hopefully that works with all players) */
         system_clock += tpsect;
         need_padding = 0;
      }
   }
}
