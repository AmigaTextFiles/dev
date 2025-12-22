{include to read a generic sound sampler
NOTE: non-system way but works with all
known amigas at the mo.
INIT_SAMPLER sets up for reading the sampler
GET_SAMPLE returns the UNSIGNED sample
Subtract 127 for real sound.
Neil S. pp0u203d@liv.ac.uk}

declare sub init_sampler
declare sub shortint get_sample

const CIAA_PORTB_DATA&=12574977
const CIAA_PORTB_DIR&=12575489
const CIAB_PORTA_DATA&=12570624
const CIAB_PORTA_DIR&=12571136

sub INIT_SAMPLER
  Poke CIAA_PORTB_DIR&,0
  Poke CIAB_PORTA_DIR&,6
  Poke CIAB_PORTA_DATA&,4
End sub

sub SHORTINT GET_SAMPLE
  GET_SAMPLE=Peek(CIAA_PORTB_DATA&)
End sub
