#include <stdio.h>
#include <time.h>
#include "defaults.h"

/*
 * Make a (simple) ISO 9660 filesystem for a Video CD
 *
 * Many things in this program are just taken from mkisofs
 *
 * Structure of the filesystem
 *
 *     Block      Content
 *
 *     0-15       empty
 *     16         Primary Volume descriptor
 *     17         End Volume descriptor
 *     18         Path table (Intel Byte order) (must fit in 1 Sector)
 *     19         Path table (Motorola Byte order) (must fit in 1 Sector)
 *     20         Root directory
 *     21  ...    Other directories
 *     150 ...    Files in directory VCD
 *     210 ...    Other files
 */


/* Path table stuff. Note that this is simplified and only valid
   if there are no subdirectories below the directories in the
   root directory and if the path tables fit into 1 sector */

#define PATH_TABLE_L_EXTENT 18
#define PATH_TABLE_M_EXTENT 19

#define ISO_DIR_SIZE 2048

static char path_table_l[2048];
static char path_table_m[2048];
static int  path_table_size;

#define ROOT_DIR_EXTENT   20
#define START_FILE_EXTENT 210 /* for files not in directory VCD */

static int root_dir_len;
static char root_dir[ISO_DIR_SIZE];
static int cur_dir_extent;
static int cur_file_extent;

static char zero2048[2048] = { 0, };
static char buff2048[2048];

#define LEN2BLOCKS(x) ( ((x)+2047)>>11 )

/* Various files on the VCD */

static char entries_file[2048];
static char info_file[2048] = {
  'V', 'I', 'D', 'E', 'O', '_', 'C', 'D',
    1,   1, '1', ' ', ' ', ' ', ' ', ' ',
  ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
  ' ', ' ',   0,   1,   0,   1,   0,   0,
};

static struct tm *t;

#define BCD(x) ( ((x)/10)*16 + (x)%10 )

static void set_721( char *pnt, unsigned int i)
{
     pnt[0] = i & 0xff;
     pnt[1] = (i >> 8) &  0xff;
}

static void set_722( char *pnt, unsigned int i)
{
     pnt[0] = (i >> 8) &  0xff;
     pnt[1] = i & 0xff;
}

static void set_723( char *pnt, unsigned int i)
{
     pnt[3] = pnt[0] = i & 0xff;
     pnt[2] = pnt[1] = (i >> 8) &  0xff;
}

static void set_731( char *pnt, unsigned int i)
{
     pnt[0] = i & 0xff;
     pnt[1] = (i >> 8) &  0xff;
     pnt[2] = (i >> 16) &  0xff;
     pnt[3] = (i >> 24) &  0xff;
}

static void set_732( char *pnt, unsigned int i)
{
     pnt[3] = i & 0xff;
     pnt[2] = (i >> 8) &  0xff;
     pnt[1] = (i >> 16) &  0xff;
     pnt[0] = (i >> 24) &  0xff;
}

static void set_733( char *pnt, unsigned int i)
{
     pnt[7] = pnt[0] = i & 0xff;
     pnt[6] = pnt[1] = (i >> 8) &  0xff;
     pnt[5] = pnt[2] = (i >> 16) &  0xff;
     pnt[4] = pnt[3] = (i >> 24) &  0xff;
}

static void set_str( char *pnt, char *src, unsigned int len)
{
     int i, l;
     l = strlen(src);

     for(i=0;i<len;i++) pnt[i] = (i<l) ? src[i] : ' ';
}


void make_path_tables()
{
   int i, j, len, extent;
   unsigned char *root_dir_entry;

   memset(path_table_l, 0, sizeof(path_table_l));
   memset(path_table_m, 0, sizeof(path_table_m));

   path_table_size = 0;

   for(root_dir_entry = root_dir;
       root_dir_entry[0]>0;
       root_dir_entry += root_dir_entry[0] )
   {
      /* Skip the .. entry in the root directory */

      if (root_dir_entry[33]==1) continue;

      len = root_dir_entry[32];
      path_table_l[path_table_size] = len;
      path_table_m[path_table_size] = len;
      path_table_size += 2;

      extent =  root_dir_entry[2]      +
               (root_dir_entry[3]<< 8) +
               (root_dir_entry[4]<<16) +
               (root_dir_entry[5]<<24);
      set_731(path_table_l + path_table_size, extent);
      set_732(path_table_m + path_table_size, extent);
      path_table_size += 4;

      set_721(path_table_l + path_table_size, 1);
      set_722(path_table_m + path_table_size, 1);
      path_table_size += 2;

      for(j=0; j<len; j++)
      {
         path_table_l[path_table_size] = root_dir_entry[33+j];
         path_table_m[path_table_size] = root_dir_entry[33+j];
         path_table_size++;
      }
      if(path_table_size & 1) path_table_size++;
   }
}

