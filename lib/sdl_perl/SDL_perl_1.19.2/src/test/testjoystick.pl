#!/usr/bin/env perl
#
#
# testjoystick.pl
#
#	adapted from SDL-1.2.x/test/testjoystick.c

use strict;
#use warnings;

use SDL;
use SDL::App;
use SDL::Rect;
use SDL::Event;


sub WatchJoystick($){
	(my $joystick) = @_;
	my $screenWidth = 640;
	my $screenHeight = 480;

	my $app = new SDL::App(-title => "Joystick Test",
			       -width => $screenWidth,
			       -height => $screenHeight,
			       -depth=> 16 );
	#Print information about the joystick we are watching
	my $name = SDL::JoystickName(SDL::JoystickIndex($joystick));
	print "Watching joystick ".SDL::JoystickIndex($joystick).
	      ": (".($name ? $name : "Unknown Joystick" ).")\n";
	print "Joystick has ".SDL::JoystickNumAxes($joystick)." axes, ".
	      SDL::JoystickNumHats($joystick)." hats, ".
	      SDL::JoystickNumBalls($joystick)." balls, and ".
	      SDL::JoystickNumButtons($joystick)." buttons\n";
	
	my $event = new SDL::Event;
	my $done = 0;	
	my $colorWhite = SDL::MapRGB($app->{-surface},255,255,255);
	my $colorBlack = SDL::MapRGB($app->{-surface},0,0,0);
	my $axisRect = 0;

	while(!$done){
		while($event->poll()){
			if($event->type() eq SDL::JOYAXISMOTION()){
				print "Joystick ".SDL::JoyAxisEventWhich($event->{-event}).
				      " axis ".SDL::JoyAxisEventAxis($event->{-event}).
				      " value: ".SDL::JoyAxisEventValue($event->{-event})."\n";
			} elsif($event->type() eq SDL::JOYHATMOTION()){
				print "Joystick ".SDL::JoyHatEventWhich($event->{-event}).
				      " hat ".SDL::JoyHatEventHat($event->{-event});
				if(SDL::JoyHatEventValue($event->{-event}) == SDL::HAT_CENTERED() ){
					print " centered";
				} elsif(SDL::JoyHatEventValue($event->{-event}) == SDL::HAT_UP() ) { 
					print " up";
				} elsif(SDL::JoyHatEventValue($event->{-event}) == SDL::HAT_RIGHT() ) {
					print " right";
				} elsif(SDL::JoyHatEventValue($event->{-event}) == SDL::HAT_DOWN() ) {
					print " down";
				} elsif(SDL::JoyHatEventValue($event->{-event}) == SDL::HAT_LEFT()) {
					print " left";
				} elsif(SDL::JoyHatEventValue($event->{-event}) == SDL::HAT_RIGHTUP() ) { 
					print " right & up";
				} elsif(SDL::JoyHatEventValue($event->{-event}) == SDL::HAT_RIGHTDOWN() ) {
					print " right & down";
				} elsif(SDL::JoyHatEventValue($event->{-event}) == SDL::HAT_LEFTDOWN() ) {
					print " left & down";
				} elsif(SDL::JoyHatEventValue($event->{-event}) == SDL::HAT_LEFTUP()) {
					print " left & up";
				}
				print "\n";
			} elsif($event->type() eq SDL::JOYBALLMOTION()){
				print "Joystick ".SDL::JoyBallEventWhich($event->{-event}).
				      " ball ".SDL::JoyBallEventBall($event->{-event}).
				      " delta: (".SDL::JoyBallEventXrel($event->{-event}).
				      ",".SDL::JoyBallEventYrel($event->{-event})."\n";
			} elsif($event->type() eq SDL::JOYBUTTONDOWN()){
				print "Joystick ".SDL::JoyButtonEventWhich($event->{-event}).
				      " button ".SDL::JoyButtonEventButton($event->{-event})." down\n";
			} elsif($event->type() eq SDL::JOYBUTTONUP()){
				print "Joystick ".SDL::JoyButtonEventWhich($event->{-event}).
				      " button ".SDL::JoyButtonEventButton($event->{-event})." up\n";
			} elsif($event->type() eq SDL_QUIT() or 
			        ($event->type() eq SDL_KEYDOWN() and 
				 $event->key_sym() == SDLK_ESCAPE)){
				$done = 1;
			}

			#Update visual joystick state
			for(my $i =0; $i < SDL::JoystickNumButtons($joystick); $i++){
				my $rect = new SDL::Rect( -width => 32,
					 		  -height => 32,
							  -x => $i*34,
							  -y => $screenHeight-34); 
				if(SDL::JoystickGetButton($joystick, $i) eq SDL::PRESSED()){
					$app->fill($rect, $colorWhite); 
				} else {
					$app->fill($rect, $colorBlack); 
				}
				$app->update($rect);
			}

			#Remove previous axis box
			if($axisRect){
				$app->fill($axisRect, $colorBlack);
				$app->update($axisRect);
			}
		
			# Draw the X/Y axis
			my $x = SDL::JoystickGetAxis($joystick, 0)+32768;
			$x *= $screenWidth;
			$x /= 65535;
			if( $x < 0) {
				$x=0;
			} elsif ( $x > ($screenWidth-16) ){
				$x = $screenWidth-16;
			}
			my $y = SDL::JoystickGetAxis($joystick, 1)+32768;
			$y *= $screenHeight;
			$y /= 65535;
			if( $y < 0) {
				$y=0;
			} elsif ( $y > ($screenHeight-16) ){
				$y = $screenHeight-16;
			}
			$axisRect = new SDL::Rect( -width=> 16,
					      -height=> 16,
					      -x => $x,
					      -y => $y);
			$app->fill($axisRect, $colorWhite);
			$app->update($axisRect);
		}
	
	}

}

die "Could not initialize SDL: ", SDL::GetError()
	if( 0 > SDL::Init(SDL::INIT_JOYSTICK()));

printf "There are %d joysticks attched\n", SDL::NumJoysticks();
for(my $i = 0; $i < SDL::NumJoysticks(); $i++){
	my $name = SDL::JoystickName($i);
	print "Joystick ".$i.": ".($name ? $name : "Unknown Joystick")."\n"; 
}

if ( $ARGV[0] ne undef){
	my $joystick = SDL::JoystickOpen($ARGV[0]);
	if(!$joystick){
		print "Couldn't open joystick ".$ARGV[0].": ".SDL::GetError()."\n";
	} else {
		WatchJoystick($joystick);
		SDL::JoystickClose($joystick);
	}
	SDL::QuitSubSystem(SDL::INIT_JOYSTICK());
}
