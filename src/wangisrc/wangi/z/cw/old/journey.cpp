#include "journey.h"

Journey::Journey(char *filename,
        int stations,
        int carriages,
        int seats)
{
	j_FileName = filename;
	ifstream in(j_FileName);
		
	if( !in )
	{
		j_Stations = stations;
		j_Carriages = carriages;
		j_NumSeats = seats;
	} else
	{
		in >> j_Stations;
		cout << "j_Stations " << j_Stations << "\n";
		in >> j_Carriages;
		cout << "j_Carriages " << j_Carriages << "\n";
		in >> j_NumSeats;
		cout << "j_NumSeats " << j_NumSeats << "\n";
		
		for( int n = 0; (n < j_Carriages) && !in.eof(); ++n )
			for( int i = 0; (i < j_NumSeats) && !in.eof(); ++i )
			{
				j_Seats[n][i].SetStations(j_Stations);
				in >> j_Seats[n][i];
			}
	}
}

	
Journey::~Journey()
{
	ofstream out(j_FileName);
	
	if(!out) {} else
	{
		out << j_Stations << "\n";
		out << j_Carriages << "\n";
		out << j_NumSeats << "\n";
		for( int n = 0; n < j_Carriages; ++n )
			for( int i = 0; i < j_NumSeats; ++i )
			{
				j_Seats[n][i].Book(1);
				j_Seats[n][i].Book(4);
				out << j_Seats[n][i];
			}
	}
}

