/* ARexx script for use with Startup-Menu. Starts up OctamedPlafer with
   a random module. NOTE this script runs OctamedPlayer so that it is self
   contained.
*/

/* Put in your own module names and paths here */
Modules.1 = 'Apps:Data/GoodModsMeds/ACTONE.MED'
Modules.2 = 'Apps:Data/GoodModsMeds/ACTTWO.MED'
Modules.3 = 'Apps:Data/GoodModsMeds/LEGEND.med'
Modules.4 = 'Apps:Data/GoodModsMeds/LIFE.med'
Modules.5 = 'Apps:Data/GoodModsMeds/Lorraine.med'
Modules.6 = 'Apps:Data/GoodModsMeds/Promise.med'
Modules.7 = 'Apps:Data/GoodModsMeds/RavenTheme.med'
Modules.8 = 'Apps:Data/GoodModsMeds/Say.med'
Modules.9 = 'Apps:Data/GoodModsMeds/Song24.med'
Modules.10 = 'Apps:Data/GoodModsMeds/TheBorder.med'
Modules.11 = 'Apps:Data/GoodModsMeds/THISMUSTBEHEAVEN.med'
Modules.12 = 'Apps:Data/GoodModsMeds/VisionOfLove.med'
Modules.13 = 'Apps:Data/GoodModsMeds/WildAndLonely.med'

/* Get a random module. NOTE this random num is taken fromthe system clock.
   Therefore if you don't have one the modules will be the same each time it
   is launched from SM due to the system clock being approx. the same. */
Randnum = random(1,13,time(s));

/* Get the corresponding module name */
Selected = Modules.Randnum;
CmdLine = 'Run >NIL: C:OctaMEDPlayer ' Selected

/* run it */
ADDRESS COMMAND CmdLine;


/* NOTE:
    You could have run OctamedPlayer previous to this script and then used
    loadmod Selected and play. But there is a problem with this OctamedPlayer 
    requires a module to be given on the command line when it is started 
    without a window :----<< */
    
