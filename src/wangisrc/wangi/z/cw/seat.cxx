/*********************************************************************
 *
 * seat.cxx
 *
 * SDC coursework 1
 * Lee Kindness
 *
 */

#include "seat.h"

Seat::Seat()
{
	/* Clear all bits */
	s_Data = 0;
}


int Seat::Book(int from, int to)
{
	if( IsFree(from, to) )
	{
		for( int n = from; n < to; ++n )
			s_Data |= SEATBITFIELD(n);
		return 1;
	}
	return 0;
}


int Seat::Unbook(int from, int to)
{
	if( AllBooked(from, to) )
	{
		for( int n = from; n < to; ++n )
			s_Data &= ~SEATBITFIELD(n);
		return 1;
	}
	return 0;
}


int Seat::IsFree(int from, int to)
{
	for( int n = from; n < to; ++n )
		if( s_Data & SEATBITFIELD(n) )
			return 0;
	return 1;
}


int Seat::AllBooked(int from, int to)
{
	for( int n = from; n < to; ++n )
		if( !(s_Data & SEATBITFIELD(n)) )
			return 0;
	return 1;
}


void Seat::ShowSeat(ostream& os)
{
	for( int n = 1; n < MAX_STATIONS; ++n )
		if( s_Data & SEATBITFIELD(n) )
			os << "#";
		else
			os << ".";
	os << '\n'; 
}


istream& operator>>(istream& is, Seat& seat)
{
	return is >> seat.s_Data;
}


ostream& operator<<(ostream& os, const Seat& seat)
{
	/* Just output the decimal data value */
	return os << seat.s_Data << " ";
}
