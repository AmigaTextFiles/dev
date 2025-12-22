#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <libmodplug/modplug.h>
#include <proto/dos.h>

void *LoadFile (const char *name, int *size_p);

int OpenAHIDevice (void);
void CloseAHIDevice (void);
void PlayPCM (void *pcm, unsigned int bytes, unsigned int freq);

static const ModPlug_Settings settings = {
	MODPLUG_ENABLE_OVERSAMPLING, // mFlags
	2, // mChannels
	16, // mBits
	44100, // mFrequency
	MODPLUG_RESAMPLE_FIR, // mResamplingMode
	256, // mStereoSeparation
	128, // mMaxMixChannels
	0, // mReverbDepth
	0, // mReverbDelay
	0, // mBassAmount
	0, // mBassRange
	0, // mSurroundDepth
	0, // mSurroundDelay
	0  // mLoopCount
};

#define PCM_SIZE 4096


int main (int argc, char **argv) {
	void *data;
	int size;
	void *pcm[2];
	int pcm_idx = 0;
	int pcm_len;
	ModPlugFile *module;

	if (argc != 2) {
		printf("Usage: modplugplay <mod file>\n");
		return EXIT_FAILURE;
	}

	ModPlug_SetSettings(&settings);

	data = LoadFile(argv[1], &size);
	if (data == NULL) {
		fprintf(stderr, "Failed to read module file.\n");
		return EXIT_FAILURE;
	}

	module = ModPlug_Load(data, size);
	if (module == NULL) {
		fprintf(stderr, "ModPlug_Load failed.\n");
		return EXIT_FAILURE;
	}

	pcm[0] = malloc(PCM_SIZE);
	pcm[1] = malloc(PCM_SIZE);
	if (pcm[0] == NULL || pcm[1] == NULL) {
		fprintf(stderr, "Failed to allocate pcm buffers.\n");
		ModPlug_Unload(module);
		return EXIT_FAILURE;
	}

	if (OpenAHIDevice() == 0) {
		fprintf(stderr, "Failed to open ahi.device.\n");
		ModPlug_Unload(module);
		return EXIT_FAILURE;
	}

	signal(SIGINT, SIG_IGN);
	printf("Playing module. Press CTRL-C to quit.\n");

	while ((pcm_len = ModPlug_Read(module, pcm[pcm_idx], PCM_SIZE)) > 0) {
		PlayPCM(pcm[pcm_idx], pcm_len, 44100);
		pcm_idx ^= 1;
		if (IDOS->CheckSignal(SIGBREAKF_CTRL_C)) break;
	}

	CloseAHIDevice();
	ModPlug_Unload(module);

	return EXIT_SUCCESS;
}


