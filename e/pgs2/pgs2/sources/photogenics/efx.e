OPT MODULE
OPT EXPORT

CONST EFX_24BIT = 1                 ->Works with 24-bit data
CONST EFX_8GREY = 2                 ->Works with 8-bit greyscale (not yet!)
CONST EFX_1BIT = 4                 ->Works with monochrome (not yet!)
CONST EFX_INDEXED = 8               ->Works with indexed colour (not yet!)
CONST EFX_NOOPTIONS = 16            ->Effect has no options.
CONST EFX_USESECOND = 32            ->Effect uses (and requires) secondary
CONST EFX_NEEDSUNDO = 64            ->Effect needs an undo (seperate destination)
CONST EFX_VALIDFORNEW = 256     ->Effect can be applied as a valid op to a new (blank) page.
CONST EFX_FULLSCREENONLY = 512  ->Effect cannot be applied to a region, only the full image.
