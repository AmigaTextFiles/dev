#include <stdio.h>
#include <stdlib.h>

void *LoadFile (const char *name, int *size_p) {
	FILE *file;
	void *data = NULL;
	int size;
	file = fopen(name, "rb");
	if (file) {
		if (fseek(file, 0, SEEK_END) == 0 &&
			(size = ftell(file)) > 0 &&
			fseek(file, 0, SEEK_SET) == 0)
		{
			data = malloc(size);
			if (data != NULL && fread(data, 1, size, file) != size) {
				free(data);
				data = NULL;
			}
		}
		fclose(file);
	}
	*size_p = data ? size : 0;
	return data;
}

