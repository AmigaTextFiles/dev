/*
 * BOFH-C64 Background editor
 */

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <ctype.h>
#include "bme.h"
#include "editio.h"

typedef struct
{
  Uint8 x;
  Uint8 y;
  Uint8 f;
  Uint8 t;
  Uint8 h;
} ACTOR;

#define LEFT_BUTTON 1
#define RIGHT_BUTTON 2
#define SINGLECOLOR 0
#define MULTICOLOR 1

#define EM_QUIT 0
#define EM_CHARS 1
#define EM_MAP 2

#define SPR_C 0
#define SPR_FONTS 1
#define COL_WHITE 0
#define COL_HIGHLIGHT 1

#define BLOCKS 256
#define FLOORS 7
#define ACTORS 256

char cwhite[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
char chl[] = {12,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
char *colxlattable[] = {cwhite, chl};
char textbuffer[80];
char copybuffer[8];
char bcopybuffer[16];
char bcopycolor;
Uint8 blockcol[BLOCKS];
char chinfo[256];
char ascii;

int actortype = 0;
int mousex;
int mousey;
int mouseb;
int prevmouseb = 0;
int charnum = 0;
int blocknum = 0;
int ccolor = 3;
int flash = 0;
int editmode = EM_CHARS;
int k;
int floor = 0;
int mapx = 0;
int mapy = 0;
int mapsx = 100;
int mapsy = 20;
int levelnum = 0;

char *chardata;
char *imagedata;
char *blockdata;
char *blockimage;
char *mapdata[FLOORS];
ACTOR *actordata[FLOORS];


char bgcol = 0;
char multicol1 = 12;
char multicol2 = 11;
Uint8 shpnum = 1;

int initchars(void);
void updateimage(int c);
void updateall(void);
void updateallblocks(void);
void updateblock(int c);
void loadchars(void);
void savechars(void);
void loadblocks(void);
void saveblocks(void);
void loadcharsinfo(void);
void savecharsinfo(void);
void loadalldata(void);
void savealldata(void);
void scrollcharleft(void);
void scrollcharright(void);
void scrollcharup(void);
void scrollchardown(void);
void char_mainloop(void);
void editchar(void);
void editblock(void);
void map_mainloop(void);
void drawimage(void);
void drawblock(int x, int y, int num);
void mouseupdate(void);
void handle_int(int a);
void loadmap(void);
void savemap(void);
void drawmap(void);
void drawgrid(void);
void changecol(void);
void changechar(void);
void initshit(void);
void drawcbar(int x, int y, char col);
void printtext_color(char *string, int x, int y, unsigned spritefile, int color);
void printtext_center_color(char *string, int y, unsigned spritefile, int color);
void loadchars(void);
void savechars(void);
void editmain(void);

extern unsigned char datafile[];
	
int main (int argc, char *argv[])
{
  int handle;

  io_openlinkeddatafile(datafile);

  if (!win_openwindow("BOFH (C64) Background Editor", NULL)) return 1;
  win_fullscreen = 0;

  handle = open("bgedit.cfg", O_RDONLY | O_BINARY);
  if (handle != -1)
  {
    read(handle, &bgcol, sizeof bgcol);
    read(handle, &multicol1, sizeof multicol1);
    read(handle, &multicol2, sizeof multicol2);
    close(handle);
  }

  initshit();

  gfx_setpalette();

  while (editmode)
  {
    if (editmode == EM_CHARS) char_mainloop();
    if (editmode == EM_MAP) map_mainloop();
  }

  handle = open("bgedit.cfg", O_RDWR | O_BINARY | O_CREAT | O_TRUNC, S_IREAD | S_IWRITE);
  if (handle != -1)
  {
    write(handle, &bgcol, sizeof bgcol);
    write(handle, &multicol1, sizeof multicol1);
    write(handle, &multicol2, sizeof multicol2);
    close(handle);
  }
  return 1;
}

void map_mainloop(void)
{
  updateallblocks();

  for (;;)
  {
    int c;

    win_getspeed(70);
    k = kbd_getkey();
    ascii = kbd_getascii();
    mouseupdate();
    if (ascii == 27)
    {
      editmode = EM_QUIT;
      break;
    }
    if ((ascii >= '0') && (ascii <= '6')) floor = ascii - '0';

    if (k == KEY_LEFT) mapx--;
    if (k == KEY_RIGHT) mapx++;
    if (k == KEY_UP) mapy--;
    if (k == KEY_DOWN) mapy++;
    if (mapx < 0) mapx = 0;
    if (mapy < 0) mapy = 0;
    if (mapx > (mapsx-10)) mapx = mapsx-10;
    if (mapy > (mapsy-6)) mapy = mapsy-6;
    if (k == KEY_F5)
    {
      editmode = EM_CHARS;
      break;
    }
    if ((k == KEY_Z) && (blocknum > 0))
    {
      blocknum--;
    }
    if ((k == KEY_X) && (blocknum < BLOCKS-1))
    {
      blocknum++;
    }
    if (k == KEY_F)
    {
      /* memset(mapdata, blocknum, 255*255); */
    }
    if (k == KEY_I)
    {
      if (mapsy > 6) mapsy--;
    }
    if (k == KEY_J)
    {
      if (mapsx > 10) mapsx--;
    }
    if (k == KEY_M)
    {
      int x;
      if (mapsy < 255)
      {
        mapsy++;
        for (x = 0; x < mapsx; x++) mapdata[floor][x+(mapsy-1)*255] = blocknum;
      }
    }
    if (k == KEY_K)
    {
      int y;
      if (mapsx < 255)
      {
        mapsx++;
        for (y = 0; y < mapsy; y++) mapdata[floor][mapsx-1+y*255] = blocknum;
      }
    }
    if (k == KEY_G)
    {
      if ((mousex >= 0) && (mousex < 320) && (mousey >= 0) && (mousey < 192))
      {
        blocknum=mapdata[floor][mapx+mousex/32+(mapy+mousey/32)*255];
      }
    }

    if (k == KEY_F1) loadmap();
    if (k == KEY_F2) savemap();
    if (k == KEY_F9) loadalldata();
    if (k == KEY_F10) savealldata();

    if (mouseb)
    {
      if ((mousex >= 0) && (mousex < 320) && (mousey >= 0) && (mousey < 192))
      {
        mapdata[floor][mapx+mousex/32+(mapy+mousey/32)*255]=blocknum;
      }
    }

    if ((mousex >= 0) && (mousex < 320) && (mousey >= 0) && (mousey < 192))
    {
      int au = -1;
      int ax = mapx+(mousex+4)/32;
      int ay = mapy+(mousey+4)/32;
      int af = (((mousex+4)/8)&3)+(((mousey+4)/8)&3)*4;

      for (c = 0; c < ACTORS; c++)
      {
        if ((actordata[floor][c].t) &&
            (actordata[floor][c].x == ax) &&
            (actordata[floor][c].y == ay) &&
            ((actordata[floor][c].f&15) == af))
        {
          au = c;
        }
      }

      if (au == -1)
      {
        if ((k == KEY_C) && (actortype > 0))
        {
          actortype--;
        }
        if ((k == KEY_V) && (actortype < 255))
        {
          actortype++;
        }
        if (k == KEY_A)
        {
          for (c = 0; c < ACTORS; c++)
          {
            if (actordata[floor][c].t == 0)
            {
              actordata[floor][c].t = actortype;
              actordata[floor][c].x = ax;
              actordata[floor][c].y = ay;
              actordata[floor][c].f = af;
              actordata[floor][c].h = 0;
              break;
            }
          }
        }
      }
      else
      {
        if (k == KEY_D)
        {
          actordata[floor][au].t = 0;
          actordata[floor][au].x = 0;
          actordata[floor][au].y = 0;
          actordata[floor][au].f = 0;
          actordata[floor][au].h = 0;
        }
        if (k == KEY_R)
        {
          actordata[floor][au].f += 16;
          actordata[floor][au].f &= 127;
        }
        if (k == KEY_C)
        {
          actordata[floor][au].h--;
        }
        if (k == KEY_V)
        {
          actordata[floor][au].h++;
        }
      }
    }

    gfx_fillscreen(0);
    drawmap();
    gfx_drawsprite(mousex, mousey, 0x00000021);
    gfx_updatepage();
  }
}

void drawmap(void)
{
  int y,x;
  int c;
  int actors = 0;
  char *dirstring[] = {"N", "NE", "E", "SE", "S", "SW", "W", "NW"};
  int xtbl[] = {0, 8, 8, 8, 0, -8, -8, -8};
  int ytbl[] = {-8, -8, 0, 8, 8, 8, 0, -8};

  for (y = 0; y < 6; y++)
  {
    for (x = 0; x < 10; x++)
    {
      drawblock(x*32,y*32,mapdata[floor][mapx+x+(mapy+y)*255]);
    }
  }
  for (c = 0; c < ACTORS; c++)
  {
    if (actordata[floor][c].t)
    {
      actors++;
      if ((actordata[floor][c].x >= mapx) && (actordata[floor][c].x - mapx < 10))
      {
        if ((actordata[floor][c].y >= mapy) && (actordata[floor][c].y - mapy < 5))
        {
          int xf = actordata[floor][c].f & 3;
          int yf = (actordata[floor][c].f / 4) & 3;
          int xt = (actordata[floor][c].x - mapx)*32+xf*8;
          int yt = (actordata[floor][c].y - mapy)*32+yf*8;

          gfx_line(xt,yt,xt+xtbl[actordata[floor][c].f >> 4],
                         yt+ytbl[actordata[floor][c].f >> 4], 1);

          gfx_plot(xt,yt,1);
          gfx_plot(xt+1,yt,0);
          gfx_plot(xt-1,yt,0);
          gfx_plot(xt,yt+1,0);
          gfx_plot(xt,yt-1,0);
          sprintf(textbuffer, "T%03d H%02X %s", actordata[floor][c].t,
          actordata[floor][c].h, dirstring[actordata[floor][c].f >> 4]);
          printtext_color(textbuffer, xt-40, yt+10,SPR_FONTS,COL_WHITE);
        }
      }
    }
  }
  sprintf(textbuffer, "XPOS %03d", mapx+mousex/32);
  printtext_color(textbuffer, 0,165,SPR_FONTS,COL_WHITE);
  sprintf(textbuffer, "YPOS %03d", mapy+mousey/32);
  printtext_color(textbuffer, 0,175,SPR_FONTS,COL_WHITE);
  sprintf(textbuffer, "FLOOR %03d", floor);
  printtext_color(textbuffer, 0,185,SPR_FONTS,COL_WHITE);
  drawblock(320-32,160,blocknum);
  sprintf(textbuffer, "BLOCK %03d", blocknum);
  printtext_color(textbuffer, 160,185,SPR_FONTS,COL_WHITE);
  sprintf(textbuffer, "XSIZE %03d", mapsx);
  printtext_color(textbuffer, 80,165,SPR_FONTS,COL_WHITE);
  sprintf(textbuffer, "YSIZE %03d", mapsy);
  printtext_color(textbuffer, 80,175,SPR_FONTS,COL_WHITE);
  sprintf(textbuffer, "ACTORTYPE %03d", actortype);
  printtext_color(textbuffer, 160,165,SPR_FONTS,COL_WHITE);
  sprintf(textbuffer, "ACTORS %03d", actors);
  printtext_color(textbuffer, 160,175,SPR_FONTS,COL_WHITE);
}

void char_mainloop(void)
{
  for (;;)
  {
    int s;
    s = win_getspeed(70);
    flash += s;
    flash &= 31;
    k = kbd_getkey();
    ascii = kbd_getascii();
    mouseupdate();
    if (ascii == 27)
    {
      editmode = EM_QUIT;
      break;
    }
    if (k == KEY_C)
    {
      memset(&chardata[charnum*8],0,8);
      chinfo[charnum]=0;
      updateimage(charnum);
      updateblock(blocknum);
    }
    if (k == KEY_1) chinfo[charnum] ^= 1;
    if (k == KEY_2) chinfo[charnum] ^= 2;
    if (k == KEY_3) chinfo[charnum] ^= 4;
    if (k == KEY_4) chinfo[charnum] ^= 8;
    if (k == KEY_5) chinfo[charnum] ^= 16;
    if (k == KEY_6) chinfo[charnum] ^= 32;
    if (k == KEY_7) chinfo[charnum] ^= 64;
    if (k == KEY_8) chinfo[charnum] ^= 128;
    if (k == KEY_U) blockcol[blocknum] ^= 16;
    if (k == KEY_D) blockcol[blocknum] ^= 32;
    if (k == KEY_L) blockcol[blocknum] ^= 64;
    if (k == KEY_R) blockcol[blocknum] ^= 128;

    if (k == KEY_B)
    {
      int y,x;
      char andtable[4] = {0xfc, 0xf3, 0xcf, 0x3f};
      for (y = 0; y < 8; y++)
      {
        for (x = 0; x < 4; x++)
        {
          char bit = (chardata[charnum*8+y] >> (x*2)) & 3;
          if (bit == 2) bit = 1;
          else if (bit == 1) bit = 2;
          chardata[charnum*8+y] &= andtable[x];
          chardata[charnum*8+y] |= (bit << (x*2));
        }
      }
      updateimage(charnum);
      updateblock(blocknum);
    }

    if (k == KEY_I)
    {
      int y;
      for (y = 0; y < 8; y++)
      {
        chardata[charnum*8+y] ^= 0xff;
      }
      updateimage(charnum);
      updateblock(blocknum);
    }

    if (k == KEY_N)
    {
      int y,x;
      char andtable[4] = {0xfc, 0xf3, 0xcf, 0x3f};
      for (y = 0; y < 8; y++)
      {
        for (x = 0; x < 4; x++)
        {
          char bit = (chardata[charnum*8+y] >> (x*2)) & 3;
          if (bit == 3) bit = 1;
          else if (bit == 1) bit = 3;
          chardata[charnum*8+y] &= andtable[x];
          chardata[charnum*8+y] |= (bit << (x*2));
        }
      }
      updateimage(charnum);
      updateblock(blocknum);
    }
    if (k == KEY_M)
    {
      int y,x;
      char andtable[4] = {0xfc, 0xf3, 0xcf, 0x3f};
      for (y = 0; y < 8; y++)
      {
        for (x = 0; x < 4; x++)
        {
          char bit = (chardata[charnum*8+y] >> (x*2)) & 3;
          if (bit == 3) bit = 2;
          else if (bit == 2) bit = 3;
          chardata[charnum*8+y] &= andtable[x];
          chardata[charnum*8+y] |= (bit << (x*2));
        }
      }
      updateimage(charnum);
      updateblock(blocknum);
    }

    if ((k == KEY_COMMA) && (charnum > 0)) charnum--;
    if ((k == KEY_COLON) && (charnum < 255)) charnum++;
    if ((k == KEY_Z) && (blocknum > 0))
    {
      blocknum--;
      updateall();
      updateblock(blocknum);
    }
    if ((k == KEY_X) && (blocknum < BLOCKS-1))
    {
      blocknum++;
      updateall();
      updateblock(blocknum);
    }
    if (k == KEY_P) memcpy(copybuffer, &chardata[charnum*8],8);
    if (k == KEY_T)
    {
      memcpy(&chardata[charnum*8],copybuffer,8);
      updateimage(charnum);
      updateblock(blocknum);
    }
    if (k == KEY_Q)
    {
      memcpy(bcopybuffer, &blockdata[blocknum*16],16);
      bcopycolor = blockcol[blocknum];
    }
    if (k == KEY_W)
    {
      blockcol[blocknum] = bcopycolor;
      memcpy(&blockdata[blocknum*16],bcopybuffer,16);
      updateall();
      updateblock(blocknum);
    }
    if (k == KEY_F1) loadchars();
    if (k == KEY_F2) savechars();
    if (k == KEY_F3) loadblocks();
    if (k == KEY_F4) saveblocks();
    if (k == KEY_F7) loadcharsinfo();
    if (k == KEY_F8) savecharsinfo();
    if (k == KEY_F5)
    {
      editmode = EM_MAP;
      break;
    }
    if (k == KEY_F9) loadalldata();
    if (k == KEY_F10) savealldata();
    if (k == KEY_LEFT) scrollcharleft();
    if (k == KEY_RIGHT) scrollcharright();
    if (k == KEY_UP) scrollcharup();
    if (k == KEY_DOWN) scrollchardown();

    changecol();
    changechar();
    editchar();
    editblock();
    gfx_fillscreen(17);
    drawgrid();
    drawblock(64,0,blocknum);
    drawimage();
    if (flash<16)
    gfx_drawsprite((charnum&31)*8+32, 128+(charnum/32)*8, 0x00000022);

    gfx_drawsprite(mousex, mousey, 0x00000021);
    gfx_updatepage();
  }
}

void scrollcharleft(void)
{
  Uint8 c;
  int y;

  if ((blockcol[blocknum] & 15) < 8) c=1;
  else c = 2;

  while (c)
  {
    Uint8 *ptr = &chardata[charnum*8];
    for (y = 0; y < 8; y++)
    {
      unsigned data = *ptr;
      Uint8 bit = *ptr >> 7;
      data <<= 1;
      *ptr = data | bit;
      ptr++;
    }
    c--;
  }
  updateimage(charnum);
  updateblock(blocknum);
}

void scrollcharright(void)
{
  Uint8 c;
  int y;

  if ((blockcol[blocknum] & 15) < 8) c=1;
  else c = 2;

  while (c)
  {
    Uint8 *ptr = &chardata[charnum*8];
    for (y = 0; y < 8; y++)
    {
      unsigned data = *ptr;
      Uint8 bit = (*ptr & 1) << 7;
      data >>= 1;
      *ptr = data | bit;
      ptr++;
    }
    c--;
  }
  updateimage(charnum);
  updateblock(blocknum);
}

void scrollcharup(void)
{
  int y;
  Uint8 *ptr = &chardata[charnum*8];
  Uint8 vara1 = ptr[0];
  for (y = 0; y < 7; y++)
  {
    ptr[y]=ptr[y+1];
  }
  ptr[7]=vara1;
  updateimage(charnum);
  updateblock(blocknum);
}

void scrollchardown(void)
{
  int y;
  Uint8 *ptr = &chardata[charnum*8];
  Uint8 vara1 = ptr[7];
  for (y = 6; y >= 0; y--)
  {
    ptr[y+1]=ptr[y];
  }
  ptr[0]=vara1;
  updateimage(charnum);
  updateblock(blocknum);
}

void drawgrid(void)
{
  char *ptr = &chardata[charnum*8];
  char v = 0;
  int x,y;

  if ((blockcol[blocknum] & 15) < 8)
  {
    for (y = 0; y < 8; y++)
    {
      unsigned data = *ptr;

      for (x = 7; x >= 0; x--)
      {
        if (data & 1) v = blockcol[blocknum] & 15;
        else v = bgcol;

        gfx_drawsprite(x*5,y*5,0x00000001+v);

        data >>= 1;
      }
      ptr++;
    }
  }
  else
  {
    for (y = 0; y < 8; y++)
    {
      unsigned data = *ptr;
      for (x = 3; x >= 0; x--)
      {
        char c = data & 3;
        switch (c)
        {
          case 0:
          v = bgcol;
          break;

          case 1:
          v = multicol1;
          break;

          case 2:
          v = multicol2;
          break;

          case 3:
          v = blockcol[blocknum] & 7;
          break;

        }
        gfx_drawsprite(x*10,y*5,0x00000011+v);
        data >>= 2;
      }
      ptr++;
    }
  }
  sprintf(textbuffer, "CHAR %03d", charnum);
  printtext_color(textbuffer, 0,50,SPR_FONTS,COL_WHITE);
  sprintf(textbuffer, "BLOCK %03d", blocknum);
  printtext_color(textbuffer, 0,65,SPR_FONTS,COL_WHITE);
  for (x = 0; x < 8; x++)
  {
    if ((chinfo[charnum] >> (7-x)) & 1) gfx_drawsprite(x*4, 41, 0x00000023);
    else gfx_drawsprite(x*4, 41, 0x00000024);
  }
  if ((blockcol[blocknum]&15) < 8)
  {
    printtext_color("SINGLECOLOR",0,80,SPR_FONTS,COL_WHITE);
  }
  else
  {
    printtext_color("MULTICOLOR",0,80,SPR_FONTS,COL_WHITE);
  }
  if (blockcol[blocknum] & 16)
          printtext_color("U",0,90,SPR_FONTS,COL_WHITE);
  if (blockcol[blocknum] & 32)
          printtext_color("D",10,90,SPR_FONTS,COL_WHITE);
  if (blockcol[blocknum] & 64)
          printtext_color("L",20,90,SPR_FONTS,COL_WHITE);
  if (blockcol[blocknum] & 128)
          printtext_color("R",30,90,SPR_FONTS,COL_WHITE);
  v = COL_WHITE;
  if (ccolor == 0) v = COL_HIGHLIGHT;
  printtext_color("BACKGROUND",130,50,SPR_FONTS,v);
  v = COL_WHITE;
  if (ccolor == 1) v = COL_HIGHLIGHT;
  printtext_color("MULTICOL 1",130,65,SPR_FONTS,v);
  v = COL_WHITE;
  if (ccolor == 2) v = COL_HIGHLIGHT;
  printtext_color("MULTICOL 2",130,80,SPR_FONTS,v);
  v = COL_WHITE;
  if (ccolor == 3) v = COL_HIGHLIGHT;
  printtext_color("BLOCK COL",130,95,SPR_FONTS,v);
  drawcbar(220,50,bgcol);
  drawcbar(220,65,multicol1);
  drawcbar(220,80,multicol2);
  drawcbar(220,95,blockcol[blocknum]&7);
}

void changechar(void)
{
  if (!mouseb) return;
  if ((mousex < 32) || (mousex >= 288)) return;
  if ((mousey < 128) || (mousey >= 192)) return;
  charnum = (mousex-32)/8+((mousey-128)/8)*32;
}

void editblock(void)
{
  char *bptr;
  if (!mouseb) return;
  if ((mousex < 64) || (mousex >= 8*4+64)) return;
  if ((mousey < 0) || (mousey >= 8*4)) return;
  bptr = &blockdata[blocknum*16+(mousey/8)*4+((mousex-64)/8)];
  *bptr = charnum;
  updateblock(blocknum);
}

void editchar(void)
{
  char *ptr = &chardata[charnum*8];
  int x,y;
  if (!mouseb) return;
  if ((mousex < 0) || (mousex >= 8*5)) return;
  if ((mousey < 0) || (mousey >= 8*5)) return;

  y = mousey / 5;
  if ((blockcol[blocknum]&15) < 8)
  {
    char bit;
    x = mousex / 5;
    bit = 7 - (x & 7);

    if (mouseb & LEFT_BUTTON)
    {
      ptr[y] |= (1 << bit);
    }
    if (mouseb & RIGHT_BUTTON)
    {
      ptr[y] &= ~(1 << bit);
    }
  }
  else
  {
    char bit;
    x = mousex / 5;
    bit = (7 - (x & 7)) & 6;

    if (mouseb & LEFT_BUTTON)
    {
      ptr[y] &= ~(3 << bit);
      ptr[y] |= (ccolor << bit);
    }
    if (mouseb & RIGHT_BUTTON)
    {
      ptr[y] &= ~(3 << bit);
    }
  }
  updateimage(charnum);
  updateblock(blocknum);
}

void changecol(void)
{
  int y;
  if (!mouseb) return;
  if ((mousex < 130) || (mousex >= 235)) return;
  if ((mousey < 50) || (mousey >= 110)) return;
  y = mousey - 50;
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
          updateall();
          updateblock(blocknum);
          break;
          case 1:
          multicol1++;
          multicol1 &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 2:
          multicol2++;
          multicol2 &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 3:
          {
                int blockbits = blockcol[blocknum] & 0xf0;
                blockcol[blocknum]++;
                blockcol[blocknum] &= 15;
                blockcol[blocknum] |= blockbits;
          }
          updateall();
          updateblock(blocknum);
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
          updateall();
          updateblock(blocknum);
          break;
          case 1:
          multicol1--;
          multicol1 &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 2:
          multicol2--;
          multicol2 &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 3:
          {
                int blockbits = blockcol[blocknum] & 0xf0;
                blockcol[blocknum]--;
                blockcol[blocknum] &= 15;
                blockcol[blocknum] |= blockbits;
          }
          updateall();
          updateblock(blocknum);
          break;
        }
      }
    }
  }
}

