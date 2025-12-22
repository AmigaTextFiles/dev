#ifndef PSG_H
#define PSG_H

#define SND_MONO 0
#define SND_STEREO 1

struct sndconfig {
  int mode;
  int bits;
  int freq;
};

struct spsg {
  int regs[14];
  int env_kept;
  struct sndconfig output;
};

typedef struct spsg psg;

/*
 * PSG *psg_init(int mode, int bits, int freq)
 * Action:
 *  setup all internal variables.
 * Parameters:
 *  mode - mono/stereo
 *  bits - 8/16
 *  freq - frequency for audio output
 * Return:
 *  psg - empty struct for you to use
 */

psg *psg_init(int, int, int);

/*
 * psg_create_samples(void *output_buffer,
 *                    psg *psg_struct,
 *                    int usec);
 * Action:
 *  builds a sample of length 'usec' into 'output_buffer'
 *  from 'psg_struct'
 * Parameters:
 *  output_buffer - allocated buffer of suitable size
 *  psg_struct - psg as returned from psg_init()
 *  usec - duration in microseconds of the produced sample
 * Return:
 *  int - 0 if things go ok
 */

int psg_create_samples(void *, psg *, int);

#endif /* PSG_H */
