# 
#	Surface.pm
#
#	A package for manipulating SDL_Surface *
#
#	Copyright (C) 2000, 2001, 2002 David J. Goehrig

package SDL::Surface;
use strict;
use SDL;
require SDL::Rect;
require SDL::Palette;
require SDL::Color;

require Exporter;

sub new {
	my $proto = shift;	
	my $class = ref($proto) || $proto;
	my $self = {};
	my %options = @_;

	verify (%options, qw/ -name -n -flags -fl -width -w -height -h -depth -d
				-pitch -p -Rmask -r -Gmask -g -Bmask -b -Amask -a
				-from -f /) if $SDL::DEBUG;
	
	if ( $options{-name} ne "" && exists $SDL::{IMGLoad} ) {		
	   $$self{-surface} = SDL::IMGLoad($options{-name});	
	} else {
		my $f = $options{-flags}  	|| $options{-fl} 	|| SDL::ANYFORMAT();
		my $w = $options{-width} 	|| $options{-w}		|| 1;
		my $h = $options{-height} 	|| $options{-h}		|| 1;	
		my $d = $options{-depth} 	|| $options{-d}		|| 8;
		my $p = $options{-pitch} 	|| $options{-p}		|| $w*$d;              
		my $r = $options{-Rmask} 	|| $options{-r}	
			||  ( SDL::BigEndian() ? 0xff000000 : 0x000000ff );
		my $g = $options{-Gmask} 	|| $options{-g}
			||  ( SDL::BigEndian() ? 0x00ff0000 : 0x0000ff00 );
		my $b = $options{-Bmask} 	|| $options{-b}
			||  ( SDL::BigEndian() ? 0x0000ff00 : 0x00ff0000 );
		my $a = $options{-Amask} 	|| $options{-a}
			||  ( SDL::BigEndian() ? 0x000000ff : 0xff000000 );

		if ( $options{-from}|| $options{-f} ) { 
			my $src = $options{-from}|| $options{-f};
			$$self{-surface} = SDL::CreateRGBSurfaceFrom(
				$src,$w,$h,$d,$p,$r,$g,$b,$a);
		} else {
			$$self{-surface} = SDL::CreateRGBSurface(
				$f,$w,$h,$d,$r,$g,$b,$a);
		}
	}
	die "SDL::Surface::new failed. ", SDL::GetError()
		unless ( $$self{-surface});
	bless $self,$class;
	return $self;
}

sub DESTROY {		
	my $self = shift;	
	SDL::FreeSurface($$self{-surface});	
}

sub flags {
	my $self = shift;
	return SDL::SurfaceFlags($$self{-surface});
}

sub palette {
	my $self = shift;
	return SDL::SurfacePalette($$self{-surface});
}

sub bpp {
	my $self = shift;
	return SDL::SurfaceBitsPerPixel($$self{-surface});
}

sub bytes_per_pixel {
	my $self = shift;
	return SDL::SurfaceBytesPerPixel($$self{-surface});
}

sub Rshift {
	my $self = shift;
	return SDL::SurfaceRshift($$self{-surface});
}

sub Gshift {
	my $self = shift;
	return SDL::SurfaceGshift($$self{-surface});
}

sub Bshift {
	my $self = shift;
	return SDL::SurfaceBshift($$self{-surface});
}

sub Ashift {
	my $self = shift;
	return SDL::SurfaceAshift($$self{-surface});
}

sub Rmask {
	my $self = shift;
	return SDL::SurfaceRmask($$self{-surface});
}

sub Gmask {
	my $self = shift;
	return SDL::SurfaceGmask($$self{-surface});
}

sub Bmask {
	my $self = shift;
	return SDL::SurfaceBmask($$self{-surface});
}

sub Amask {
	my $self = shift;
	return SDL::SurfaceAmask($$self{-surface});
}

sub color_key {
	my $self = shift;
	return SDL::SurfaceColorKey($$self{-surface});
}

sub alpha {
	my $self = shift;
	return SDL::SurfaceAlpha($$self{-surface});
}

sub width {
	my $self = shift;
	return SDL::SurfaceW($$self{-surface});
}

sub height {
	my $self = shift;
	return SDL::SurfaceH($$self{-surface});
}

sub pitch {
	my $self = shift;
	return SDL::SurfacePitch($$self{-surface});
}

sub pixels {
	my $self = shift;
	return SDL::SurfacePixels($$self{-surface});
}

sub pixel {
	my ($self,$x,$y,$color) = @_;
	if ($color) {
		$color = $$color{-color} if (ref($color) && $color->isa('SDL::Color'));
		return SDL::SurfacePixel($$self{-surface},$x,$y,$color);
	} else {
		return SDL::SurfacePixel($$self{-surface},$x,$y);
	}
}

sub fill {
	my ($self,$rect,$color) = @_;
	$rect = $$rect{-rect} if (ref($rect) && $rect->isa("SDL::Rect"));
	$color = $$color{-color} if (ref($color) && $color->isa("SDL::Color"));
	return SDL::FillRect($$self{-surface},$rect,$color);
}

