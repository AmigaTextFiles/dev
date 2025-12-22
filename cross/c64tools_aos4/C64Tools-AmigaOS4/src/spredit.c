/*
 * C64 Sprite editor
 */

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <ctype.h>
#include <string.h>

#include "bme.h"

#define LEFT_BUTTON 1
#define RIGHT_BUTTON 2
#define SINGLECOLOR 0
#define MULTICOLOR 1

#define SPR_C 0
#define SPR_FONTS 1

#define COL_WHITE 0
#define COL_HIGHLIGHT 1

unsigned char cwhite[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
unsigned char chl[] = {12,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
unsigned char *colxlattable[] = {cwhite, chl};
unsigned char textbuffer[80];
unsigned char ib1[80];
int k,l;
unsigned char ascii;

int mousex = 160;
int mousey = 100;
int mouseb;
int prevmouseb = 0;
int sprnum = 0;
unsigned char *spritedata;
unsigned char ccolor = 2;
int testspr = 0;

int testsprx[16];
int testspry[16];
unsigned char testsprf[16];

unsigned char bgcol = 0;
unsigned char multicol1 = 15;
unsigned char multicol2 = 11;

unsigned char copybuffer[64] = {0};

unsigned char magx[256];
unsigned char magy[256];

void mainloop(void);
void mouseupdate(void);
int initsprites(void);
void drawgrid(void);
void clearspr(void);
void loadspr(void);
void savespr(void);
void flipsprx(void);
void flipspry(void);
void editspr(void);
void scrollsprleft(void);
void scrollsprright(void);
void scrollsprup(void);
void scrollsprdown(void);
void changecol(void);
void initstuff(void);
void drawcbar(int x, int y, unsigned char col);
void drawc64sprite(int bx, int by, int num);
void printtext_color(unsigned char *string, int x, int y, unsigned spritefile, int color);
void printtext_center_color(unsigned char *string, int y, unsigned spritefile, int color);
int inputtext(unsigned char *buffer, int maxlength);

extern unsigned char datafile[];

int main(int argc, char *argv[])
{
  FILE *handle;
  ib1[0] = 0; /* Initial filename=empty */

  io_openlinkeddatafile(datafile);

  if (!win_openwindow("C64 Sprite Editor", NULL)) return 1;
  win_fullscreen = 0;

  handle = fopen("spredit.cfg", "rb");
  if (handle)
  {
    fread(&bgcol, sizeof bgcol, 1, handle);
    fread(&multicol1, sizeof multicol1, 1, handle);
    fread(&multicol2, sizeof multicol2, 1, handle);
    fclose(handle);
  }

  initstuff();
  gfx_calcpalette(63,0,0,0);
  gfx_setpalette();
  mainloop();

  handle = fopen("spredit.cfg", "wb");
  if (handle)
  {
    fwrite(&bgcol, sizeof bgcol, 1, handle);
    fwrite(&multicol1, sizeof multicol1, 1, handle);
    fwrite(&multicol2, sizeof multicol2, 1, handle);
    fclose(handle);
  }
  return 0;
}

void mainloop(void)
{
  for (;;)
  {
    win_getspeed(70);
    k = kbd_getkey();
    ascii = kbd_getascii();
    if (ascii == 27) break;
    if (k == KEY_M) spritedata[sprnum*64+63] ^= 16;
    if (k == KEY_W) magx[sprnum] ^= 1;
    if (k == KEY_H) magy[sprnum] ^= 1;
    if (k == KEY_C) clearspr();
    if (k == KEY_V)
    {
      int y,x,c;
      unsigned char andtable[4] = {0xfc, 0xf3, 0xcf, 0x3f};
      for (y = 0; y < 21; y++)
      {
        for (c = 0; c < 3; c++)
        {
          for (x = 0; x < 4; x++)
          {
            unsigned char bit = (spritedata[sprnum*64+y*3+c] >> (x*2)) & 3;
            if (bit == 2) bit = 1;
            else if (bit == 1) bit = 2;
            spritedata[sprnum*64+y*3+c] &= andtable[x];
            spritedata[sprnum*64+y*3+c] |= (bit << (x*2));
          }
        }
      }
    }
    if (k == KEY_B)
    {
      int y,x,c;
      unsigned char andtable[4] = {0xfc, 0xf3, 0xcf, 0x3f};
      for (y = 0; y < 21; y++)
      {
        for (c = 0; c < 3; c++)
        {
          for (x = 0; x < 4; x++)
          {
            unsigned char bit = (spritedata[sprnum*64+y*3+c] >> (x*2)) & 3;
            if (bit == 3) bit = 1;
            else if (bit == 1) bit = 3;
            spritedata[sprnum*64+y*3+c] &= andtable[x];
            spritedata[sprnum*64+y*3+c] |= (bit << (x*2));
          }
        }
      }
    }
    if (k == KEY_N)
    {
      int y,x,c;
      unsigned char andtable[4] = {0xfc, 0xf3, 0xcf, 0x3f};
      for (y = 0; y < 21; y++)
      {
        for (c = 0; c < 3; c++)
        {
          for (x = 0; x < 4; x++)
          {
            unsigned char bit = (spritedata[sprnum*64+y*3+c] >> (x*2)) & 3;
            if (bit == 3) bit = 2;
            else if (bit == 2) bit = 3;
            spritedata[sprnum*64+y*3+c] &= andtable[x];
            spritedata[sprnum*64+y*3+c] |= (bit << (x*2));
          }
        }
      }
    }

    if ((k == KEY_COMMA) && (sprnum > 0)) sprnum--;
    if ((k == KEY_COLON) && (sprnum < 255)) sprnum++;
    if (k == KEY_LEFT) scrollsprleft();
    if (k == KEY_RIGHT) scrollsprright();
    if (k == KEY_UP) scrollsprup();
    if (k == KEY_DOWN) scrollsprdown();
    if (k == KEY_X) flipsprx();
    if (k == KEY_Y) flipspry();
    if (k == KEY_P) memcpy(copybuffer, &spritedata[sprnum*64],64);
    if (k == KEY_T) memcpy(&spritedata[sprnum*64],copybuffer,64);
    if (k == KEY_F1) loadspr();
    if (k == KEY_F2) savespr();
    if ((k == KEY_2) && (testspr < 15))
    {
      testspr++;
    }
    if ((k == KEY_1) && (testspr > 0))
    {
      testspr--;
    }
    if (k == KEY_3) testsprx[testspr]-=2;
    if (k == KEY_4) testsprx[testspr]+=2;
    if (k == KEY_5) testspry[testspr]-=1;
    if (k == KEY_6) testspry[testspr]+=1;
    if (k == KEY_7)
    {
      testsprf[testspr]--;
      testsprf[testspr] &= 0xff;
    }
    if (k == KEY_8)
    {
      testsprf[testspr]++;
      testsprf[testspr] &= 0xff;
    }

    mouseupdate();
    editspr();
    changecol();
    gfx_fillscreen(17);
    drawgrid();
    for (l = 0; l < 16; l++)
    {
      if (testsprf[l] != 255)
      {
        drawc64sprite(testsprx[l],testspry[l],testsprf[l]);
      }
    }

    sprintf(textbuffer, "TESTSPR %03d", testspr);
    printtext_color(textbuffer, 0,150,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "X %03d", testsprx[testspr]);
    printtext_color(textbuffer, 0,160,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "Y %03d", testspry[testspr]);
    printtext_color(textbuffer, 0,170,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "F %03d", testsprf[testspr]);
    printtext_color(textbuffer, 0,180,SPR_FONTS,COL_WHITE);
    gfx_drawsprite(mousex, mousey, 0x00000021);
    gfx_updatepage();
  }
}

void clearspr(void)
{
  unsigned char *ptr = &spritedata[sprnum*64];
  memset(ptr, 0, 63);
}

void loadspr(void)
{
  unsigned char ib2[5];
  int phase = 1;
  ib2[0] = 0;

  for (;;)
  {
    win_getspeed(70);
    gfx_fillscreen(17);
    printtext_center_color("LOAD SPRITEFILE:",70,SPR_FONTS,COL_WHITE);
    printtext_center_color(ib1,80,SPR_FONTS,COL_HIGHLIGHT);
    if (phase > 1)
    {
      printtext_center_color("LOAD AT SPRITENUM:",95,SPR_FONTS,COL_WHITE);
      printtext_center_color(ib2,105,SPR_FONTS,COL_HIGHLIGHT);
    }
    gfx_updatepage();
    if (phase == 1)
    {
      int r = inputtext(ib1, 80);
      if (r == -1) return;
      if (r == 1) phase = 2;
    }
    if (phase == 2)
    {
      int r = inputtext(ib2, 5);
      if (r == -1) return;
      if (r == 1)
      {
        int frame;
        FILE *handle;
        int maxbytes = 16384;
        sscanf(ib2, "%d", &frame);
        if (frame < 0) frame = 0;
        if (frame > 255) frame = 255;
        maxbytes -= frame*64;
        handle = fopen(ib1, "rb");
        if (!handle) return;
        fread(&spritedata[frame*64], maxbytes, 1, handle);
        fclose(handle);
        return;
      }
    }
  }
}

void savespr(void)
{
  unsigned char ib2[5];
  unsigned char ib3[5];
  int phase = 1;
  ib2[0] = 0;
  ib3[0] = 0;

  for (;;)
  {
    win_getspeed(70);
    gfx_fillscreen(17);
    printtext_center_color("SAVE SPRITEFILE:",60,SPR_FONTS,COL_WHITE);
    printtext_center_color(ib1,70,SPR_FONTS,COL_HIGHLIGHT);
    if (phase > 1)
    {
      printtext_center_color("SAVE FROM SPRITENUM:",85,SPR_FONTS,COL_WHITE);
      printtext_center_color(ib2,95,SPR_FONTS,COL_HIGHLIGHT);
    }
    if (phase > 2)
    {
      printtext_center_color("SAVE HOW MANY:",110,SPR_FONTS,COL_WHITE);
      printtext_center_color(ib3,120,SPR_FONTS,COL_HIGHLIGHT);
    }
    gfx_updatepage();
    if (phase == 1)
    {
      int r = inputtext(ib1, 80);
      if (r == -1) return;
      if (r == 1) phase = 2;
    }
    if (phase == 2)
    {
      int r = inputtext(ib2, 5);
      if (r == -1) return;
      if (r == 1) phase = 3;
    }
    if (phase == 3)
    {
      int r = inputtext(ib3, 5);
      if (r == -1) return;
      if (r == 1)
      {
        int frame, frames;
        FILE *handle;
        sscanf(ib2, "%d", &frame);
        sscanf(ib3, "%d", &frames);
        if (frame < 0) frame = 0;
        if (frame > 255) frame = 255;
        if (frames < 1) frames = 1;
        if (frame+frames > 256) frames = 256-frame;

        handle = fopen(ib1, "wb");
        if (!handle) return;
        fwrite(&spritedata[frame*64], frames*64, 1, handle);
        fclose(handle);
        return;
      }
    }
  }
}

void changecol(void)
{
  int y;
  if (!mouseb) return;
  if ((mousex < 130) || (mousex >= 235)) return;
  if ((mousey < 80) || (mousey >= 135)) return;
  y = mousey - 80;
  if ((y % 15) >= 9) return;
  if (mousex < 220)
  {
    ccolor = y / 15;
  }
  else
  {
    if (!prevmouseb)
    {
      if (mouseb & LEFT_BUTTON)
      {
        switch(y/15)
        {
          case 0:
          bgcol++;
          bgcol &= 15;
          break;
          case 1:
          multicol1++;
          multicol1 &= 15;
          break;
          case 2:
          spritedata[sprnum*64+63]++;
          spritedata[sprnum*64+63] &= 31;
          break;
          case 3:
          multicol2++;
          multicol2 &= 15;
          break;
        }
      }
      if (mouseb & RIGHT_BUTTON)
      {
        switch(y/15)
        {
          case 0:
          bgcol--;
          bgcol &= 15;
          break;
          case 1:
          multicol1--;
          multicol1 &= 15;
          break;
          case 2:
          spritedata[sprnum*64+63]--;
          spritedata[sprnum*64+63] &= 31;
          break;
          case 3:
          multicol2--;
          multicol2 &= 15;
          break;
        }
      }
    }
  }
}

void editspr(void)
{
  unsigned char *ptr = &spritedata[sprnum*64];
  int x,y;
  if (!mouseb) return;
  if ((mousex < 0) || (mousex >= 24*5)) return;
  if ((mousey < 0) || (mousey >= 21*5)) return;

  y = mousey / 5;
  if (spritedata[sprnum*64+63] & 16)
  {
    unsigned char byte, bit;
    x = mousex / 5;
    byte = x >> 3;
    bit = 7 - (x & 7);

    if (mouseb & LEFT_BUTTON)
    {
      ptr[byte+3*y] |= (1 << bit);
    }
    if (mouseb & RIGHT_BUTTON)
    {
      ptr[byte+3*y] &= ~(1 << bit);
    }
  }
  else
  {
    unsigned char byte, bit;
    x = mousex / 5;
    byte = x >> 3;
    bit = (7 - (x & 7)) & 6;

    if (mouseb & LEFT_BUTTON)
    {
      ptr[byte+3*y] &= ~(3 << bit);
      ptr[byte+3*y] |= (ccolor << bit);
    }
    if (mouseb & RIGHT_BUTTON)
    {
      ptr[byte+3*y] &= ~(3 << bit);
    }
  }
}

void flipsprx(void)
{
  unsigned char c,a;
  unsigned char *ptr = &spritedata[sprnum*64];
  int y,x;

  if (spritedata[sprnum*64+63] & 16)
  {
    c = 1;
    a = 1;
  }
  else
  {
    c = 2;
    a = 3;
  }

  for (y = 0; y < 21; y++)
  {
    unsigned src = (ptr[0]<<16) | (ptr[1]<<8) | ptr[2];
    unsigned dest = 0;
    for (x = 0; x < 24; x += c)
    {
      unsigned sh = (src >> x) & a;
      dest |= sh << ((24-c)-x);
    }
    ptr[0] = dest>>16;
    ptr[1] = dest>>8;
    ptr[2] = dest;
    ptr += 3;
  }
}

void flipspry(void)
{
  unsigned char *ptr = &spritedata[sprnum*64];
  unsigned char temppi[63];
  int y;

  for (y = 0; y < 21; y++)
  {
    temppi[60-y*3] = ptr[y*3];
    temppi[60-y*3+1] = ptr[y*3+1];
    temppi[60-y*3+2] = ptr[y*3+2];
  }
  memcpy(ptr, temppi, 63);
}

void scrollsprleft(void)
{
  unsigned char c;
  int y;

  if (spritedata[sprnum*64+63] & 16) c = 1;
  else c = 2;

  while (c)
  {
    unsigned char *ptr = &spritedata[sprnum*64];
    for (y = 0; y < 21; y++)
    {
      unsigned data = (ptr[0]<<16) | (ptr[1]<<8) | ptr[2];
      unsigned char bit = ptr[0] >> 7;
      data <<= 1;
      ptr[0] = data>>16;
      ptr[1] = data>>8;
      ptr[2] = data | bit;
      ptr += 3;
    }
    c--;
  }
}

void scrollsprright(void)
{
  unsigned char c;
  int y;

  if (spritedata[sprnum*64+63] & 16) c = 1;
  else c = 2;

  while (c)
  {
    unsigned char *ptr = &spritedata[sprnum*64];
    for (y = 0; y < 21; y++)
    {
      unsigned data = (ptr[0]<<16) | (ptr[1]<<8) | ptr[2];
      unsigned char bit = ptr[2] << 7;
      data >>= 1;
      ptr[0] = (data>>16) | bit;
      ptr[1] = data>>8;
      ptr[2] = data;
      ptr += 3;
    }
    c--;
  }
}

void scrollsprup(void)
{
  int y;
  unsigned char *ptr = &spritedata[sprnum*64];
  unsigned char vara1 = ptr[0];
  unsigned char vara2 = ptr[1];
  unsigned char vara3 = ptr[2];
  for (y = 0; y < 20; y++)
  {
    ptr[y*3]=ptr[y*3+3];
    ptr[y*3+1]=ptr[y*3+4];
    ptr[y*3+2]=ptr[y*3+5];
  }
  ptr[60]=vara1;
  ptr[61]=vara2;
  ptr[62]=vara3;
}

void scrollsprdown(void)
{
  int y;
  unsigned char *ptr = &spritedata[sprnum*64];
  unsigned char vara1 = ptr[60];
  unsigned char vara2 = ptr[61];
  unsigned char vara3 = ptr[62];
  for (y = 19; y >= 0; y--)
  {
    ptr[y*3+3]=ptr[y*3];
    ptr[y*3+4]=ptr[y*3+1];
    ptr[y*3+5]=ptr[y*3+2];
  }
  ptr[0]=vara1;
  ptr[1]=vara2;
  ptr[2]=vara3;
}

void drawc64sprite(int bx, int by, int num)
{
  unsigned char *ptr = &spritedata[num*64];
  unsigned char sprcol = ptr[63];
  unsigned char v = 0;
  int x,y;

  if (sprcol & 16)
  {
    for (y = 0; y < 21; y++)
    {
      unsigned data = (ptr[0]<<16) | (ptr[1]<<8) | ptr[2];
      for (x = 23; x >= 0; x--)
      {
        unsigned char c = data & 1;
        v = 17;
        if (c) v = sprcol & 15;
        if (v != 17)
        {
        if (magx[num])
        {
          if (magy[num])
          {
            gfx_plot(bx+x*2,by+y*2,v);
            gfx_plot(bx+x*2+1,by+y*2,v);
            gfx_plot(bx+x*2,by+y*2+1,v);
            gfx_plot(bx+x*2+1,by+y*2+1,v);
          }
          else
          {
            gfx_plot(bx+x*2,by+y,v);
            gfx_plot(bx+x*2+1,by+y,v);
          }
        }
        else
        {
          if (magy[num])
          {
            gfx_plot(bx+x,by+y*2,v);
            gfx_plot(bx+x,by+y*2+1,v);
          }
          else
          {
            gfx_plot(bx+x,by+y,v);
          }
        }
        }
        data >>= 1;
      }
      ptr += 3;
    }
  }
  else
  {
    for (y = 0; y < 21; y++)
    {
      unsigned data = (ptr[0]<<16) | (ptr[1]<<8) | ptr[2];
      for (x = 11; x >= 0; x--)
      {
        unsigned char c = data & 3;
        switch (c)
        {
          case 0:
          v = bgcol;
          break;

          case 1:
          v = multicol1;
          break;

          case 2:
          v = sprcol;
          break;

          case 3:
          v = multicol2;
          break;
        }
        if (c)
        {
        if (magx[num])
        {
          if (magy[num])
          {
            gfx_plot(bx+x*4,by+y*2,v);
            gfx_plot(bx+x*4+1,by+y*2,v);
            gfx_plot(bx+x*4,by+y*2+1,v);
            gfx_plot(bx+x*4+1,by+y*2+1,v);
            gfx_plot(bx+x*4+2,by+y*2,v);
            gfx_plot(bx+x*4+3,by+y*2,v);
            gfx_plot(bx+x*4+2,by+y*2+1,v);
            gfx_plot(bx+x*4+3,by+y*2+1,v);
          }
          else
          {
            gfx_plot(bx+x*4,by+y,v);
            gfx_plot(bx+x*4+1,by+y,v);
            gfx_plot(bx+2+x*4,by+y,v);
            gfx_plot(bx+2+x*4+1,by+y,v);
          }
        }
        else
        {
          if (magy[num])
          {
            gfx_plot(bx+x*2,by+y*2,v);
            gfx_plot(bx+x*2,by+y*2+1,v);
            gfx_plot(bx+1+x*2,by+y*2,v);
            gfx_plot(bx+1+x*2,by+y*2+1,v);
          }
          else
          {
            gfx_plot(bx+x*2,by+y,v);
            gfx_plot(bx+1+x*2,by+y,v);
          }
        }
        }
        data >>= 2;
      }
      ptr += 3;
    }
  }
}


void drawgrid(void)
{
  unsigned char *ptr = &spritedata[sprnum*64];
  unsigned char sprcol = ptr[63];
  unsigned char v = 0;
  int x,y;

  if (sprcol & 16)
  {
    for (y = 0; y < 21; y++)
    {
      unsigned data = (ptr[0]<<16) | (ptr[1]<<8) | ptr[2];
      for (x = 23; x >= 0; x--)
      {
        unsigned char c = data & 1;
        if (c) v = sprcol & 15;
        else v = bgcol;

        gfx_drawsprite(x*5,y*5,0x00000001+v);
        if (magx[sprnum])
        {
          if (magy[sprnum])
          {
            gfx_plot(130+x*2,y*2,v);
            gfx_plot(130+x*2+1,y*2,v);
            gfx_plot(130+x*2,y*2+1,v);
            gfx_plot(130+x*2+1,y*2+1,v);
          }
          else
          {
            gfx_plot(130+x*2,y,v);
            gfx_plot(130+x*2+1,y,v);
          }
        }
        else
        {
          if (magy[sprnum])
          {
            gfx_plot(130+x,y*2,v);
            gfx_plot(130+x,y*2+1,v);
          }
          else
          {
            gfx_plot(130+x,y,v);
          }
        }

        data >>= 1;
      }
      ptr += 3;
    }
  }
  else
  {
    for (y = 0; y < 21; y++)
    {
      unsigned data = (ptr[0]<<16) | (ptr[1]<<8) | ptr[2];
      for (x = 11; x >= 0; x--)
      {
        unsigned char c = data & 3;
        switch (c)
        {
          case 0:
          v = bgcol;
          break;

          case 1:
          v = multicol1;
          break;

          case 2:
          v = sprcol;
          break;

          case 3:
          v = multicol2;
          break;
        }
        gfx_drawsprite(x*10,y*5,0x00000011+v);
        if (magx[sprnum])
        {
          if (magy[sprnum])
          {
            gfx_plot(130+x*4,y*2,v);
            gfx_plot(130+x*4+1,y*2,v);
            gfx_plot(130+x*4,y*2+1,v);
            gfx_plot(130+x*4+1,y*2+1,v);
            gfx_plot(132+x*4,y*2,v);
            gfx_plot(132+x*4+1,y*2,v);
            gfx_plot(132+x*4,y*2+1,v);
            gfx_plot(132+x*4+1,y*2+1,v);
          }
          else
          {
            gfx_plot(130+x*4,y,v);
            gfx_plot(130+x*4+1,y,v);
            gfx_plot(132+x*4,y,v);
            gfx_plot(132+x*4+1,y,v);
          }
        }
        else
        {
          if (magy[sprnum])
          {
            gfx_plot(130+x*2,y*2,v);
            gfx_plot(130+x*2,y*2+1,v);
            gfx_plot(131+x*2,y*2,v);
            gfx_plot(131+x*2,y*2+1,v);
          }
          else
          {
            gfx_plot(130+x*2,y,v);
            gfx_plot(131+x*2,y,v);
          }
        }

        data >>= 2;
      }
      ptr += 3;
    }
  }
  sprintf(textbuffer, "SPRITE %03d", sprnum);
  printtext_color(textbuffer, 0,110,SPR_FONTS,COL_WHITE);
  if (spritedata[sprnum*64+63] & 16)
  {
    printtext_color("SINGLECOLOR",0,125,SPR_FONTS,COL_WHITE);
  }
  else
  {
    printtext_color("MULTICOLOR",0,125,SPR_FONTS,COL_WHITE);
  }
  v = COL_WHITE;
  if (ccolor == 0) v = COL_HIGHLIGHT;
  printtext_color("BACKGROUND",130,80,SPR_FONTS,v);
  v = COL_WHITE;
  if (ccolor == 1) v = COL_HIGHLIGHT;
  printtext_color("MULTICOL 1",130,95,SPR_FONTS,v);
  v = COL_WHITE;
  if (ccolor == 2) v = COL_HIGHLIGHT;
  printtext_color("SPRITE COL",130,110,SPR_FONTS,v&15);
  v = COL_WHITE;
  if (ccolor == 3) v = COL_HIGHLIGHT;
  printtext_color("MULTICOL 2",130,125,SPR_FONTS,v);
  drawcbar(220,80,bgcol);
  drawcbar(220,95,multicol1);
  drawcbar(220,110,(sprcol&15));
  drawcbar(220,125,multicol2);
}

void drawcbar(int x, int y, unsigned char col)
{
  int a;
  for (a = y; a < y+9; a++)
  {
    gfx_line(x, a, x+14, a, col);
  }
}

int initsprites(void)
{
  unsigned char *ptr;
  int c;
  spritedata = malloc(256*64);
  if (!spritedata) return 0;
  ptr = spritedata;
  for (c = 0; c < 16; c++)
  {
    testsprx[c] = 160;
    testspry[c] = 0;
    testsprf[c] = 255;
  }
  for (c = 0; c < 256; c++)
  {
    magx[c]=0;
    magy[c]=0;
    memset(ptr, 0, 63); /* Tyhjennet„„n spritedata */
    ptr += 63;
    *ptr = 14; /* Spriten v„ri */
    ptr++;
  }

  return 1;
}

void mouseupdate(void)
{
  mou_getpos(&mousex, &mousey);
  prevmouseb = mouseb;
  mouseb = mou_getbuttons();
}

void printtext_color(unsigned char *string, int x, int y, unsigned spritefile, int color)
{
  unsigned char *xlat = colxlattable[color];

  spritefile <<= 16;
  while (*string)
  {
    unsigned num = *string - 31;

    if (num >= 64) num -= 32;
    gfx_drawspritex(x, y, spritefile + num, xlat);
    x += spr_xsize;
    string++;
  }
}

void printtext_center_color(unsigned char *string, int y, unsigned spritefile, int color)
{
  int x = 0;
  unsigned char *stuff = string;
  unsigned char *xlat = colxlattable[color];
  spritefile <<= 16;

  while (*stuff)
  {
    unsigned num = *stuff - 31;

    if (num >= 64) num -= 32;
    gfx_getspriteinfo(spritefile + num);
    x += spr_xsize;
    stuff++;
  }
  x = 160 - x / 2;

  while (*string)
  {
    unsigned num = *string - 31;

    if (num >= 64) num -= 32;
    gfx_drawspritex(x, y, spritefile + num, xlat);
    x += spr_xsize;
    string++;
  }
}

void initstuff(void)
{
  int c;
  for (c = 0; c < 63; c++)
  {
        copybuffer[c] = 0;
  }
  if (!initsprites())
  {
    win_messagebox("Out of memory!");
    exit(1);
  }

  kbd_init();

  win_fullscreen = 0;
  if (!gfx_init(320,200,70,GFX_DOUBLESIZE))
  {
    win_messagebox("Graphics init error!");
    exit(1);
  }
  win_setmousemode(MOUSE_ALWAYS_HIDDEN);

  if ((!gfx_loadsprites(SPR_C, "editor.spr")) ||
      (!gfx_loadsprites(SPR_FONTS, "editfont.spr")))
  {
    win_messagebox("Error loading editor graphics!");
    exit(1);
  }
  if (!gfx_loadpalette("editor.pal"))
  {
    win_messagebox("Error loading editor palette!");
    exit(1);
  }
}

int inputtext(unsigned char *buffer, int maxlength)
{
  int len = strlen(buffer);

  ascii = kbd_getascii();
  k = ascii;

  if (!k) return 0;
  if (k == 27) return -1;
  if (k == 13) return 1;

  if (k >= 32)
  {
    if (len < maxlength-1)
    {
      buffer[len] = k;
      buffer[len+1] = 0;
    }
  }
  if ((k == 8) && (len > 0))
  {
    buffer[len-1] = 0;
  }
  return 0;
}

