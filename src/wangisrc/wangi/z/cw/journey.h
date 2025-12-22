/*********************************************************************
 *
 * journey.h
 *
 * SDC coursework 1
 * Lee Kindness
 *
 */

#ifndef _JOURNEY_H_
#define _JOURNEY_H_

#include <iostream.h>
#include <fstream.h>

#include "seat.h"

/* Maximum of seats in a train */
#define MAX_SEATS 100

class Journey
{
private:
	char *j_FileName;  /* File to save record to */
	int   j_NumSeats;  /* Number of seats */
	Seat  j_Seats[MAX_SEATS];
	                   /* The actual record for each seat */
public:
	/* Loads in filename from disk and builds the object based on it */
	Journey(char *filename = "default.jny",
	        int   seats = MAX_SEATS);
	
	/* Save object to disk */
	~Journey();
	
	/* Book seat between from and to, returns 0 is seat already booked */
	int Book(int seat, int from, int to);
	
	/* Free seat between from and to, returns 0 if seat was not booked */
	int Unbook(int seat, int from, int to);
	
	/* Find the first seat which is free between from and to, returns 0 if none */
	int FindFree(int from, int to);
	
	/* Returns the number of seats */
	int Seats();
	
	/* Display a whole train */
	friend ostream& operator<<(ostream& os, Journey& j);
};

#endif /* _JOURNEY_H_ */