/* From mkisofs: */

#define ISODCL(from, to) (to - from + 1)

static struct iso_primary_descriptor {
        char type                       [ISODCL (  1,   1)]; /* 711 */
        char id                         [ISODCL (  2,   6)];
        char version                    [ISODCL (  7,   7)]; /* 711 */
        char unused1                    [ISODCL (  8,   8)];
        char system_id                  [ISODCL (  9,  40)]; /* achars */
        char volume_id                  [ISODCL ( 41,  72)]; /* dchars */
        char unused2                    [ISODCL ( 73,  80)];
        char volume_space_size          [ISODCL ( 81,  88)]; /* 733 */
        char escape_sequences           [ISODCL ( 89, 120)];
        char volume_set_size            [ISODCL (121, 124)]; /* 723 */
        char volume_sequence_number     [ISODCL (125, 128)]; /* 723 */
        char logical_block_size         [ISODCL (129, 132)]; /* 723 */
        char path_table_size            [ISODCL (133, 140)]; /* 733 */
        char type_l_path_table          [ISODCL (141, 144)]; /* 731 */
        char opt_type_l_path_table      [ISODCL (145, 148)]; /* 731 */
        char type_m_path_table          [ISODCL (149, 152)]; /* 732 */
        char opt_type_m_path_table      [ISODCL (153, 156)]; /* 732 */
        char root_directory_record      [ISODCL (157, 190)]; /* 9.1 */
        char volume_set_id              [ISODCL (191, 318)]; /* dchars */
        char publisher_id               [ISODCL (319, 446)]; /* achars */
        char preparer_id                [ISODCL (447, 574)]; /* achars */
        char application_id             [ISODCL (575, 702)]; /* achars */
        char copyright_file_id          [ISODCL (703, 739)]; /* 7.5 dchars */
        char abstract_file_id           [ISODCL (740, 776)]; /* 7.5 dchars */
        char bibliographic_file_id      [ISODCL (777, 813)]; /* 7.5 dchars */
        char creation_date              [ISODCL (814, 830)]; /* 8.4.26.1 */
        char modification_date          [ISODCL (831, 847)]; /* 8.4.26.1 */
        char expiration_date            [ISODCL (848, 864)]; /* 8.4.26.1 */
        char effective_date             [ISODCL (865, 881)]; /* 8.4.26.1 */
        char file_structure_version     [ISODCL (882, 882)]; /* 711 */
        char unused4                    [ISODCL (883, 883)];
        char application_data           [ISODCL (884, 1395)];
        char unused5                    [ISODCL (1396, 2048)];
} ipd;

static struct iso_directory_record {
        unsigned char length            [ISODCL (1, 1)];   /* 711 */
        char ext_attr_length            [ISODCL (2, 2)];   /* 711 */
        char extent                     [ISODCL (3, 10)];  /* 733 */
        char size                       [ISODCL (11, 18)]; /* 733 */
        char date                       [ISODCL (19, 25)]; /* 7 by 711 */
        char flags                      [ISODCL (26, 26)];
        char file_unit_size             [ISODCL (27, 27)]; /* 711 */
        char interleave                 [ISODCL (28, 28)]; /* 711 */
        char volume_sequence_number     [ISODCL (29, 32)]; /* 723 */
        unsigned char name_len          [ISODCL (33, 33)]; /* 711 */
        char name                       [34]; /* Not really, but we need something here */
} idr;


