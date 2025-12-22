#	App.pm
#
#	The application object, sort of like a surface
#
#	Copyright (C) 2000,2002 David J. Goehrig

package SDL::App;
use strict;
use vars qw(@ISA);

use SDL;
use SDL::Surface;
use SDL::Event;

@ISA = qw(SDL::Surface Exporter);


BEGIN {
	use Exporter();
	use vars qw(@EXPORT);
	@EXPORT = qw(&SDL_SWSURFACE &SDL_HWSURFACE &SDL_ANYFORMAT 
		     &SDL_HWPALETTE &SDL_DOUBLEBUF &SDL_FULLSCREEN
		     &SDL_TEXTWIDTH &SDL_RESIZABLE &SDL_HWACCEL	
		     &SDL_SRCCOLORKEY &SDL_RLEACCELOK &SDL_RLEACCEL	
		     &SDL_SRCALPHA &SDL_ASYNCBLIT &SDL_GRAB_QUERY
		     &SDL_GRAB_ON &SDL_GRAB_OFF &SDL_OPENGL
		    );
}

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my %options = @_;

	verify (%options, qw/	-opengl -gl -fullscreen -full
				-title -t -icon_title -it -icon -i 
				-width -w -height -h -depth -d -flags -f 
				-red_size -r -blue_size -b -green_size -g -alpha_size -a
				-red_accum_size -ras -blue_accum_size -bas 
				-green_accum_sizee -gas -alpha_accum_size -aas
				-double_buffer -db -buffer_size -bs -stencil_size -st
		/ ) if ($SDL::DEBUG);

	SDL::Init(SDL::INIT_EVERYTHING());
	
	my $self = {};

	my $t = $options{-title} 	|| $options{-t} 	|| $0;
	my $it = $options{-icon_title} 	|| $options{-it} 	|| $t;
	my $ic = $options{-icon} 	|| $options{-i}		|| "";
	my $w = $options{-width} 	|| $options{-w}		|| 800;
	my $h = $options{-height} 	|| $options{-h}		|| 600;
	my $d = $options{-depth} 	|| $options{-d}		|| 16;
	my $f = $options{-flags} 	|| $options{-f}		|| SDL::ANYFORMAT();
	my $r = $options{-red_size}	|| $options{-r}		|| 5;
	my $g = $options{-green_size}	|| $options{-g}		|| 5;
	my $b = $options{-blue_size}	|| $options{-b}		|| 5;
	my $a = $options{-alpha_size}	|| $options{-a}		|| 0;
	my $ras = $options{-red_accum_size}	|| $options{-ras}		|| 0;
	my $gas = $options{-green_accum_size}	|| $options{-gas}		|| 0;
	my $bas = $options{-blue_accum_size}	|| $options{-bas}		|| 0;
	my $aas = $options{-alpha_accum_size}	|| $options{-aas}		|| 0;
	my $db = $options{-double_buffer} 	|| $options{-db}		|| 1; 
	my $bs = $options{-buffer_size}		|| $options{-bs}		|| 0;
	my $st	= $options{-stencil_size}	|| $options{-st}		|| 0;

	$f |= SDL_OPENGL() if ($options{-gl} || $options{-opengl});
	$f |= SDL_FULLSCREEN() if ($options{-fullscreen} || $options{-full});

	if ($f & SDL_OPENGL()) { 
		$$self{-opengl} = 1; 

		SDL::GLSetAttribute(SDL::GL_RED_SIZE(),$r) if ($r);	
		SDL::GLSetAttribute(SDL::GL_GREEN_SIZE(),$g) if ($g);	
		SDL::GLSetAttribute(SDL::GL_BLUE_SIZE(),$b) if ($b);	
		SDL::GLSetAttribute(SDL::GL_ALPHA_SIZE(),$a) if ($a);	

		SDL::GLSetAttribute(SDL::GL_RED_ACCUM_SIZE(),$ras) if ($ras);	
		SDL::GLSetAttribute(SDL::GL_GREEN_ACCUM_SIZE(),$gas) if ($gas);	
		SDL::GLSetAttribute(SDL::GL_BLUE_ACCUM_SIZE(),$bas) if ($bas);	
		SDL::GLSetAttribute(SDL::GL_ALPHA_ACCUM_SIZE(),$aas) if ($aas);	
		
		SDL::GLSetAttribute(SDL::GL_DOUBLEBUFFER(),$db) if ($db);
		SDL::GLSetAttribute(SDL::GL_BUFFER_SIZE(),$bs) if ($bs);
		SDL::GLSetAttribute(SDL::GL_DEPTH_SIZE(),$d);
	}

	($$self{-surface} = SDL::SetVideoMode($w,$h,$d,$f)) 
		or die SDL::GetError();
	
	if ($ic and -e $ic) {
	   my $icon = new SDL::Surface -name => $ic;
	   SDL::WMSetIcon($$icon{-surface});	   
	}

	SDL::WMSetCaption($t,$it);
	
	bless $self,$class;
	return $self;
}	

sub title ($;$) {
	my $self = shift;
	my ($title,$icon);
	if (@_) { 
		$title = shift; 
		$icon = shift || $title;
		SDL::WMSetCaption($title,$icon);
	}
	return SDL::WMGetCaption();
}

sub delay ($$) {
	my $self = shift;
	my $delay = shift;
	SDL::Delay($delay);
}

sub ticks {
	return SDL::GetTicks();
}

sub error {
	return SDL::GetError();
}

sub warp ($$$) {
	my $self = shift;
	SDL::WarpMouse(@_);
}

