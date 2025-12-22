#!/usr/bin/env perl

use SDL;
use SDL::App;
use SDL::Event;
use SDL::OpenGL;
use SDL::OpenGL::Cube;

die "Usage: $0 delay\n Hold the space key for a white cube\n" unless (defined $ARGV[0]);
$delay = $ARGV[0];

print "Starting $0\n";

my $app = new SDL::App	-w => 800, -h => 600, -d => 16, -gl =>1;

print "Initializing OpenGL settings\n";
printf "%-24s%s\n", "GL_RED_SIZE ", $app->attribute( SDL::GL_RED_SIZE() );
printf "%-24s%s\n", "GL_GREEN_SIZE ", $app->attribute( SDL::GL_GREEN_SIZE());
printf "%-24s%s\n", "GL_BLUE_SIZE ", $app->attribute( SDL::GL_BLUE_SIZE() );
printf "%-24s%s\n", "GL_DEPTH_SIZE ", $app->attribute( SDL::GL_DEPTH_SIZE() );
printf "%-24s%s\n", "GL_DOUBLEBUFFER ", $app->attribute( SDL::GL_DOUBLEBUFFER() );

$angle = 0;	
$other = 0;
	
my @colors =  (
	1.0,1.0,0.0,	1.0,0.0,0.0,	0.0,1.0,0.0, 0.0,0.0,1.0,	#back
	0.4,0.4,0.4,	0.3,0.3,0.3,	0.2,0.2,0.2, 0.1,0.1,0.1 );	#front
	

$cube = new SDL::OpenGL::Cube;
$cube->color(@colors);

$white = new SDL::OpenGL::Cube;

$toggle = 1;

glEnable(GL_CULL_FACE);
glFrontFace(GL_CCW);
glCullFace(GL_BACK);

sub DrawScene {

	glClear( GL_DEPTH_BUFFER_BIT() 
		| GL_COLOR_BUFFER_BIT());

	glLoadIdentity();

	glTranslate(0,0,-6.0);
	glRotate($angle % 360,1,1,0);
	glRotate($other % 360,0,1,1);

	$angle += 6;
	$other += $angle % 5;

	glColor(1,1,1);
	$toggle ? $cube->draw() : $white->draw();

	$app->sync();

}

sub InitView {
	glViewport(0,0,800,600);

	glMatrixMode(GL_PROJECTION());
	glLoadIdentity();

	if ( @_ ) {
		glPerspective(45.0,4/3,0.1,100.0);
	} else {
		glFrustum(-0.1,0.1,-0.075,0.075,0.3,100.0);
	}

	glMatrixMode(GL_MODELVIEW());
	glLoadIdentity();
}

InitView();

DrawScene();
$app->sync();

my $event = new SDL::Event;

for (;;) {
	for (0 .. 5) {
			$event->pump();	
			$event->poll();
			exit(0) if ($event->type() == SDL_QUIT());	
			if (SDL::GetKeyState(SDLK_SPACE()) == SDL_PRESSED()) {
				$toggle = 0;
			} else {
				$toggle = 1;
			}
			$app->delay($delay);
		}
	DrawScene();
}

