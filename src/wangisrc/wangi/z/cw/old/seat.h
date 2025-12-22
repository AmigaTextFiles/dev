#ifndef _SEAT_H_
#define _SEAT_H

#include <iostream.h>

/* Maximum Number of stations on the line */
#define MAX_STATIONS (sizeof(int) * 8)

#define SEATBITFIELD(X) (1 << (X - 1))

class Seat
{
private:
	unsigned int s_Stations;
	unsigned int s_Data;
public:
	enum state { BOOKED, UNBOOKED, NOTAVAILABLE };
	
	/* Constructor */
	Seat();
	
	/* Set the number of stations, and hence howmany booking this
	 * seat can have, need because we cant specify a constructor
	 * argument when delaring arrays
	 */
	void SetStations(unsigned int n = MAX_STATIONS);
	
	/* Book a seat between station section and station section+1 */
	void Book(unsigned int section);
	
	/* Book the seat for the entire journey */
	void BookAll();
	
	/* Unbook a seat for a section */
	void Unbook(unsigned int section);
	
	/* Free a seat for the entire journey */
	void UnBookAll();
	
	/* Is the seat booked, unbooked or notavailable in this section? */
	int Seatstate(unsigned int section);
	
	/* Stream operators */
	friend istream& operator>>(istream& is, Seat& seat);
	friend ostream& operator<<(ostream& os, const Seat& seat);
};

#endif

