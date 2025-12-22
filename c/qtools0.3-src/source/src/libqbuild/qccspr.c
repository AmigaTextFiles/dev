/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define MAX_BUFFER_SIZE	0x100000

staticvar unsigned char *lumpbuffer, *plump;
staticvar struct palpic *image;

/*
 * ===============
 * Cmd_Type
 * ===============
 */
staticfnc void Cmd_SPRType(sprBase sprMem)
{
  GetToken(FALSE);
  if (!__strcmp(token, "vp_parallel_upright"))
    sprMem->header.type = SPR_VP_PARALLEL_UPRIGHT;
  else if (!__strcmp(token, "facing_upright"))
    sprMem->header.type = SPR_FACING_UPRIGHT;
  else if (!__strcmp(token, "vp_parallel"))
    sprMem->header.type = SPR_VP_PARALLEL;
  else if (!__strcmp(token, "oriented"))
    sprMem->header.type = SPR_ORIENTED;
  else if (!__strcmp(token, "vp_parallel_oriented"))
    sprMem->header.type = SPR_VP_PARALLEL_ORIENTED;
  else
    Error("Bad sprite type\n");
}

/*
 * ===============
 * Cmd_Beamlength
 * ===============
 */
staticfnc void Cmd_SPRBeamlength(sprBase sprMem)
{
  GetToken(FALSE);
  sprMem->header.beamlength = atof(token);
}

/*
 * ===============
 * Cmd_Load
 * ===============
 */
staticfnc void Cmd_SPRLoad(sprBase sprMem)
{
  FILE *imagefile;

  GetToken(FALSE);
  if (!(imagefile = __fopen(token, F_READ_BINARY)))
    Error(failed_fileopen, token);
  if (!(image = GetImage(imagefile, 0, 0, 0)))
    Error(failed_fileload, token);
  __fclose(imagefile);
}

/*
 * ===============
 * Cmd_Frame
 * ===============
 */
staticfnc void Cmd_SPRFrame(sprBase sprMem)
{
  int x, y, xl, yl, xh, yh, w, h;
  unsigned char *screen_p, *source;
  int linedelta;
  struct dspriteframe_t *pframe;
  int pix;

  GetToken(FALSE);
  xl = atoi(token);
  GetToken(FALSE);
  yl = atoi(token);
  GetToken(FALSE);
  w = atoi(token);
  GetToken(FALSE);
  h = atoi(token);

  if ((xl & 0x07) || (yl & 0x07) || (w & 0x07) || (h & 0x07))
    Error("Sprite dimensions not multiples of 8\n");

  if ((w > 255) || (h > 255))
    Error("Sprite has a dimension longer than 255");

  xh = xl + w;
  yh = yl + h;

  pframe = (struct dspriteframe_t *)plump;
  sprMem->frames[sprMem->numframes].pdata = pframe;
  sprMem->frames[sprMem->numframes].type = SPR_SINGLE;

  if (TokenAvailable()) {
    GetToken(FALSE);
    sprMem->frames[sprMem->numframes].interval = atof(token);
    if (sprMem->frames[sprMem->numframes].interval <= 0.0)
      Error("Non-positive interval");
  }
  else
    sprMem->frames[sprMem->numframes].interval = 0.1;

  if (TokenAvailable()) {
    GetToken(FALSE);
    pframe->origin[0] = -atoi(token);
    GetToken(FALSE);
    pframe->origin[1] = atoi(token);
  }
  else {
    pframe->origin[0] = -(w >> 1);
    pframe->origin[1] = h >> 1;
  }

  pframe->width = w;
  pframe->height = h;

  if (w > sprMem->framesmaxs[0])
    sprMem->framesmaxs[0] = w;
  if (h > sprMem->framesmaxs[1])
    sprMem->framesmaxs[1] = h;

  plump = (unsigned char *) (pframe + 1);
  screen_p = &image->rawdata[yl * image->width + xl];
  linedelta = image->width - w;
  source = plump;

  for (y = yl; y < yh; y++) {
    for (x = xl; x < xh; x++) {
      pix = *screen_p;
      *screen_p++ = 0;
      /* if (pix == 255) */
      /*   pix = 0; */
      *plump++ = pix;
    }
    screen_p += linedelta;
  }

  if (sprMem->numframes >= sprMem->max_numframes)
    ExpandSPRClusters(sprMem, SPRITE_FRAMES);
  sprMem->numframes++;
  
  pfree(image);
}

/*
 * ===============
 * Cmd_GroupStart       
 * ===============
 */
staticfnc void Cmd_SPRGroupStart(sprBase sprMem)
{
  int groupframe;

  if (sprMem->numframes >= sprMem->max_numframes)
    ExpandSPRClusters(sprMem, SPRITE_FRAMES);
  groupframe = sprMem->numframes++;

  sprMem->frames[groupframe].type = SPR_GROUP;
  sprMem->frames[groupframe].numgroupframes = 0;

  while (1) {
    GetToken(TRUE);
    if (endofscript)
      Error("End of file during group");

    if (!__strcmp(token, "$frame")) {
      Cmd_SPRFrame(sprMem);
      sprMem->frames[groupframe].numgroupframes++;
    }
    else if (!__strcmp(token, "$load"))
      Cmd_SPRLoad(sprMem);
    else if (!__strcmp(token, "$groupend"))
      break;
    else
      Error("$frame, $load, or $groupend expected\n");
  }

  if (sprMem->frames[groupframe].numgroupframes == 0)
    Error("Empty group\n");
}

/*
 * ==============
 * Cmd_Spritename
 * ==============
 */
staticfnc char *Cmd_SPRName(sprBase sprMem, char *filebase)
{
  if (sprMem->numframes)
    FinishSprite(sprMem, filebase);

  GetToken(FALSE);
  sprMem->numframes = 0;

  sprMem->framesmaxs[0] = sprMem->framesmaxs[1] = -999999;

  if (!(lumpbuffer = tmalloc(MAX_BUFFER_SIZE * 2)))				/* *2 for padding */
    Error("Couldn't get buffer memory");

  plump = lumpbuffer;
  sprMem->header.synctype = ST_RAND;						/* default */
  
  return smalloc(token);
}
