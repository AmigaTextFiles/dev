#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

#define ULONG unsigned long
#define UBYTE unsigned char
#define BOOL char
#define TRUE 1
#define FALSE 0

#define STRING_SIZE 100

UBYTE far data_blk[65536];

#define HEX(c) ((c>'9')?c-'A'+10:c-'0')

/* for non SAS compilers
void stch_l(char *chr_ptr, ULONG *u_ptr) {
  *u_ptr=0;
  while (isxdigit(*chr_ptr)) {
    *u_ptr=*u_ptr*16+HEX(*chr_ptr);
    chr_ptr++;
  }
}
*/

BOOL load(char *dest, char *src, ULONG *addr, ULONG *next_addr) {
  UBYTE chksum, temp1, temp2, byte_count, i;

  chksum=byte_count=(HEX(src[0]))*16 + HEX(src[1]); src+=2;
  temp1=(HEX(src[0]))*16 + HEX(src[1]);
  temp2=(HEX(src[2]))*16 + HEX(src[3]); src+=4;
  *addr=(long)temp1*256 + (long)temp2;
  *next_addr=*addr+(long)byte_count-3;
  chksum+=temp1+temp2;
  for (i=0;i<byte_count-3;i++) {
    temp1=(HEX(src[0]))*16 + HEX(src[1]); src+=2;
    chksum+=temp1;
    *(dest+(long)*addr+i)=temp1;
  }
  temp1=(HEX(src[0]))*16 + HEX(src[1]); src+=2;
  chksum+=temp1;
  if (chksum == 255) return(TRUE);
  return(FALSE);
}

void main(int argc, char **argv) {
  FILE *file_ptr;
  char string[STRING_SIZE];
  ULONG addr,next_addr;
  ULONG min_addr=65535,max_addr=0;
  ULONG line_num=0;
  ULONG i, j;
  int s_addr, e_addr;
  BOOL s_flag = FALSE, e_flag = FALSE;

  if (argc<3 || argc==2 && argv[1][0]=='?') {
    printf("USAGE: %s <options> <source> <destination>\n",argv[0]);
    printf("  options:  -s<hex number>  EPROM start address\n");
    printf("            -e<hex number>  EPROM end address\n");
  } else {
    for (j = 1; j < argc; j++) {
      if (argv[j][0] != '-') {
        break;
      } else {
        if (argv[j][1] == 's') {
          strcpy(string,&argv[j][2]);
          stch_i(string,&s_addr);
          s_flag = TRUE;
        }
        else if (argv[j][1] == 'e') {
          strcpy(string,&argv[j][2]);
          stch_i(string,&e_addr);
          e_flag = TRUE;
        } else {
          printf("Unknown option \'%s\'\n",argv[j]);
        }
      }
    }
    if (j+2 != argc) {
      printf("Missing source or destination filename\n");
    } else {
      if (!(file_ptr=fopen(argv[j],"r")))
        printf("Unable to open %s for input\n",argv[1]);
      else {
        for (i=0;i<65536;i++) {
          data_blk[i]=0xff;
        }
        while (fgets(string,STRING_SIZE,file_ptr)) {
          line_num++;
          if (string[0]!='S')
            printf("Not a Motorola Hex format file\n");
          else {
            switch (string[1]) {
              case '0':
                if (!load(string,&string[2],&addr,&next_addr))
                  printf("format or checksum error in line %ld\n",line_num);
                else {
                  string[next_addr]='\0';
                  printf("  Loading program %s\n",string);
                }
                break;
              case '1':
                if (!load(data_blk,&string[2],&addr,&next_addr))
                  printf("format or checksum error in line %ld\n",line_num);
                else {
                  max_addr=max((long)max_addr,next_addr);
                  min_addr=min((long)min_addr,addr);
                }
                break;
              case '2':
                printf("This program does not support 24 bit addresses\n");
                break;
              case '8':
                printf("This program does not support 24 bit addresses\n");
                break;
              case '9':
                if (!load(data_blk,&string[2],&addr,&next_addr))
                  printf("format or checksum error in line %ld",line_num);
                else {
                  printf("  Start address = %lX\n",addr);
                }
                break;
            }
          }
        }
        fclose(file_ptr);
        printf("\n  Address range = %lX - %lX\n",min_addr,max_addr-1);
        if (!s_flag) {
          while (TRUE) {
            printf("What is the starting address of the EPROM (Hex) ? ");
            gets(string);
            stch_l(string,&addr);
            if (addr>65535 || addr<0)
              printf("Invalid address\n");
            else break;
          }
        } else {
          addr = s_addr;
        }
        if (!e_flag) {
          while (TRUE) {
            printf("What is the ending address of the EPROM (Hex) [%X]? ",max_addr-1);
            gets(string);
            if (string[0] == '\0') break;
            stch_l(string,&max_addr);
            if (max_addr>65535 || max_addr<0)
              printf("Invalid address\n");
            else {
              max_addr++;
              break;
            }
          }
        } else {
          max_addr = e_addr+1;
        }
        if (!(file_ptr=fopen(argv[j+1],"wb")))
          printf("Unable to open %s for output\n",argv[2]);
        else {
          while (max_addr-addr>=16384) {
            fwrite(&data_blk[addr],16384,1,file_ptr);
            addr+=16384;
          }
          fwrite(&data_blk[addr],max_addr-addr,1,file_ptr);
        }
        fclose(file_ptr);
      }
    }
  }
}
