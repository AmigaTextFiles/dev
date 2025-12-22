#!/usr/bin/perl
## You may have to change the line above to reflect the location of your perl
# on your amiga this demo work.
# This demonstrates how to dynamically build a request choice gadget and detect
# which choice was made. 
#
# I have also made a subroutine to which  you can send the gadget parameters and get
# back a choice
#
# This runs an amiga request_choice gadget and returns the value to the main program
# I have found that the qx/systemcommand/ technique for executing system commands seems 
# to work better on the Amiga than the system('systemcommand') technique.
# 
# This demonstration includes a little subroutine &getentry("topic") that streamlines
# getting an entry from the cli.  
# 
# Since the request_choice binary is specific to the Amiga OS you would have to do
# something else on a different platform.
# Comments and suggestions to:
# Bonnie Dalzell
# 5100 Hydes Rd
# Hydes MD USA 
# 410-592-5512 - within the USA I do have flat rate long distance so if you want
# to discuss perl on the amiga I can call you back at no expense
# bdalzell@qis.net

use English;

print "\n\nWelcome to the Perl". $]." program ".$PROGRAM_NAME." running under $OSNAME\n\n"; 

$reqtitle=&getentry('request gadget title');

$reqtext=&getentry('request gadget text');

$i='1';
$entry=&getentry("button $i");
@list=$entry;
print " first entry is $list[0]\n";
$requestor_choices="\"$entry\"";

$i++;
while ($entry ne ""){
 $entry=&getentry("button $i");

 if ($entry ne ""){
   $requestor_choices="$requestor_choices \"$entry\"";
    @list= (@list,"$entry");
    $i++; 

  }#endif
}#end while
$listlen = @list;
print "from array there are $listlen choices\n";
$zero=pop(@list);
print "last element is $zero\n";
unshift(@list,$zero);

$choice=qx/requestchoice "${reqtitle}" "${reqtext}" $requestor_choices/; 

print "your choice was \"$list[$choice]\" with a value of $choice.\n"; 

####subroutines####

sub getentry {
my $topic=$_[0];
  print "for $topic: enter word, character or number or cr to end entry phase: ";
  my $entry=<STDIN>;
  chomp($entry);
  if ($entry  ne ""){
    print "you entered $entry\n";
  }#endif
  return $entry;
}#end sub

sub ami_request_choice {
### you call this by   ami_request_choice(@list); 
###
### Where the first element of @list is the title of your requestor such as: 
###    My Requestor
### The next element is the text within the requestor such as (for 2 lines of text): 
###    Pick A Button*n Any Button (the *n is a line break)
### The balance of the list is the various botton lables in order.
###
### In the standard c:request_choice program the buttons return values from
### left to right of 1,2,3,...,0. Zero is the value of the rightmost button
### which is generally the 'cancel' button. You can then use the returned value
### to launch a response to your requestor. 
###

my @variables =@_;
my $reqtitle=shift(@variables);
my $reqtext=shift(@variables);

print "req title is $reqtitle \n";
  foreach $item (@variables){
   $requestor_choices="$requestor_choices \"$variables\"";
  }

  $choice=qx/requestchoice "${reqtitle}" "${reqtext}" $requestor_choices/; 
  return $choice;

}
