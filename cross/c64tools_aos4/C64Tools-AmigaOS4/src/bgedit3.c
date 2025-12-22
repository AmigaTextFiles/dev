/*
 * C64 Background editor for MW3! Uncompatible with all previous editors :-)
 */

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <ctype.h>
#include "bme.h"
#include "editio.h"

#define COLOR_DELAY 10
#define NUMDOORS 160
#define NUMLVLSHP 64
#define NUMBLOCKS 192

#define LEFT_BUTTON 1
#define RIGHT_BUTTON 2
#define SINGLECOLOR 0
#define MULTICOLOR 1

#define EM_QUIT 0
#define EM_CHARS 1
#define EM_MAP 2
#define EM_LEVEL 3

#define SPR_C 0
#define SPR_FONTS 1
#define COL_WHITE 0
#define COL_HIGHLIGHT 1

char cwhite[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
char chl[] = {12,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
char *colxlattable[] = {cwhite, chl};
char textbuffer[80];
char copybuffer[8];
char bcopybuffer[16];
char copycharcolor;
char charcol[256];
char chinfo[256];

Uint8 lvlshpx[NUMLVLSHP];
Uint8 lvlshpy[NUMLVLSHP];
Uint8 lvlshpp[NUMLVLSHP];
Uint8 lvlshpt[NUMLVLSHP];
Uint8 lvlshpb[NUMLVLSHP];

Uint8 doorx[NUMDOORS];
Uint8 doory[NUMDOORS];
Uint8 doorl[NUMDOORS];
Uint8 doord[NUMDOORS];

int mousex;
int mousey;
int mouseb;
int colormode = 0;
int prevmouseb = 0;
int charnum = 0;
int blocknum = 0;
int ccolor = 3;
int flash = 0;
int editmode = EM_CHARS;
int mapx = 0;
int mapy = 0;
int mapsx = 100;
int mapsy = 20;
int levelnum = 0;
char ascii;
int k;
int multiplier = 64;
int colordelay = 0;

unsigned char *chardata;
unsigned char *imagedata;
unsigned char *blockdata;
unsigned char *blockimage;
unsigned char *mapdata;

unsigned char bgcol[4] = {0,0,0,0};
unsigned char multicol1[4] = {11,11,11,11};
unsigned char multicol2[4] = {12,12,12,12};
Uint8 shpnum = 1;

void char_mainloop(void);
void map_mainloop(void);
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
void level_mainloop(void);
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
int inputtext(char *buffer, int maxlength);

extern unsigned char datafile[];

int main(int argc, char *argv[])
{
  int handle;

  io_openlinkeddatafile(datafile);

  if (!win_openwindow("C64 Background Editor 3", NULL)) return 1;

  initshit();
  handle = open("mw3door.dat", O_RDONLY | O_BINARY);
  if (handle != -1)
  {
    read(handle, doorx, NUMDOORS);
    read(handle, doory, NUMDOORS);
    read(handle, doorl, NUMDOORS);
    read(handle, doord, NUMDOORS);
    close(handle);
  }

  gfx_setpalette();

  while (editmode)
  {
    if (editmode == EM_CHARS) char_mainloop();
    if (editmode == EM_LEVEL) level_mainloop();
    if (editmode == EM_MAP) map_mainloop();
  }

  gfx_uninit();
  win_closewindow();

  handle = open("mw3door.dat", O_RDWR | O_BINARY | O_CREAT | O_TRUNC, S_IREAD | S_IWRITE);
  if (handle != -1)
  {
    write(handle, doorx, NUMDOORS);
    write(handle, doory, NUMDOORS);
    write(handle, doorl, NUMDOORS);
    write(handle, doord, NUMDOORS);
    close(handle);
  }
  return 0;
}

void map_mainloop(void)
{
  updateallblocks();

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
    if (k == KEY_TAB)
    {
        colormode++;
        colormode &= 3;
        updateall();
        updateallblocks();
    }
    if (k == KEY_LEFT) mapx--;
    if (k == KEY_RIGHT) mapx++;
    if (k == KEY_UP) mapy--;
    if (k == KEY_DOWN) mapy++;
    if (mapx < 0) mapx = 0;
    if (mapy < 0) mapy = 0;
    if (mapx > (mapsx-10)) mapx = mapsx-10;
    if (mapy > (mapsy-5)) mapy = mapsy-5;
    if (k == KEY_F5)
    {
      editmode = EM_CHARS;
      break;
    }
    if (k == KEY_F6)
    {
      editmode = EM_LEVEL;
      break;
    }
    if ((k == KEY_Z) && (blocknum > 0))
    {
      blocknum--;
    }
    if ((k == KEY_X) && (blocknum < NUMBLOCKS-1))
    {
      blocknum++;
    }
    if (k == KEY_DEL)
    {
      int x;
      for (x = mapx+mousex/32; x < mapsx-1; x++)
      {
        mapdata[x+(mapy+mousey/32)*255] = mapdata[x+1+(mapy+mousey/32)*255];
      }
    }
    if (k == KEY_F)
    {
      /* Too dangerous! */
      /* memset(mapdata, blocknum, 255*255); */
    }
    if (k == KEY_I)
    {
      if (mapsy > 5) mapsy--;
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
        for (x = 0; x < mapsx; x++) mapdata[x+(mapsy-1)*255] = blocknum;
      }
    }
    if (k == KEY_K)
    {
      int y;
      if (mapsx < 255)
      {
        mapsx++;
        for (y = 0; y < mapsy; y++) mapdata[mapsx-1+y*255] = blocknum;
      }
    }
    if (k == KEY_G)
    {
      if ((mousex >= 0) && (mousex < 320) && (mousey >= 0) && (mousey < 160))
      {
        blocknum=mapdata[mapx+mousex/32+(mapy+mousey/32)*255];
      }
    }
    if (k == KEY_L)
    {
      if ((mousex >= 0) && (mousex < 320) && (mousey >= 0) && (mousey < 160))
      {
        int c;
        int maprow = mapy+mousey/32;
        for (c = maprow; c < mapsy-1; c++)
        {
                memcpy(&mapdata[c*255], &mapdata[(c+1)*255],255);
        }
        mapsy--;
        for (c = 0; c < NUMDOORS; c++)
        {
                if (doorl[c] == levelnum)
                {
                  if (doory[c] > maprow)
                  {
                    doory[c]--;
                  }
                }
        }
      }
    }


    if (k == KEY_F1) loadmap();
    if (k == KEY_F2) savemap();
    if (k == KEY_F9) loadalldata();
    if (k == KEY_F10) savealldata();

    if (mouseb)
    {
      if ((mousex >= 0) && (mousex < 320) && (mousey >= 0) && (mousey < 160))
      {
        mapdata[mapx+mousex/32+(mapy+mousey/32)*255]=blocknum;
      }
    }
    drawmap();
    gfx_drawsprite(mousex, mousey, 0x00000021);
    gfx_updatepage();
  }
}

