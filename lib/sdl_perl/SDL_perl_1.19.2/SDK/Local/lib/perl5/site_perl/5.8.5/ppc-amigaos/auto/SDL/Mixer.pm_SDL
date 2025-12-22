#	Mixer.pm
#
#	a SDL module for manipulating the SDL_mixer lib.
#
#	Copyright (C) 2000,2002 David J. Goehrig

package SDL::Mixer;
use strict;
use SDL;
require SDL::Music;
require SDL::Sound;

BEGIN {
	use Exporter();
	use vars qw(@EXPORT @ISA);
	@ISA = qw(Exporter);
	@EXPORT = qw(&MIX_MAX_VOLUME &MIX_DEFAULT_FREQUENCY &MIX_DEFAULT_FORMAT
			&MIX_DEFAULT_CHANNELS &MIX_NO_FADING &MIX_FADING_OUT
			&MIX_FADING_IN &AUDIO_U8 &AUDIO_S8 &AUDIO_U16 
			&AUDIO_S16 &AUDIO_U16MSB &AUDIO_S16MSB );
}

sub MIX_MAX_VOLUME { return SDL::MIX_MAX_VOLUME(); }
sub MIX_DEFAULT_FREQUENCY { return SDL::MIX_DEFAULT_FREQUENCY(); }
sub MIX_DEFAULT_FORMAT { return SDL::MIX_DEFAULT_FORMAT(); }
sub MIX_DEFAULT_CHANNELS { return SDL::MIX_DEFAULT_CHANNELS(); }
sub MIX_NO_FADING { return SDL::MIX_NO_FADING(); }
sub MIX_FADING_OUT { return SDL::MIX_FADING_OUT(); }
sub MIX_FADING_IN { return SDL::MIX_FADING_IN(); }
sub AUDIO_U8 { return SDL::AUDIO_U8(); }
sub AUDIO_S8 { return SDL::AUDIO_S8(); }
sub AUDIO_U16 { return SDL::AUDIO_U16(); }
sub AUDIO_S16 { return SDL::AUDIO_S16(); }
sub AUDIO_U16MSB { return SDL::AUDIO_U16MSB(); }
sub AUDIO_S16MSB { return SDL::AUDIO_S16MSB(); }

$SDL::Mixer::initialized = 0;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	my %options = @_;
	my $frequency = $options{-frequency} || $options{-rate} || MIX_DEFAULT_FREQUENCY();
	my $format = $options{-format} || MIX_DEFAULT_FORMAT();
	my $channels = $options{-channels} || MIX_DEFAULT_CHANNELS();
	my $size = $options{-size} || 4096;
	unless ( $SDL::Mixer::initialized ) {
		SDL::MixOpenAudio($frequency,$format,$channels,$size ) && 
			die SDL::GetError(); 
		$SDL::Mixer::initialized = 1;
	} else {
		++$SDL::Mixer::initialized;
	}
	bless $self,$class;
	return $self;
}	

sub DESTROY {
	my $self = shift;
	--$SDL::Mixer::initialized;
	unless ($SDL::Mixer::initialized) {
		SDL::MixCloseAudio();
	}
}


sub query_spec () {
	my ($status,$freq,$format,$channels) = SDL::MixQuerySpec();
	my %hash = ( -status => $status, -frequency => $freq, 
			-format => $format, -channels => $channels );
	return \%hash;
}

sub reserve_channels ($$) {
	my ($self,$channels) = @_;
	return SDL::MixReserveChannels($channels);
}

sub allocate_channels ($$) {
	my ($self,$channels) = @_;
	return SDL::MixAllocateChannels($channels);
}

sub group_channel ($$$) {
	my ($self,$channel,$group) = @_;
	return SDL::MixGroupChannel($channel, $group);
}

sub group_channels ($$$$) {
	my ($self,$from,$to,$group) = @_;
	return SDL::MixGroupChannels($from,$to,$group);
}

sub group_available ($$) {
	my ($self,$group) = @_;	
	return SDL::MixGroupAvailable($group);
}

sub group_count ($$) {
	my ($self,$group) = @_;	
	return SDL::MixGroupCount($group);
}	

