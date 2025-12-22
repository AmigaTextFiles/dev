/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Library General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define	LIBQTOOLS_CORE
#define	LIBQBUILD_CORE
#include "../include/libqtools.h"
#include "../include/libqbuild.h"

/*
 * ============
 * WriteFrame
 * ============
 */
staticfnc void WriteSPRFrame(sprBase sprMem, HANDLE spriteouthandle, int framenum)
{
  struct dspriteframe_t *pframe;
  struct dspriteframe_t frametemp;

  pframe = (struct dspriteframe_t *) sprMem->frames[framenum].pdata;
  frametemp.origin[0] = LittleLong(pframe->origin[0]);
  frametemp.origin[1] = LittleLong(pframe->origin[1]);
  frametemp.width = LittleLong(pframe->width);
  frametemp.height = LittleLong(pframe->height);

  __write(spriteouthandle, &frametemp, sizeof(frametemp));
  __write(spriteouthandle, (unsigned char *) (pframe + 1), pframe->height * pframe->width);
}

/*
 * ============
 * WriteSprite
 * ============
 */
staticfnc void WriteSprite(sprBase sprMem, HANDLE spriteouthandle)
{
  int i, groupframe, curframe;
  struct dsprite_t spritetemp;

  sprMem->header.boundingradius = sqrt(((sprMem->framesmaxs[0] >> 1) *
					(sprMem->framesmaxs[0] >> 1)) +
				       ((sprMem->framesmaxs[1] >> 1) *
					(sprMem->framesmaxs[1] >> 1)));

  /* write out the sprite header */
  spritetemp.type = LittleLong(sprMem->header.type);
  spritetemp.boundingradius = LittleFloat(sprMem->header.boundingradius);
  spritetemp.width = LittleLong(sprMem->framesmaxs[0]);
  spritetemp.height = LittleLong(sprMem->framesmaxs[1]);
  spritetemp.numframes = LittleLong(sprMem->numframes);
  spritetemp.beamlength = LittleFloat(sprMem->header.beamlength);
  spritetemp.synctype = LittleFloat(sprMem->header.synctype);
  spritetemp.version = LittleLong(SPR_VERSION_Q1);
  spritetemp.ident = LittleLong(MAGIC_SPR_Q1);

  __write(spriteouthandle, &spritetemp, sizeof(spritetemp));

  /* write out the frames */
  curframe = 0;

  for (i = 0; i < sprMem->numframes; i++) {
    __write(spriteouthandle, &sprMem->frames[curframe].type, sizeof(sprMem->frames[curframe].type));

    if (sprMem->frames[curframe].type == SPR_SINGLE) {
      /* single (non-grouped) frame */
      WriteSPRFrame(sprMem, spriteouthandle, curframe);
      curframe++;
    }
    else {
      int j, numframes;
      struct dspritegroup_t dsgroup;
      float totinterval;

      groupframe = curframe;
      curframe++;
      numframes = sprMem->frames[groupframe].numgroupframes;

      /* set and write the group header */
      dsgroup.numframes = LittleLong(numframes);

      __write(spriteouthandle, &dsgroup, sizeof(dsgroup));

      /* write the interval array */
      totinterval = 0;

      for (j = 0; j < numframes; j++) {
	struct dspriteinterval_t temp;

	totinterval += sprMem->frames[groupframe + 1 + j].interval;
	temp.interval = LittleFloat(totinterval);

	__write(spriteouthandle, &temp, sizeof(temp));
      }

      for (j = 0; j < numframes; j++) {
	WriteSPRFrame(sprMem, spriteouthandle, curframe);
	curframe++;
      }
    }
  }
}

/*
 * ==============
 * FinishSprite 
 * ==============
 */
void FinishSprite(sprBase sprMem, char *filebase)
{
  if (sprMem->numframes &&
      filebase) {
    HANDLE spriteouthandle;

    ReplaceExt(filebase, "spr");

    if ((spriteouthandle = __open(filebase, H_WRITE_BINARY))) {
      mprintf("    - saving in %s\n", filebase);
      WriteSprite(sprMem, spriteouthandle);
      __close(spriteouthandle);
    }

    mprintf("    - spritegen: successful\n");
    mprintf("    - %d frame(s)\n", sprMem->numframes);
  /*mprintf("    - %d ungrouped frame(s), including group headers\n", framecount);*/
  }
}
