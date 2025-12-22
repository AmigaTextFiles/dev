/*********************************************************************
 *
 * journey.cxx
 *
 * SDC coursework 1
 * Lee Kindness
 *
 */

#include "journey.h"

Journey::Journey(char *filename,
                 int seats)
{
	j_FileName = filename;
	ifstream in(j_FileName);
	
	/* Check range */
	if( seats < 1 ) seats = 1;
	seats > MAX_SEATS ? j_NumSeats = MAX_SEATS : j_NumSeats = seats;

	in >> j_NumSeats;
		
	for( int i = 0; (i < j_NumSeats) && !in.eof(); ++i )
		in >> j_Seats[i];
}

	
Journey::~Journey()
{
	ofstream out(j_FileName);
	
	if(!out) {} else
	{
		out << j_NumSeats << '\n';
		
		for( int i = 0; i < j_NumSeats; ++i )
			out << j_Seats[i];
	}
}


int Journey::Book(int seat,
                  int from,
                  int to)
{
	if( (seat > 0) && (seat <= j_NumSeats) )
		return j_Seats[seat-1].Book(from, to);
	return 0;
}


int Journey::Unbook(int seat,
                    int from,
                    int to)
{
	if( (seat > 0) && (seat <= j_NumSeats) )
		return j_Seats[seat-1].Unbook(from, to);
	return 0;
}


int Journey::FindFree(int from, int to)
{
	for( int n = 0; n < j_NumSeats; ++n )
		if( j_Seats[n].IsFree(from, to) )
			return n+1;
	return 0;
}


int Journey::Seats()
{
	return( j_NumSeats );
}


ostream& operator<<(ostream& os, Journey& j)
{
	os << "# = booked\n"
	   << ". = unbooked\n\n"
	   << "           Stations\n"
	   << "seat  1";
	for( int i = 3; i < MAX_STATIONS; ++i )
		os << ' ';
	os << MAX_STATIONS << "\n\n";
	for( int n = 0; n < j.j_NumSeats; ++n )
	{
		os << " ";
		os.width(3);
		os << n+1 << "  ";
		j.j_Seats[n].ShowSeat(os);
	}
	os << '\n';
	return os;
}