void printtext_color(char *string, int x, int y, unsigned spritefile, int color)
{
  char *xlat = colxlattable[color];

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

void printtext_center_color(char *string, int y, unsigned spritefile, int color)
{
  int x = 0;
  char *shit = string;
  char *xlat = colxlattable[color];
  spritefile <<= 16;

  while (*shit)
  {
    unsigned num = *shit - 31;

    if (num >= 64) num -= 32;
    gfx_getspriteinfo(spritefile + num);
    x += spr_xsize;
    shit++;
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

void mouseupdate(void)
{
  mou_getpos(&mousex, &mousey);
  prevmouseb = mouseb;
  mouseb = mou_getbuttons();
}

int initchars(void)
{
  int c;
  for (c = 0; c < FLOORS; c++)
  {
    mapdata[c] = malloc(255*255);
    if (!mapdata[c]) return 0;
    memset(mapdata[c],0,255*255);
    actordata[c] = malloc(ACTORS*sizeof(ACTOR));
    if (!actordata[c]) return 0;
    memset(actordata[c],0,ACTORS*sizeof(ACTOR));
  }
  chardata = malloc(2048);
  if (!chardata) return 0;
  memset(chardata,0,2048);
  memset(chinfo,0,256);
  imagedata = malloc(8*8*256);
  if (!imagedata) return 0;
  blockdata = malloc(BLOCKS*16);
  memset(blockdata,0,BLOCKS*16);
  memset(blockcol,9,BLOCKS);
  if (!blockdata) return 0;
  blockimage = malloc(32*32*256);
  if (!blockimage) return 0;
  updateall();
  updateallblocks();
  return 1;
}

void updateall(void)
{
  int c;
  for (c = 0; c < 256; c++) updateimage(c);
}

void updateallblocks(void)
{
  int c;
  for (c = 0; c < BLOCKS; c++) updateblock(c);
}

void updateblock(int c)
{
  char *blockptr = &blockdata[c*16];
  int bx,by,y,x,v = 0;

  for (by=0; by<4; by++)
  {
    for (bx=0; bx<4; bx++)
    {
      int cnum = *blockptr++;
      char *ptr = &chardata[cnum*8];
      char *destptr = &blockimage[c*32*32+bx*8+by*256];

      if ((blockcol[c]&15) < 8)
      {
        for (y = 0; y < 8; y++)
        {
          unsigned data = *ptr;

          for (x = 7; x >= 0; x--)
          {
            if (data & 1) v = blockcol[c]&15;
            else v = bgcol;

            destptr[y*32+x]=v;

            data >>= 1;
          }
          ptr++;
        }
      }
      else
      {
        for (y = 0; y < 8; y++)
        {
          unsigned data = *ptr;
          for (x = 3; x >= 0; x--)
          {
            char chr = data & 3;
            switch (chr)
            {
              case 0:
              v = bgcol;
              break;

              case 1:
              v = multicol1;
              break;

              case 2:
              v = multicol2;
              break;

              case 3:
              v = blockcol[c]&7;
              break;

            }
            destptr[y*32+x*2]=v;
            destptr[y*32+x*2+1]=v;
            data >>= 2;
          }
          ptr++;
        }
      }
    }
  }
}

void updateimage(int c)
{
  char *destptr = &imagedata[(c&31)*8+(c/32)*2048];

  char *ptr = &chardata[c*8];
  char v = 0;
  int x,y;

  if ((blockcol[blocknum]&15) < 8)
  {
    for (y = 0; y < 8; y++)
    {
      unsigned data = *ptr;

      for (x = 7; x >= 0; x--)
      {
        if (data & 1) v = blockcol[blocknum]&15;
        else v = bgcol;

        destptr[y*256+x]=v;

        data >>= 1;
      }
      ptr++;
    }
  }
  else
  {
    for (y = 0; y < 8; y++)
    {
      unsigned data = *ptr;
      for (x = 3; x >= 0; x--)
      {
        char c = data & 3;
        switch (c)
        {
          case 0:
          v = bgcol;
          break;

          case 1:
          v = multicol1;
          break;

          case 2:
          v = multicol2;
          break;

          case 3:
          v = blockcol[blocknum]&7;
          break;

        }
        destptr[y*256+x*2]=v;
        destptr[y*256+x*2+1]=v;
        data >>= 2;
      }
      ptr++;
    }
  }
}

void initshit(void)
{
  if (!initchars())
  {
    win_messagebox("Out of memory!");
    exit(1);
  }

  if (!kbd_init())
  {
    win_messagebox("Keyboard init error!");
    exit(1);
  }

  if (!gfx_init(320,200,70, GFX_DOUBLESIZE))
  {
    win_messagebox("Graphics init error!");
    exit(1);
  }
  win_setmousemode(MOUSE_ALWAYS_HIDDEN);

  if ((!gfx_loadsprites(SPR_C, "editor.spr")) ||
      (!gfx_loadsprites(SPR_FONTS, "editfont.spr")))
  {
    win_messagebox("Error loading sprites!");
    exit(1);
  }
  if (!gfx_loadpalette("editor.pal"))
  {
    win_messagebox("Error loading palette!");
    exit(1);
  }
}

int inputtext(char *buffer, int maxlength)
{
  int len = strlen(buffer);
  int k;

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

void loadalldata(void)
{
  int c;
  char ib1[80];
  ib1[0] = 0;

  for (;;)
  {
    int r;

    win_getspeed(70);
    gfx_fillscreen(17);
    printtext_center_color("LOAD ALL LEVELDATA:",90,SPR_FONTS,COL_WHITE);
    printtext_center_color(ib1,100,SPR_FONTS,COL_HIGHLIGHT);
    gfx_updatepage();

    r = inputtext(ib1, 80);
    if (r == -1) return;
    if (r == 1)
    {
      int handle;
      char ib2[80];

      if (strlen(ib1)) levelnum = atoi(&ib1[strlen(ib1)-1]);
      strcpy(ib2, ib1);
      strcat(ib2, ".chr");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        read(handle, chinfo, 256);
        read(handle, chardata, 2048);
        close(handle);
        updateall();
        updateallblocks();
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".blk");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        read(handle, blockdata, BLOCKS*16);
        read(handle, blockcol, BLOCKS);
        close(handle);
        updateall();
        updateallblocks();
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".map");
      handle = open(ib2, O_RDONLY|O_BINARY);
      if (handle != -1)
      {
        read(handle, &mapsx, 1);
        read(handle, &mapsy, 1);
        read(handle, &bgcol, 1);
        read(handle, &multicol1, 1);
        read(handle, &multicol2, 1);
        close(handle);
      }
      for (c = 0; c < FLOORS; c++)
      {
        int y;
        char fn[] = ".m0";
        fn[2] = c + '0';

        strcpy(ib2, ib1);
        strcat(ib2, fn);
        handle = open(ib2, O_RDONLY|O_BINARY);
        if (handle != -1)
        {
          for (y = 0; y < mapsy; y++)
          {
            read(handle, &mapdata[c][y*255], mapsx);
          }
          close(handle);
        }
        fn[1] = 'a';
        fn[2] = c + '0';

        strcpy(ib2, ib1);
        strcat(ib2, fn);
        handle = open(ib2, O_RDONLY|O_BINARY);
        if (handle != -1)
        {
          read(handle, actordata[c], ACTORS*sizeof(ACTOR));
          close(handle);
        }

      }
      updateall();
      updateallblocks();
      return;
    }
  }
}

void savealldata(void)
{
  int c;
  char ib1[80];
  strcpy(ib1, "level ");
  ib1[5] = levelnum + '0';


  for (;;)
  {
    int r;

    win_getspeed(70);
    gfx_fillscreen(17);
    printtext_center_color("SAVE ALL LEVELDATA:",90,SPR_FONTS,COL_WHITE);
    printtext_center_color(ib1,100,SPR_FONTS,COL_HIGHLIGHT);
    gfx_updatepage();

    r = inputtext(ib1, 80);
    if (r == -1) return;
    if (r == 1)
    {
      int handle;
      char ib2[80];

      strcpy(ib2, ib1);
      strcat(ib2, ".chr");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        write(handle, chinfo, 256);
        write(handle, chardata, 2048);
        close(handle);
        updateall();
        updateallblocks();
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".blk");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        write(handle, blockdata, BLOCKS*16);
        write(handle, blockcol, BLOCKS);
        close(handle);
        updateall();
        updateallblocks();
      }

      strcpy(ib2, ib1);
      strcat(ib2, ".map");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        write(handle, &mapsx, 1);
        write(handle, &mapsy, 1);
        write(handle, &bgcol, 1);
        write(handle, &multicol1, 1);
        write(handle, &multicol2, 1);
        close(handle);
      }
      for (c = 0; c < FLOORS; c++)
      {
        int y;
        char fn[] = ".m0";
        fn[2] = c + '0';

        strcpy(ib2, ib1);
        strcat(ib2, fn);
        handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
        if (handle != -1)
        {
          for (y = 0; y < mapsy; y++)
          {
            write(handle, &mapdata[c][y*255], mapsx);
          }
          close(handle);
        }

        fn[1] = 'a';
        fn[2] = c + '0';

        strcpy(ib2, ib1);
        strcat(ib2, fn);
        handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
        if (handle != -1)
        {
          write(handle, actordata[c], ACTORS*sizeof(ACTOR));
          close(handle);
        }

      }
      return;
    }
  }
}

