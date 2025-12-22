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

#define	LIBQTOOLS_CORE
#define	LIBQBUILD_CORE
#include "../include/libqtools.h"
#include "../include/libqbuild.h"
#include "./qccparse.h"

#include "./qccmdl.c"
#include "./qccspr.c"

/*
 * ===============
 * ParseScript  
 * ===============
 */
char *ParseScript(int type, mdlBase mdlMem, sprBase sprMem) {
  char *filebase = 0;

  while (1) {
    do {							/* look for a line starting with a $ command */
      GetToken(TRUE);
      if (endofscript)
	return 0;
      if (token[0] == '$')
	break;
      while (TokenAvailable())
	GetToken(FALSE);
    } while (1);

    if (!__strcmp(token, "$cd")) {
      GetToken(FALSE);
      cwd(token);
    }

    if (type == PARSE_MODEL) {
      if (!__strcmp(token, "$modelname"))
        filebase = Cmd_MDLName(mdlMem, filebase);
      else if (!__strcmp(token, "$base"))
        Cmd_MDLBase(mdlMem);
      else if (!__strcmp(token, "$sync"))
        mdlMem->header.synctype = ST_SYNC;
      else if (!__strcmp(token, "$origin"))
        Cmd_MDLOrigin(mdlMem);
      else if (!__strcmp(token, "$eyeposition"))
        Cmd_MDLEyeposition(mdlMem);
      else if (!__strcmp(token, "$scale"))
        Cmd_MDLScaleUp(mdlMem);
      else if (!__strcmp(token, "$flags"))
        Cmd_MDLFlags(mdlMem);
      else if (!__strcmp(token, "$frame"))
        Cmd_MDLFrame(mdlMem, 0);
      else if (!__strcmp(token, "$skin")) {
        Cmd_MDLSkin(mdlMem);
        mdlMem->numskins++;
      }
      else if (!__strcmp(token, "$framegroupstart")) {
        Cmd_MDLFrameGroupStart(mdlMem);
        mdlMem->numframes++;
      }
      else if (!__strcmp(token, "$skingroupstart")) {
        Cmd_MDLSkinGroupStart(mdlMem);
        mdlMem->numskins++;
      }
      else
        Error("bad command %s\n", token);
    }
    else if (type == PARSE_SPRITE) {
      if (!__strcmp(token, "$load"))
        Cmd_SPRLoad(sprMem);
      else if (!__strcmp(token, "$spritename"))
        filebase = Cmd_SPRName(sprMem, filebase);
      else if (!__strcmp(token, "$type"))
        Cmd_SPRType(sprMem);
      else if (!__strcmp(token, "$beamlength"))
        Cmd_SPRBeamlength(sprMem);
      else if (!__strcmp(token, "$sync"))
        sprMem->header.synctype = ST_SYNC;
      else if (!__strcmp(token, "$frame")) {
        Cmd_SPRFrame(sprMem);
        sprMem->numframes++;
      }
      else if (!__strcmp(token, "$load"))
        Cmd_SPRLoad(sprMem);
      else if (!__strcmp(token, "$groupstart")) {
        Cmd_SPRGroupStart(sprMem);
        sprMem->numframes++;
      }
      else
        Error("bad command %s\n", token);
    }
  }
  
  return filebase;
}
