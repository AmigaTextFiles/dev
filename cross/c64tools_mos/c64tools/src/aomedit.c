/*
 * AGENTS OF METAL (MW4) Background editor
 */

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <ctype.h>
#include "bme.h"
#include "editio.h"

#define COLOR_DELAY 10
#define NUMLVLACT 128
#define NUMDOORS 42
#define NUMZONES 16

#define LEFT_BUTTON 1
#define RIGHT_BUTTON 2
#define SINGLECOLOR 0
#define MULTICOLOR 1

#define EM_QUIT 0
#define EM_CHARS 1
#define EM_MAP 2
#define EM_LEVEL 3
#define EM_ZONE 4

#define BLOCKS 256
#define SPR_C 0
#define SPR_FONTS 1
#define COL_WHITE 0
#define COL_HIGHLIGHT 1

unsigned char lvlactx[NUMLVLACT];
unsigned char lvlacty[NUMLVLACT];
unsigned char lvlactb[NUMLVLACT];
unsigned char lvlactt[NUMLVLACT];
unsigned char lvlactp[NUMLVLACT];
unsigned char lvlactbits[NUMLVLACT];
unsigned char lvlactwpn[NUMLVLACT];
unsigned char lvlactid[NUMLVLACT];

unsigned char zonel[NUMZONES];
unsigned char zoner[NUMZONES];
unsigned char zoneu[NUMZONES];
unsigned char zoned[NUMZONES];
unsigned char zonebg1[NUMZONES];
unsigned char zonebg2[NUMZONES];
unsigned char zonebg3[NUMZONES];
unsigned char zonemusic[NUMZONES];

unsigned char doorx[64];
unsigned char doory[64];
unsigned char doord[64];

char *actorname[256];
char *itemname[256];
char *groupname[8];
char *idname[128];
char *modename[4];