static void add_dirent(char *dir, int *dirlen, int dirsize,
           char *name, int namelen, int extent, int size, int flags, int xa)
{
   int reclen;

   reclen = 33 + namelen;
   if(reclen & 1) reclen++;

   if(xa>0) reclen += 14; /* RJ: I don't know for what - see below */

   if( (*dirlen) + reclen > dirsize )
   {
      fprintf(stderr,"Fatal Error: add_dirent - max dirsize exceeded\n");
      exit(1);
   }

   memset(dir+(*dirlen), 0, reclen);

   memset(&idr, 0 , sizeof(idr));

   idr.length[0] = reclen;
   idr.ext_attr_length[0] = 0;
   set_733(idr.extent,extent);
   set_733(idr.size,size);

   idr.date[0] = t->tm_year;
   idr.date[1] = t->tm_mon+1;
   idr.date[2] = t->tm_mday;
   idr.date[3] = t->tm_hour;
   idr.date[4] = t->tm_min;
   idr.date[5] = t->tm_sec;
   idr.date[6] = 0; /* This is in units of 15 minutes from GMT */

   idr.flags[0] = flags;
   idr.file_unit_size[0] = 0;
   idr.interleave[0] = 0;

   set_723(idr.volume_sequence_number,1);

   idr.name_len[0] = namelen;

   memcpy(dir+(*dirlen), &idr, 33);
   memcpy(dir+(*dirlen)+33, name, namelen);

   /* RJ: I don't know exactly what the following is good for,
          it is needed to play VCDs under windows.
          Since I don't know the meaning of some entries,
          this stuff is only added for the MPEG files.
          Other VCDs have it for every file */

   if(xa>0)
   {
      dir[*dirlen+reclen-10] = 0x15; /* ????? */
      dir[*dirlen+reclen- 9] = 0x55; /* ????? */
      dir[*dirlen+reclen- 8] = 'X';
      dir[*dirlen+reclen- 7] = 'A';
      dir[*dirlen+reclen- 6] = xa;
   }

   (*dirlen) += reclen;

}

static void make_ipd()
{
   char iso_time[17];
   int len;
   char name[1];

   memset(&ipd,0,sizeof(ipd));

   ipd.type[0] = 1;
   set_str(ipd.id,"CD001",5);
   ipd.version[0] = 1;

   set_str(ipd.system_id,CD_SYSTEM_ID,32);
   set_str(ipd.volume_id,CD_VOLUME_ID,32);

   set_733(ipd.volume_space_size,ISO_FS_BLOCKS);
   /* we leave ipd.escape_sequences = 0 */

   set_723(ipd.volume_set_size,1);
   set_723(ipd.volume_sequence_number,1);
   set_723(ipd.logical_block_size,2048);

   set_733(ipd.path_table_size,path_table_size);
   set_731(ipd.type_l_path_table,PATH_TABLE_L_EXTENT);
   set_731(ipd.opt_type_l_path_table,0);
   set_732(ipd.type_m_path_table,PATH_TABLE_M_EXTENT);
   set_732(ipd.opt_type_m_path_table,0);

   len = 0;
   name[0] = 0;
   add_dirent(ipd.root_directory_record, &len, 34,
              name, 1, ROOT_DIR_EXTENT, ISO_DIR_SIZE, 2, -1);
   if(len!=34)
   {
      fprintf(stderr,"Internal error in make_ipd\n");
      exit(1);
   }

   set_str(ipd.volume_set_id , CD_VOLUME_SET_ID , 128);
   set_str(ipd.publisher_id  , CD_PUBLISHER_ID  , 128);
   set_str(ipd.preparer_id   , CD_PREPARER_ID   , 128);
   set_str(ipd.application_id, CD_APPLICATION_ID, 128);

   set_str(ipd.copyright_file_id    , " ", 37);
   set_str(ipd.abstract_file_id     , " ", 37);
   set_str(ipd.bibliographic_file_id, " ", 37);

   sprintf(iso_time, "%4.4d%2.2d%2.2d%2.2d%2.2d%2.2d00",
              1900+(t->tm_year), t->tm_mon+1, t->tm_mday,
              t->tm_hour, t->tm_min, t->tm_sec);
   iso_time[16] = 0; /* This is in binary! Units of 15 minutes from GMT */

   memcpy(ipd.creation_date,    iso_time,17);
   memcpy(ipd.modification_date,iso_time,17);
   memcpy(ipd.expiration_date,  "0000000000000000\0",17);
   memcpy(ipd.effective_date,   iso_time,17);

   ipd.file_structure_version[0] = 1;

   /*  The string CD-XA001 in this exact position indicates  */
   /*  that the disk contains XA sectors.                    */
   memcpy(ipd.application_data+141, "CD-XA001", 8);
}

