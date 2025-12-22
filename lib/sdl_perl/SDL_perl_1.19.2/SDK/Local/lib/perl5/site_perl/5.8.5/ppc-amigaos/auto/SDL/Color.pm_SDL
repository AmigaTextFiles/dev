#	Color.pm
#
#	A package for manipulating SDL_Color *
#
#	Copyright (C) 2002 David J. Goehrig

package SDL::Color;
use strict;
use SDL;

use vars qw/ $white $black $red $green $blue  /;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	my (%options) = @_;

	verify (%options, qw/ -color -surface -pixel -r -g -b /) if ($SDL::DEBUG);

	if ($options{-color}) {
		$self->{-color} = $options{-color};	
		$self->{-r} = SDL::ColorR($$self{-color});
		$self->{-g} = SDL::ColorG($$self{-color});
		$self->{-b} = SDL::ColorB($$self{-color});
	} elsif ($options{-pixel} && $options{-surface}) {
		$options{-surface} = $options{-surface}{-surface} 
			if ( ref($options{-surface}) && $options{-surface}->isa("SDL::Surface"));
		($self->{-r},$self->{-g},$self->{-b}) = SDL::GetRGB($options{-surface},
								$options{-pixel});
		$self->{-color} = SDL::NewColor($self->{-r},$self->{-g},$self->{-b});
	} else {
		$self->{-r} = $options{-red}	|| $options{-r} || 0;
		$self->{-g} = $options{-green}	|| $options{-g} || 0;
		$self->{-b} = $options{-blue}	|| $options{-b} || 0;
		$self->{-color} = SDL::NewColor($self->{-r},$self->{-g},$self->{-b});
	} 
	die "Could not create color, ", SDL::GetError(), "\n"
		unless ($self->{-color});
	bless $self,$class;
	return $self;
}

sub DESTROY {
	my $self = shift;
	SDL::FreeColor($self->{-color});
}

sub r {
	my $self = shift;
	return SDL::ColorR($self->{-color},@_);	
}

sub g {
	my $self = shift;
	return SDL::ColorG($self->{-color},@_);
}

sub b {
	my $self = shift;
	return SDL::ColorB($self->{-color},@_);
}

sub pixel {
	my ($self,$surface) = @_;
	$surface = $$surface{-surface} if (ref($surface) && $surface->isa("SDL::Surface"));
	return SDL::MapRGB($surface,$self->{-r},$self->{-g},$self->{-b});
}

$white = new SDL::Color -r => 0xff, -g => 0xff, -b => 0xff;
$black = new SDL::Color -r => 0x0, -g => 0x0, -b => 0x0;
$red = new SDL::Color -r => 0xff, -g => 0x0, -b => 0x0;
$green = new SDL::Color -r => 0x0, -g => 0xff, -b => 0x0;
$blue = new SDL::Color -r => 0x0, -g => 0x0, -b => 0xff;


1;

__END__;

=head1 NAME

SDL::Color - a SDL perl extension

=head1 SYNOPSIS

  $color = new SDL::Color ( -r => 0xde, -g => 0xad, -b =>c0 );
  $color = new SDL::Color -surface => $app, -pixel => $app->pixel($x,$y);
  $color = new SDL::Color -color => SDL::NewColor(0xff,0xaa,0xdd);

=head1 DESCRIPTION

C<SDL::Color> is a wrapper for display format independent color
representations. 

=head2 new ( -color =>  )

C<SDL::Color::new> with the C<-color> option allows one to create
a new color object from a pre-existing SDL_Color*.  This constructor
will set the internal color state to mirror that of the specified color.
This object will deallocate the color object upon completion.  This is
not suitable for color that exist as part of another object.

=head2 new ( -r => 0xff, -g => 0xff, -b => 0xff )

C<SDL::Color::new> with the C<-r,-g,-b> options will populate a new
color object with the corresponding composite values.

=head2 new ( -surface => , -pixel => )

C<SDL::Color::new> with a SDL::Surface and a Uint32 pixel value can also
be used to generate SDL::Color objects.  Like as with the C<-color> option
C<-surface,-pixel> will set the internal state to reflect the color values
given the SDL::Surface's palette and color format.

=head2 r ( [ red ] )

C<SDL::Color::r> sets and fetches the red component of the color object

=head2 g ( [ green ] )

C<SDL::Color::g> sets and fetches the green component of the color object

=head2 b ( [ blue ] )

C<SDL::Color::b> sets and fetches the blue component of the color object

=head2 pixel ()

C<SDL::Color::pixel> returns the Uint32 color value of the given color
in the format of the provided surface.

=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

perl(1) SDL::Surface(3) SDL::TTFont(3)

=cut