unsigned char cwhite[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
unsigned char chl[] = {12,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
Uint8 *colxlattable[] = {cwhite, chl};
unsigned char textbuffer[80];
unsigned char copybuffer[8];
unsigned char bcopybuffer[16];
unsigned char copycharcolor;
unsigned char charcol[256];
unsigned char chinfo[256];
unsigned char charused[256];
unsigned char ascii;
int k;
int blockeditmode = 0;

int maxusedblocks = 0;
int colordelay = 0;
unsigned char oldchar;
unsigned char blockeditnum;

int mousex;
int mousey;
int mouseb;
int prevmouseb = 0;
unsigned char charnum = 0;
int blocknum = 0;
int zonenum = 0;
int ccolor = 3;
int flash = 0;
int editmode = EM_CHARS;
int mapx = 0;
int mapy = 0;
int mapsx = 100;
int mapsy = 20;
char levelname[80];

Uint8 *chardata;
Uint8 *imagedata;
Uint8 *blockdata;
Uint8 *blockimage;
Uint8 *mapdata;

int actfound = 0;
int actindex = 0;
int doorfound = 0;
int doorindex = 0;
unsigned char actnum = 1;
unsigned char frommap = 0;

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
void level_mainloop(void);
void zone_mainloop(void);
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
void initstuff(void);
void drawcbar(int x, int y, char col);
void printtext_color(char *string, int x, int y, unsigned spritefile, int color);
void printtext_center_color(char *string, int y, unsigned spritefile, int color);
void loadchars(void);
void savechars(void);
void editmain(void);
void copychar(int c, int d);
void transferchar(int c, int d);
int findsamechar(int c, int d);
void removeunusedchars(void);
void optimizechars(void);

extern unsigned char datafile[];

int main (int argc, char *argv[])
{
  int c;
  FILE *names;

  io_openlinkeddatafile(datafile);

  if (!win_openwindow("AOM Background Editor", NULL)) return 1;
  win_fullscreen = 0;

  for (c = 0; c < 256; c++) actorname[c] = " ";
  for (c = 0; c < 256; c++) itemname[c] = " ";
  for (c = 0; c < 8; c++) groupname[c] = " ";
  for (c = 0; c < 128; c++) idname[c] = " ";
  for (c = 0; c < 4; c++) modename[c] = " ";
  levelname[0] = 0;
  names = fopen("names.txt", "rt");
  if (!names) goto NONAMES;

  for (c = 0; c < 256; c++)
  {
    actorname[c] = malloc(80);
    actorname[c][0] = 0;
    AGAIN1:
    if (!fgets(actorname[c], 80, names)) break;
    if (actorname[c][0] == ' ') goto AGAIN1;
    if (actorname[c][0] == ';') goto AGAIN1;
    if (strlen(actorname[c]) > 1) actorname[c][strlen(actorname[c])-1] = 0; /* Delete newline */
    if (!strcmp(actorname[c], "end")) break;
  }
  for (c = 0; c < 256; c++)
  {
    itemname[c] = malloc(80);
    itemname[c][0] = 0;
    AGAIN2:
    if (!fgets(itemname[c], 80, names)) break;
    if (itemname[c][0] == ' ') goto AGAIN2;
    if (itemname[c][0] == ';') goto AGAIN2;
    if (strlen(itemname[c]) > 1) itemname[c][strlen(itemname[c])-1] = 0; /* Delete newline */
    if (!strcmp(itemname[c], "end")) break;
  }
  for (c = 0; c < 8; c++)
  {
    groupname[c] = malloc(80);
    groupname[c][0] = 0;
    AGAIN3:
    if (!fgets(groupname[c], 80, names)) break;
    if (groupname[c][0] == ' ') goto AGAIN3;
    if (groupname[c][0] == ';') goto AGAIN3;
    if (strlen(groupname[c]) > 1) groupname[c][strlen(groupname[c])-1] = 0; /* Delete newline */
    if (!strcmp(groupname[c], "end")) break;
  }
  for (c = 0; c < 128; c++)
  {
    idname[c] = malloc(80);
    idname[c][0] = 0;
    AGAIN4:
    if (!fgets(idname[c], 80, names)) break;
    if (idname[c][0] == ' ') goto AGAIN4;
    if (idname[c][0] == ';') goto AGAIN4;
    if (strlen(idname[c]) > 1) idname[c][strlen(idname[c])-1] = 0; /* Delete newline */
    if (!strcmp(idname[c], "end")) break;
  }
  for (c = 0; c < 4; c++)
  {
    modename[c] = malloc(80);
    modename[c][0] = 0;
    AGAIN5:
    if (!fgets(modename[c], 80, names)) break;
    if (modename[c][0] == ' ') goto AGAIN5;
    if (modename[c][0] == ';') goto AGAIN5;
    if (strlen(modename[c]) > 1) modename[c][strlen(modename[c])-1] = 0; /* Delete newline */
  }

  fclose(names);
  NONAMES:

  initstuff();

  gfx_setpalette();

  while (editmode)
  {
    if (editmode == EM_CHARS) char_mainloop();
    if (editmode == EM_MAP) map_mainloop();
    if (editmode == EM_LEVEL) level_mainloop();
    if (editmode == EM_ZONE) zone_mainloop();
  }
  return 0;
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
      editmode++;
      if (editmode > EM_ZONE) editmode = EM_CHARS;
      break;
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
      actnum--;
    }
    if ((k == KEY_2) || (k == KEY_X))
    {
      actnum++;
    }
    if (k == KEY_3)
    {
      actnum -= 16;
    }
    if (k == KEY_4)
    {
      actnum += 16;
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
    if (k == KEY_F7)
    {
      editmode = EM_ZONE;
      break;
    }

    if (k == KEY_F1) loadmap();
    if (k == KEY_F2) savemap();
    if (k == KEY_F9) loadalldata();
    if (k == KEY_F10) savealldata();

    if ((mousex >= 0) && (mousex < 320) && (mousey >= 0) && (mousey < 160))
    {
      int c;
      int x = mapx+mousex/32;
      int y = mapy+mousey/32;
      int xf = (((mapx*32+mousex) % 32) & 0x18) + 4;
      int yf = ((mapy*32+mousey) % 32) & 0x18;

      actfound = 0;

      for (c = 0; c < NUMLVLACT; c++)
      {
        if (lvlactt[c])
        {
          if ((lvlactx[c] == x) && (lvlacty[c] == y))
          {
            actfound = 1;
            actindex = c;
            break;
          }
        }
      }

      if (actfound)
      {
        if (k == KEY_A)
        {
          int mode = lvlactbits[actindex] >> 3;
          mode &= 0x3;
          mode++;
          mode &= 0x3;
          mode <<= 3;
          lvlactbits[actindex] &= (0xff - 0x18);
          lvlactbits[actindex] |= mode;
        }
        if (k == KEY_D) lvlactbits[actindex] ^= 0x80;
        if (k == KEY_G)
        {
          int group = lvlactbits[actindex];
          group &= 0x7;
          group++;
          group &= 0x7;
          lvlactbits[actindex] &= (0xff - 0x07);
          lvlactbits[actindex] |= group;
        }

        if ((k == KEY_5) || (k == KEY_COMMA))
        {
          lvlactp[actindex]--;
        }
        if ((k == KEY_6) || (k == KEY_COLON))
        {
          lvlactp[actindex]++;
        }
        if ((k == KEY_7) || (k == KEY_C) || (k == KEY_Q))
        {
          lvlactwpn[actindex]--;
        }
        if ((k == KEY_8) || (k == KEY_V) || (k == KEY_W))
        {
          lvlactwpn[actindex]++;
        }
        if ((k == KEY_N) || (k == KEY_I))
        {
          lvlactid[actindex]++;
          lvlactid[actindex] &= 127;
        }
        if (k == KEY_M)
        {
          lvlactid[actindex]--;
          lvlactid[actindex] &= 127;
        }
      }
      if ((mouseb == 1) && (actnum))
      {
        if (!actfound)
        {
          for (c = 0; c < NUMLVLACT; c++)
          {
            if (!lvlactt[c])
            {
              lvlactt[c] = actnum;
              lvlactx[c] = x;
              lvlacty[c] = y;
              lvlactb[c] = (xf/2) | ((yf/2)<<4);
              lvlactbits[c] = 0;
              lvlactwpn[c] = 0;
              lvlactid[c] = 0;
              if (actnum == 1)
              {
                lvlactp[c] = 0x00; /* Default pickup amount */
                lvlactwpn[c] = 0x01; /* First item */
              }
              else lvlactp[c] = 0xff; /* Default HP */
              break;
            }
          }
        }
        else
        {
          lvlactb[actindex] = (xf/2) | ((yf/2)<<4);
        }
      }
      if ((mouseb == 2) && (actfound))
      {
        lvlactt[actindex] = 0;
        lvlactp[actindex] = 0;
        lvlactx[actindex] = 0;
        lvlacty[actindex] = 0;
        lvlactb[actindex] = 0;
        lvlactbits[actindex] = 0;
        lvlactwpn[actindex] = 0;
      }

      doorfound = 0;

      for (c = 0; c < NUMDOORS; c++)
      {
        if ((doorx[c] == x) && (doory[c] == y))
        {
          doorfound = 1;
          doorindex = c;
          break;
        }
      }

      if (k == KEY_E)
      {
        if (doorfound)
        {
          doord[doorindex] = 0xff;
          doorx[doorindex] = 0;
          doory[doorindex] = 0;
        }
        else
        {
          for (c = 0; c < NUMDOORS; c++)
          {
            if (doord[c] == 0xff)
            {
              doorx[c] = x;
              doory[c] = y;
              doord[c] = c;
              break;
            }
          }
        }
      }
      if ((k == KEY_COMMA) || (k == KEY_5))
      {
        if (doorfound)
        {
          doord[doorindex]--;
          if (doord[doorindex] == 0xff)
            doord[doorindex] = 0xfe;
        }
      }
      if ((k == KEY_COLON) || (k == KEY_6))
      {
        if (doorfound)
        {
          doord[doorindex]++;
          if (doord[doorindex] == 0xff)
            doord[doorindex] = 0;
        }
      }
    }

    gfx_fillscreen(17);
    drawmap();
    gfx_drawsprite(mousex, mousey, 0x00000021);
    gfx_updatepage();
  }
}

void zone_mainloop(void)
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
      editmode++;
      if (editmode > EM_ZONE) editmode = EM_CHARS;
      break;
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
      zonenum--;
      zonenum &= (NUMZONES-1);
      updateall();
      updateallblocks();
    }
    if ((k == KEY_2) || (k == KEY_X))
    {
      zonenum++;
      zonenum &= (NUMZONES-1);
      updateall();
      updateallblocks();
    }
    if (k == KEY_N)
    {
      zonemusic[zonenum]--;
    }
    if (k == KEY_M)
    {
      zonemusic[zonenum]++;
    }
    if (k == KEY_V)
    {
      zonemusic[zonenum] -= 8;
    }
    if (k == KEY_B)
    {
      zonemusic[zonenum] += 8;
    }

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
    if (k == KEY_F7)
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
      int x = mapx+mousex/32;
      int y = mapy+mousey/32;

      if ((mouseb == 1) || (k == KEY_K))
      {
        zonel[zonenum] = x;
        zoneu[zonenum] = y;
      }
      if ((mouseb == 2) || (k == KEY_L))
      {
        zoner[zonenum] = x+1;
        zoned[zonenum] = y+1;
      }
    }

    gfx_fillscreen(17);
    drawmap();
    gfx_drawsprite(mousex, mousey, 0x00000021);
    gfx_updatepage();
  }
}