static void init_iso_dir(char *dir, int *dirlen, int self, int parent)
{
   char name[1];

   memset(dir,0,ISO_DIR_SIZE);
   *dirlen = 0;

   /* add . and .. entries */

   name[0] = 0;
   add_dirent(dir, dirlen, ISO_DIR_SIZE, name, 1, self,   ISO_DIR_SIZE, 2, 0);

   name[0] = 1;
   add_dirent(dir, dirlen, ISO_DIR_SIZE, name, 1, parent, ISO_DIR_SIZE, 2, 0);
}

void add_CDI_dir()
{
   char dir[ISO_DIR_SIZE];
   int dirlen, len, i;

   cur_dir_extent++;

   if(cur_dir_extent>=150)
   { fprintf(stderr,"Fatal Error: too many dirs\n"); exit(1); }

   /* Initialize directory */

   init_iso_dir(dir, &dirlen, cur_dir_extent, ROOT_DIR_EXTENT);

   /* Add this directory to root directory */

   add_dirent(root_dir, &root_dir_len, ISO_DIR_SIZE,
              "CDI", 3, cur_dir_extent, ISO_DIR_SIZE, 2, 0);

   /* Add files */

   /* Since this directory is only used for CDI players
      which are hardly in use any more, we add only a bogus file
      CDI_VCD.APP consisting of 0's */

   /* CDI_VCD.APP */

   len = 2048;
   add_dirent(dir, &dirlen, ISO_DIR_SIZE,
              "CDI_VCD.APP;1", 13, cur_file_extent, len, 0, 0);
   for(i=0;i<LEN2BLOCKS(len);i++) output_form1(cur_file_extent++,zero2048);

   /* Output the directory record */

   output_form1(cur_dir_extent,dir);
}

void add_MPEGAV_dir(int num, int *extent, int *size)
{
   char dir[ISO_DIR_SIZE];
   int dirlen, len, i;
   char name[32];

   cur_dir_extent++;

   if(cur_dir_extent>=150)
   { fprintf(stderr,"Fatal Error: too many dirs\n"); exit(1); }

   /* Initialize directory */

   init_iso_dir(dir, &dirlen, cur_dir_extent, ROOT_DIR_EXTENT);

   /* Add this directory to root directory */

   add_dirent(root_dir, &root_dir_len, ISO_DIR_SIZE,
              "MPEGAV", 6, cur_dir_extent, ISO_DIR_SIZE, 2, 0);

   /* Add files */

   /* RJ:
      This directory contains pointers to the MPEG files
      elsewhere (outside the ISO file system) on the disk.
      We have only to add the directory entries, not the
      files themselves.

      The length is also not the true length but the number
      of sectors muliplied by 2048
   */


   for(i=0;i<num;i++)
   {
      sprintf(name,"AVSEQ%2.2d.DAT;1",i+1);
      add_dirent(dir, &dirlen, ISO_DIR_SIZE,
                 name, 13, extent[i], size[i]*2048, 0, i+1);
   }

   /* Output the directory record */

   output_form1(cur_dir_extent,dir);
}

