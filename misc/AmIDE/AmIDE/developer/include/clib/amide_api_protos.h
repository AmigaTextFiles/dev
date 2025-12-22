/*
**  $Id: amide_api_protos.h,v 1.2 2001/03/04 18:26:49 damato Exp $
**
**  AmIDE - Amiga Integrated Development Environment
**          main include file for amide_api module
**
**  Copyright (C) 1998-2001 by
**
**  LightSpeed Communications GbR
**
**  Jens Langner                        Jens Troeger
**  Bergstrasse 68                      i4/182 Dornoch Tce
**  01069 Dresden                       Highgate Hill, QLD, 4101
**  Germany                             Australia
**  <damato@light-speed.de>             <savage@light-speed.de>
**
**  This program is free software; you can redistribute it and/or modify
**  it under the terms of the GNU General Public License as published by
**  the Free Software Foundation; either version 2 of the License, or
**  any later version.
**
**  This program is distributed in the hope that it will be useful,
**  but WITHOUT ANY WARRANTY; without even the implied warranty of
**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**  GNU General Public License for more details.
**
**  You should have received a copy of the GNU General Public License
**  along with this program; if not, write to the Free Software
**  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
**
**  $VER: amide_api_protos.h 37.1 (04.03.2001)
*/

#ifndef CLIB_AMIDE_API_PROTOS_H
#define CLIB_AMIDE_API_PROTOS_H

/*
** We only have one function in this module where we have to return a created BOOPSI class
** and on this class we use our methods
*/

Class *AmIDE_API_GetClass(void);

#endif /* CLIB_AMIDE_API_PROTOS_H */
