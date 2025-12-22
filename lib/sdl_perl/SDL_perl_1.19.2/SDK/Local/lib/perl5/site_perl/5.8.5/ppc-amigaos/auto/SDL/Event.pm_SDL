#	Event.pm
#
#	A package for handling SDL_Event *
#
#	Copyright (C) 2000,2001,2002 David J. Goehrig
#
#	see the file COPYING for terms of use
#

package SDL::Event;
use strict;
use SDL;

BEGIN {
	use Exporter();
	use vars qw(@EXPORT @ISA);
	@ISA = qw(Exporter);
	@EXPORT = qw(&SDL_IGNORE &SDL_ENABLE &SDL_QUERY
			&SDL_ACTIVEEVENT &SDL_KEYDOWN &SDL_KEYUP
			&SDL_MOUSEMOTION &SDL_MOUSEBUTTONDOWN 
			&SDL_MOUSEBUTTONUP &SDL_QUIT &SDL_SYSWMEVENT
			&SDL_APPMOUSEFOCUS &SDL_APPINPUTFOCUS 
			&SDL_APPACTIVE &SDL_PRESSED &SDL_RELEASED
			&SDLK_BACKSPACE &SDLK_TAB &SDLK_CLEAR 
			&SDLK_RETURN &SDLK_PAUSE &SDLK_ESCAPE 
			&SDLK_SPACE &SDLK_EXCLAIM &SDLK_QUOTEDBL 
			&SDLK_HASH &SDLK_DOLLAR &SDLK_AMPERSAND 
			&SDLK_QUOTE &SDLK_LEFTPAREN &SDLK_RIGHTPAREN 
			&SDLK_ASTERISK &SDLK_PLUS &SDLK_COMMA 
			&SDLK_MINUS &SDLK_PERIOD &SDLK_SLASH 
			&SDLK_0 &SDLK_1 &SDLK_2 
			&SDLK_3 &SDLK_4 &SDLK_5 
			&SDLK_6 &SDLK_7 &SDLK_8 
			&SDLK_9 &SDLK_COLON &SDLK_SEMICOLON 
			&SDLK_LESS &SDLK_EQUALS &SDLK_GREATER 
			&SDLK_QUESTION &SDLK_AT &SDLK_LEFTBRACKET 
			&SDLK_BACKSLASH &SDLK_RIGHTBRACKET &SDLK_CARET 
			&SDLK_UNDERSCORE &SDLK_BACKQUOTE &SDLK_a 
			&SDLK_b &SDLK_c &SDLK_d 
			&SDLK_e &SDLK_f &SDLK_g 
			&SDLK_h &SDLK_i &SDLK_j 
			&SDLK_k &SDLK_l &SDLK_m 
			&SDLK_n &SDLK_o &SDLK_p 
			&SDLK_q &SDLK_r &SDLK_s 
			&SDLK_t &SDLK_u &SDLK_v 
			&SDLK_w &SDLK_x &SDLK_y 
			&SDLK_z &SDLK_DELETE &SDLK_KP0 
			&SDLK_KP1 &SDLK_KP2 &SDLK_KP3 
			&SDLK_KP4 &SDLK_KP5 &SDLK_KP6 
			&SDLK_KP7 &SDLK_KP8 &SDLK_KP9 
			&SDLK_KP_PERIOD &SDLK_KP_DIVIDE &SDLK_KP_MULTIPLY 
			&SDLK_KP_MINUS &SDLK_KP_PLUS &SDLK_KP_ENTER 
			&SDLK_KP_EQUALS &SDLK_UP &SDLK_DOWN 
			&SDLK_RIGHT &SDLK_LEFT &SDLK_INSERT 
			&SDLK_HOME &SDLK_END &SDLK_PAGEUP 
			&SDLK_PAGEDOWN &SDLK_F1 &SDLK_F2 
			&SDLK_F3 &SDLK_F4 &SDLK_F5 
			&SDLK_F6 &SDLK_F7 &SDLK_F8 
			&SDLK_F9 &SDLK_F10 &SDLK_F11 
			&SDLK_F12 &SDLK_F13 &SDLK_F14 
			&SDLK_F15 &SDLK_NUMLOCK &SDLK_CAPSLOCK 
			&SDLK_SCROLLOCK &SDLK_RSHIFT &SDLK_LSHIFT 
			&SDLK_RCTRL &SDLK_LCTRL &SDLK_RALT 
			&SDLK_LALT &SDLK_RMETA &SDLK_LMETA 
			&SDLK_LSUPER &SDLK_RSUPER &SDLK_MODE 
			&SDLK_HELP &SDLK_PRINT &SDLK_SYSREQ 
			&SDLK_BREAK &SDLK_MENU &SDLK_POWER 
			&SDLK_EURO &KMOD_NONE &KMOD_NUM 
			&KMOD_CAPS &KMOD_LCTRL &KMOD_RCTRL 
			&KMOD_RSHIFT &KMOD_LSHIFT &KMOD_RALT 
			&KMOD_LALT &KMOD_CTRL &KMOD_SHIFT 
			&KMOD_ALT); 
	}