void loadblocks(void)
{
  char ib1[80];
  ib1[0] = 0;

  for (;;)
  {
    int r;

    win_getspeed(70);
    gfx_fillscreen(17);
    printtext_center_color("LOAD BLOCKFILE:",90,SPR_FONTS,COL_WHITE);
    printtext_center_color(ib1,100,SPR_FONTS,COL_HIGHLIGHT);
    gfx_updatepage();

    r = inputtext(ib1, 80);
    if (r == -1) return;
    if (r == 1)
    {
      int handle;
      handle = open(ib1, O_RDONLY | O_BINARY);
      if (handle == -1) return;
      read(handle, blockdata, BLOCKS*16);
      read(handle, blockcol, BLOCKS);
      close(handle);
      updateall();
      updateallblocks();
      return;
    }
  }
}

void loadmap(void)
{
  char ib1[80];
  ib1[0] = 0;

  for (;;)
  {
    int r;

    win_getspeed(70);
    gfx_fillscreen(17);
    printtext_center_color("LOAD MAPFILE:",90,SPR_FONTS,COL_WHITE);
    printtext_center_color(ib1,100,SPR_FONTS,COL_HIGHLIGHT);
    gfx_updatepage();

    r = inputtext(ib1, 80);
    if (r == -1) return;
    if (r == 1)
    {
      int handle,y;
      handle = open(ib1, O_RDONLY | O_BINARY);
      if (handle == -1) return;
      read(handle, &mapsx, 1);
      read(handle, &mapsy, 1);
      read(handle, &bgcol, 1);
      read(handle, &multicol1, 1);
      read(handle, &multicol2, 1);
      for (y = 0; y < mapsy; y++)
      {
        read(handle, &mapdata[y*255], mapsx);
      }
      close(handle);
      return;
    }
  }
}

