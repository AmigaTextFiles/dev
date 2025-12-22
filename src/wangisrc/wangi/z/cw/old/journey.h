#ifndef _JOURNEY_H_
#define _JOURNEY_H_

#include <iostream.h>
#include <fstream.h>

#include "seat.h"

/* Maximum of seats in a carraiage */
#define MAX_SEATSINCAR 10

/* Maxamum number of carriages in a train */
#define MAX_CARRIAGES 2

class Journey
{
private:
	char *j_FileName;  /* File to save record to */
	int   j_Stations;  /* Number of stations */
	int   j_Carriages; /* Number of carriages */
	int   j_NumSeats;  /* Number of seats */
	Seat  j_Seats[MAX_CARRIAGES][MAX_SEATSINCAR];
	                   /* The actual record for each seat */
public:
	Journey(char *filename,
        	int stations = MAX_STATIONS,
	        int carriages = MAX_CARRIAGES,
	        int seats = MAX_SEATSINCAR);
	~Journey();
};

#endif /* _JOURNEY_H_ */
