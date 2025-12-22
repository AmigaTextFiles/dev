/* Sunrize */

#define PAN_LEFT    0x00000000
#define PAN_CENTER  0x00000C80 /* 3200 */
#define PAN_RIGHT   0x00001900 /* 6400 */

#define SAMPLE_RATE 44100 /* 0xAC44 */
#define ZERODB      0xC80

#define TAG_KWIK (('K' << 24)|('W' << 16)|('K' << 8)|('3'))

struct SampleInfo {
	int rate;						/** sampling rate **/
	int filter3db;					/** Anti-aliasing filter value **/
	unsigned short volume;		/** prefered volume level **/
	int starttimecode;
	float smpte_sampling_rate;
	int pan;
	long flags;
	long reserved[1];
	};
/* length 30 bytes */

struct DiskRegion {				/* DiskRegion is saved to disk */
	char region_name[40];
	unsigned long start;		 	/* starting sample, inclusive */
	unsigned long end;			/* ending sample, inclusive **/
	struct SampleInfo parms;	/** filter, rate, volume,etc. **/
	unsigned long flags;
	};
/* length 82 bytes */

struct SampleDataClip {
	long start;			/** inclusive **/
	long end;			/** inclusive **/
	};

#define SFT_NUM_REGIONS 32
#define DS_NUM_CLIPS 128

struct SampleFileTag {
	struct SampleInfo parms;
	int org_length;			/** length of samp with no data clips **/
	int length;					/** length of samp with using data clips **/
	struct SampleDataClip dclips[DS_NUM_CLIPS];
	struct DiskRegion dregions[SFT_NUM_REGIONS];
	};
