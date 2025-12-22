/*********************************************************************
 *
 * seat.h
 *
 * SDC coursework 1
 * Lee Kindness
 *
 */

#ifndef _SEAT_H_
#define _SEAT_H

#include <iostream.h>

/* Maximum Number of stations on the line */
#define MAX_STATIONS (sizeof(int) * 8)

/* Get the bitfield number for station X */
#define SEATBITFIELD(X) (1 << (X - 1))

class Seat
{
private:
	/* The data for each part of the journey is stored as a single bit... */
	unsigned int s_Data;
	
	/* Returns true if all stations are booked between from and to */
	int AllBooked(int from, int to);
public:
	
	/* Constructor */
	Seat();
	
	/* Book seat between from and to */
	int  Book(int from, int to);
	
	/* Free seat between from and to */
	int  Unbook(int from, int to);
	
	/* Returns true if all stations are free between from and to */
	int  IsFree(int from, int to);
	
	/* 'Show' the seat */
	void ShowSeat(ostream&);
	
	/* Stream operators */
	friend istream& operator>>(istream& is, Seat& seat);
	friend ostream& operator<<(ostream& os, const Seat& seat);
};

#endif

