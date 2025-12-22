using namespace std;

#include "player.h"

//********************** main
int main(int argc, char *argv[])
{
 AnimPlayer animplayer;        //create player object
 animplayer.main(argc, argv);  //runs the player
 animplayer.~AnimPlayer();
}