sub SDL_IGNORE { return SDL::IGNORE(); }
sub SDL_ENABLE { return SDL::ENABLE(); }
sub SDL_QUERY { return SDL::QUERY(); }
sub SDL_ACTIVEEVENT { return SDL::ACTIVEEVENT(); }
sub SDL_KEYDOWN { return SDL::KEYDOWN(); }
sub SDL_KEYUP { return SDL::KEYUP(); }
sub SDL_MOUSEMOTION { return SDL::MOUSEMOTION(); }
sub SDL_MOUSEBUTTONDOWN { return SDL::MOUSEBUTTONDOWN(); }
sub SDL_MOUSEBUTTONUP { return SDL::MOUSEBUTTONUP(); }
sub SDL_QUIT { return SDL::QUIT(); }
sub SDL_SYSWMEVENT { return SDL::SYSWMEVENT(); }
sub SDL_APPMOUSEFOCUS { return SDL::APPMOUSEFOCUS(); }
sub SDL_APPINPUTFOCUS { return SDL::APPINPUTFOCUS(); }
sub SDL_APPACTIVE { return SDL::APPACTIVE(); }
sub SDL_PRESSED { return SDL::PRESSED(); }
sub SDL_RELEASED { return SDL::RELEASED(); }

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	$self->{-event} = SDL::NewEvent();
	bless $self, $class;
	return $self;
}

sub DESTROY {
	my $self = shift;
	SDL::FreeEvent($self->{-event});
}

sub type {
	my $self = shift;
	return SDL::EventType($self->{-event});
}

sub pump {
	SDL::PumpEvents();
}

sub poll {
	my $self = shift;
	return SDL::PollEvent($self->{-event});
}

sub wait {
	my $self = shift;
	return SDL::WaitEvent($self->{-event});
}

sub set { 
	my $self = shift;
	my $type = shift;
	my $state = shift;
	return SDL::EventState($type,$state);
}

sub set_unicode {
	my $self = shift;
	my $toggle = shift;
	return SDL::EnableUnicode($toggle);
}

sub set_key_repeat {
	my $self = shift;
	my $delay = shift;
	my $interval = shift;
	return SDL::EnableKeyRepeat($delay,$interval);
}

sub active_gain {
	my $self = shift;
	return SDL::ActiveEventGain($self->{-event});
}

sub active_state {
	my $self = shift;
	return SDL::ActiveEventState($self->{-event});
}

sub key_state {
	my $self = shift;
	return SDL::KeyEventState($self->{-event});
}

sub key_sym {
	my $self = shift;
	return SDL::KeyEventSym($self->{-event});
}

sub key_name {
	my $self = shift;
	return SDL::GetKeyName(SDL::KeyEventSym($self->{-event}));
}

sub key_mod {
	my $self = shift;
	return SDL::KeyEventMod($self->{-event});
}

sub key_unicode {
	my $self = shift;
	return SDL::KeyEventUnicode($self->{-event});
}

sub key_scancode {
	my $self = shift;
	return SDL::KeyEventScanCode($self->{-event});
}

sub motion_state {
	my $self = shift;
	return SDL::MouseMotionState($self->{-event});
}

sub motion_x {
	my $self = shift;
	return SDL::MouseMotionX($self->{-event});
}

sub motion_y {
	my $self = shift;
	return SDL::MouseMotionY($self->{-event});
}

sub motion_xrel {
	my $self = shift;
	return SDL::MouseMotionXrel($self->{-event});
}

sub motion_yrel {
	my $self = shift;
	return SDL::MouseMotionYrel($self->{-event});
}

sub button_state {
	my $self = shift;
	return SDL::MouseButtonState($self->{-event});
}