void level_mainloop(void)
{
  updateallblocks();

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
    if (k == KEY_TAB)
    {
        colormode++;
        colormode &= 3;
        updateall();
        updateallblocks();
    }
    if (k == KEY_LEFT) mapx--;
    if (k == KEY_RIGHT) mapx++;
    if (k == KEY_UP) mapy--;
    if (k == KEY_DOWN) mapy++;
    if (mapx < 0) mapx = 0;
    if (mapy < 0) mapy = 0;
    if (mapx > (mapsx-10)) mapx = mapsx-10;
    if (mapy > (mapsy-5)) mapy = mapsy-5;
    if ((k == KEY_1) || (k == KEY_Z))
    {
      shpnum--;
    }
    if ((k == KEY_2) || (k == KEY_X))
    {
      shpnum++;
    }
    if (k == KEY_3)
    {
      shpnum -= 16;
    }
    if (k == KEY_4)
    {
      shpnum += 16;
    }
    if (k == KEY_F5)
    {
      editmode = EM_CHARS;
      break;
    }
    if (k == KEY_F6)
    {
      editmode = EM_MAP;
      break;
    }

    if (k == KEY_F1) loadmap();
    if (k == KEY_F2) savemap();
    if (k == KEY_F9) loadalldata();
    if (k == KEY_F10) savealldata();

    if ((mousex >= 0) && (mousex < 320) && (mousey >= 0) && (mousey < 160))
    {
      int c;
      int found = 0;
      int snum = 0;
      int dnum = 0;
      int x = mapx+mousex/32;
      int y = mapy+mousey/32;
      int xf = ((mapx*32+mousex) % 32) & 0x18;
      int yf = ((mapy*32+mousey) % 32) & 0x18;

      for (c = 0; c < NUMLVLSHP; c++)
      {
        if (lvlshpt[c])
        {
          if ((lvlshpx[c] == x) && (lvlshpy[c] == y))
          {
            found = 1;
            snum = c;
            break;
          }
        }
      }

      if (found)
      {
        if ((k == KEY_5) || (k == KEY_COMMA))
        {
          lvlshpp[snum]--;
        }
        if ((k == KEY_6) || (k == KEY_COLON))
        {
          lvlshpp[snum]++;
        }
        if (k == KEY_7)
        {
          lvlshpp[snum] -= 16;
        }
        if (k == KEY_8)
        {
          lvlshpp[snum] += 16;
        }
      }
      if ((mouseb == 1) && (shpnum))
      {
        if (!found)
        {
                for (c = 0; c < NUMLVLSHP; c++)
                {
                  if (!lvlshpt[c])
                  {
                    lvlshpt[c] = shpnum;
                    lvlshpp[c] = 0;
                    lvlshpx[c] = x;
                    lvlshpy[c] = y;
                    lvlshpb[c] = (xf/2) | ((yf/2)<<4);
                    break;
                  }
                }
        }
        else
        {
                lvlshpb[snum] = (xf/2) | ((yf/2)<<4);
        }
      }
      if ((mouseb == 2) && (found))
      {
        lvlshpt[snum] = 0;
        lvlshpp[snum] = 0;
        lvlshpx[snum] = 0;
        lvlshpy[snum] = 0;
        lvlshpb[snum] = 0;
      }

      found = 0;

      for (c = 0; c < NUMDOORS; c++)
      {
        if (doorl[c] == levelnum)
        {
          if ((doorx[c] == x) && (doory[c] == y))
          {
            found = 1;
            dnum = c;
            break;
          }
        }
      }

      if (k == KEY_D)
      {
        if (found)
        {
          doorl[dnum] = 0xff;
          doord[dnum] = 0;
          doorx[dnum] = 0;
          doory[dnum] = 0;
        }
        else
        {
          for (c = 0; c < NUMDOORS; c++)
          {
            if (doorl[c] == 0xff)
            {
              doorx[c] = x;
              doory[c] = y;
              doorl[c] = levelnum;
              doord[c] = c;
              break;
            }
          }
        }
      }
      if ((k == KEY_COMMA) || (k == KEY_5))
      {
        if (found) doord[dnum]--;
      }
      if ((k == KEY_COLON) || (k == KEY_6))
      {
        if (found) doord[dnum]++;
      }
    }

    drawmap();
    gfx_drawsprite(mousex, mousey, 0x00000021);
    gfx_updatepage();
  }
}

