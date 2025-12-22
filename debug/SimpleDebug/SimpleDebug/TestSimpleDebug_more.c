/***************************************************************************
**
** TestSimpleDebug_more.c Part of SimpleDebug package.
** Copyright (C) 2009- by Mikko Koivunalho
**
** This software is free software; you can redistribute it and/or
** modify it under the terms of the GNU Lesser General Public
** License as published by the Free Software Foundation; either
** version 2.1 of the License, or (at your option) any later version.
**
** This library is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
** Lesser General Public License for more details.
**
** $Id $
**
***************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define SIMPLE_DEBUG

#include <SimpleDebug/SimpleDebug.h>

SD_SETUP_EXTERNAL


/*
** SimpleDebug helper routines and datastructures defined
*/

/*
** Subroutines defined
*/
int testerroutine1(int i);
int testerroutine2(int i);
int testerroutine3(int i);


/*
** Routines
*/

int testerroutine1(int i) {
	SD_BEGIN("testerroutine1", 80);

	i = i * i + i + i * 2 * i;

	SD_APPEND("Returning value %d\n", i); SD_PRINTBUFFER();
	SD_END();
	return i;
}

int testerroutine2(int i) {
	SD_BEGIN("testerroutine2", 80);

	i = i * i + i + i * 2 * i;
	i = testerroutine1(i);

	SD_APPEND("Returning value %d\n", i); SD_PRINTBUFFER();
	SD_END();
	return i;
}

int testerroutine3(int i) {
	SD_BEGIN("testerroutine3", 80);

	i = i * i + i + i * 2 * i;
	i = testerroutine2(i);

	SD_APPEND("Returning value %d\n", i); SD_PRINTBUFFER();
	SD_END();
	return i;
}