sub button_x {
	my $self = shift;
	return SDL::MouseButtonX($self->{-event});
}

sub button_y {
	my $self = shift;
	return SDL::MouseButtonY($self->{-event});
}

sub button {
	my $self = shift;
	return SDL::MouseButton($self->{-event});
}


sub SDLK_BACKSPACE { return SDL::SDLK_BACKSPACE(); }
sub SDLK_TAB { return SDL::SDLK_TAB(); }
sub SDLK_CLEAR { return SDL::SDLK_CLEAR(); }
sub SDLK_RETURN { return SDL::SDLK_RETURN(); }
sub SDLK_PAUSE { return SDL::SDLK_PAUSE(); }
sub SDLK_ESCAPE { return SDL::SDLK_ESCAPE(); }
sub SDLK_SPACE { return SDL::SDLK_SPACE(); }
sub SDLK_EXCLAIM { return SDL::SDLK_EXCLAIM(); }
sub SDLK_QUOTEDBL { return SDL::SDLK_QUOTEDBL(); }
sub SDLK_HASH { return SDL::SDLK_HASH(); }
sub SDLK_DOLLAR { return SDL::SDLK_DOLLAR(); }
sub SDLK_AMPERSAND { return SDL::SDLK_AMPERSAND(); }
sub SDLK_QUOTE { return SDL::SDLK_QUOTE(); }
sub SDLK_LEFTPAREN { return SDL::SDLK_LEFTPAREN(); }
sub SDLK_RIGHTPAREN { return SDL::SDLK_RIGHTPAREN(); }
sub SDLK_ASTERISK { return SDL::SDLK_ASTERISK(); }
sub SDLK_PLUS { return SDL::SDLK_PLUS(); }
sub SDLK_COMMA { return SDL::SDLK_COMMA(); }
sub SDLK_MINUS { return SDL::SDLK_MINUS(); }
sub SDLK_PERIOD { return SDL::SDLK_PERIOD(); }
sub SDLK_SLASH { return SDL::SDLK_SLASH(); }
sub SDLK_0 { return SDL::SDLK_0(); }
sub SDLK_1 { return SDL::SDLK_1(); }
sub SDLK_2 { return SDL::SDLK_2(); }
sub SDLK_3 { return SDL::SDLK_3(); }
sub SDLK_4 { return SDL::SDLK_4(); }
sub SDLK_5 { return SDL::SDLK_5(); }
sub SDLK_6 { return SDL::SDLK_6(); }
sub SDLK_7 { return SDL::SDLK_7(); }
sub SDLK_8 { return SDL::SDLK_8(); }
sub SDLK_9 { return SDL::SDLK_9(); }
sub SDLK_COLON { return SDL::SDLK_COLON(); }
sub SDLK_SEMICOLON { return SDL::SDLK_SEMICOLON(); }
sub SDLK_LESS { return SDL::SDLK_LESS(); }
sub SDLK_EQUALS { return SDL::SDLK_EQUALS(); }
sub SDLK_GREATER { return SDL::SDLK_GREATER(); }
sub SDLK_QUESTION { return SDL::SDLK_QUESTION(); }
sub SDLK_AT { return SDL::SDLK_AT(); }
sub SDLK_LEFTBRACKET { return SDL::SDLK_LEFTBRACKET(); }
sub SDLK_BACKSLASH { return SDL::SDLK_BACKSLASH(); }
sub SDLK_RIGHTBRACKET { return SDL::SDLK_RIGHTBRACKET(); }
sub SDLK_CARET { return SDL::SDLK_CARET(); }
sub SDLK_UNDERSCORE { return SDL::SDLK_UNDERSCORE(); }
sub SDLK_BACKQUOTE { return SDL::SDLK_BACKQUOTE(); }
sub SDLK_a { return SDL::SDLK_a(); }
sub SDLK_b { return SDL::SDLK_b(); }
sub SDLK_c { return SDL::SDLK_c(); }
sub SDLK_d { return SDL::SDLK_d(); }
sub SDLK_e { return SDL::SDLK_e(); }
sub SDLK_f { return SDL::SDLK_f(); }
sub SDLK_g { return SDL::SDLK_g(); }
sub SDLK_h { return SDL::SDLK_h(); }
sub SDLK_i { return SDL::SDLK_i(); }
sub SDLK_j { return SDL::SDLK_j(); }
sub SDLK_k { return SDL::SDLK_k(); }
sub SDLK_l { return SDL::SDLK_l(); }
sub SDLK_m { return SDL::SDLK_m(); }
sub SDLK_n { return SDL::SDLK_n(); }
sub SDLK_o { return SDL::SDLK_o(); }
sub SDLK_p { return SDL::SDLK_p(); }
sub SDLK_q { return SDL::SDLK_q(); }
sub SDLK_r { return SDL::SDLK_r(); }
sub SDLK_s { return SDL::SDLK_s(); }
sub SDLK_t { return SDL::SDLK_t(); }
sub SDLK_u { return SDL::SDLK_u(); }
sub SDLK_v { return SDL::SDLK_v(); }
sub SDLK_w { return SDL::SDLK_w(); }
sub SDLK_x { return SDL::SDLK_x(); }
sub SDLK_y { return SDL::SDLK_y(); }
sub SDLK_z { return SDL::SDLK_z(); }
sub SDLK_DELETE { return SDL::SDLK_DELETE(); }
sub SDLK_KP0 { return SDL::SDLK_KP0(); }
sub SDLK_KP1 { return SDL::SDLK_KP1(); }
sub SDLK_KP2 { return SDL::SDLK_KP2(); }
sub SDLK_KP3 { return SDL::SDLK_KP3(); }
sub SDLK_KP4 { return SDL::SDLK_KP4(); }
sub SDLK_KP5 { return SDL::SDLK_KP5(); }
sub SDLK_KP6 { return SDL::SDLK_KP6(); }
sub SDLK_KP7 { return SDL::SDLK_KP7(); }
sub SDLK_KP8 { return SDL::SDLK_KP8(); }
sub SDLK_KP9 { return SDL::SDLK_KP9(); }
sub SDLK_KP_PERIOD { return SDL::SDLK_KP_PERIOD(); }
sub SDLK_KP_DIVIDE { return SDL::SDLK_KP_DIVIDE(); }
sub SDLK_KP_MULTIPLY { return SDL::SDLK_KP_MULTIPLY(); }
sub SDLK_KP_MINUS { return SDL::SDLK_KP_MINUS(); }
sub SDLK_KP_PLUS { return SDL::SDLK_KP_PLUS(); }
sub SDLK_KP_ENTER { return SDL::SDLK_KP_ENTER(); }
sub SDLK_KP_EQUALS { return SDL::SDLK_KP_EQUALS(); }
sub SDLK_UP { return SDL::SDLK_UP(); }
sub SDLK_DOWN { return SDL::SDLK_DOWN(); }
sub SDLK_RIGHT { return SDL::SDLK_RIGHT(); }
sub SDLK_LEFT { return SDL::SDLK_LEFT(); }
sub SDLK_INSERT { return SDL::SDLK_INSERT(); }
sub SDLK_HOME { return SDL::SDLK_HOME(); }
sub SDLK_END { return SDL::SDLK_END(); }
sub SDLK_PAGEUP { return SDL::SDLK_PAGEUP(); }
sub SDLK_PAGEDOWN { return SDL::SDLK_PAGEDOWN(); }
sub SDLK_F1 { return SDL::SDLK_F1(); }
sub SDLK_F2 { return SDL::SDLK_F2(); }
sub SDLK_F3 { return SDL::SDLK_F3(); }
sub SDLK_F4 { return SDL::SDLK_F4(); }
sub SDLK_F5 { return SDL::SDLK_F5(); }
sub SDLK_F6 { return SDL::SDLK_F6(); }
sub SDLK_F7 { return SDL::SDLK_F7(); }
sub SDLK_F8 { return SDL::SDLK_F8(); }
sub SDLK_F9 { return SDL::SDLK_F9(); }
sub SDLK_F10 { return SDL::SDLK_F10(); }
sub SDLK_F11 { return SDL::SDLK_F11(); }
sub SDLK_F12 { return SDL::SDLK_F12(); }
sub SDLK_F13 { return SDL::SDLK_F13(); }
sub SDLK_F14 { return SDL::SDLK_F14(); }
sub SDLK_F15 { return SDL::SDLK_F15(); }
sub SDLK_NUMLOCK { return SDL::SDLK_NUMLOCK(); }
sub SDLK_CAPSLOCK { return SDL::SDLK_CAPSLOCK(); }
sub SDLK_SCROLLOCK { return SDL::SDLK_SCROLLOCK(); }
sub SDLK_RSHIFT { return SDL::SDLK_RSHIFT(); }
sub SDLK_LSHIFT { return SDL::SDLK_LSHIFT(); }
sub SDLK_RCTRL { return SDL::SDLK_RCTRL(); }
sub SDLK_LCTRL { return SDL::SDLK_LCTRL(); }
sub SDLK_RALT { return SDL::SDLK_RALT(); }
sub SDLK_LALT { return SDL::SDLK_LALT(); }
sub SDLK_RMETA { return SDL::SDLK_RMETA(); }
sub SDLK_LMETA { return SDL::SDLK_LMETA(); }
sub SDLK_LSUPER { return SDL::SDLK_LSUPER(); }
sub SDLK_RSUPER { return SDL::SDLK_RSUPER(); }
sub SDLK_MODE { return SDL::SDLK_MODE(); }
sub SDLK_HELP { return SDL::SDLK_HELP(); }
sub SDLK_PRINT { return SDL::SDLK_PRINT(); }
sub SDLK_SYSREQ { return SDL::SDLK_SYSREQ(); }
sub SDLK_BREAK { return SDL::SDLK_BREAK(); }
sub SDLK_MENU { return SDL::SDLK_MENU(); }
sub SDLK_POWER { return SDL::SDLK_POWER(); }
sub SDLK_EURO { return SDL::SDLK_EURO(); }

