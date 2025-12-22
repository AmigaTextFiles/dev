#
#	Palette.pm
#
#	a module for manipulating SDL_Palette *
#
#	Copyright (C) 2000,2002 David J. Goehrig

package SDL::Palette;
use strict;
use SDL;

# NB: there is no palette destructor because most of the time the 
# palette will be owned by a surface, so any palettes you create 
# with new, won't be destroyed until the program ends!

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	my $image;
	if (@_) { 
		$image = shift;
		$self->{-palette} = $image->palette(); 
	} else { $self->{-palette} = SDL::NewPalette(256); }
	bless $self, $class;
	return $self;
}

sub size {
	my $self = shift;
	return SDL::PaletteNColors($self->{-palette});
}

sub color {
	my $self = shift;
	my $index = shift;
	my ($r,$g,$b);
	if (@_) { 
		$r = shift; $g = shift; $b = shift; 
		return SDL::PaletteColors($self->{-palette},$index,$r,$g,$b);
	} else {
		return SDL::PaletteColors($self->{-palette},$index);
	}
}

sub red {
	my $self = shift;
	my $index = shift;
	my $c;
	if (@_) {
		$c = shift;
		return SDL::ColorR(
			SDL::PaletteColors($self->{-palette},$index),$c);
	} else {	
		return SDL::ColorR(
			SDL::PaletteColors($self->{-palette},$index));
	}
}

sub green {
	my $self = shift;
	my $index = shift;
	my $c;
	if (@_) {
		$c = shift;
		return SDL::ColorG(
			SDL::PaletteColors($self->{-palette},$index),$c);
	} else {	
		return SDL::ColorG(
			SDL::PaletteColors($self->{-palette},$index));
	}
}

sub blue {
	my $self = shift;
	my $index = shift;
	my $c;
	if (@_) {
		$c = shift;
		return SDL::ColorB(
			SDL::PaletteColors($self->{-palette},$index),$c);
	} else {	
		return SDL::ColorB(
			SDL::PaletteColors($self->{-palette},$index));
	}
}


1;
