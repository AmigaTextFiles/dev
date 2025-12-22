#ifndef _SGERESOURCE_H
#define _SGERESOURCE_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgeresource.h
 * @brief Resource handling functions
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeResource
 * @brief Resource handling functions
 *
 * Functions to handle resources like encrypted
 * files, images, audio data, ...
 *
 * @{
 */

/**
 * @struct SGEFILE
 *
 * A handle to a encrypted sge file archive created with sga
 */
typedef struct {
	/** @private */
	FILE *f;
	/**
	 * @brief The number of files contained in the archive
	 */
	int numberOfFiles;
	/** @privatesection */
	char *archname;
	char **fileName;
	Uint32 *position;
	Uint32 *fileSize;
	char *encryptionkey;
} SGEFILE;

/**
 * @brief Open a sge archive created with sga
 * @param filename The name of the archive file
 * @param encryptionkey The password of the file
 * @return A SGEFILE struct
 *
 * A sge archive is not automatically read into memory,
 * it may be much larger then the available ram. Think of
 * it more like a encrypted disk image.
 *
 * Please note, this uses a very simple encryption.
 * It is meant to prevent standard users from extracting
 * your game data. It is not hack safe and is not intended
 * to hold real security relevand information.
 */
SGEFILE *sgeOpenFile(const char *filename, const char *encryptionkey);

/**
 * @brief Close a sge archive and free its memory resources
 */
void sgeCloseFile(SGEFILE *f);

/** @private */
void sgeEncryptBuffer(void *buffer, Uint32 length, const char *encryptionkey);
/** @private */
#define sgeDecryptBuffer sgeEncryptBuffer

/**
 * @brief Create a new sge archive
 * @param filename The name of the new sge archive
 * @param filenames A list of char pointers of the filenames to add to the archive
 * @param numberOfFiles The number of files to add to the archive
 * @param encryptionkey The password
 *
 * Use this function only if for some reason you need to create a archive
 * yourself. If you just want to pack data for your game it is recommended
 * to use the commandline utility 'sga' which is in the 'tools' directory.
 */
void sgeCreateFile(const char *filename, char *filenames[], Uint32 numberOfFiles, const char *encryptionkey);

/**
 * @brief Return the index a file is in the archives lookup table
 * @param f A SGEFILE oject
 * @param filename The filename to search for
 * @return A integer with the index of the file
 */
int sgeGetFileIndex(SGEFILE *f, const char *filename);

/**
 * @brief Return the size of a file in the archive
 * @param f A SGEFILE oject
 * @param filename The filename to search for
 * @return The size of the file
 */
Uint32 sgeGetFileSize(SGEFILE *f, const char *filename);

/**
 * @brief Read a file from the archive to memory
 * @param f A SGEFILE object
 * @param filename The filename to read
 * @return A void pointer to the file data
 */
void *sgeReadFile(SGEFILE *f, const char *filename);

/**
 * @brief Read a video accelerated image file from archive
 * @param f A SGEFILE object
 * @param filename The filename to read
 * @return A video accelerated SDL_Surface struct with the image
 *
 * The image will be hold in video ram if possible, use only
 * on images you really need for your actual game drawing functions.
 */
SDL_Surface *sgeReadImage(SGEFILE *f, const char *filename);

/**
 * @brief Read a image file from archive into RAM
 * @param f A SGEFILE object
 * @param filename The filename to read
 * @return A SDL_Surface struct with the image
 *
 * The image will be hold in the computers RAM. Use on images
 * that are not that important to draw fast, otherwise use @link sgeReadImage @endlink
 */
SDL_Surface *sgeReadImageMemory(SGEFILE *f, const char *filename);

/**
 * @brief Read a sound file from archive
 * @param f A SGEFILE object
 * @param filename The filename to read
 * @return A Mix_Chunk struct with the sound file
 */
Mix_Chunk *sgeReadSound(SGEFILE *f, const char *filename);

/**
 * @brief Duplicate a sdl surface
 * @param s A SDL_Surface aka image
 * @return A copy of s
 */
SDL_Surface *sgeDuplicateSDLSurface(SDL_Surface *s);

// }@

#ifdef __cplusplus
}
#endif

#endif
