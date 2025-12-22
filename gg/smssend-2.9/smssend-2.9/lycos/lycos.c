/* Lycos Number Detector                */
/* (c) Ze KiLleR / SkyTech - 2001       */
/* This soft tries to detect the number */
/* found in the .jpg file passed as     */
/* first parameter. It returns it on    */
/* stdout.                              */
/* Compile it using :                   */
/*   gcc lycos.c -o lycos -ljpeg        */

#include <stdio.h>
#include "jpeglib.h"
#include <setjmp.h>

#define IMAGE_WIDTH 50
#define IMAGE_HEIGHT 20
#define NUMBER_WIDTH 6
#define NUMBER_HEIGHT 10
#define FILTER_VALUE 550

unsigned long int Pixels[IMAGE_HEIGHT][IMAGE_WIDTH];
unsigned char NUMBERS[10][NUMBER_HEIGHT][NUMBER_WIDTH] =
{{{0,0,255,255,0,0}, /* 0 */
  {0,255,0,0,255,0},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {0,255,0,0,255,0},
  {0,0,255,255,0,0}
  },
 {{0,0,0,255,0,0}, /* 1 */
  {0,0,255,255,0,0},
  {0,255,0,255,0,0},
  {0,0,0,255,0,0},
  {0,0,0,255,0,0},
  {0,0,0,255,0,0},
  {0,0,0,255,0,0},
  {0,0,0,255,0,0},
  {0,0,0,255,0,0},
  {0,255,255,255,255,255}
  },
 {{0,255,255,255,255,0}, /* 2 */
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {0,0,0,0,0,255},
  {0,0,0,255,255,0},
  {0,0,0,0,0,0},
  {0,255,255,0,0,0},
  {255,0,0,0,0,0},
  {255,0,0,0,0,0},
  {255,255,255,255,255,255}
  },
 {{0,255,255,255,255,0}, /* 3 */
  {255,0,0,0,0,255},
  {0,0,0,0,0,255},
  {0,0,0,0,0,255},
  {0,0,255,255,255,0},
  {0,0,0,0,0,255},
  {0,0,0,0,0,255},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {0,255,255,255,255,0}
  },
 {{0,0,0,0,255,0}, /* 4 */
  {0,0,0,255,255,0},
  {0,0,255,0,255,0},
  {0,255,0,0,255,0},
  {255,0,0,0,255,0},
  {255,0,0,0,255,0},
  {255,255,255,255,255,255},
  {0,0,0,0,255,0},
  {0,0,0,0,255,0},
  {0,0,0,0,255,0}
  },
 {{255,255,255,255,255,255}, /* 5 */
  {255,0,0,0,0,0},
  {255,0,0,0,0,0},
  {255,0,0,0,0,0},
  {255,255,255,255,255,0},
  {0,0,0,0,0,255},
  {0,0,0,0,0,255},
  {0,0,0,0,0,255},
  {0,0,0,0,0,255},
  {255,255,255,255,255,0}
  },
 {{0,0,255,255,255,0}, /* 6 */
  {0,255,0,0,0,0},
  {255,0,0,0,0,0},
  {255,0,0,0,0,0},
  {255,255,255,255,255,0},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {0,255,255,255,255,0}
  },
 {{255,255,255,255,255,255}, /* 7 */
  {0,0,0,0,0,255},
  {0,0,0,0,0,255},
  {0,0,0,0,255,0},
  {0,0,0,0,255,0},
  {0,0,0,0,255,0},
  {0,0,0,255,0,0},
  {0,0,0,255,0,0},
  {0,0,0,255,0,0},
  {0,0,0,255,0,0}
  },
 {{0,255,255,255,255,0}, /* 8 */
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {0,255,255,255,255,0},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {0,255,255,255,255,0}
  },
 {{0,255,255,255,255,0}, /* 9 */
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {255,0,0,0,0,255},
  {0,255,255,255,255,255},
  {0,0,0,0,0,255},
  {0,0,0,0,0,255},
  {0,0,0,0,0,255},
  {0,0,0,0,255,0},
  {0,255,255,255,0,0}
  }};


struct my_error_mgr {
  struct jpeg_error_mgr pub;	/* "public" fields */
  jmp_buf setjmp_buffer;	/* for return to caller */
};
typedef struct my_error_mgr * my_error_ptr;
METHODDEF(void) my_error_exit (j_common_ptr cinfo)
{
  my_error_ptr myerr = (my_error_ptr) cinfo->err;
  (*cinfo->err->output_message) (cinfo);
  longjmp(myerr->setjmp_buffer, 1);
}

