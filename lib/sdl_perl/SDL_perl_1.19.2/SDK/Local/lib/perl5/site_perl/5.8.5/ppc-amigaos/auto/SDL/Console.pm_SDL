#	Console.pm
#
#	A package for SDL_Console
#
#	Copyright (C) 2002 Wayne Keenan

package SDL::Console;
use strict;
use SDL;

# class instance hash used to map
# the console command to the perl sub
my %cmdCallbacks =();

# class instance hash used to
# map the C SDL_console object
# to the perl object which created it.
# this allows us to pass the perl
# object to the perl callback, so
# it can easily, say, print to 'this/self'
# console.
my %cmdObjects =();


sub new {
	my $proto = shift;	
	my $class = ref($proto) || $proto;
	my $self = {};
	my %options = @_;

	verify (%options, qw/ -surface -font -lines  -rect  /) if $SDL::DEBUG;
	
	# possibility $options{-surface} || SDL::GetVideoSurface();

	my $surface = $options{-surface} || die "No surface given";
	my $font    = $options{-font}  || "ConsoleFont.bmp";
	my $lines   = $options{-lines} || 32;
	my $rect    = $options{-rect}  || new SDL::Rect(-width  =>$surface->width,
							-height =>$surface->height/4
						       );
	
	my $console = SDL::ConsoleInit($font, 
				    $surface->{-surface}, 
				    $lines,
				    $rect->{-rect}
				   ) ;
	
	$$self{-console} = $console 
	  or die "failed to create console";

	$cmdObjects{$console}=$self; # use for callback context
	SDL::EnableUnicode(1);
	SDL::ConsoleSendFullCommand(1); # we need to see the command for context
	
	bless $self,$class;
	return $self;
}

sub DESTROY {		
	my $self = shift;		
	my $con = $$self{-console};

	delete $cmdObjects{$con};
	SDL::ConsoleDestroy($con);	
}

sub draw 
{		
  my $self = shift;	
  SDL::ConsoleDrawConsole($$self{-console});	
}


# set the focus
sub topmost
{		
  my $self = shift;	
  SDL::ConsoleTopmost($$self{-console});	
}


# class static to add new callbacks
sub AddCommand
{
  my ($cmd, $cb) = @_;

  die "not a subroutine ref (actully given '".ref($cb)."' for '$cmd')"  
    unless (ref($cb) eq "CODE");

  SDL::ConsoleAddCommand($cmd);
  $cmdCallbacks{$cmd}= $cb;
}

# class static to allow SDL_Console to handle it's events
sub Event
{
  my $event = shift;
  SDL::ConsoleEvents($event->{-event});
}


sub print
{
  my $self = shift;
  # join all the @_ args togeter, then split on newlines.
  # there is a max line width in SDL_Console;
  map {SDL::ConsoleOut($$self{-console}, $_)} split "\n", join ' ', @_;
}

sub alpha
{
  my ($self, $alpha) = @_;  
  SDL::ConsoleAlpha($$self{-console}, $alpha);
}

sub background
{
  my ($self, $file, $x, $y) = @_;  
  SDL::ConsoleBackground($$self{-console}, $file, $x,$y);
}

sub list_commands
{
  my $self = shift;  
  return SDL::ConsoleListCommands($$self{-console});
}

sub position
{
  my ($self, $x, $y) = @_;  
  SDL::ConsolePosition($$self{-console}, $x,$y);
}

sub resize
{
  my ($self, $rect) = @_;  
  return SDL::ConsoleResize($$self{-console}, $rect->{-rect});
}


# class static method called by
# the (single) XS SDL_Console callback
sub CommandDispatch
{
  my ($console, $line) = @_;

  if ($line =~ /^\s*([^\s]+)\s*(.*)$/)
  {
    my $cmd =$1;
    my $params= $2;
    my $func = $cmdCallbacks{$cmd};    
    &{$func}($cmdObjects{$console}, $params, split ' ', $params);
  }
  else
  {
    warn "Failed to parse command from : '$line'\n";
  }
}

1;

__END__;

=head1 NAME

SDL::Console - a SDL perl extension

=head1 SYNOPSIS

  use SDL::Console;
  
  my $console_rect= new SDL::Rect(
				  -width =>$app->width, 
				  -height=>128
				 );

  my $console = new SDL::Console(
				 -surface => $app,
				 -rect  => $console_rect, 
				 -font  => "ConsoleFont.bmp",
				 -lines => 100,
				);

  SDL::Console::addCommand("my_command", \&cmd_func);

  $console->topmost();    # gain focus

  while ($doStuffFlag)
  {
    # do normal event processing
    SDL::Console::event($event);    # pass SDL::Event obj
    $console->draw;                 # blit console
  }


  sub cmd_func
  {
    my $console = shift;  # SDL::Console object 
    my $rawparams= shift; # original command line, not include command
    my @params =@_;       # command line as indiviual args 
                          # (split ' ', $rawparams)

    $console->print("you called me with: $rawparams"); # print to the console
  }




=head1 DESCRIPTION

The C<SDL::Console> module encapsulates the SDL_Console library, and
many of its ancillatory functions.    

=head2 new (-surface => $app, ... )

Specifies the surface on which the console will be blitted.  
This method takes the following additional parameters:

=over 4

=item *

-font		the font file to use, default: "ConsoleFont.bmp"

=item *

-lines		number of lines in the console, default: 32

=item *

-rect		a SDL::Rect which specifies the console bounding box, 
                default: x=0, y=0, w=surface width, height=25% of surface height

=back

=head2 topmost       ()
give this console the keyboard focus.

=head2 draw          ()
blit this console to the associated surface

=head2 print         ( @strings )
write a string(s) the console

=head2 alpha         ( $alpha )

set the console alpha component (0-255)

=head2 background    ( $file, $x,$y)

load a background image

=head2 position      ( $x, $y)

set the console origin

=head2 resize        ( SDL::Rect )

resize the console

=head2 Event         ( SDL::Event )

class method to be called when events are processed.

=head2 AddCommand    ( $command, sub {} )

class method to add a command to the Consoles repository

=head2 list_commands ()

display the registered commands to the console & stdout



=head1 AUTHOR

Wayne Keenan

=head1 SEE ALSO

	perl(1) SDL::Surface(3) SDL::Rect(3) SDL::App(3) SDL::Event(3).

=cut

