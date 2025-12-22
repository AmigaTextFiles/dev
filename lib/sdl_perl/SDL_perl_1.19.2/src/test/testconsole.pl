#!/usr/bin/env perl
#
# testsdlconsole.pl
#
# *** WARNING ***
#
# This is a first draft of SDL::Console, the interface may change.
#
# Usage: sdlconsole.pl [-bpp N] [-hw] [-flip] [-fast] [-fullscreen]

package main;

#use strict;
use Getopt::Long;
use Data::Dumper;

use SDL;
use SDL::App;
use SDL::Event;
use SDL::Surface;
use SDL::Color;
use SDL::Rect;
use SDL::Console;

use vars qw/ $done $app $app_rect $background $event $sprite $sprite_rect $videoflags /;

## User tweakable settings (via cmd-line)
my %settings = (
	'numsprites'    => 10,
	'screen_width'  => 640,
	'screen_height' => 480,
	'video_bpp'     => 8,
	'fast'          => 0,
	'hw'            => 0,
	'flip'          => 1,
	'fullscreen'    => 0,
	'bpp'           => undef,
);

## Process commandline arguments

sub get_cmd_args
{
  GetOptions("width:i"  => \$settings{screen_width},
	     "height:i" => \$settings{screen_height},
	     "bpp:i"    => \$settings{bpp},
	     "fast!"   => \$settings{fast},
	     "hw!"     => \$settings{hw},
	     "flip!"    => \$settings{flip},
	     "fullscreen!" => \$settings{fullscreen},
	    );
}

## Initialize application options

sub set_app_args
{
  $settings{bpp} ||= 8;  	# default to 8 bits per pix

  $videoflags |= SDL_HWACCEL     if $settings{hw};  
  $videoflags |= SDL_DOUBLEBUF   if $settings{flip};  
  $videoflags |= SDL_FULLSCREEN  if $settings{fullscreen}; 
}

## Setup 

sub  init_game_context
{
  $done = 0;
  $app = new SDL::App (
		       -width => $settings{screen_width}, 
		       -height=> $settings{screen_height}, 
		       -title => "SDL_console test",
		       -icon  => "icon.bmp",
		       -flags => $videoflags,
			);

  $app_rect= new SDL::Rect(
			   -height => $settings{screen_height}, 
			   -width  => $settings{screen_width},
			  );

  $background = $SDL::Color::blue;

  $sprite = new SDL::Surface(-name =>"data/logo.png"); 

  # Set transparent pixel as the pixel at (0,0) 

  $sprite->set_color_key(SDL_SRCCOLORKEY,0,0);	# sets the transparent color to that at (0,0)

  $sprite->display_format();

  $sprite_rect = new SDL::Rect(-x     => 0, 
			       -y     => 0,
			       -width => $sprite->width,
			       -height=> $sprite->height,
			      );
  
  $event = new SDL::Event();
}

## Prints diagnostics

sub instruments
{
  if ( ($app->flags & SDL_HWSURFACE) == SDL_HWSURFACE ) {
    printf("Screen is in video memory\n");
  } else {
    printf("Screen is in system memory\n");
  }

  if ( ($app->flags & SDL_DOUBLEBUF) == SDL_DOUBLEBUF ) {
    printf("Screen has double-buffering enabled\n");
  }

  if ( ($sprite->flags & SDL_HWSURFACE) == SDL_HWSURFACE ) {
    printf("Sprite is in video memory\n");
  } else {
    printf("Sprite is in system memory\n");
  }
  
  # Run a sample blit to trigger blit (if posssible)
  # acceleration before the check just after 
  $sprite->blit(0, $app, 0);  
  
  if ( ($sprite->flags & SDL_HWACCEL) == SDL_HWACCEL ) {
    printf("Sprite blit uses hardware acceleration\n");
  }
  if ( ($sprite->flags & SDL_RLEACCEL) == SDL_RLEACCEL ) {
    printf("Sprite blit uses RLE acceleration\n");
  }
  
}



# a hash containing our command functionality

my %commands = (

"!" => sub 
{
  my $console = shift;  
  my $rawparams= shift;
  my $output = `$rawparams`;
  $console->print($output);
},


"!!" => sub 
{
  my $console = shift;  
  my $rawparams= shift;
  eval $rawparams;
  
  my $output = $@ || "OK";
  $console->print($output);
},

"help" => sub 
{
  my $console = shift;  
  my $rawparams= shift;
  $console->list_commands();
},

"alpha" => sub 
{
  my $console = shift;  
  my $rawparams= shift;
  my @params = @_;
  $console->alpha(@_);
},

"echo" => sub 
{
  my $console = shift;  
  my $rawparams= shift;
  $console->print($rawparams);
},


"background" => sub 
{
  my $console = shift;  
  my $rawparams= shift;
  $console->background(@_);
},

"move" => sub 
{
  my $console = shift;  
  my $rawparams= shift;
  $console->position(@_);
},

"resize" => sub 
{
  my $console = shift;  
  my $rawparams= shift;
  my ($x, $y , $w, $h) = @_;
  my $rect = new SDL::Rect (-x => $x,
			    -y => $y,
			    -width => $w,
			    -height => $h
			   );
  $console->resize($rect);
},

"demo" => sub 
{
  my $console = shift;  
  my $rawparams= shift;
},

"quit" => sub 
{
  $done=1;
},


);





sub init_console
{
  my $console_rect= new SDL::Rect(
				  -width =>$app->width, 
				  -height=>128
				 );
  
  my $console = new SDL::Console(
				 -surface => $app,
				 -rect  => $console_rect,
				 -font  => "data/LargeFont.bmp",
				 -lines => 100,
				);

  # add commands, they are available to all consoles.
  while ( my ($command, $func) = each %commands)
  {
    SDL::Console::AddCommand($command, $func);
  }

  $console->topmost();
  return $console;
}
  


sub game_loop
{
  my $console = init_console();

 FRAME:
  while (not $done) 
  {
    # process event queue
    #$event->pump;
    if ($event->poll)
    {
      my $etype=$event->type;      
      SDL::Console::Event($event);

      # handle quit events
      last FRAME if ($etype eq SDL_QUIT );
      last FRAME if (SDL::GetKeyState(SDLK_ESCAPE));
    }

    $app->flip if $settings{flip};

    # needed for HW surface locking
    #$app->lock() if $app->lockp();  
    # draw..
    #$app->unlock();

    ################################################
    # do some drawing 

    $app->fill($app_rect, $background);

    $console->draw;
    
  }

}



## Main program loop

get_cmd_args();
set_app_args();
init_game_context();
instruments();
game_loop();
exit(0);