sub fullscreen ($) {
	my $self = shift;
	SDL::WMToggleFullScreen($self->{-surface});
}

sub iconify ($) {
	my $self = shift;
	SDL::WMIconifyWindow();
}

sub grab_input ($$) {
	my ($self,$mode) = @_;
	SDL::WMGrabInput($mode);
}

sub loop ($$) {
	my ($self,$href) = @_;
	my $event = new SDL::Event;
	while ( $event->wait() ) {
		if ( ref($$href{$event->type()}) eq "CODE" ) {
			&{$$href{$event->type()}}($event);
			$self->sync();
		}
	}
}

sub sync ($) {
	my $self = shift;
	if ($self->{-opengl}) {
		SDL::GLSwapBuffers()
	} else {
		$self->flip();
	}
}

sub attribute ($$;$) {
	my ($self,$mode,$value) = @_;
	return undef unless ($self->{-opengl});
	if (defined $value) {
		SDL::GLSetAttribute($mode,$value);
	}
	my $returns = SDL::GLGetAttribute($mode);	
	die "SDL::App::attribute failed to get GL attribute" if ($$returns[0] < 0);
	$$returns[1];	
}

sub SDL_SWSURFACE {
	return SDL::SWSURFACE;
}

sub SDL_HWSURFACE {
	return SDL::HWSURFACE;
}

sub SDL_ANYFORMAT  {
	return SDL::ANYFORMAT;
}

sub SDL_HWPALETTE {
	return SDL::HWPALETTE;
}

sub SDL_DOUBLEBUF {
	return SDL::DOUBLEBUF;
}

sub SDL_FULLSCREEN {
	return SDL::FULLSCREEN;
}

sub SDL_TEXTWIDTH {
	return SDL::TextWidth(join('',@_));
}

sub SDL_RESIZABLE {
	return SDL::RESIZABLE;
}

sub SDL_HWACCEL {	
	return SDL::HWACCEL;
}

sub SDL_SRCCOLORKEY {
	return SDL::SRCCOLORKEY;
}

sub SDL_RLEACCELOK {
	return SDL::RLEACCELOK;
}

sub SDL_RLEACCEL {
	return SDL::RLEACCEL;
}

sub SDL_SRCALPHA {
	return SDL::SRCALPHA;
}

sub SDL_ASYNCBLIT {
	return SDL::ASYNCBLIT;
}

sub SDL_GRAB_QUERY {
	return SDL::GRAB_QUERY;
}

sub SDL_GRAB_ON {
	return SDL::GRAB_ON;
}

sub SDL_GRAB_OFF {
	return SDL::GRAB_OFF;
}

sub SDL_OPENGL {
	return SDL::OPENGL;
}

1;

__END__;

=head1 NAME

SDL::App - a SDL perl extension

=head1 SYNOPSIS

  $app = new SDL::App ( -title => 'test program', 
		-width => 640, -height => 480, -depth => 32 );

=head1 DESCRIPTION

=head2 new

C<SDL::App::new> initializes the SDL, creates a new screen,
and initializes some of the window manager properties.
C<SDL::App::new> takes a series of named parameters:

=over 4

=item *
-title

=item *
-icon_title

=item *
-icon

=item *
-width

=item *
-height

=item *
-depth

=item *
-flags

=back

=head2 title

C<SDL::App::title> takes 0, 1, or 2  arguments.  It returns the current
application window title.  If one parameter is passed, both the window
title and icon title will be set to its value.  If two parameters are
passed the window title will be set to the first, and the icon title
to the second.

=head2 delay

C<SDL::App::delay> takes 1 argument, and will sleep the application for
that many ms.

=head2 ticks

C<SDL::App::ticks> returns the number of ms since the application began.

=head2 error

C<SDL::App::error> returns the last error message set by the SDL.

=head2 fullscreen

C<SDL::App::fullscreen> toggles the application in and out of fullscreen mode.

=head2 iconify

C<SDL::App::iconify> iconifies the applicaiton window.

=head2 grab_input

C<SDL::App::grab_input> can be used to change the input focus behavior of
the application.  It takes one argument, which should be one of the following:

=over 4

=item *
SDL_GRAB_QUERY

=item *
SDL_GRAB_ON

=item *
SDL_GRAB_OFF

=head2 loop

C<SDL::App::loop> is a simple event loop method which takes a reference to a hash
of event handler subroutines.  The keys of the hash must be SDL event types such
as SDL_QUIT(), SDL_KEYDOWN(), and the like.  The event method recieves as its parameter 
the event object used in the loop.
 
  Example:

	my $app = new SDL::App  -title => "test.app", 
				-width => 800, 
				-height => 600, 
				-depth => 32;
	
	my %actions = (
		SDL_QUIT() => sub { exit(0); },
		SDL_KEYDOWN() => sub { print "Key Pressed" },
	);

	$app->loop(\%actions);

=head2 sync

C<SDL::App::sync> encapsulates the various methods of syncronizing the screen with the
current video buffer.  SDL::App::sync will do a fullscreen update, using the double buffer
or OpenGL buffer if applicable.  This is prefered to calling flip on the application window.

=head2 attribute ( attr, [value] )

C<SDL::App::attribute> allows one to set and get GL attributes.  By passing a value
in addition to the attribute selector, the value will be set.  C<SDL:::App::attribute>
always returns the current value of the given attribute, or dies on failure.

=head1 AUTHOR

  David J. Goehrig

=head1 SEE ALSO

  perl(1) SDL::Surface(3) SDL::Mixer(3) SDL::Event(3) SDL::Cdrom(3).

=cut	