void savemap(void)
{
  char ib1[80];
  ib1[0] = 0;

  for (;;)
  {
    int r;

    win_getspeed(70);
    gfx_fillscreen(17);
    printtext_center_color("SAVE MAPFILE:",90,SPR_FONTS,COL_WHITE);
    printtext_center_color(ib1,100,SPR_FONTS,COL_HIGHLIGHT);
    gfx_updatepage();

    r = inputtext(ib1, 80);
    if (r == -1) return;
    if (r == 1)
    {
      int handle,y;
      handle = open(ib1, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle == -1) return;
      write(handle, &mapsx, 1);
      write(handle, &mapsy, 1);
      write(handle, &bgcol, 1);
      write(handle, &multicol1, 1);
      write(handle, &multicol2, 1);
      for (y = 0; y < mapsy; y++)
      {
        write(handle, &mapdata[y*255], mapsx);
      }
      close(handle);
      return;
    }
  }
}

void saveblocks(void)
{
  char ib1[80];
  ib1[0] = 0;

  for (;;)
  {
    int r;

    win_getspeed(70);
    gfx_fillscreen(17);
    printtext_center_color("SAVE BLOCKFILE:",90,SPR_FONTS,COL_WHITE);
    printtext_center_color(ib1,100,SPR_FONTS,COL_HIGHLIGHT);
    gfx_updatepage();

    r = inputtext(ib1, 80);
    if (r == -1) return;
    if (r == 1)
    {
      int handle;
      handle = open(ib1, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle == -1) return;
      write(handle, blockdata, BLOCKS*16);
      write(handle, blockcol, BLOCKS);
      close(handle);
      return;
    }
  }
}