sub KMOD_NONE { return SDL::MOD_NONE(); }
sub KMOD_NUM { return SDL::MOD_NUM(); }
sub KMOD_CAPS { return SDL::MOD_CAPS(); }
sub KMOD_LCTRL { return SDL::MOD_LCTRL(); }
sub KMOD_RCTRL { return SDL::MOD_RCTRL(); }
sub KMOD_RSHIFT { return SDL::MOD_RSHIFT(); }
sub KMOD_LSHIFT { return SDL::MOD_LSHIFT(); }
sub KMOD_RALT { return SDL::MOD_RALT(); }
sub KMOD_LALT { return SDL::MOD_LALT(); }
sub KMOD_CTRL { return SDL::MOD_CTRL(); }
sub KMOD_SHIFT { return SDL::MOD_SHIFT(); }
sub KMOD_ALT { return SDL::MOD_ALT(); }

1;

__END__;

=head1 NAME

SDL::Event - a SDL perl extension

=head1 SYNOPSIS

 use SDL::Event;
 my $event = new SDL::Event;             # create a new event
 while ($event->wait()) {
 	my $type = $event->type();      # get event type
 	# ... handle event
 	exit if $type == SDL_QUIT;
 }
 
=head1 EXPORTS

C<SDL::Event> exports the following symbols by default:
 
       SDL_IGNORE              SDL_ENABLE
       SDL_QUERY               SDL_ACTIVEEVENT
       SDL_KEYDOWN             SDL_KEYUP
       SDL_MOUSEMOTION         SDL_MOUSEBUTTONDOWN
       SDL_MOUSEBUTTONUP       SDL_QUIT
       SDL_SYSWMEVENT          SDL_APPMOUSEFOCUS
       SDL_APPINPUTFOCUS       SDL_APPACTIVE
       SDL_PRESSED             SDL_RELEASED
       SDLK_BACKSPACE          SDLK_TAB
       SDLK_CLEAR              SDLK_RETURN
       SDLK_PAUSE              SDLK_ESCAPE
       SDLK_SPACE              SDLK_EXCLAIM
       SDLK_QUOTEDBL           SDLK_HASH
       SDLK_DOLLAR             SDLK_AMPERSAND
       SDLK_QUOTE              SDLK_LEFTPAREN
       SDLK_RIGHTPAREN         SDLK_ASTERISK
       SDLK_PLUS               SDLK_COMMA
       SDLK_MINUS              SDLK_PERIOD
       SDLK_SLASH              SDLK_0
       SDLK_1                  SDLK_2
       SDLK_3                  SDLK_4
       SDLK_5                  SDLK_6
       SDLK_7                  SDLK_8
       SDLK_9                  SDLK_COLON
       SDLK_SEMICOLON          SDLK_LESS
       SDLK_EQUALS             SDLK_GREATER
       SDLK_QUESTION           SDLK_AT
       SDLK_LEFTBRACKET        SDLK_BACKSLASH
       SDLK_RIGHTBRACKET       SDLK_CARET
       SDLK_UNDERSCORE         SDLK_BACKQUOTE

       SDLK_a                  SDLK_b
       SDLK_c                  SDLK_d
       SDLK_e                  SDLK_f
       SDLK_g                  SDLK_h
       SDLK_i                  SDLK_j
       SDLK_k                  SDLK_l
       SDLK_m                  SDLK_n
       SDLK_o                  SDLK_p
       SDLK_q                  SDLK_r
       SDLK_s                  SDLK_t
       SDLK_u                  SDLK_v
       SDLK_w                  SDLK_x
       SDLK_y                  SDLK_z
       SDLK_DELETE             SDLK_KP0
       SDLK_KP1                SDLK_KP2
       SDLK_KP3                SDLK_KP4
       SDLK_KP5                SDLK_KP6
       SDLK_KP7                SDLK_KP8
       SDLK_KP9                SDLK_KP_PERIOD
       SDLK_KP_DIVIDE          SDLK_KP_MULTIPLY
       SDLK_KP_MINUS           SDLK_KP_PLUS
       SDLK_KP_ENTER           SDLK_KP_EQUALS
       SDLK_UP                 SDLK_DOWN
       SDLK_RIGHT              SDLK_LEFT
       SDLK_INSERT             SDLK_HOME
       SDLK_END                SDLK_PAGEUP

       SDLK_PAGEDOWN           SDLK_F1
       SDLK_F2                 SDLK_F3
       SDLK_F4                 SDLK_F5
       SDLK_F6                 SDLK_F7
       SDLK_F8                 SDLK_F9
       SDLK_F10                SDLK_F11
       SDLK_F12                SDLK_F13
       SDLK_F14                SDLK_F15
       SDLK_NUMLOCK            SDLK_CAPSLOCK
       SDLK_SCROLLOCK          SDLK_RSHIFT
       SDLK_LSHIFT             SDLK_RCTRL
       SDLK_LCTRL              SDLK_RALT
       SDLK_LALT               SDLK_RMETA
       SDLK_LMETA

