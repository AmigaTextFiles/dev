#include "seat.h"

inline Seat::Seat()
{
	s_Stations = MAX_STATIONS;
	s_Data = 0;
}

inline void Seat::SetStations(unsigned int n)
{
	s_Stations = n;
}

void Seat::Book(unsigned int section)
{
	if( section < s_Stations )
		s_Data |= SEATBITFIELD(section);
}

inline void Seat::BookAll()
{
	s_Data = ~0;
}

void Seat::Unbook(unsigned int section)
{
	if( section < s_Stations )
		s_Data &= ~SEATBITFIELD(section);
}

inline void Seat::UnBookAll()
{
	s_Data = 0;
}


int Seat::Seatstate(unsigned int section)
{
	int ret = NOTAVAILABLE;
	
	if( section < s_Stations )
	{
		if( s_Data & SEATBITFIELD(section) )
			ret = BOOKED;
		else
			ret = UNBOOKED;
	}
	return ret;
}


istream& operator>>(istream& is, Seat& seat)
{
	static int n = 0;
	is >> seat.s_Data;
	++n;
	cout << n << ": " << seat.s_Data << "\n";
	return is;
}

ostream& operator<<(ostream& os, const Seat& seat)
{
	return os << seat.s_Data << " ";
}
