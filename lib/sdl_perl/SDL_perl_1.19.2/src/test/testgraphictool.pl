#!/usr/bin/env perl

use strict;
use warnings;

use SDL;
use SDL::App;
use SDL::GraphicTool;


my $app = new SDL::App(-title	=> "GraphicTool Test",
		       -width	=> 640,
		       -height	=> 480,
		       -depth	=> 16,
		       -fullscreen => 0);
my $app_rect = new SDL::Rect(	-x=>0,
				-y=>0,
				-width=>$app->width,
				-height=>$app->height);

my $sprite = new SDL::Surface(-name => "data/logo.png");
$sprite->set_color_key(SDL_SRCCOLORKEY, 0, 0);
$sprite->display_format();

#Test Zoom
my $graphicTool = new SDL::GraphicTool();
$graphicTool->zoom($sprite, .5, .5, 1);

my $sprite_rect = new SDL::Rect(	-x=>0,
				-y=>0,
				-width=>$sprite->width,
				-height=>$sprite->height);
$sprite->blit($sprite_rect, $app, $sprite_rect);
$app->flip();
sleep 4;
$app->fill($app_rect, $SDL::Color::black);


#Test Rotate
$graphicTool->rotoZoom($sprite, 90, 1, 1);

$sprite_rect = new SDL::Rect(	-x=>0,
				-y=>0,
				-width=>$sprite->width,
				-height=>$sprite->height);
$sprite->blit($sprite_rect, $app, $sprite_rect);
$app->flip();
sleep 4;



