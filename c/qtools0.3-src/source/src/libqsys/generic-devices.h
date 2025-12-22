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

struct rgb {							/* red/green/blue */
  unsigned char r, g, b;
} __packed;

struct argb {							/* alpha/red/green/blue */
  unsigned char a;
  struct rgb rgb;
} __packed;

struct DisplayDimension {
  bool changedOffset;						/* offset of display-device in global desktop (eg. the window on a screen) */
  short int X, Y;
  bool changedSize;						/* size of display-device in global desktop (eg. the window on a screen) */
  short int Width, Height;
  bool changedDesktopOffset;					/* offset of global desktop (eg. the screen) */
  short int dtX, dtY;
  bool changedDesktopSize;					/* size of global desktop (eg. the screen) */
  short int dtWidth, dtHeight;

  bool changedBuffer;						/* the actual used framebuffer */
  void *frameBuffer;						/* address of the buffer to use for offscreen-rendering */
#ifdef	USE_ZBUFFER
  unsigned short int *zBuffer;					/* address for zbuffer-comparisons */
#endif
  char frameDepth;						/* the depth in bits */
  char frameBPP;						/* the depth in BitPerPel */
  int frameSize;						/* maximum size allowed to use */

  short int ID;							/* id-field of display */
  struct DisplayDimension *nextDim;				/* maybe we need more displays than one */
  void *driverPrivate;						/* some datas we need nothing know about; */
};

extern struct DisplayDimension localDim;

void SetDisplay(struct DisplayDimension *dim);

/*
 * here are the structs, externals and functions descripted,
 * that could but must not be implemented by the system-drivers
 * the file generic will ever compiled, you can activate
 * your functions with defines
 */

#undef	OPENDISPLAY
struct DisplayDimension *OpenDisplay(short int width, short int height, char depth, struct rgb *Palette);

#undef	SWAPDISPLAY
void *SwapDisplay(struct DisplayDimension *disp, void *oldBuffer);

/*
 * x,y are the offsets in the display-buffer
 * width, height are the sizes of the buffer to be displayed
 * (o offsets in the buffer to be displayed, must be width*height sized)
 */
#undef	UPDATEDISPLAY
void *UpdateDisplay(struct DisplayDimension *disp, void *oldBuffer, short int x, short int y, short int width, short int height);

#undef	CHANGEDISPLAY
void ChangeDisplay(struct DisplayDimension *disp, short int width, short int height, char depth, struct rgb *Palette, char *Title);

#undef	CLOSEDISPLAY
void CloseDisplay(struct DisplayDimension *disp);

#undef	OPENKEYS
void OpenKeys(struct DisplayDimension *disp);

#undef	GETKEYS
bool GetKeys(struct DisplayDimension *disp, struct keyEvent *eventBuffer);

#undef	CLOSEKEYS
void CloseKeys(struct DisplayDimension *disp);

#undef	OPENMOUSE
void OpenMouse(void);

#undef	GETMOUSE
void GetMouse(struct mouseEvent *eventBuffer);

#undef	CLOSEMOUSE
void CloseMouse(void);
