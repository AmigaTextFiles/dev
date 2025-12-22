#!/usr/bin/env perl

use SDL::App;
use SDL::Event;
use SDL::Shell;

my $app = new SDL::App -t => $0, -w => 1200, -h => 600, -d => 24;
my $rect = new SDL::Rect -w => 1200, -h => 600;
my $con = new SDL::Shell -surface => $app, -rect => $rect, 
		-font => "data/LargeFont.bmp", -lines => 100;
my $event = new SDL::Event;

$con->topmost();

for (;;) {
	if ($event->poll) {
		$con->process($event);
	}
	$app->sync();
	$con->draw();
}