void drawmap(void)
{
  int y,x;

  for (y = 160; y < 208; y++) gfx_line(0,y,319,y,17);

  for (y = 0; y < 5; y++)
  {
    for (x = 0; x < 10; x++)
    {
      drawblock(x*32,y*32,mapdata[mapx+x+(mapy+y)*255]);
    }
  }
  sprintf(textbuffer, "XPOS %03d", mapx+mousex/32);
  printtext_color(textbuffer, 0,175,SPR_FONTS,COL_WHITE);
  sprintf(textbuffer, "YPOS %03d", mapy+mousey/32);
  printtext_color(textbuffer, 0,185,SPR_FONTS,COL_WHITE);
  if (editmode != EM_LEVEL)
  {
    drawblock(320-32,170,blocknum);
    sprintf(textbuffer, "BLOCK %03d", blocknum);
    printtext_color(textbuffer, 200,185,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "XSIZE %03d", mapsx);
    printtext_color(textbuffer, 80,175,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "YSIZE %03d", mapsy);
    printtext_color(textbuffer, 80,185,SPR_FONTS,COL_WHITE);
  }
  else
  {
    int shpc = 0, doorc = 0, doorc2 = 0;
    int c;
    for (c = 0; c < NUMLVLSHP; c++)
    {
      if (lvlshpt[c])
      {
        int scrx, scry;
        shpc++;
        scrx = lvlshpx[c] - mapx;
        scry = lvlshpy[c] - mapy;
        if ((scrx >= 0) && (scrx < 10) && (scry >= 0) && (scry < 5))
        {
          scrx <<= 5;
          scry <<= 5;
          scrx += (lvlshpb[c]&15)*2;
          scry += (lvlshpb[c]>>4)*2;
          if (flash<16) gfx_drawsprite(scrx, scry, 0x22);
          scry += 4;
          scrx -= 16;
          sprintf(textbuffer, "S%03d", lvlshpt[c]);
          printtext_color(textbuffer, scrx,scry+8,SPR_FONTS,COL_WHITE);
          sprintf(textbuffer, "P%03d", lvlshpp[c]);
          printtext_color(textbuffer, scrx,scry+18,SPR_FONTS,COL_WHITE);
        }
      }
    }
    for (c = 0; c < NUMDOORS; c++)
    {
      if (doorl[c]!=0xff) doorc2++;
      if (doorl[c]==levelnum)
      {
        int scrx, scry;
        doorc++;
        scrx = doorx[c] - mapx;
        scry = doory[c] - mapy;
        if ((scrx >= 0) && (scrx < 10) && (scry >= 0) && (scry < 5))
        {
          scrx <<= 5;
          scry <<= 5;
          sprintf(textbuffer, "DOOR");
          printtext_color(textbuffer, scrx,scry,SPR_FONTS,COL_WHITE);
          sprintf(textbuffer, "%03d", c);
          printtext_color(textbuffer, scrx,scry+8,SPR_FONTS,COL_WHITE);
          sprintf(textbuffer, "DEST");
          printtext_color(textbuffer, scrx,scry+16,SPR_FONTS,COL_WHITE);
          sprintf(textbuffer, "%03d", doord[c]);
          printtext_color(textbuffer, scrx,scry+24,SPR_FONTS,COL_WHITE);
        }
      }
    }
    sprintf(textbuffer, "SHAPES %03d", shpc);
    printtext_color(textbuffer, 80,175,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "SHPNUM %03d", shpnum);
    printtext_color(textbuffer, 80,185,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "DOORS/LEVEL %03d", doorc);
    printtext_color(textbuffer, 180,175,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "DOORS/TOTAL %03d", doorc2);
    printtext_color(textbuffer, 180,185,SPR_FONTS,COL_WHITE);
  }
}

