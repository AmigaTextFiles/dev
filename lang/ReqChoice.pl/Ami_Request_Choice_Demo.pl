#!/gg/bin/perl/
### Ami_Request_Choice_Demo.pl by Bonnie Dalzell - freeware is a sample of how to use an 
### Amiga File Request Choice Gadget in a perl program that employs the perl qx// (system) command.
#
# Comments and suggestions to:
# Bonnie Dalzell
# 5100 Hydes Rd
# Hydes MD USA 
# 410-592-5512 - within the USA I do have flat rate long distance so if you want
# to discuss perl on the amiga I can call you back at no expense
# bdalzell@qis.net

@list=('Test Gadget','Pick a Button*nAny Button','One','Two','Three','Cancel');
$choice=&ami_request_choice(@list);
print "your choice was number $choice\n";


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
  print "\n Look for the gadget in the upper left corner of the screen\!\n";
  foreach $item (@variables){
   $requestor_choices="$requestor_choices \"$item\"";
  }
  $choice=qx/requestchoice "${reqtitle}" "${reqtext}" $requestor_choices/; 
  return $choice;

}
