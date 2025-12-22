#	Music.pm
#
#	a SDL_mixer data module
#
#	Copyright (C) 2000,2002 David J. Goehrig

package SDL::Music;
use strict;
use SDL;

sub new {
	my $proto = shift;	
	my $class = ref($proto) || $proto;
	my $self = {};
	my $filename = shift;
	$self->{-data} = SDL::MixLoadMusic($filename);
	bless $self,$class;
	return $self;
}

sub DESTROY {
	my $self = shift;
	SDL::MixFreeMusic($self->{-data});
}

1;

__END__;