void loadcharsinfo(void)
{
  char ib1[80];
  int handle;
  ib1[0] = 0;


  for (;;)
  {
    win_getspeed(70);
    gfx_fillscreen(17);
    printtext_center_color("LOAD CHARS WITH INFO:",70,SPR_FONTS,COL_WHITE);
    printtext_center_color(ib1,80,SPR_FONTS,COL_HIGHLIGHT);
    gfx_updatepage();
    {
      int r = inputtext(ib1, 80);
      if (r == -1) return;
      if (r == 1)
      {
        handle = open(ib1, O_RDONLY | O_BINARY);
        if (handle == -1) return;
        read(handle, chardata, 2048);
        read(handle, chinfo, 256);
        close(handle);
        updateall();
        updateallblocks();
        return;
      }
    }
  }
}

void savecharsinfo(void)
{
  char ib1[80];
  int handle;
  ib1[0] = 0;

  for (;;)
  {
    win_getspeed(70);
    gfx_fillscreen(17);
    printtext_center_color("SAVE CHARS WITH INFO:",70,SPR_FONTS,COL_WHITE);
    printtext_center_color(ib1,80,SPR_FONTS,COL_HIGHLIGHT);
    gfx_updatepage();
    {
      int r = inputtext(ib1, 80);
      if (r == -1) return;
      if (r == 1)
      {
        handle = open(ib1, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
        if (handle == -1) return;
        write(handle, chinfo, 256);
        write(handle, chardata, 2048);
        close(handle);
        return;
      }
    }
  }
}

void loadchars(void)
{
  char ib1[80];
  char ib2[5];
  int phase = 1;
  ib1[0] = 0;
  ib2[0] = 0;

  for (;;)
  {
    win_getspeed(70);
    gfx_fillscreen(17);
    printtext_center_color("LOAD CHARFILE:",70,SPR_FONTS,COL_WHITE);
    printtext_center_color(ib1,80,SPR_FONTS,COL_HIGHLIGHT);
    if (phase > 1)
    {
      printtext_center_color("LOAD AT CHARNUM:",95,SPR_FONTS,COL_WHITE);
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
        int handle;
        int maxbytes = 2048;
        sscanf(ib2, "%d", &frame);
        if (frame < 0) frame = 0;
        if (frame > 255) frame = 255;
        maxbytes -= frame*8;
        handle = open(ib1, O_RDONLY | O_BINARY);
        if (handle == -1) return;
        read(handle, &chardata[frame*8], maxbytes);
        close(handle);
        updateall();
        updateallblocks();
        return;
      }
    }
  }
}