sub lockp {
	my $self = shift;
	return SDL::MUSTLOCK($$self{-surface});
}

sub lock {
	my $self = shift;
	return SDL::SurfaceLock($$self{-surface});
}

sub unlock {
	my $self = shift;
	return SDL::SurfaceUnlock($$self{-surface});
}

sub update {
	my ($self,@rects) = @_;
	my @rect_ptrs;
	for (@rects) { 
		push @rect_ptrs, (ref($_) &&  $_->isa("SDL::Rect") ? $$_{-rect} : $_ );
	}
	SDL::UpdateRects($$self{-surface}, @rect_ptrs );
}

sub flip {
	my $self = shift;
	SDL::Flip($$self{-surface});
}

sub blit {
	my ($self,$srect,$dest,$drect) = @_;
	$srect = $$srect{-rect} if (ref($srect) && $srect->isa("SDL::Rect"));
	$drect = $$drect{-rect} if (ref($drect) && $drect->isa( "SDL::Rect"));
	$dest = $$dest{-surface} if (ref($dest) && $dest->isa("SDL::Surface"));
	return SDL::BlitSurface($$self{-surface},$srect,$dest,$drect);
}

sub set_colors {
	my ($self,$start,@colors) = @_;
	my (@color_ptrs);
	for (@colors) {
		push @color_ptrs, (ref($_) && $_->isa("SDL::Color") ? $$_{-color} : $_ );
	}
	return SDL::SetColors($$self{-surface},$start,@color_ptrs);
}

sub set_color_key {
	my $self = shift;
	my $flag = shift;
	my $pixel;
	if (@_ == 1) {
		$pixel = shift;
		$pixel = $pixel->pixel($$self{-surface}) 
			if (ref($pixel) && $pixel->isa("SDL::Color"));
	} else {
		$pixel = $self->pixel(@_);
	}	
	return SDL::SetColorKey($$self{-surface},$flag,$pixel);
}

sub set_alpha {
	my ($self,$flag,$alpha) = @_;
	return SDL::SetAlpha($$self{-surface},$flag,$alpha);
}

sub display_format {
	my $self = shift;
	my $tmp = SDL::DisplayFormat ($$self{-surface});
	SDL::FreeSurface ($$self{-surface});
	$$self{-surface} = $tmp;
	return $self;
}

sub rgb {
	my $self = shift;
	my $tmp = SDL::ConvertRGB($$self{-surface});
	SDL::FreeSurface($$self{-surface});
	$$self{-surface} = $tmp;
	return $self;
}

sub rgba {
	my $self = shift;
	my $tmp = SDL::ConvertRGBA($$self{-surface});
	SDL::FreeSurface($$self{-surface});
	$$self{-surface} = $tmp;
	return $self;
}

sub print {
	my ($self,$x,$y,@text) = @_;
	SDL::PutString( $$self{-surface}, $x, $y, join('',@text));
}

sub save_bmp {
	my ($self,$filename) = @_;
	return SDL::SaveBMP( $$self{-surface}, $filename);
}

sub video_info {
	my $self = shift;
	return SDL::VideoInfo();
}

1;

__END__;

=head1 NAME

SDL::Surface - a SDL perl extension

=head1 SYNOPSIS

  use SDL::Surface;
  $image = new SDL::Surface(-name=>"yomama.jpg");

=head1 DESCRIPTION

The C<SDL::Surface> module encapsulates the SDL_Surface* structure, and
many of its ancillatory functions.  Not only is it a workhorse of the
OO Layer, it is the base class for the C<SDL::App> class.  

=head2 new (-name => 'foo.png')

The C<SDL::Surface> class can be instantiated in a number of different ways.
If support for the SDL_image library was included when SDL_perl was compiled,
the easiest way to create a new surface is to use the C<SDL::Surface::new>
method with the C<-name> option.  This will load the image from the file 
and return an object encapsulating the SDL_Surface*.

=head2 new (-from => $buffer, ... )

If the contents of the new Surface is already in memory, C<SDL::Surface::new>
may be called with the C<-from> option to create an image from that section
of memory.  This method takes the following additional parameters:

=over 4

=item *

-width		the width of the image in pixels

=item *

-height 		the height of the image in pixels

=item *

-depth		the number of bits per pixel

=item *

-pitch		the number of bytes per line

=item *

-Rmask		an optional bitmask for red

=item *

-Gmask		an optional bitmask for green

=item *

-Bmask		an optional bitmask for green

=item *

-Amask		an optional bitmask for alpha

=back

=head2 new ( -flags => SDL_SWSURFACE, ... )

Finally, C<SDL::Suface::new> may be invoked with the C<-flags> option, in a
similar fashion to the C<-from> directive.  This invocation takes the same
additional options as C<-from> with the exception of C<-pitch> which is ignored.
This method returns a new, blank, SDL::Surface option with any of the following
flags turned on:

=over 4

=item *

SWSURFACE()	a non-accelerated surface

=item *

HWSURFACE()	a hardware accelerated surface 

=item *

