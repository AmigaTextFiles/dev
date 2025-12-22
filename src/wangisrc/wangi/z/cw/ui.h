/*********************************************************************
 *
 * ui.h
 *
 * SDC coursework 1
 * Lee Kindness
 *
 */

#ifndef _UI_H_
#define _UI_H_

#include "journey.h"
#include <iostream.h>

class UserInterface
{
	Journey *ui_Journey;
	
	/* The edit journey menu */
	void EditJourney(int newrec = 0);
	
	/* Get a from and destination station */
	void Getfromto(int& from, int& to);
	
	/* Get a seat number */
	void Getseat(int& seat);
	
	/* Get an int between man and max from cout */
	int Getint(int min, int max, const char *prompt);
public:
	UserInterface() {};
	
	/* Start up... */
	void Go();
};

#define INV_ON "\033[7m"
#define INV_OFF "\033[m"
#define INV_ONB "[" INV_ON
#define INV_OFFB INV_OFF "]"

#endif

