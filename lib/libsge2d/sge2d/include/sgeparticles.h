#ifndef _SGEPARTICLES_H
#define _SGEPARTICLES_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgeparticles.h
 * @brief Particle system
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeParticles
 * @brief Particle system
 *
 * There are currently two types of particle systems:
 * Pixel particles, which are repesented by a single pixel
 * on screen and allow a color variation, and sprite
 * particles, which are represented by a @link SGESPRITE @endlink
 *
 * After creating the particle emitter, you have a number of
 * configuration options, most of them allow you to specify
 * a ...Distribution.
 *
 * This value allows you to specify a +/- range of the values.
 * For example, if you have a emitters angle set to 90 degrees, and
 * its angleDistribution to 60 degrees, particles emit in a random range
 * of 90-30 to 90+30, so a random range of 60 to 120 degrees.
 *
 * @{
 */

/**
 * @brief @b internal, holds information of a pixel particle
 */
typedef struct {
	/** @privatesection */
	Uint32 timeToLive;
	float speed;
	float angle;
	float x,y;
	float gravity;
	Uint32 color;
} SGEPIXELPARTICLE;

/**
 * @brief @b internal, holds color information of a pixel particle
 */
typedef struct {
	/** @privatesection */
	Uint8 r1,g1,b1;
	Uint8 r2,g2,b2;
} SGEPIXELPARTICLEDATA;

/**
 * @brief @b internal, holds information of a sprite particle
 */
typedef struct {
	/** @privatesection */
	Uint32 timeToLive;
	float speed;
	float angle;
	float x,y;
	float gravity;
} SGESPRITEPARTICLE;

/**
 * @brief @b internal, holds image representation of a sprite particle
 */
typedef struct {
	/** @privatesection */
	SGESPRITE *sprite;
} SGESPRITEPARTICLEDATA;

/**
 * @struct SGEPARTICLES
 * @brief a structure holding necessary information about a particle emitter and providing a lot of variables for configuration
 */
typedef struct {
	/** @brief the SDL_Surface to draw the particles on, defaults to screen */
	SDL_Surface *drawSurface;

	/** @brief the runtime of the particles emitter in frames */
	Uint32 runtime;

	/** @brief a @link SGEARRAY @endlink holding the particles */
	SGEARRAY *particles;

	/** @brief YES/NO if the particles should live forever, defaults to NO */
	Uint32 infinite;

	/** @brief the emitters x coordinate */
	Uint32 x;

	/** @brief the emitters y coordinate */
	Uint32 y;

	/** @brief the time to live for particles in frames */
	Uint32 timeToLive;

	/** @brief a range the timeToLive will vary, it is +/-, so timeToLive=100 and timeToLiveDistribution=50 will give values of 100-25 to 100+25, so 75 to 125 */
	Uint32 timeToLiveDistribution;

	/** @brief the number of particles created per frame as float, so values of less then 1 are possible */
	float emission;

	/** @brief the +/- range of the emission */
	float emissionDistribution;

	/** @brief the speed of the particles */
	float speed;

	/** @brief the +/- range of the particle speed */
	float speedDistribution;

	/** @brief the angle at which particles are fired at in degrees */
	float angle;

	/** @brief the +/- range of the angle in degrees */
	float angleDistribution;

	/** @brief the gravity pixels are influenced by along the y axis */
	float gravity;

	/** @privatesection */
	void *custom;
	void (*customDestroy)(void *);
	Uint32 (*draw)(Uint32, void *);
	void *(*create)(void *);
	float internalEmission;
} SGEPARTICLES;

/**
 * @brief create a new pixel emitter
 * @param r1 the red value of the first color
 * @param g1 the green value of the first color
 * @param b1 the blue value of the first color
 * @param r2 the red value of the second color
 * @param g2 the green value of the second color
 * @param b2 the blue value of the second color
 * @return a pointer to @link SGEPARTICLES @endlink
 * @see SGEPARTICLES
 *
 * The two colors specify a range of colors within the
 * created pixel particles are.
 */
SGEPARTICLES *sgeParticlesPixelNew(Uint8 r1, Uint8 g1, Uint8 b1, Uint8 r2, Uint8 g2, Uint8 b2);

/**
 * @brief create a new sprite particle emitter
 * @param a pointer to @link SGESPRITE @endlink which is used as particle image
 * @return a pointer to @link SGEPARTICLES @endlink
 * @see SGEPARTICLES
 */
SGEPARTICLES *sgeParticlesSpriteNew(SGESPRITE *sprite);

/**
 * @brief destroy a @link SGEPARTICLES @endlink structure and free its resources
 * @param p a pointer to @link SGEPARTICLES @endlink
 */
void sgeParticlesDestroy(SGEPARTICLES *p);

/**
 * @brief draw the particles on the destination surface
 * @param p a pointer to @link SGEPARTICLES @endlink
 */
void sgeParticlesDraw(SGEPARTICLES *p);

/** @privatesection */
float sgeParticlesGetNewEmission(SGEPARTICLES *p);
Uint32 sgeParticlesGetNewTimeToLive(SGEPARTICLES *p);
float sgeParticlesGetNewSpeed(SGEPARTICLES *p);
float sgeParticlesGetNewAngle(SGEPARTICLES *p);
float sgeParticlesGetNewX(float x, float angle, float speed);
float sgeParticlesGetNewY(float y, float angle, float speed, float gravity);

void *sgePixelParticleNew(void *p);
void sgePixelParticleDestroy(Uint32 arrayidx, void *particle);
Uint32 sgePixelParticleDraw(Uint32 arrayidx, void *p);
void sgeParticlesPixelCustomDestroy(void *data);

void *sgeSpriteParticleNew(void *p);
void sgeSpriteParticleDestroy(Uint32 arrayidx, void *particle);
Uint32 sgeSpriteParticleDraw(Uint32 arrayidx, void *p);
void sgeParticlesSpriteCustomDestroy(void *data);

SGEPARTICLES *sgeParticlesNew(
		void *(*createFunction)(void *),
		Uint32 (*drawFunction)(Uint32, void *),
		void (*freeFunction)(Uint32, void *)
);

// }@

#ifdef __cplusplus
}
#endif

#endif
