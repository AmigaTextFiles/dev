#!gg:bin/perl -w
### afilereq.pl by Bonnie Dalzell - freeware is a sample of how to use an 
### Amiga File Requester in a perl program that employs the perl system command.
### 
### To do this you need to have the binary program BatchRequester by Christoph 
### Teuber installed on your Amiga in the system path.
### 
### BatchRequester is on Aminet at: 
### http://de.aminet/pub/aminet/util/batch/BatchRequester.lha
### the variable $filename contains the file you picked and the path to it.
###
### get_filereq.pl stores the picked file name in your ENV:directory 
### in an ascii file called "perl_requestor_path".
### You can store the picked file name elsewhere if you wish but you need
### to change both the value of $storage and the path name in the system command.
### 
### Remember - this is Amiga specific, for cross platform perl programs you will have to figure
### out some other way to open a gui file requestor.
### Contact Bonnie Dalzell for comments/suggestions bdalzell@QIS.net
### 5100 Hydes Rd, Hydes MD, 20182 USA

print "This program only runs on a Amiga with BatchRequestor from Aminet installed\n";

$filename=&afr; #this calls a subroutine &afr that runs BatchRequestor and returns the 
                #the selected file and its path to your program.

print "you picked the file $filename\n";

sub afr {

  my  $storage='Env:perl_requester_path';
  system('Batchrequester Env:perl_requester_path');
  open(IN,"Env:$storage")||die "have you installed BatchRequester in your system path? /n I cannot find $storage or \n";
  my  $filename=<IN>;
  chomp($filename);
  return $filename;

}
1;