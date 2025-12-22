#
#	Rect.pm
#
#	A package for manipulating SDL_Rect *
#
#	Copyright (C) 2000,2001,2002 David J. Goehrig

package SDL::Rect;
use strict;
use SDL;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	my %options = @_;

	verify (%options, qw/ -x -y -width -height -w -h / ) if $SDL::DEBUG;

	my $x = $options{-x} 		|| 0;
	my $y = $options{-y} 		|| 0;
	my $w = $options{-width}	|| $options{-w}		|| 0;
	my $h = $options{-height}	|| $options{-h}		|| 0;
	$self->{-rect} = SDL::NewRect($x,$y,$w,$h);
	bless $self,$class;
	return $self;
}

sub DESTROY {
	my $self = shift;
	SDL::FreeRect($self->{-rect});
}

sub x {
	my $self = shift;
	return SDL::RectX($self->{-rect},@_);
}

sub y {
	my $self = shift;
	return SDL::RectY($self->{-rect},@_);
}

sub width {
	my $self = shift;
	return SDL::RectW($self->{-rect},@_);
}

sub height {
	my $self = shift;
	return SDL::RectH($self->{-rect},@_);
}

1;

__END__;

=head1 NAME

SDL::Rect - a SDL perl extension

=head1 SYNOPSIS

  $rect = new SDL::Rect ( -height => 4, -width => 40 );

=head1 DESCRIPTION


	SDL::Rect->new(...); creates a SDL_Rect structure which is
used for specifying regions for filling, blitting, and updating.
These objects make it easy to cut and backfill.

By default, x, y = 0, and h, w default to 0. (the default
scratch sizes);

=head2 Rect fields

	The four fields of a rectangle can be set simply
by passing a value to the applicable method.  These are:

	$rect->x(4);		# sets x to 4
	$rect->y();		# reads y
	$rect->width(49);	# sets width to 49
	$rect->height();	# reads height

=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

perl(1) SDL::Surface(3)

=cut