GLOBAL(int) read_JPEG_file (const char *filename)
{
  struct jpeg_decompress_struct cinfo;
  struct my_error_mgr jerr;
  FILE * infile;		/* source file */
  JSAMPARRAY buffer;		/* Output row buffer */
  int row_stride,i,j;		/* physical row width in output buffer */

  if ((infile = fopen(filename, "rb")) == NULL) {
    fprintf(stderr, "can't open %s\n", filename);
    return 0;
  }
  cinfo.err = jpeg_std_error(&jerr.pub);
  jerr.pub.error_exit = my_error_exit;
  if (setjmp(jerr.setjmp_buffer)) {
    jpeg_destroy_decompress(&cinfo);
    fclose(infile);
    return 0;
  }
  jpeg_create_decompress(&cinfo);
  jpeg_stdio_src(&cinfo, infile);
  (void) jpeg_read_header(&cinfo, TRUE);
  (void) jpeg_start_decompress(&cinfo);
  row_stride = cinfo.output_width * cinfo.output_components;
  buffer = (*cinfo.mem->alloc_sarray)
		((j_common_ptr) &cinfo, JPOOL_IMAGE, row_stride, 1);
  j = 0;
  while (cinfo.output_scanline < cinfo.output_height) {
    (void) jpeg_read_scanlines(&cinfo, buffer, 1);
    for(i=0;i<row_stride/3;i++)
    {
      Pixels[j][i] = (buffer[0][i*3]+buffer[0][i*3+1]+buffer[0][i*3+2])>FILTER_VALUE?255:0;
    }
    j++;
  }
  (void) jpeg_finish_decompress(&cinfo);
  jpeg_destroy_decompress(&cinfo);
  fclose(infile);
  return 1;
}

void PrintNumber(unsigned char Num[NUMBER_HEIGHT][NUMBER_WIDTH])
{
  int i,j;

  for(j=0;j<NUMBER_HEIGHT;j++)
  {
    for(i=0;i<NUMBER_WIDTH;i++)
      printf("%d",Num[j][i]==0?0:1);
    printf("\n");
  }
  printf("\n");
}

int GetDiffValue(unsigned char A[NUMBER_HEIGHT][NUMBER_WIDTH],unsigned char B[NUMBER_HEIGHT][NUMBER_WIDTH])
{
  int I,J;
  int Diff;

  Diff = 0;
  for(J=0;J<NUMBER_HEIGHT;J++)
    for(I=0;I<NUMBER_WIDTH;I++)
    {
      if(A[J][I] != B[J][I])
        Diff++;
    }
  return Diff;
}

int FindNumber(unsigned char Num[NUMBER_HEIGHT][NUMBER_WIDTH])
{
  int I;
  int Val,Pos,Min;

  Min = 255;
  Pos = 255;
  for(I=0;I<10;I++)
  {
    Val = GetDiffValue(Num,NUMBERS[I]);
    if(Val < Min)
    {
      Min = Val;
      Pos = I;
    }
  }
  return Pos;
}

void ExtractNumber(int X,int Y,unsigned char Num[NUMBER_HEIGHT][NUMBER_WIDTH])
{
  int I,J;
  int R,G,B;

  for(J=0;J<NUMBER_HEIGHT;J++)
    for(I=0;I<NUMBER_WIDTH;I++)
      Num[J][I] = Pixels[Y+J][X+I];
}

void FindValue(char Val[])
{
  unsigned char Num1[NUMBER_HEIGHT][NUMBER_WIDTH],Num2[NUMBER_HEIGHT][NUMBER_WIDTH],Num3[NUMBER_HEIGHT][NUMBER_WIDTH],Num4[NUMBER_HEIGHT][NUMBER_WIDTH];

  ExtractNumber(11,5,Num1);
  ExtractNumber(19,5,Num2);
  ExtractNumber(27,5,Num3);
  ExtractNumber(35,5,Num4);
  snprintf(Val,5,"%d%d%d%d",FindNumber(Num1),FindNumber(Num2),FindNumber(Num3),FindNumber(Num4));
}

void PrintValue()
{
  int i,j;

  for(j=0;j<20;j++)
  {
    for(i=0;i<50;i++)
      printf("%d",Pixels[j][i]==0?0:1);
    printf("\n");
  }
  printf("\n");
}

int main(int argc,char *argv[])
{
  char Val[10];

  read_JPEG_file(argv[1]);
//  PrintValue();
  FindValue(Val);
  printf("%s\n",Val);
  return 0;
}
