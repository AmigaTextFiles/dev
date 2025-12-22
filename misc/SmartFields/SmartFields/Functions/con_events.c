/***************************************
*  CONsole EVENTS v1.11
*  © Copyright 1988 Software Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <intuition/intuition.h>
#include <console/console.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

UBYTE cse__escdata[42];

void con_events( wreq, flags, set_or_reset )
  struct IOStdReq *wreq;
  ULONG  flags;
  UBYTE  set_or_reset;
{
  REG  int i = 1;

  cse__escdata[0] = CSI;
  if (flags & RAWKEY) {
    cse__escdata[i++] = '1';
    cse__escdata[i++] = ';';
  }
  if (flags & MOUSEBUTTONS) {
    cse__escdata[i++] = '2';
    cse__escdata[i++] = ';';
  }
  if (flags & MOUSEMOVE) {
    cse__escdata[i++] = '4';
    cse__escdata[i++] = ';';
  }
  if (flags & INTUITICKS) {
    cse__escdata[i++] = '6';
    cse__escdata[i++] = ';';
  }
  if (flags & GADGETDOWN) {
    cse__escdata[i++] = '7';
    cse__escdata[i++] = ';';
  }
  if (flags & GADGETUP) {
    cse__escdata[i++] = '8';
    cse__escdata[i++] = ';';
  }
  if (flags & REQCLEAR) {
    cse__escdata[i++] = '9';
    cse__escdata[i++] = ';';
  }
  if (flags & MENUPICK) {
    cse__escdata[i++] = '1';
    cse__escdata[i++] = '0';
    cse__escdata[i++] = ';';
  }
  if (flags & CLOSEWINDOW) {
    cse__escdata[i++] = '1';
    cse__escdata[i++] = '1';
    cse__escdata[i++] = ';';
  }
  if (flags & NEWSIZE) {
    cse__escdata[i++] = '1';
    cse__escdata[i++] = '2';
    cse__escdata[i++] = ';';
  }
  if (flags & REFRESHWINDOW) {
    cse__escdata[i++] = '1';
    cse__escdata[i++] = '3';
    cse__escdata[i++] = ';';
  }
  if (flags & NEWPREFS) {
    cse__escdata[i++] = '1';
    cse__escdata[i++] = '4';
    cse__escdata[i++] = ';';
  }
  if (flags & DISKREMOVED) {
    cse__escdata[i++] = '1';
    cse__escdata[i++] = '5';
    cse__escdata[i++] = ';';
  }
  if (flags & DISKINSERTED) {
    cse__escdata[i++] = '1';
    cse__escdata[i++] = '6';
    cse__escdata[i++] = ';';
  }
  if (flags & ACTIVEWINDOW) {
    cse__escdata[i++] = '1';
    cse__escdata[i++] = '7';
    cse__escdata[i++] = ';';
  }
  if (flags & INACTIVEWINDOW) {
    cse__escdata[i++] = '1';
    cse__escdata[i++] = '8';
    cse__escdata[i++] = ';';
  }
  cse__escdata[i++] = set_or_reset;
  con_write( wreq, &cse__escdata[0], i );
}