void char_mainloop(void)
{
  for (;;)
  {
    int s = 0;
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

    if (k == KEY_TAB)
    {
        colormode++;
        colormode &= 3;
        updateall();
        updateallblocks();
    }
    if (k == KEY_R)
    {
      int y;
      for (y = 0; y < 8; y++)
      {
        chardata[charnum*8+y] ^= 0xff;
      }
      updateimage(charnum);
      updateblock(blocknum);
    }
    if (k == KEY_M)
    {
      charcol[charnum] ^= 8;
      updateimage(charnum);
      updateblock(blocknum);
    }
    if (k == KEY_V)
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

    if (k == KEY_B)
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
    if (k == KEY_N)
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
    if ((k == KEY_X) && (blocknum < NUMBLOCKS-1))
    {
      blocknum++;
      updateall();
      updateblock(blocknum);
    }
    if (k == KEY_P)
    {
      copycharcolor = charcol[charnum];
      memcpy(copybuffer, &chardata[charnum*8],8);
    }
    if (k == KEY_T)
    {
      charcol[charnum] = copycharcolor;
      memcpy(&chardata[charnum*8],copybuffer,8);
      updateimage(charnum);
      updateblock(blocknum);
    }
    if (k == KEY_Q)
    {
      memcpy(bcopybuffer, &blockdata[blocknum*16],16);
    }
    if (k == KEY_W)
    {
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
    if (k == KEY_F6)
    {
      editmode = EM_LEVEL;
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

  if (charcol[charnum] < 8) c=1;
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

  if (charcol[charnum] < 8) c=1;
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

  if (charcol[charnum] < 8)
  {
    for (y = 0; y < 8; y++)
    {
      unsigned data = *ptr;

      for (x = 7; x >= 0; x--)
      {
        if (data & 1) v = charcol[charnum];
        else v = bgcol[colormode];

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
          v = bgcol[colormode];
          break;

          case 1:
          v = multicol1[colormode];
          break;

          case 2:
          v = multicol2[colormode];
          break;

          case 3:
          v = charcol[charnum]-8;
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
  if (charcol[charnum] < 8)
  {
    printtext_color("SINGLECOLOR",0,80,SPR_FONTS,COL_WHITE);
  }
  else
  {
    printtext_color("MULTICOLOR",0,80,SPR_FONTS,COL_WHITE);
  }
  sprintf(textbuffer, "COLORMODE %d", colormode);
  printtext_color(textbuffer, 130,35,SPR_FONTS,COL_WHITE);
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
  printtext_color("CHAR COL",130,95,SPR_FONTS,v);
  drawcbar(220,50,bgcol[colormode]);
  drawcbar(220,65,multicol1[colormode]);
  drawcbar(220,80,multicol2[colormode]);
  drawcbar(220,95,charcol[charnum]&7);
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
  if (charcol[charnum] < 8)
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
  if (colordelay < COLOR_DELAY) colordelay++;
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
    if ((!prevmouseb) || (colordelay > COLOR_DELAY))
    {
      if (mouseb & LEFT_BUTTON)
      {
        switch(y/15)
        {
          case 0:
          bgcol[colormode]++;
          bgcol[colormode] &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 1:
          multicol1[colormode]++;
          multicol1[colormode] &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 2:
          multicol2[colormode]++;
          multicol2[colormode] &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 3:
          charcol[charnum]++;
          charcol[charnum] &= 15;
          updateall();
          updateblock(blocknum);
          break;
        }
        colordelay = 0;
      }
      if (mouseb & RIGHT_BUTTON)
      {
        switch(y/15)
        {
          case 0:
          bgcol[colormode]--;
          bgcol[colormode] &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 1:
          multicol1[colormode]--;
          multicol1[colormode] &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 2:
          multicol2[colormode]--;
          multicol2[colormode] &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 3:
          charcol[charnum]--;
          charcol[charnum] &= 15;
          updateall();
          updateblock(blocknum);
          break;
        }
        colordelay = 0;
      }
    }
  }
}

void mouseupdate(void)
{
  mou_getpos(&mousex, &mousey);
  prevmouseb = mouseb;
  mouseb = mou_getbuttons();
}

void handle_int(int a)
{
  exit(0); /* Atexit functions will be called! */
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

int initchars(void)
{
  int c;
  mapdata = malloc(255*255);
  if (!mapdata) return 0;
  memset(mapdata,0,255*255);
  chardata = malloc(2048);
  if (!chardata) return 0;
  memset(chardata,0,2048);
  memset(chinfo,0,256);
  imagedata = malloc(8*8*256);
  if (!imagedata) return 0;
  blockdata = malloc(NUMBLOCKS*16);
  memset(blockdata,0,NUMBLOCKS*16);
  memset(charcol,1,256);
  if (!blockdata) return 0;
  blockimage = malloc(32*32*NUMBLOCKS);
  if (!blockimage) return 0;
  for (c = 0; c < NUMLVLSHP; c++)
  {
    lvlshpx[c] = 0;
    lvlshpy[c] = 0;
    lvlshpt[c] = 0;
    lvlshpp[c] = 0;
    lvlshpb[c] = 0;
  }
  for (c = 0; c < NUMDOORS; c++)
  {
    doorx[c] = 0;
    doory[c] = 0;
    doorl[c] = 0xff;
    doord[c] = 0;
  }
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
  for (c = 0; c < NUMBLOCKS; c++) updateblock(c);
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

      if (charcol[cnum] < 8)
      {
        for (y = 0; y < 8; y++)
        {
          unsigned data = *ptr;

          for (x = 7; x >= 0; x--)
          {
            if (data & 1) v = charcol[cnum];
            else v = bgcol[colormode];

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
              v = bgcol[colormode];
              break;

              case 1:
              v = multicol1[colormode];
              break;

              case 2:
              v = multicol2[colormode];
              break;

              case 3:
              v = charcol[cnum]-8;
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

  if (charcol[c] < 8)
  {
    for (y = 0; y < 8; y++)
    {
      unsigned data = *ptr;

      for (x = 7; x >= 0; x--)
      {
        if (data & 1) v = charcol[c];
        else v = bgcol[colormode];

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
        char chr = data & 3;
        switch (chr)
        {
          case 0:
          v = bgcol[colormode];
          break;

          case 1:
          v = multicol1[colormode];
          break;

          case 2:
          v = multicol2[colormode];
          break;

          case 3:
          v = charcol[c]-8;
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

  if (!gfx_init(320,208,70, GFX_DOUBLESIZE))
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
      int firstnum;
      char ib2[80];

      for (firstnum = 0; firstnum < strlen(ib1); firstnum++)
      {
        if ((ib1[firstnum] >= '0') && (ib1[firstnum] <= '9')) break;
      }

      if (firstnum < strlen(ib1)) levelnum = atoi(&ib1[firstnum]);
      strcpy(ib2, ib1);
      strcat(ib2, ".lvl");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        read(handle, lvlshpx, NUMLVLSHP);
        read(handle, lvlshpy, NUMLVLSHP);
        read(handle, lvlshpt, NUMLVLSHP);
        read(handle, lvlshpp, NUMLVLSHP);
        read(handle, lvlshpb, NUMLVLSHP);
        close(handle);
      }
      else
      {
        int c;
        for (c = 0; c < NUMLVLSHP; c++)
        {
          lvlshpx[c] = 0;
          lvlshpy[c] = 0;
          lvlshpt[c] = 0;
          lvlshpp[c] = 0;
          lvlshpb[c] = 0;
        }
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".inf");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        read(handle, chinfo, 256);
        read(handle, charcol, 256);
        close(handle);
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".chr");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        read(handle, chardata, 2048);
        close(handle);
        updateall();
        updateallblocks();
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".map");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        int y;
        read(handle, &mapsx, 1);
        read(handle, &mapsy, 1);
        read(handle, bgcol, 4);
        read(handle, multicol1, 4);
        read(handle, multicol2, 4);
        for (y = 0; y < mapsy; y++)
        {
          read(handle, &mapdata[y*255], mapsx);
        }
        close(handle);
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".blk");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        read(handle, blockdata, NUMBLOCKS*16);
        close(handle);
        updateall();
        updateallblocks();
      }
      return;
    }
  }
}

void savealldata(void)
{
  char ib1[80];
  sprintf(ib1, "level%d", levelnum);

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
        write(handle, chardata, 2048);
        close(handle);
        updateall();
        updateallblocks();
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".inf");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        write(handle, chinfo, 256);
        write(handle, charcol, 256);
        close(handle);
        updateall();
        updateallblocks();
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".blk");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        write(handle, blockdata, NUMBLOCKS*16);
        close(handle);
        updateall();
        updateallblocks();
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".map");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        int y;
        write(handle, &mapsx, 1);
        write(handle, &mapsy, 1);
        write(handle, bgcol, 4);
        write(handle, multicol1, 4);
        write(handle, multicol2, 4);
        for (y = 0; y < mapsy; y++)
        {
          write(handle, &mapdata[y*255], mapsx);
        }
        close(handle);
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".lvl");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        write(handle, lvlshpx, NUMLVLSHP);
        write(handle, lvlshpy, NUMLVLSHP);
        write(handle, lvlshpt, NUMLVLSHP);
        write(handle, lvlshpp, NUMLVLSHP);
        write(handle, lvlshpb, NUMLVLSHP);
        close(handle);
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
      read(handle, blockdata, NUMBLOCKS*16);
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
      read(handle, bgcol, 4);
      read(handle, multicol1, 4);
      read(handle, multicol2, 4);
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
      write(handle, bgcol, 4);
      write(handle, multicol1, 4);
      write(handle, multicol2, 4);
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
      write(handle, blockdata, NUMBLOCKS*16);
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
        read(handle, chinfo, 256);
        read(handle, charcol, 256);
        read(handle, chardata, 2048);
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
        write(handle, charcol, 256);
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
