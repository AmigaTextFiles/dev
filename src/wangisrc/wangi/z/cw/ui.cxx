/*********************************************************************
 *
 * ui.cxx
 *
 * SDC coursework 1
 * Lee Kindness
 *
 */

#include "ui.h"

void UserInterface::Go()
{
	char ch;
	cout << "DEESIDE and SUBURBS Railway Company\n"
	     << INV_ON << "Deeside Line Ticket Reservation System" << INV_OFF << "\n\n";
	do
	{
		cout << "Main Menu, Options:\n"
		     << "\t" << INV_ONB << "E" << INV_OFFB << "dit a journey record\n"
		     << "\tCreate a " << INV_ONB << "N" << INV_OFFB << "ew journey record\n"
		     << "\t" << INV_ONB << "Q" << INV_OFFB << "uit\n"
		     << "Your choice : ";

		cin >> ch;
		cout << endl;

		switch( ch )
		{
			case 'e' :
			case 'E' : 
				EditJourney();
				break;
			case 'n' :
			case 'N' :
				EditJourney(1);
				break;
		}

	} while( (ch != 'q') && (ch != 'Q') );
}


void UserInterface::EditJourney(int newrec)
{
	char jname[200];
	char ch;
	int seats = MAX_SEATS;

	cout << "Record name : ";
	cin >> jname;

	if( newrec )
		seats = Getint(1, MAX_SEATS, "Number of seats?");
	
	/* Create a journey object */
	ui_Journey = new Journey (jname, seats);
	
	int from, lffrom, to, lfto, seat, lfseat = 0;

	do
	{
		cout << "Edit Menu, Options:\n"
		     << "\t" << INV_ONB << "F" << INV_OFFB << "ind a free seat\n";
		if( lfseat )
			cout << "\tBook " << INV_ONB << "L" << INV_OFFB << "ast query\n";
		cout << "\t" << INV_ONB << "B" << INV_OFFB << "ook a seat\n"
		     << "\t" << INV_ONB << "U" << INV_OFFB << "nbook a seat\n"
		     << "\t" << INV_ONB << "V" << INV_OFFB << "iew all seats\n"
		     << "\t" << INV_ONB << "Q" << INV_OFFB << "uit to main menu\n"
		     << "Your choice : ";

		cin >> ch;
		cout << endl;
		
		switch( ch )
		{
			case 'f' :
			case 'F' :
				/* Find a free seat */
				Getfromto(from, to);
				if( seat = ui_Journey->FindFree(from, to) )
				{
					cout << "Seat " << seat << " is free between stations "
					     << from << " and " << to << "\n\n";
					lfseat = seat;
					lffrom = from;
					lfto = to;
				}
				else
				{
					lfseat = 0;
					cout << "ERROR:\n No free seats between " << from << " and " << to << "\n\n";
				}
				break;

			case 'l' :
			case 'L' :
				/* Book last found seat */
				if( lfseat )
				{
					if( !ui_Journey->Book(lfseat, lffrom, lfto) )
						cout << "ERROR:\n cannot book\n";
					else
						cout << "Seat " << lfseat << " now booked between stations " << lffrom << " and " << lfto << "\n";
					lfseat = 0;
				}
				break;

			case 'b' :
			case 'B' :
				/* Book a seat */
				lfseat = 0;
				Getfromto(from, to);
				Getseat(seat);
				if( !ui_Journey->Book(seat, from, to) )
					cout << "ERROR:\n cannot book\n";
				else
					cout << "Seat " << seat << " now booked between stations " << from << " and " << to << "\n";
				break;
				
			case 'u' :
			case 'U' :
				/* Free a seat */
				lfseat = 0;
				Getfromto(from, to);
				Getseat(seat);
				if( !ui_Journey->Unbook(seat, from, to) )
					cout << "ERROR:\n cannot un-book\n";
				else
						cout << "Seat " << seat << " now free between stations " << from << " and " << to << "\n";
				break;
			
			case 'v' :
			case 'V' :
				cout << *ui_Journey;
				break;
		}
	} while( (ch != 'q') && (ch != 'Q') );
	
	delete ui_Journey;
}


void UserInterface::Getfromto(int& from, int& to)
{
	from = Getint(1, MAX_STATIONS-1, "From station?");
	to = Getint(from+1, MAX_STATIONS, "To station?");
}


void UserInterface::Getseat(int& seat)
{
	seat = Getint(1, ui_Journey->Seats(), "Seat number?");
}


int UserInterface::Getint(int min, int max, const char *prompt)
{
	if( min == max )
		return min;
	else
	{
		int res;
		
		/* loop until res is valid */
		do
		{
			cout << prompt << " (min=" << min << ",max=" << max << ") : ";
			cin >> res;
		} while( (res < min) || (res > max) );
		return res;
	}
}