SRCCOLORKEY()	a surface with a transperant color	

=item *

SRCALPHA()	an alpha blended, translucent surface 

=back

=head2 flags ()

C<SDL::Surface::flags> returns the flags with which the surface was initialized.

=head2 palette ()

C<SDL::Surface::palette> currently returns a SDL_Palette*, this may change in
future revisions.

=head2 bpp ()

C<SDL::Surface::bpp> returns the bits per pixel of the surface

=head2 bytes_per_pixel ()

C<SDL::Surface::bytes_per_pixel> returns the bytes per pixel of the surface

=head2 Rshift ()

C<SDL::Surface::Rshift> returns the bit index of the red field for the surface's pixel format

=head2 Gshift ()

C<SDL::Surface::Gshift> returns the bit index of the green field for the surface's pixel format

=head2 Bshift ()

C<SDL::Surface::Bshift> returns the bit index of the blue field for the surface's pixel format

=head2 Ashift ()

C<SDL::Surface::Ashift> returns the bit index of the alpha field for the surface's pixel format

=head2 Rmask ()

C<SDL::Surface::Rmask> returns the bit mask for the red field for teh surface's pixel format

=head2 Gmask ()

C<SDL::Surface::Gmask> returns the bit mask for the green field for teh surface's pixel format

=head2 Bmask ()

C<SDL::Surface::Bmask> returns the bit mask for the blue field for teh surface's pixel format

=head2 Amask ()

C<SDL::Surface::Amask> returns the bit mask for the alpha field for teh surface's pixel format

=head2 color_key ()

C<SDL::Surface::color_key> returns the current color key for the image, which can be set with
the C<SDL::Surface::set_color_key> method.

=head2 alpha ()

C<SDL::Surface::alpha> returns the current alpha value for the image, which can be set with
the C<SDL::Surface::set_alpha> method.

=head2 width ()

C<SDL::Surface::width> returns the width in pixels of the surface

=head2 height ()

C<SDL::Surface::height> returns the height in pixels of the surface

=head2 pitch ()

C<SDL::Surface::pitch> returns the width of a surface's scanline in bytes

=head2 pixels ()

C<SDL::Surface::pixels> returns a Uint8* to the image's pixel data.  This is not
inherently useful within perl, though may be used to pass image data to user provided
C functions.

=head2 pixel (x,y,[color])

C<SDL::Surface::pixel> will set the color value of the pixel at (x,y) to the given
color if provided.  C<SDL::Surface::pixel> returns a SDL::Color object for the 
color value of the pixel at (x,y) after any possible modifications.

=head2 fill (rect,color)

C<SDL::Surface::fill> will fill the given SDL::Rect rectangle with the specified SDL::Color
This function optionally takes a SDL_Rect* and a SDL_Color*

=head2 lockp ()

C<SDL::Surface::lockp> returns true if the surface must be locked

=head2 lock ()

C<SDL::Surface::lock> places a hardware lock if necessary, preventing access to 
the surface's memory

=head2 unlock ()

C<SDL::Surface::unlock> removes any hardware locks, enabling blits

=head2 update ( rects...)

C<SDL::Surface::update> takes one or more SDL::Rect's which determine which sections
of the image are to be updated.  This option is only useful on the appliaction surface.

=head2 flip ()

C<SDL::Surface::flip> updates the full surface, using a double buffer if available

=head2 blit (srect,dest,drect)

C<SDL::Surface::blit> blits the current surface onto the destination surface,
according to the provided rectangles.  If a rectangle is 0, then the full surface is used.

=head2 set_colors (start,colors...) 

C<SDL::Surface::set_colors> updates the palette starting at index C<start> with the
supplied colors.  The colors may either be SDL::Color objects or SDL_Color* from the
low level C-style API.

=head2 set_color_key (flag,pixel) or (flag,x,y)

C<SDL::Surface::set_color_key> sets the blit flag, usually SDL_SRCCOLORKEY, 
for either the supplied pixel, or for the value of the pixel at (x,y) in the image.
A SDL::Color object may be passed for the pixel value.

=head2 set_alpha (flag,alpha)

C<SDL::Surface::set_alpha> sets the opacity of the image for alpha blits. 
C<alpha> takes a value from 0x00 to 0xff.

=head2 display_format ()

C<SDL::Surface::display_format> converts the surface to the same format as the
current screen.

=head2 rgb ()
C<SDL::Surface::rgb> converts the surface to a 24 bit rgb format regardless of the 
initial format.

=head2 rgba ()
C<SDL::Surface::rgba> converts the surface to a 32 bit rgba format regarless of the
initial format.

=head2 print (x,y,text...)

C<SDL::Surface::print> renders the text using the current font onto the image.
This option is only supported for with SDL_image and SFont.

=head2 save_bmp (filename)

C<SDL::Surface::save_bmp> saves the surface to filename in Windows BMP format.

=head2 video_info ()

C<SDL::Surface::video_info> returns a hash describing the current state of the 
video hardware.

=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

	perl(1) SDL::Rect(3) SDL::Font(3) SDL::App(3).

=cut