sub group_oldest ($$) {
	my ($self,$group) = @_;	
	return SDL::MixGroupOldest($group);
}	

sub group_newer ($$) {
	my ($self,$group) = @_;	
	return SDL::MixGroupNewer($group);
}	

sub play_channel ($$$$;$) {
	my ($self,$channel,$chunk,$loops,$ticks) = @_;
	$ticks ||= -1; 
	return SDL::MixPlayChannelTimed($channel,$chunk->{-data},$loops,$ticks);
}

sub play_music ($$$) {
	my ($self,$music,$loops) = @_;
	return SDL::MixPlayMusic($music->{-data},$loops);
}

sub fade_in_channel ($$$$$;$) {
	my ($self,$channel,$chunk,$loops,$ms,$ticks) = @_;
	$ticks ||= -1;
	return SDL::MixFadeInChannelTimed($channel,$chunk->{-data},$loops,$ms,$ticks);
}

sub fade_in_music ($$$$) {
	my ($self,$music,$loops,$ms) = @_;
	return SDL::MixFadeInMusic($music->{-data},$loops,$ms);
}

sub channel_volume ($$$) {
	my ($self,$channel,$volume) = @_;
	return SDL::MixVolume($channel,$volume);
}

sub music_volume ($$) {
	my ($self,$volume) = @_;
	return SDL::MixVolumeMusic($volume);
}

sub halt_channel ($$) {
	my ($self,$channel) = @_;
	return SDL::MixHaltChannel($channel);
}

sub halt_group ($$) {
	my ($self,$group) = @_;
	return SDL::MixHaltGroup($group);
}

sub halt_music (){
	return SDL::MixHaltMusic();
}

sub channel_expire ($$$) {
	my ($self,$channel,$ticks) = @_;
	return SDL::MixExpireChannel($channel,$ticks);
}

sub fade_out_channel ($$$) {
	my ($self,$channel,$ms) = @_;
	return SDL::MixFadeOutChannel($channel,$ms);
}

sub fade_out_group ($$$) {
	my ($self,$group,$ms) = @_;
	return SDL::MixFadeOutGroup($group,$ms);
}

sub fade_out_music ($$) {
	my ($self,$ms) = @_;
	return SDL::MixFadeOutMusic($ms);
}

sub fading_music () {
	return SDL::MixFadingMusic();
}

sub fading_channel ($$) {
	my ($self,$channel) = @_;
	return SDL::MixFadingChannel($channel);
}
	
sub pause ($$) {
	my ($self,$channel) = @_;
	SDL::MixPause($channel);
}

sub resume ($$) {
	my ($self,$channel) = @_;
	SDL::MixResume($channel);
}

sub paused ($$) {
	my ($self,$channel) = @_;
	return SDL::MixPaused($channel);
}

sub pause_music () {
	SDL::MixPauseMusic();
}

sub resume_music () {
	SDL::MixResumeMusic();
}

sub rewind_music (){
	SDL::MixRewindMusic();
}

sub music_paused (){
	return SDL::MixPausedMusic();
}

sub playing ($$) {
	my ($self,$channel) = @_;
	return SDL::MixPlaying($channel);
}

sub playing_music () {
	return SDL::MixPlayingMusic();
}

1;

__END__;

=head1 NAME

SDL::Mixer - a SDL perl extension

=head1 SYNOPSIS

  $mixer = new SDL::Mixer 	-frequency => MIX_DEFAULT_FREQUENCY,
				-format => MIX_DEFAULT_FORMAT,
				-channels => MIX_DEFAULT_CHANNELS,
				-size => 4096;

=head1 EXPORTS

SDL::Mixer exports the following symbols by default:

	MIX_MAX_VOLUME
	MIX_DEFAULT_FREQUENCY
	MIX_DEFAULT_FORMAT
	MIX_DEFAULT_CHANNELS
	MIX_NO_FADING
	MIX_FADING_OUT
	MIX_FADING_IN
	AUDIO_U8
	AUDIO_S8
	AUDIO_U16
	AUDIO_S16
	AUDIO_U16MSB
	AUDIO_S16MSB