For instance, C<SDLK_F12> means the key F12, C<SDLK_KP9> means the
key labeled '9' on the keypad (KP). Check for SDL_KEYDOWN for whether a key
was pressed or not.

=head1 DESCRIPTION

C<SDL::Event> offers an object-oriented approach to SDL events. By creating
an instance of SDL::Event via new() you can wait for events, and then determine
the type of the event and take an appropriate action.

=head1 EXAMPLE

Here is an example of a simple event handler loop routine.
See also L<SDL::App::loop>.

       sub loop {
               my ($self,$href) = @_;
               my $event = new SDL::Event;
               while ( $event->wait() ) {
                       # ... insert here your event handling like:
                       if ( ref($$href{$event->type()}) eq "CODE" ) {
                               &{$$href{$event->type()}}($event);
                               $self->sync();
                       }
               }
       }

=head1 METHODS

=head2 new()

Create a new event object.

=head2 type()

Returns the type of the event, see list of exported symbols for which are
available.

=head2 pump()

=head2 poll()

=head2 wait()

Waits for an event end returns then. Always returns true.

=head2 set()

       $event->set($type,$state);

Set type and state of the event.

=head2 set_unicode()

       $event->set_unicode($toggle);

Toggle unicode on the event.

=head2 set_key_repeat()

       $event->set_key_repeat($delay,$interval);

Sets the delay and intervall of the key repeat rate (e.g. when a user
holds down a key on the keyboard).

=head2 active_gain()

=head2 active_state()

=head2 key_state()

=head2 key_sym()

=head2 key_name()

=head2 key_mod()

=head2 key_unicode()

=head2 key_scancode()

=head2 motion_state()

=head2 motion_x()

       my $dist = $event->motion_x();

Returns the motion of the mouse in X direction as an absolute value.

=head2 motion_y()

       my $dist = $event->motion_y();

Returns the motion of the mouse in Y direction as an absolute value.

=head2 motion_xrel()

       my $rel_dist = $event->motion_xrel();

Returns the motion of the mouse in X direction as a relative value.

=head2 motion_yrel()

       my $rel_dist = $event->motion_xrel();

Returns the motion of the mouse in Y direction as a relative value.

=head2 button_state()

Returns the state of the mouse buttons.

=head2 button_x()

=head2 button_y()

=head2 button()

=head1 AUTHOR

 David J. Goehrig
 Documentation by Tels <http://bloodgate.com/>

=head1 SEE ALSO

  perl(1) and L<SDL::App>.

=cut

