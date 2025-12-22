#
#	Sound.pm
#
#	a SDL_mixer data module
#
#	Copyright (C) 2000,2002 David J. Goehrig

package SDL::Sound;
use strict;
use SDL;

sub new {
	my $proto = shift;	
	my $class = ref($proto) || $proto;
	my $self = {};
	my $filename = shift;
	$self->{-data} = SDL::MixLoadWAV($filename);
	bless $self,$class;
	return $self;
}

sub DESTROY {
	my $self = shift;
	SDL::MixFreeChunk($self->{-data});
}

sub volume {
	my $self = shift;
	my $volume = shift;
	return SDL::MixVolumeChunk($self->{-data},$volume);
}

1;

__END__;