void add_VCD_dir(int num, int *extent)
{
   char dir[ISO_DIR_SIZE];
   int dirlen, len, i;

   cur_dir_extent++;

   if(cur_dir_extent>=150)
   { fprintf(stderr,"Fatal Error: too many dirs\n"); exit(1); }

   /* Initialize directory */

   init_iso_dir(dir, &dirlen, cur_dir_extent, ROOT_DIR_EXTENT);

   /* Add this directory to root directory */

   add_dirent(root_dir, &root_dir_len, ISO_DIR_SIZE,
              "VCD", 3, cur_dir_extent, ISO_DIR_SIZE, 2, 0);

   /* Add files */

   /* RJ:
      I have no description how the files in this directory
      should look, all I have is:
      
      ENTRIES.VCD file (MUST be at sector 151)
      This file of one Sector contains the list of
      start positions of Entries in the MPEG
      Audio/Video Tracks on the disc. The
      Entry address values are used by the
      PSD playlist to access Play segments in
      the MPEG tracks. It's also used at linear
      playback for NEXT / PREVIOUS chapter.

      INFO.VCD file (MUST be at sector 150)
      This file of one sector contains the
      Video CD system identification
      and a provision to identify the discs
      belonging to one Album.  An Album is a
      series of discs which contain related
      Audio/Video programs. It also contains
      information associated with the Play
      Sequence Descriptor (PSD).

      LOT.VCD file (probably sectors 152-183)
      This 32 sectors file contains the List ID
      Offset Table (LOT). The LOT associates
      List ID numbers with the corresponding
      List Offset values.
      This file is optional and not added here!

      PSD.VCD file (probably sectors 184-xxx)
      This file contains the data for the Play
      Sequence Descriptor (PSD). The size of
      the PSD may be variable, up to a
      maximum of 256 sectors or 512 KB.
      This file is optional and not added here!
   */


   /* ENTRIES.VCD */

   len = 2048;
   memset(entries_file, 0, 2048);
   strncpy(entries_file,"ENTRYVCD",8);
   entries_file[ 8] = 1;
   entries_file[ 9] = 1;
   entries_file[10] = 0;
   entries_file[11] = num;
   for(i=0;i<num;i++)
   {
      int m, s, f;

      f = extent[i]%75;
      s = extent[i]/75 + 2;
      m = s/60;
      s = s%60;
      entries_file[12+4*i  ] = i + 2;
      entries_file[12+4*i+1] = BCD(m);
      entries_file[12+4*i+2] = BCD(s);
      entries_file[12+4*i+3] = BCD(f);
   }
   cur_file_extent = 151;
   add_dirent(dir, &dirlen, ISO_DIR_SIZE,
              "ENTRIES.VCD;1", 13, cur_file_extent, len, 0, 0);
   output_form1(cur_file_extent++,entries_file);


   /* INFO.VCD */

   /* The info file is already set */
   len = 2048;
   cur_file_extent = 150;
   add_dirent(dir, &dirlen, ISO_DIR_SIZE,
              "INFO.VCD;1", 10, cur_file_extent, len, 0, 0);
   output_form1(cur_file_extent++,info_file);

   cur_file_extent = 152;

   /* Output the directory record */

   output_form1(cur_dir_extent,dir);
}

void mk_vcd_iso_fs(int num_MPEG_files, int *MPEG_extent, int *MPEG_size)
{
   int i;
   time_t T;
   /* some initializations */

   time(&T);
   t = gmtime(&T);

   init_iso_dir(root_dir, &root_dir_len, ROOT_DIR_EXTENT, ROOT_DIR_EXTENT);

   cur_dir_extent = ROOT_DIR_EXTENT;
   cur_file_extent = START_FILE_EXTENT;

   /* set the first 16 blocks to 0 */

   for(i=0;i<16;i++) output_form1(i,zero2048);

   /* Output the data */

   /* RJ: I don't know if the following has to be sorted */

   add_CDI_dir();
   add_MPEGAV_dir(num_MPEG_files, MPEG_extent, MPEG_size);

   /* Fill up the end of the iso file system, the VCD directory
      (which is still to be filled in) is before all others */

   for(i=cur_file_extent;i<ISO_FS_BLOCKS;i++)
      output_form1(i,zero2048);

   /* Add VCD directory */

   add_VCD_dir(num_MPEG_files, MPEG_extent);

   /* Fill in the gap beetween VCD directory data and other data */

   for(i=cur_file_extent;i<START_FILE_EXTENT;i++)
      output_form1(i,zero2048);

   /* Fill in the gap beetween directories and start of
      VCD directory data (which is always at sector 150) */

   for(i=cur_dir_extent+1;i<150;i++)
      output_form1(i,zero2048);

   /* Create and output path tables */

   make_path_tables();

   output_form1(PATH_TABLE_L_EXTENT,path_table_l);
   output_form1(PATH_TABLE_M_EXTENT,path_table_m);

   /* Output root directory */

   output_form1(ROOT_DIR_EXTENT, root_dir);

   /* Create ISO Primary desriptor */

   make_ipd();
   output_form1(16,(char *) &ipd);

   /* Create end volume descriptor */

   memset(buff2048, 0, 2048);

   buff2048[0] = 0xff;
   buff2048[1] = 'C';
   buff2048[2] = 'D';
   buff2048[3] = '0';
   buff2048[4] = '0';
   buff2048[5] = '1';
   buff2048[6] = 0x01;
   output_form1(17, buff2048);
}
