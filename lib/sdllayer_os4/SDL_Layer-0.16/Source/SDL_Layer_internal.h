/************************************************************************
 * SDL_Layer - A layered display mechanism for SDL
 * Copyright (C) 2008  Julien CLEMENT
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ************************************************************************/


#ifndef _SDL_Layer_internal_h_
#define _SDL_Layer_internal_h_

#include "SDL_Layer.h"

#define MAX(x,y)	((x) > (y) ? (x) : (y))
#define MIN(x,y)	((x) < (y) ? (x) : (y))
#define ABS(x)		MAX((x),-(x))

#define LAYER(ldptr,k)	((ldptr)->layers[k])

void SDLayer_DiscardRects (SDLayer * l);

#endif