=head1 DESCRIPTION

SDL::Mixer allows you access to the SDL mixer library, enablig sound and
music volume setting, playing, pausing and resuming, as well as fading
the sound and music in and out.

=head1 METHODS
  
=head2 new()

	$mixer = SDL::Mixer->new(	-frequency => MIX_DEFAULT_FREQUENCY,
					-format    => MIX_DEFAULT_FORMAT,
					-channels  => MIX_DEFAULT_CHANNELS,
					-size      => 4096);

Creates a new SDL::Mixer object. C<$size> is the buffer size in bytes.

=head2 query_spec()

	my $specs = SDL::Mixer::query_spec();

Returns a hash reference, containing the following keys and their respective
values:

	-status
	-frequency
	-channels
	-format

=head2 reserve_channels

	$mixer->reserve_channels(4);

Reserve so many channels.

=head2 allocate_channels()

	$mixer->reserve_channels(2);

Allocate so many channels.

=head2 group_channel()

	$mixer->group_channel($channel,$group);

Group the channel number C<$channel> into group C<$group>.

=head2 group_channels()

	$mixer->group_channels ($from, $to, $group);

=head2 group_available()

	$mixer->group_available($group);

Return true when the group is available.

=head2 group_count

	$mixer = $self->group_count($group);

=head2 group_oldest()

	$mixer->group_oldest($group);

=head2 group_newer()

	$mixer->group_newer($group);

=head2 play_channel()

	$mixer->play_channel($channel,$chunk,$loops,$ticks);

=head2 play_music()

	$mixer->play_music($music,$loops);

Play C<$music> C<$loop> times.

=head2 fade_in_channel()

	$mixer->fade_in_channel($channel,$chunk,$loops,$ms,$ticks);

=head2 fade_in_music()

	$mixer->fade_in_music($music,$loops,$ms);

=head2 channel_volume()

	$mixer->channel_volume($channel,$volume);

=head2 mucis_volume()

	$mixer->music_volume($volume);
	
Set the volume for the music.

=head2 halt_channel()

	$mixer->halt_channel($channel);
	
=head2 halt_group()

	$mixer->halt_group($group);

=head2 halt_music()

	$mixer->halt_music();

=head2 channel_expire()

	$mixer->channel_expire($channel,$ticks);

=head2 fade_out_channel()

	$mixer->fade_out_channel($channel,$ms);

Fade the channel number C<$channel> in C<$ms> ms out.

=head2 fade_out_group()
	
	$mixer->fade_out_group($group,$ms);

Fade the channel group C<$group> in C<$ms> ms out.

=head2 fade_out_music()
	
	$mixer->fade_out_music($ms);

Fade the music in C<$ms> ms out.

=head2 fading_music()

	if ($mixer->fading_music())
	  {
	  ...
	  }

Return true when the music is currently fading in or out.

=head2 fading_channel()

	if ($mixer->fading_channel($channel))
	  {
	  ...
	  }

Return true when the channel number C<$channel> is currently fading in or out.

=head2 pause()

	$mixer->pause($channel);

Pause the channel C<$channel>.

=head2 resume()

	$mixer->resume($channel);

Resume the channel C<$channel>.

=head2 paused()

	if ($mixer->paused($channel))
	  {
	  ...
	  }

Return true when the channel is currently paused.

=head2 pause_music()

	$mixer->pause_music();

Pause the music play.

=head2 resume_music()
	
	$mixer->resume_music();

Resume the music play.

=head2 rewind_music()

	$mixer->rewind_music();

=head2 music_paused()

	if ($mixer->music_paused())
	  {
	  ...
	  }

Return true when the music is currently paused.

=head2 playing()

	$mixer->playing($channel);

Return true when the channel is currently playing.

=head2 playing_music ()

	$mixer->playing_music();

Return true when the music is currently playing.

=head1 AUTHORS 

David J. Goehrig, basic doc added by Tels <http://bloodgate.com>.

=head1 SEE ALSO

perl(1), L<SDL::Music> and L<SDL::Sound>.

=cut