void savechars(void)
{
  char ib1[80];
  char ib2[5];
  char ib3[5];
  int phase = 1;
  ib1[0] = 0;
  ib2[0] = 0;
  ib3[0] = 0;

  for (;;)
  {
    win_getspeed(70);
    gfx_fillscreen(17);
    printtext_center_color("SAVE CHARFILE:",60,SPR_FONTS,COL_WHITE);
    printtext_center_color(ib1,70,SPR_FONTS,COL_HIGHLIGHT);
    if (phase > 1)
    {
      printtext_center_color("SAVE FROM CHARNUM:",85,SPR_FONTS,COL_WHITE);
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
        int handle;
        sscanf(ib2, "%d", &frame);
        sscanf(ib3, "%d", &frames);
        if (frame < 0) frame = 0;
        if (frame > 255) frame = 255;
        if (frames < 1) frames = 1;
        if (frame+frames > 256) frames = 256-frame;

        handle = open(ib1, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
        if (handle == -1) return;
        write(handle, &chardata[frame*8], frames*8);
        close(handle);
        return;
      }
    }
  }
}

void drawcbar(int x, int y, char col)
{
  int a;
  for (a = y; a < y+9; a++)
  {
    gfx_line(x, a, x+14, a, col);
  }
}

void handle_int(int a)
{
  exit(0); /* Atexit functions will be called! */
}

void drawimage(void)
{
        int c;

        for (c = 0; c < 64; c++)
        {
                memcpy(&gfx_vscreen[(128 + c) * 320 + 32], &imagedata[256*c], 256);
        }
}

void drawblock(int x, int y, int num)
{
        int c;

        for (c = 0; c < 32; c++)
        {
                memcpy(&gfx_vscreen[(y + c) * 320 + x], &blockimage[1024*num+c*32], 32);
        }
}