void map_mainloop(void)
{
  updateallblocks();

  for (;;)
  {
    win_getspeed(70);
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
      editmode++;
      if (editmode > EM_ZONE) editmode = EM_CHARS;
      break;
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
    if (k == KEY_F7)
    {
      editmode = EM_ZONE;
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
    if ((k == KEY_G) || (ascii == 13))
    {
      if ((mousex >= 0) && (mousex < 320) && (mousey >= 0) && (mousey < 160))
      {
        blocknum=mapdata[mapx+mousex/32+(mapy+mousey/32)*255];
      }
    }
    if (ascii == 13)
    {
      optimizechars();
      {
        int c;
        updateallblocks();
        for (c = 240; c < 256; c++)
        {
          if (charused[c]) goto NOBLOCKMODE;
        }
        for (c = 0; c < 16; c++)
        {
          copychar(blockdata[16*blocknum+c], 240+c);
          blockdata[16*blocknum+c] = 240+c;
        }
        blockeditmode = 1;
        blockeditnum = blocknum;
        oldchar = charnum;
        charnum = 240;
        updateall();
        updateallblocks();
        editmode = EM_CHARS;
        frommap = 1;
        break;
        NOBLOCKMODE: {}
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
    gfx_fillscreen(17);
    drawmap();
    gfx_drawsprite(mousex, mousey, 0x00000021);
    gfx_updatepage();
  }
}

void drawmap(void)
{
  int y,x;

  for (y = 0; y < 5; y++)
  {
    for (x = 0; x < 10; x++)
    {
      drawblock(x*32,y*32,mapdata[mapx+x+(mapy+y)*255]);
    }
  }
  if (editmode == EM_MAP)
  {
    sprintf(textbuffer, "XPOS %03d", mapx+mousex/32);
    printtext_color(textbuffer, 0,165,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "YPOS %03d", mapy+mousey/32);
    printtext_color(textbuffer, 0,175,SPR_FONTS,COL_WHITE);
    drawblock(320-32,160,blocknum);
    sprintf(textbuffer, "BLOCK %03d", blocknum);
    printtext_color(textbuffer, 200,175,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "XSIZE %03d", mapsx);
    printtext_color(textbuffer, 80,165,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "YSIZE %03d", mapsy);
    printtext_color(textbuffer, 80,175,SPR_FONTS,COL_WHITE);
  }
  if (editmode == EM_ZONE)
  {
    int l,r,u,d;

    l = zonel[zonenum] - mapx;
    r = zoner[zonenum] - mapx - 1;
    u = zoneu[zonenum] - mapy;
    d = zoned[zonenum] - mapy - 1;

    if ((l >= 0) && (u >= 0) && (l < 10) && (u < 5))
    {
      gfx_line(l*32,u*32,l*32+31,u*32,1);
      gfx_line(l*32,u*32+1,l*32+31,u*32+1,1);
      gfx_line(l*32,u*32,l*32,u*32+31,1);
      gfx_line(l*32+1,u*32,l*32+1,u*32+31,1);
    }
    if ((r >= 0) && (d >= 0) && (r < 10) && (d < 5))
    {
      gfx_line(r*32+30,d*32,r*32+30,d*32+31,1);
      gfx_line(r*32+31,d*32,r*32+31,d*32+31,1);
      gfx_line(r*32,d*32+30,r*32+31,d*32+30,1);
      gfx_line(r*32,d*32+31,r*32+31,d*32+31,1);
    }

    sprintf(textbuffer, "XPOS %03d", mapx+mousex/32);
    printtext_color(textbuffer, 0,165,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "YPOS %03d", mapy+mousey/32);
    printtext_color(textbuffer, 0,175,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "COLORS %01X %01X %01X", zonebg1[zonenum], zonebg2[zonenum], zonebg3[zonenum]);
    printtext_color(textbuffer, 80,175,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "MUSIC %02d-%01d", zonemusic[zonenum] / 8, zonemusic[zonenum] % 8);
    printtext_color(textbuffer, 80,185,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "ZONE %03d (%02d,%02d)-(%02d,%02d)", zonenum, zonel[zonenum],zoneu[zonenum],zoner[zonenum]-1,zoned[zonenum]-1);
    printtext_color(textbuffer, 80,165,SPR_FONTS,COL_WHITE);
  }

  if (editmode == EM_LEVEL)
  {
    int actc = 0, doorc = 0;
    int c;
    for (c = 0; c < NUMLVLACT; c++)
    {
      if (lvlactt[c])
      {
        int scrx, scry;
        actc++;
        scrx = lvlactx[c] - mapx;
        scry = lvlacty[c] - mapy;
        if ((scrx >= 0) && (scrx < 10) && (scry >= 0) && (scry < 5))
        {
          scrx <<= 5;
          scry <<= 5;
          scrx += (lvlactb[c]&15)*2-4;
          scry += (lvlactb[c]>>4)*2;
          if (flash<16) gfx_drawsprite(scrx, scry, 0x22);
          scry += 4;
          scrx -= 16;
          sprintf(textbuffer, "A%03d", lvlactt[c]);
          printtext_color(textbuffer, scrx,scry+8,SPR_FONTS,COL_WHITE);
          sprintf(textbuffer, "P%03d", lvlactp[c]);
          printtext_color(textbuffer, scrx,scry+18,SPR_FONTS,COL_WHITE);
        }
      }
    }
    for (c = 0; c < NUMDOORS; c++)
    {
      if (doord[c]!=0xff)
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
    sprintf(textbuffer, "ACTOR  %d", actnum);
    printtext_color(textbuffer, 240,165,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "ACTORS %d", actc);
    printtext_color(textbuffer, 240,175,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "DOORS  %d", doorc);
    printtext_color(textbuffer, 240,185,SPR_FONTS,COL_WHITE);
    if ((actfound) && (lvlactt[actindex]))
    {
      if (lvlactt[actindex] == 1)
      {
        sprintf(textbuffer, "%s", actorname[lvlactt[actindex]]);
        printtext_color(textbuffer, 0,165,SPR_FONTS,COL_WHITE);
        sprintf(textbuffer, "%s", itemname[lvlactwpn[actindex]]);
        printtext_color(textbuffer, 0,175,SPR_FONTS,COL_WHITE);
        if (lvlactp[actindex])
        {
          sprintf(textbuffer, "PICKUP AMOUNT: %d", lvlactp[actindex]);
          printtext_color(textbuffer, 0,185,SPR_FONTS,COL_WHITE);
        }
        else
        {
          sprintf(textbuffer, "PICKUP AMOUNT: DEFAULT");
          printtext_color(textbuffer, 0,185,SPR_FONTS,COL_WHITE);
        }
      }
      else
      {
        if (lvlactid[actindex] == 0x00)
        {
          sprintf(textbuffer, "%s", actorname[lvlactt[actindex]]);
          printtext_color(textbuffer,0,165,SPR_FONTS,COL_WHITE);
        }
        else
        {
          sprintf(textbuffer, "%s (%s)", actorname[lvlactt[actindex]], idname[lvlactid[actindex]]);
          printtext_color(textbuffer,0,165,SPR_FONTS,COL_WHITE);
        }
        if (lvlactp[actindex] == 0xff)
        {
          sprintf(textbuffer, "HP: DEF");
          printtext_color(textbuffer,0,175,SPR_FONTS,COL_WHITE);
        }
        else
        {
          sprintf(textbuffer, "HP: %d", lvlactp[actindex]);
          printtext_color(textbuffer,0,175,SPR_FONTS,COL_WHITE);
        }
        if (lvlactbits[actindex] & 0x80)
        {
          printtext_color("LEFT",64,175,SPR_FONTS,COL_WHITE);
        }
        else
        {
          printtext_color("RIGHT",64,175,SPR_FONTS,COL_WHITE);
        }
        {
          int mode = lvlactbits[actindex] >> 3;
          mode &= 0x3;
          printtext_color(modename[mode],112,175,SPR_FONTS,COL_WHITE);
        }

        sprintf(textbuffer, "%s", groupname[lvlactbits[actindex]&7]);
        printtext_color(textbuffer, 160,175,SPR_FONTS,COL_WHITE);

        sprintf(textbuffer, "WEAP: %s", itemname[lvlactwpn[actindex]]);
        printtext_color(textbuffer, 0,185,SPR_FONTS,COL_WHITE);
      }
    }
    else
    {
      sprintf(textbuffer, "%s", actorname[actnum]);
      printtext_color(textbuffer, 0,165,SPR_FONTS,COL_WHITE);
    }
  }
}

void char_mainloop(void)
{
  if ((blockeditmode) && (blocknum != blockeditnum))
  {
    blockeditmode = 0;
    charnum = oldchar;
  }
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
    if (ascii == 13)
    {
      optimizechars();
      if (blockeditmode)
      {
        blockeditmode = 0;
        charnum = oldchar;
        if (frommap)
        {
          editmode = EM_MAP;
          break;
        }
      }
      else
      {
        int c;
        updateallblocks();
        for (c = 240; c < 256; c++)
        {
          if (charused[c]) goto NOBLOCKMODE;
        }
        for (c = 0; c < 16; c++)
        {
          copychar(blockdata[16*blocknum+c], 240+c);
          blockdata[16*blocknum+c] = 240+c;
        }
        blockeditmode = 1;
        blockeditnum = blocknum;
        oldchar = charnum;
        charnum = 240;
        updateall();
        updateallblocks();
        frommap = 0;
        NOBLOCKMODE: {}
      }
    }

    if (k == KEY_TAB)
    {
      editmode++;
      if (editmode > EM_ZONE) editmode = EM_CHARS;
      break;
    }

    if (k == KEY_O) optimizechars();
    if (k == KEY_U) removeunusedchars();
    if (k == KEY_C)
    {
      memset(&chardata[charnum*8],0,8);
      chinfo[charnum]=0;
      updateimage(charnum);
      updateblock(blocknum);
    }
    if (k == KEY_8) chinfo[charnum] ^= 1;
    if (k == KEY_7) chinfo[charnum] ^= 2;
    if (k == KEY_6) chinfo[charnum] ^= 4;
    if (k == KEY_5) chinfo[charnum] ^= 8;
    if (k == KEY_4) chinfo[charnum] ^= 16;
    if (k == KEY_3) chinfo[charnum] ^= 32;
    if (k == KEY_2) chinfo[charnum] ^= 64;
    if (k == KEY_1) chinfo[charnum] ^= 128;

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

    if (!blockeditmode)
    {
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
    if (k == KEY_F7)
    {
      editmode = EM_ZONE;
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
    drawblock(170,0,blocknum);
    if (!blockeditmode)
    {
      drawimage();
      if (flash < 16) gfx_drawsprite((charnum&31)*8+32, 128+(charnum/32)*8, 0x00000022);
    }

    gfx_drawsprite(mousex, mousey, 0x00000021);
    gfx_updatepage();
  }
}

void scrollcharleft(void)
{
  unsigned char c;
  int y;

  if (charcol[charnum] < 8) c=1;
  else c = 2;

  while (c)
  {
    Uint8 *ptr = &chardata[charnum*8];
    for (y = 0; y < 8; y++)
    {
      unsigned data = *ptr;
      unsigned char bit = *ptr >> 7;
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
  unsigned char c;
  int y;

  if (charcol[charnum] < 8) c=1;
  else c = 2;

  while (c)
  {
    Uint8 *ptr = &chardata[charnum*8];
    for (y = 0; y < 8; y++)
    {
      unsigned data = *ptr;
      unsigned char bit = (*ptr & 1) << 7;
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
  unsigned char vara1 = ptr[0];
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
  unsigned char vara1 = ptr[7];
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
  Uint8 *ptr = &chardata[charnum*8];
  char v = 0;
  int x,y;
  int xc = 0,yc = 0;

  if (!blockeditmode)
  {
    if (charcol[charnum] < 8)
    {
      for (y = 0; y < 8; y++)
      {
        unsigned data = *ptr;

        for (x = 7; x >= 0; x--)
        {
          if (data & 1) v = charcol[charnum];
          else v = zonebg1[zonenum];

          gfx_drawsprite(x*5+xc*40,y*5+yc*40,0x00000001+v);

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
            v = zonebg1[zonenum];
            break;

            case 1:
            v = zonebg2[zonenum];
            break;

            case 2:
            v = zonebg3[zonenum];
            break;

            case 3:
            v = charcol[charnum]-8;
            break;

          }
          gfx_drawsprite(x*10+xc*40,y*5+yc*40,0x00000011+v);
          data >>= 2;
        }
        ptr++;
      }
    }
  }
  else
  {
    for (yc = 0; yc < 4; yc++)
    {
      for (xc = 0; xc < 4; xc++)
      {
        ptr = &chardata[(240+yc*4+xc)*8];
        if (charcol[240+yc*4+xc] < 8)
        {
          for (y = 0; y < 8; y++)
          {
            unsigned data = *ptr;

            for (x = 7; x >= 0; x--)
            {
              if (data & 1) v = charcol[240+yc*4+xc];
              else v = zonebg1[zonenum];

              gfx_drawsprite(x*5+xc*40,y*5+yc*40,0x00000001+v);
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
                v = zonebg1[zonenum];
                break;

                case 1:
                v = zonebg2[zonenum];
                break;

                case 2:
                v = zonebg3[zonenum];
                break;

                case 3:
                v = charcol[240+yc*4+xc]-8;
                break;

              }
              gfx_drawsprite(x*10+xc*40,y*5+yc*40,0x00000011+v);
              data >>= 2;
            }
            ptr++;
          }
        }
        if ((charnum == 240+yc*4+xc) && (flash<16))
        {
          gfx_line(xc*40-1,yc*40-1, xc*40+39, yc*40-1, 1);
          gfx_line(xc*40+39,yc*40-1, xc*40+39, yc*40+39, 1);
          gfx_line(xc*40+39,yc*40+39, xc*40-1, yc*40+39, 1);
          gfx_line(xc*40-1,yc*40+39, xc*40-1, yc*40-1, 1);
        }
      }
    }
  }


  if (!blockeditmode)
  {
    for (x = 0; x < 8; x++)
    {
      if ((chinfo[charnum] >> (7-x)) & 1) gfx_drawsprite(x*4, 41, 0x00000023);
      else gfx_drawsprite(x*4, 41, 0x00000024);
    }
    sprintf(textbuffer, "CHAR %03d", charnum);
    printtext_color(textbuffer, 0,50,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "BLOCK %03d", blocknum);
    printtext_color(textbuffer, 0,65,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "ZONE %03d", zonenum);
    printtext_color(textbuffer, 0,80,SPR_FONTS,COL_WHITE);
    sprintf(textbuffer, "BLOCKS %03d", maxusedblocks);
    printtext_color(textbuffer, 0,110,SPR_FONTS,COL_WHITE);
    if (charcol[charnum] < 8)
    {
      printtext_color("SINGLECOLOR",0,95,SPR_FONTS,COL_WHITE);
    }
    else
    {
      printtext_color("MULTICOLOR",0,95,SPR_FONTS,COL_WHITE);
    }
  }
  else
  {
    for (x = 0; x < 8; x++)
    {
      if ((chinfo[charnum] >> (7-x)) & 1) gfx_drawsprite(x*4, 161, 0x00000023);
      else gfx_drawsprite(x*4, 161, 0x00000024);
    }
  }
  v = COL_WHITE;
  if (ccolor == 0) v = COL_HIGHLIGHT;
  printtext_color("BACK",170,50,SPR_FONTS,v);
  v = COL_WHITE;
  if (ccolor == 1) v = COL_HIGHLIGHT;
  printtext_color("MC 1",170,65,SPR_FONTS,v);
  v = COL_WHITE;
  if (ccolor == 2) v = COL_HIGHLIGHT;
  printtext_color("MC 2",170,80,SPR_FONTS,v);
  v = COL_WHITE;
  if (ccolor == 3) v = COL_HIGHLIGHT;
  printtext_color("CHAR",170,95,SPR_FONTS,v);
  drawcbar(220,50,zonebg1[zonenum]);
  drawcbar(220,65,zonebg2[zonenum]);
  drawcbar(220,80,zonebg3[zonenum]);
  drawcbar(220,95,charcol[charnum]&7);
  gfx_line(218,48+15*ccolor,236,48+15*ccolor,1);
  gfx_line(236,48+15*ccolor,236,60+15*ccolor,1);
  gfx_line(236,60+15*ccolor,218,60+15*ccolor,1);
  gfx_line(218,60+15*ccolor,218,48+15*ccolor,1);

}

void changechar(void)
{
  if (blockeditmode) return;
  if (!mouseb) return;
  if ((mousex < 32) || (mousex >= 288)) return;
  if ((mousey < 128) || (mousey >= 192)) return;
  charnum = (mousex-32)/8+((mousey-128)/8)*32;
}

void editblock(void)
{
  Uint8 *bptr;
  if (!mouseb) return;
  if (blockeditmode) return;
  if ((mousex < 170) || (mousex >= 8*4+170)) return;
  if ((mousey < 0) || (mousey >= 8*4)) return;
  bptr = &blockdata[blocknum*16+(mousey/8)*4+((mousex-170)/8)];
  *bptr = charnum;
  updateblock(blocknum);
}

void editchar(void)
{
  Uint8 *ptr;
  int x,y;

  if (!mouseb) return;
  if (!blockeditmode)
  {
    if ((mousex < 0) || (mousex >= 8*5)) return;
    if ((mousey < 0) || (mousey >= 8*5)) return;
  }
  else
  {
    if ((mousex < 0) || (mousex >= 32*5)) return;
    if ((mousey < 0) || (mousey >= 32*5)) return;
    charnum = 240 + mousex / 40 + (mousey / 40) * 4;
  }

  ptr = &chardata[charnum*8];

  y = (mousey % 40) / 5;
  if (charcol[charnum] < 8)
  {
    char bit;
    x = (mousex % 40) / 5;
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
    x = (mousex % 40) / 5;
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
  if ((mousex < 170) || (mousex >= 235)) return;
  if ((mousey < 50) || (mousey >= 110)) return;
  y = mousey - 50;
  if ((y % 15) >= 9) return;
  if (mousex < 220)
  {
    ccolor = y / 15;
  }
  else
  {
    if ((!prevmouseb) || (colordelay >= COLOR_DELAY))
    {
      if (mouseb & LEFT_BUTTON)
      {
        switch(y/15)
        {
          case 0:
          zonebg1[zonenum]++;
          zonebg1[zonenum] &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 1:
          zonebg2[zonenum]++;
          zonebg2[zonenum] &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 2:
          zonebg3[zonenum]++;
          zonebg3[zonenum] &= 15;
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
          zonebg1[zonenum]--;
          zonebg1[zonenum] &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 1:
          zonebg2[zonenum]--;
          zonebg2[zonenum] &= 15;
          updateall();
          updateblock(blocknum);
          break;
          case 2:
          zonebg3[zonenum]--;
          zonebg3[zonenum] &= 15;
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

void printtext_color(char *string, int x, int y, unsigned spritefile, int color)
{
  Uint8 *xlat = colxlattable[color];

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
  char *stuff = string;
  Uint8 *xlat = colxlattable[color];
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

void mouseupdate(void)
{
  mou_getpos(&mousex, &mousey);
  prevmouseb = mouseb;
  mouseb = mou_getbuttons();
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
  blockdata = malloc(4096);
  memset(blockdata,0,4096);
  memset(charcol,9,256);
  if (!blockdata) return 0;
  blockimage = malloc(32*32*BLOCKS);
  if (!blockimage) return 0;
  for (c = 0; c < NUMLVLACT; c++)
  {
    lvlactx[c] = 0;
    lvlacty[c] = 0;
    lvlactt[c] = 0;
    lvlactp[c] = 0;
    lvlactb[c] = 0;
    lvlactbits[c] = 0;
    lvlactwpn[c] = 0;
    lvlactid[c] = 0;
  }
  for (c = 0; c < NUMDOORS; c++)
  {
    doorx[c] = 0;
    doory[c] = 0;
    doord[c] = 0xff;
  }
  for (c = 0; c < NUMZONES; c++)
  {
    zonel[c] = 0;
    zoner[c] = 1;
    zoneu[c] = 0;
    zoned[c] = 1;
    zonebg1[c] = 0;
    zonebg2[c] = 11;
    zonebg3[c] = 12;
    zonemusic[c] = 0;
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
  for (c = 0; c < BLOCKS; c++) updateblock(c);
  for (c = 255; c > 0; c--)
  {
    int d;
    for (d = 0; d < 16; d++)
    {
      if (blockdata[c*16+d]) goto FOUND;
    }
  }
  FOUND:
  maxusedblocks = c+1;
  for (c = 0; c < 256; c++) charused[c] = 0;
  for (c = 0; c < maxusedblocks*16; c++)
  {
    charused[blockdata[c]] = 1;
  }
}

void transferchar(int c, int d)
{
        int e;
        if (c == d) return;
        for (e = 0; e < 8; e++)
        {
                chardata[d*8+e] = chardata[c*8+e];
                chardata[c*8+e] = 0;
        }
        for (e = 0; e < BLOCKS*16; e++)
        {
                if (blockdata[e] == c) blockdata[e] = d;
        }
        charcol[d] = charcol[c];
        chinfo[d] = chinfo[c];
        chinfo[c] = 0;
}

void copychar(int c, int d)
{
        int e;
        for (e = 0; e < 8; e++)
        {
                chardata[d*8+e] = chardata[c*8+e];
        }
        charcol[d] = charcol[c];
        chinfo[d] = chinfo[c];
}


int findsamechar(int c, int d)
{
        int e;
        if (c == d) return 0;
        for (e = 0; e < 8; e++)
        {
                if (chardata[c*8+e] != chardata[d*8+e]) return 0;
        }
        if (chinfo[c] != chinfo[d]) return 0;
        if (charcol[c] >= 8)
        {
                for (e = 0; e < 8; e++)
                {
                        if ((chardata[c*8+e] & 0xc0) == 0xc0) goto CHECKCOLOR;
                        if ((chardata[c*8+e] & 0x30) == 0x30) goto CHECKCOLOR;
                        if ((chardata[c*8+e] & 0x0c) == 0x0c) goto CHECKCOLOR;
                        if ((chardata[c*8+e] & 0x03) == 0x03) goto CHECKCOLOR;
                }
        }
        else
        {
                for (e = 0; e < 8; e++)
                {
                        if (chardata[c*8+e]) goto CHECKCOLOR;
                }
        }
        return 1;
        CHECKCOLOR:
        if (charcol[c] != charcol[d]) return 0;
        return 1;
}

void removeunusedchars(void)
{
        int c;
        updateallblocks();
        for (c = 0; c < 256; c++)
        {
                if (!charused[c])
                {
                        int e;
                        for (e = 0; e < 8; e++)
                        {
                                chardata[c*8+e] = 0;
                        }
                        chinfo[c] = 0;
                }
        }
        optimizechars();
}

void optimizechars(void)
{
        int c,d;
        for (c = 0; c < 256; c++) charused[c] = 1;

        for (d = 1; d < 256; d++)
        {
                for (c = 0; c < d; c++)
                {
                        if (findsamechar(d,c))
                        {
                                transferchar(d,c);
                                charused[d] = 0;
                                break;
                        }
                }
        }
        for (d = 1; d < 256; d++)
        {
                int v = 0;
                for (c = 0; c < 8; c++) v += chardata[d*8+c];
                if (v)
                {
                        for (c = 0; c < d; c++)
                        {
                                if (!charused[c])
                                {
                                        transferchar(d,c);
                                        charused[d] = 0;
                                        charused[c] = 1;
                                        break;
                                }
                        }
                }
        }
        updateall();
        updateallblocks();
}

void updateblock(int c)
{
  Uint8 *blockptr = &blockdata[c*16];
  int bx,by,y,x,v = 0,e;

  for (e = 255; e > 0; e--)
  {
    int d;
    for (d = 0; d < 16; d++)
    {
      if (blockdata[e*16+d]) goto FOUND;
    }
  }
  FOUND:
  maxusedblocks = e+1;

  for (by=0; by<4; by++)
  {
    for (bx=0; bx<4; bx++)
    {
      int cnum = *blockptr++;
      Uint8 *ptr = &chardata[cnum*8];
      Uint8 *destptr = &blockimage[c*32*32+bx*8+by*256];

      if (charcol[cnum] < 8)
      {
        for (y = 0; y < 8; y++)
        {
          unsigned data = *ptr;

          for (x = 7; x >= 0; x--)
          {
            if (data & 1) v = charcol[cnum];
            else v = zonebg1[zonenum];

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
              v = zonebg1[zonenum];
              break;

              case 1:
              v = zonebg2[zonenum];
              break;

              case 2:
              v = zonebg3[zonenum];
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
  Uint8 *destptr = &imagedata[(c&31)*8+(c/32)*2048];

  Uint8 *ptr = &chardata[c*8];
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
        else v = zonebg1[zonenum];

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
        char b = data & 3;
        switch (b)
        {
          case 0:
          v = zonebg1[zonenum];
          break;

          case 1:
          v = zonebg2[zonenum];
          break;

          case 2:
          v = zonebg3[zonenum];
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

void initstuff(void)
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
  char ib1[80];
  strcpy(ib1, levelname);

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

      strcpy(levelname, ib1);
      strcpy(ib2, ib1);
      strcat(ib2, ".lva");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        read(handle, lvlactx, NUMLVLACT);
        read(handle, lvlacty, NUMLVLACT);
        read(handle, lvlactb, NUMLVLACT);
        read(handle, lvlactt, NUMLVLACT);
        read(handle, lvlactp, NUMLVLACT);
        read(handle, lvlactbits, NUMLVLACT);
        read(handle, lvlactwpn, NUMLVLACT);
        read(handle, lvlactid, NUMLVLACT);
        close(handle);
      }
      else
      {
        int c;
        for (c = 0; c < NUMLVLACT; c++)
        {
          lvlactx[c] = 0;
          lvlacty[c] = 0;
          lvlactt[c] = 0;
          lvlactp[c] = 0;
          lvlactb[c] = 0;
          lvlactbits[c] = 0;
          lvlactwpn[c] = 0;
          lvlactid[c] = 0;
        }
      }
      strcpy(levelname, ib1);
      strcpy(ib2, ib1);
      strcat(ib2, ".lvz");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        read(handle, zonel, NUMZONES);
        read(handle, zoner, NUMZONES);
        read(handle, zoneu, NUMZONES);
        read(handle, zoned, NUMZONES);
        read(handle, zonebg1, NUMZONES);
        read(handle, zonebg2, NUMZONES);
        read(handle, zonebg3, NUMZONES);
        read(handle, zonemusic, NUMZONES);
        close(handle);
      }
      else
      {
        int c;
        for (c = 0; c < NUMZONES; c++)
        {
          zonel[c] = 0;
          zoner[c] = 1;
          zoneu[c] = 0;
          zoned[c] = 1;
          zonebg1[c] = 0;
          zonebg2[c] = 11;
          zonebg3[c] = 12;
          zonemusic[c] = 0;
        }
      }

      strcpy(ib2, ib1);
      strcat(ib2, ".lvd");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        read(handle, doorx, NUMDOORS);
        read(handle, doory, NUMDOORS);
        read(handle, doord, NUMDOORS);
        close(handle);
      }
      else
      {
        int c;
        for (c = 0; c < NUMDOORS; c++)
        {
          doorx[c] = 0;
          doory[c] = 0;
          doord[c] = 0xff;
        }
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".chr");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        read(handle, chardata, 2040);
        close(handle);
        updateall();
        updateallblocks();
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".chi");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        read(handle, chinfo, 256);
        close(handle);
        updateall();
        updateallblocks();
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".blk");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        char unused;
        memset(blockdata,0,4096);
        read(handle, &unused, 1); /* Skip the chunkheader */
        read(handle, &unused, 1);
        read(handle, &unused, 1);
        read(handle, blockdata, BLOCKS*16);
        close(handle);
        updateall();
        updateallblocks();
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".chc");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        read(handle, &charcol, 256);
        close(handle);
        updateall();
        updateallblocks();
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".map");
      handle = open(ib2, O_RDONLY | O_BINARY);
      if (handle != -1)
      {
        char unused;
        int y,x;
        read(handle, &mapsx, 1);
        read(handle, &mapsy, 1);
        read(handle, &unused, 1); /* Skip the chunkheader */
        read(handle, &unused, 1);
        read(handle, &unused, 1);
        for (y = 0; y < mapsy; y++)
        {
          for (x = 0; x < mapsx; x++)
          {
            read(handle, &mapdata[y*255+x], 1);
          }
        }
        close(handle);
      }
      updateall();
      updateallblocks();
      return;
    }
  }
}

void savealldata(void)
{
  char ib1[80];
  strcpy(ib1, levelname);

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

      strcpy(levelname, ib1);
      strcpy(ib2, ib1);
      strcat(ib2, ".lvz");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        write(handle, zonel, NUMZONES);
        write(handle, zoner, NUMZONES);
        write(handle, zoneu, NUMZONES);
        write(handle, zoned, NUMZONES);
        write(handle, zonebg1, NUMZONES);
        write(handle, zonebg2, NUMZONES);
        write(handle, zonebg3, NUMZONES);
        write(handle, zonemusic, NUMZONES);
        close(handle);
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".lva");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        write(handle, lvlactx, NUMLVLACT);
        write(handle, lvlacty, NUMLVLACT);
        write(handle, lvlactb, NUMLVLACT);
        write(handle, lvlactt, NUMLVLACT);
        write(handle, lvlactp, NUMLVLACT);
        write(handle, lvlactbits, NUMLVLACT);
        write(handle, lvlactwpn, NUMLVLACT);
        write(handle, lvlactid, NUMLVLACT);
        close(handle);
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".lvd");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        write(handle, doorx, NUMDOORS);
        write(handle, doory, NUMDOORS);
        write(handle, doord, NUMDOORS);
        close(handle);
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".chr");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        write(handle, chardata, 2040);
        close(handle);
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".chi");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        write(handle, chinfo, 256);
        close(handle);
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".blk");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        int sizehi = (maxusedblocks * 16) >> 8;
        int sizelo = (maxusedblocks * 16) & 0xff;
        unsigned char objects = 0;
        write(handle, &objects, 1);
        write(handle, &sizehi, 1);
        write(handle, &sizelo, 1);
        write(handle, blockdata, maxusedblocks*16);
        close(handle);
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".chc");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        write(handle, &charcol, 256);
        close(handle);
      }
      strcpy(ib2, ib1);
      strcat(ib2, ".map");
      handle = open(ib2, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle != -1)
      {
        unsigned char sizehi = (mapsx*mapsy) >> 8;
        unsigned char sizelo = (mapsx*mapsy) & 0xff;
        unsigned char objects = 0;
        int y,x;
        write(handle, &mapsx, 1); // A bit of a nonstandard chunk file:
        write(handle, &mapsy, 1); // map size comes first
        write(handle, &objects, 1);
        write(handle, &sizehi, 1);
        write(handle, &sizelo, 1);
        for (y = 0; y < mapsy; y++)
        {
          for (x = 0; x < mapsx; x++)
          {
            write(handle, &mapdata[y*255+x], 1);
          }
        }
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
      read(handle, blockdata, BLOCKS*16);
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
      int handle,y,x;
      char discard;
      handle = open(ib1, O_RDONLY | O_BINARY);
      if (handle == -1) return;
      read(handle, &mapsx, 1);
      read(handle, &mapsy, 1);
      read(handle, &discard, 1);
      read(handle, &discard, 1);
      read(handle, &discard, 1);
      for (y = 0; y < mapsy; y++)
      {
        for (x = 0; x < mapsx; x++)
        {
          read(handle, &mapdata[y*255+x], 1);
        }
      }
      close(handle);
      break;
    }
  }
  updateall();
  updateallblocks();
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
      unsigned char sizehi = (mapsx*mapsy) >> 8;
      unsigned char sizelo = (mapsx*mapsy) & 0xff;
      unsigned char objects = 0;
      int handle,y,x;
      handle = open(ib1, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle == -1) return;
      write(handle, &mapsx, 1); // A bit of a nonstandard chunk file:
      write(handle, &mapsy, 1); // map size comes first
      write(handle, &objects, 1);
      write(handle, &sizehi, 1);
      write(handle, &sizelo, 1);
      for (y = 0; y < mapsy; y++)
      {
        for (x = 0; x < mapsx; x++)
        {
          unsigned char byte = mapdata[y*255+x];
          write(handle, &byte, 1);
        }
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
      unsigned char sizehi = (maxusedblocks * 16) >> 8;
      unsigned char sizelo = (maxusedblocks * 16) & 0xff;
      unsigned char objects = 0;
      int handle;
      handle = open(ib1, O_RDWR|O_BINARY|O_TRUNC|O_CREAT, S_IREAD|S_IWRITE);
      if (handle == -1) return;
      write(handle, &objects, 1);
      write(handle, &sizehi, 1);
      write(handle, &sizelo, 1);
      write(handle, blockdata, maxusedblocks*16);
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

