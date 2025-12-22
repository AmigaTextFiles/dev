#ifndef GUI_LOCALE_H
#define GUI_LOCALE_H

/* This file was generated automatically by IEditor!
   Do NOT edit by hand!
 */

/*************************************************************************/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifdef CATCOMP_ARRAY
#undef CATCOMP_NUMBERS
#define CATCOMP_NUMBERS
#endif

struct CatCompArrayType
{
	LONG	cca_ID;
	STRPTR	cca_Str;
};

/*************************************************************************/

#ifdef CATCOMP_NUMBERS

#define REQ_OPENW  0
#define REQ_SETIDCMP  1
#define REQ_SETFLAGS  2
#define REQ_GADTYPE  3
#define ASL_LOADGUI  4
#define ASL_SAVE_GUI  5
#define ASL_SAVE_WND  6
#define ASL_LOAD_WND  7
#define MSG_HERE_I_AM  8
#define MSG_OPEN_WND  9
#define MSG_CLOSE_WND  10
#define MSG_DELETED_WND  11
#define MSG_DELETED_ALLWNDS  12
#define MSG_ALREADY_OPEN  13
#define ERR_NOMEMORY  14
#define ERR_NOWND  15
#define MSG_ABORTED  16
#define MSG_DONE  17
#define ERR_CLOSEWB  18
#define ERR_NOWB  19
#define ERR_NOASL  20
#define ERR_IOERR  21
#define MSG_SAVING  22
#define MSG_SAVED  23
#define MSG_LOADED  24
#define MSG_WND_SAVED  25
#define ERR_DATA_FORMAT  26
#define MSG_LOADING  27
#define MSG_WND_LOADED  28
#define ERR_NOT_A_WND  29
#define ERR_NOT_PROJECT  30
#define MSG_DEMO  31
#define ANS_DEMO  32
#define MSG_ABOUT  33
#define MSG_DELETE_OR_NOT  34
#define MSG_GUI_NOT_SAVED  35
#define MSG_WRONG_VERSION  36
#define ANS_YES_NO  37
#define ANS_SAVE_QUIT_CANCEL  38
#define MSG_CREATE  39
#define MSG_SOURCE_CREATED  40
#define MSG_GAD_SAVED  41
#define MSG_GAD_LOADED  42
#define ERR_NOWND2  43
#define MSG_GAD_DELETED  44
#define MSG_GAD_ALIGNED  45
#define MSG_CLICK  46
#define MSG_RESIZE  47
#define ASL_LOAD_GAD  48
#define ASL_SAVE_GAD  49
#define ERR_NO_GADGETS  50
#define MSG_DRAW_GAD  51
#define MSG_GAD_ADDED  52
#define MSG_GAD_FAIL  53
#define MSG_SELECT  54
#define REQ_GAD_ITEMS  55
#define ASL_GAD_FONT  56
#define MSG_TWO_ITEMS  57
#define MSG_DELETE_GAD  58
#define ASL_SCR_FONT  59
#define ASL_SCR_TYPE  60
#define REQ_MODIFY_PALETTE  61
#define ASL_LOAD_PALETTE  62
#define ASL_SAVE_PALETTE  63
#define ERR_NOT_ILBM  64
#define ERR_NO_CMAP  65
#define ERR_NO_ASL  66
#define ASL_LOAD_SCR  67
#define ASL_SAVE_SCR  68
#define ERR_NO_SCR  69
#define ASL_LOADIMG  70
#define MSG_IMGUSED  71
#define REQ_GETIMG  72
#define ERR_PRINTERR  73
#define MSG_PRINTING  74
#define MSG_SYSINFO  75
#define ANS_MORE_CONT  76
#define MSG_UPDATESCR  77
#define ASL_GET_MACRO  78
#define ERR_NOREXX  79
#define MSG_NOOTHERWND  80
#define MSG_DRAWBBOX  81
#define MSG_NO_DISKFONT  82
#define MSG_SELECTIMG  83
#define REQ_GETTEXT  84
#define MSG_MOVETEXT  85
#define ASL_TEXTFONT  86
#define MSG_SELECTBOX  87
#define ERR_NOT_SUPPORTED  88
#define ASL_GET_CATALOG  89
#define MSG_LOADERS_NOTFOUND  90
#define MSG_NO_IEX  91
#define REQ_GETGADGETBANK  92
#define ERR_DUPLICATE_KEY  93
#define ASL_IMPORT_STRINGS  94
#define ASL_SELECT_CT  95
#define MSG_STRING_0 96
#define MSG_STRING_1 97
#define MSG_STRING_2 98
#define MSG_STRING_3 99
#define MSG_STRING_4 100
#define MSG_STRING_5 101
#define MSG_STRING_6 102
#define MSG_STRING_7 103
#define MSG_STRING_8 104
#define MSG_STRING_9 105
#define MSG_STRING_10 106
#define MSG_STRING_11 107
#define MSG_STRING_12 108
#define MSG_STRING_13 109
#define MSG_STRING_14 110
#define MSG_STRING_15 111
#define MSG_STRING_16 112
#define MSG_STRING_17 113
#define MSG_STRING_18 114
#define MSG_STRING_19 115
#define MSG_STRING_20 116
#define MSG_STRING_21 117
#define MSG_STRING_22 118
#define MSG_STRING_23 119
#define MSG_STRING_24 120
#define MSG_STRING_25 121
#define MSG_STRING_26 122
#define MSG_STRING_27 123
#define MSG_STRING_28 124
#define MSG_STRING_29 125
#define MSG_STRING_30 126
#define MSG_STRING_31 127
#define MSG_STRING_32 128
#define MSG_STRING_33 129
#define MSG_STRING_34 130
#define MSG_STRING_35 131
#define MSG_STRING_36 132
#define MSG_STRING_37 133
#define MSG_STRING_38 134
#define MSG_STRING_39 135
#define MSG_STRING_40 136
#define MSG_STRING_41 137
#define MSG_STRING_42 138
#define MSG_STRING_43 139
#define MSG_STRING_44 140
#define MSG_STRING_45 141
#define MSG_STRING_46 142
#define MSG_STRING_47 143
#define MSG_STRING_48 144
#define MSG_STRING_49 145
#define MSG_STRING_50 146
#define MSG_STRING_51 147
#define MSG_STRING_52 148
#define MSG_STRING_53 149
#define MSG_STRING_54 150
#define MSG_STRING_55 151
#define MSG_STRING_56 152
#define MSG_STRING_57 153
#define MSG_STRING_58 154
#define MSG_STRING_59 155
#define MSG_STRING_60 156
#define MSG_STRING_61 157
#define MSG_STRING_62 158
#define MSG_STRING_63 159
#define MSG_STRING_64 160
#define MSG_STRING_65 161
#define MSG_STRING_66 162
#define MSG_STRING_67 163
#define MSG_STRING_68 164
#define MSG_STRING_69 165
#define MSG_STRING_70 166
#define MSG_STRING_71 167
#define MSG_STRING_72 168
#define MSG_STRING_73 169
#define MSG_STRING_74 170
#define MSG_STRING_75 171
#define MSG_STRING_76 172
#define MSG_STRING_77 173
#define MSG_STRING_78 174
#define MSG_STRING_79 175
#define MSG_STRING_80 176
#define MSG_STRING_81 177
#define MSG_STRING_82 178
#define MSG_STRING_83 179
#define MSG_STRING_84 180
#define MSG_STRING_85 181
#define MSG_STRING_86 182
#define MSG_STRING_87 183
#define MSG_STRING_88 184
#define MSG_STRING_89 185
#define MSG_STRING_90 186
#define MSG_STRING_91 187
#define MSG_STRING_92 188
#define MSG_STRING_93 189
#define MSG_STRING_94 190
#define MSG_STRING_95 191
#define MSG_STRING_96 192
#define MSG_STRING_97 193
#define MSG_STRING_98 194
#define MSG_STRING_99 195
#define MSG_STRING_100 196
#define MSG_STRING_101 197
#define MSG_STRING_102 198
#define MSG_STRING_103 199
#define MSG_STRING_104 200
#define MSG_STRING_105 201
#define MSG_STRING_106 202
#define MSG_STRING_107 203
#define MSG_STRING_108 204
#define MSG_STRING_109 205
#define MSG_STRING_110 206
#define MSG_STRING_111 207
#define MSG_STRING_112 208
#define MSG_STRING_113 209
#define MSG_STRING_114 210
#define MSG_STRING_115 211
#define MSG_STRING_116 212
#define MSG_STRING_117 213
#define MSG_STRING_118 214
#define MSG_STRING_119 215
#define MSG_STRING_120 216
#define MSG_STRING_121 217
#define MSG_STRING_122 218
#define MSG_STRING_123 219
#define MSG_STRING_124 220
#define MSG_STRING_125 221
#define MSG_STRING_126 222
#define MSG_STRING_127 223
#define MSG_STRING_128 224
#define MSG_STRING_129 225
#define MSG_STRING_130 226
#define MSG_STRING_131 227
#define MSG_STRING_132 228
#define MSG_STRING_133 229
#define MSG_STRING_134 230
#define MSG_STRING_135 231
#define MSG_STRING_136 232
#define MSG_STRING_137 233
#define MSG_STRING_138 234
#define MSG_STRING_139 235
#define MSG_STRING_140 236
#define MSG_STRING_141 237
#define MSG_STRING_142 238
#define MSG_STRING_143 239
#define MSG_STRING_144 240
#define MSG_STRING_145 241
#define MSG_STRING_146 242
#define MSG_STRING_147 243
#define MSG_STRING_148 244
#define MSG_STRING_149 245
#define MSG_STRING_150 246
#define MSG_STRING_151 247
#define MSG_STRING_152 248
#define MSG_STRING_153 249
#define MSG_STRING_154 250
#define MSG_STRING_155 251
#define MSG_STRING_156 252
#define MSG_STRING_157 253
#define MSG_STRING_158 254
#define MSG_STRING_159 255
#define MSG_STRING_160 256
#define MSG_STRING_161 257
#define MSG_STRING_162 258
#define MSG_STRING_163 259
#define MSG_STRING_164 260
#define MSG_STRING_165 261
#define MSG_STRING_166 262
#define MSG_STRING_167 263
#define MSG_STRING_168 264
#define MSG_STRING_169 265
#define MSG_STRING_170 266
#define MSG_STRING_171 267
#define MSG_STRING_172 268
#define MSG_STRING_173 269
#define MSG_STRING_174 270
#define MSG_STRING_175 271
#define MSG_STRING_176 272
#define MSG_STRING_177 273
#define MSG_STRING_178 274
#define MSG_STRING_179 275
#define MSG_STRING_180 276
#define MSG_STRING_181 277
#define MSG_STRING_182 278
#define MSG_STRING_183 279
#define MSG_STRING_184 280
#define MSG_STRING_185 281
#define MSG_STRING_186 282
#define MSG_STRING_187 283
#define MSG_STRING_188 284
#define MSG_STRING_189 285
#define MSG_STRING_190 286
#define MSG_STRING_191 287
#define MSG_STRING_192 288
#define MSG_STRING_193 289
#define MSG_STRING_194 290
#define MSG_STRING_195 291
#define MSG_STRING_196 292
#define MSG_STRING_197 293
#define MSG_STRING_198 294
#define MSG_STRING_199 295
#define MSG_STRING_200 296
#define MSG_STRING_201 297
#define MSG_STRING_202 298
#define MSG_STRING_203 299
#define MSG_STRING_204 300
#define MSG_STRING_205 301
#define MSG_STRING_206 302
#define MSG_STRING_207 303
#define MSG_STRING_208 304
#define MSG_STRING_209 305
#define MSG_STRING_210 306
#define MSG_STRING_211 307
#define MSG_STRING_212 308
#define MSG_STRING_213 309
#define MSG_STRING_214 310
#define MSG_STRING_215 311
#define MSG_STRING_216 312
#define MSG_STRING_217 313
#define MSG_STRING_218 314
#define MSG_STRING_219 315
#define MSG_STRING_220 316
#define MSG_STRING_221 317
#define MSG_STRING_222 318
#define MSG_STRING_223 319
#define MSG_STRING_224 320
#define MSG_STRING_225 321
#define MSG_STRING_226 322
#define MSG_STRING_227 323
#define MSG_STRING_228 324
#define MSG_STRING_229 325
#define MSG_STRING_230 326
#define MSG_STRING_231 327
#define MSG_STRING_232 328
#define MSG_STRING_233 329
#define MSG_STRING_234 330
#define MSG_STRING_235 331
#define MSG_STRING_236 332
#define MSG_STRING_237 333
#define MSG_STRING_238 334
#define MSG_STRING_239 335
#define MSG_STRING_240 336
#define MSG_STRING_241 337
#define MSG_STRING_242 338
#define MSG_STRING_243 339
#define MSG_STRING_244 340
#define MSG_STRING_245 341
#define MSG_STRING_246 342
#define MSG_STRING_247 343
#define MSG_STRING_248 344
#define MSG_STRING_249 345
#define MSG_STRING_250 346
#define MSG_STRING_251 347
#define MSG_STRING_252 348
#define MSG_STRING_253 349
#define MSG_STRING_254 350
#define MSG_STRING_255 351
#define MSG_STRING_256 352
#define MSG_STRING_257 353
#define MSG_STRING_258 354
#define MSG_STRING_259 355
#define MSG_STRING_260 356
#define MSG_STRING_261 357
#define MSG_STRING_262 358
#define MSG_STRING_263 359
#define MSG_STRING_264 360
#define MSG_STRING_265 361
#define MSG_STRING_266 362
#define MSG_STRING_267 363
#define MSG_STRING_268 364
#define MSG_STRING_269 365
#define MSG_STRING_270 366
#define MSG_STRING_271 367
#define MSG_STRING_272 368
#define MSG_STRING_273 369
#define MSG_STRING_274 370
#define MSG_STRING_275 371
#define MSG_STRING_276 372
#define MSG_STRING_277 373
#define MSG_STRING_278 374
#define MSG_STRING_279 375
#define MSG_STRING_280 376
#define MSG_STRING_281 377
#define MSG_STRING_282 378
#define MSG_STRING_283 379
#define MSG_STRING_284 380
#define MSG_STRING_285 381
#define MSG_STRING_286 382
#define MSG_STRING_287 383
#define MSG_STRING_288 384
#define MSG_STRING_289 385
#define MSG_STRING_290 386
#define MSG_STRING_291 387
#define MSG_STRING_292 388
#define MSG_STRING_293 389
#define MSG_STRING_294 390
#define MSG_STRING_295 391
#define MSG_STRING_296 392
#define MSG_STRING_297 393
#define MSG_STRING_298 394
#define MSG_STRING_299 395
#define MSG_STRING_300 396
#define MSG_STRING_301 397
#define MSG_STRING_302 398
#define MSG_STRING_303 399
#define MSG_STRING_304 400
#define MSG_STRING_305 401
#define MSG_STRING_306 402
#define MSG_STRING_307 403
#define MSG_STRING_308 404
#define MSG_STRING_309 405
#define MSG_STRING_310 406
#define MSG_STRING_311 407
#define MSG_STRING_312 408
#define MSG_STRING_313 409
#define MSG_STRING_314 410
#define MSG_STRING_315 411
#define MSG_STRING_316 412
#define MSG_STRING_317 413
#define MSG_STRING_318 414
#define MSG_STRING_319 415
#define MSG_STRING_320 416
#define MSG_STRING_321 417
#define MSG_STRING_322 418
#define MSG_STRING_323 419
#define MSG_STRING_324 420
#define MSG_STRING_325 421
#define MSG_STRING_326 422
#define MSG_STRING_327 423
#define MSG_STRING_328 424
#define MSG_STRING_329 425
#define MSG_STRING_330 426
#define MSG_STRING_331 427
#define MSG_STRING_332 428
#define MSG_STRING_333 429
#define MSG_STRING_334 430
#define MSG_STRING_335 431
#define MSG_STRING_336 432
#define MSG_STRING_337 433
#define MSG_STRING_338 434
#define MSG_STRING_339 435
#define MSG_STRING_340 436
#define MSG_STRING_341 437
#define MSG_STRING_342 438
#define MSG_STRING_343 439
#define MSG_STRING_344 440
#define MSG_STRING_345 441
#define MSG_STRING_346 442
#define MSG_STRING_347 443
#define MSG_STRING_348 444
#define MSG_STRING_349 445
#define MSG_STRING_350 446
#define MSG_STRING_351 447
#define MSG_STRING_352 448
#define MSG_STRING_353 449
#define MSG_STRING_354 450
#define MSG_STRING_355 451
#define MSG_STRING_356 452
#define MSG_STRING_357 453
#define MSG_STRING_358 454
#define MSG_STRING_359 455
#define MSG_STRING_360 456
#define MSG_STRING_361 457
#define MSG_STRING_362 458
#define MSG_STRING_363 459
#define MSG_STRING_364 460
#define MSG_STRING_365 461
#define MSG_STRING_366 462
#define MSG_STRING_367 463
#define MSG_STRING_368 464
#define MSG_STRING_369 465
#define MSG_STRING_370 466
#define MSG_STRING_371 467
#define MSG_STRING_372 468
#define MSG_STRING_373 469
#define MSG_STRING_374 470
#define MSG_STRING_375 471
#define MSG_STRING_376 472
#define MSG_STRING_377 473
#define MSG_STRING_378 474
#define MSG_STRING_379 475
#define MSG_STRING_380 476
#define MSG_STRING_381 477
#define MSG_STRING_382 478
#define MSG_STRING_383 479
#define MSG_STRING_384 480
#define MSG_STRING_385 481
#define MSG_STRING_386 482
#define MSG_STRING_387 483
#define MSG_STRING_388 484
#define MSG_STRING_389 485
#define MSG_STRING_390 486
#define MSG_STRING_391 487
#define MSG_STRING_392 488
#define MSG_STRING_393 489
#define MSG_STRING_394 490
#define MSG_STRING_395 491
#define MSG_STRING_396 492
#define MSG_STRING_397 493
#define MSG_STRING_398 494
#define MSG_STRING_399 495
#define MSG_STRING_400 496
#define MSG_STRING_401 497
#define MSG_STRING_402 498
#define MSG_STRING_403 499
#define MSG_STRING_404 500
#define MSG_STRING_405 501
#define MSG_STRING_406 502
#define MSG_STRING_407 503
#define MSG_STRING_408 504
#define MSG_STRING_409 505
#define MSG_STRING_410 506
#define MSG_STRING_411 507
#define MSG_STRING_412 508
#define MSG_STRING_413 509
#define MSG_STRING_414 510
#define MSG_STRING_415 511
#define MSG_STRING_416 512
#define MSG_STRING_417 513
#define MSG_STRING_418 514
#define MSG_STRING_419 515
#define MSG_STRING_420 516
#define MSG_STRING_421 517
#define MSG_STRING_422 518
#define MSG_STRING_423 519
#define MSG_STRING_424 520
#define MSG_STRING_425 521
#define MSG_STRING_426 522
#define MSG_STRING_427 523
#define MSG_STRING_428 524
#define MSG_STRING_429 525
#define MSG_STRING_430 526
#define MSG_STRING_431 527

#endif /* CATCOMP_NUMBERS */

/*************************************************************************/

#ifdef CATCOMP_ARRAY

struct CatCompArrayType CatCompArray[] =
{
	{REQ_OPENW ,"Scegli una finestra:"},
	{REQ_SETIDCMP ,"Setta gli IDCMP..."},
	{REQ_SETFLAGS ,"Setta i flags..."},
	{REQ_GADTYPE ,"Tipo del gadget:"},
	{ASL_LOADGUI ,"Carica interfaccia..."},
	{ASL_SAVE_GUI ,"Salva interfaccia..."},
	{ASL_SAVE_WND ,"Salva finestra..."},
	{ASL_LOAD_WND ,"Carica finestra..."},
	{MSG_HERE_I_AM ,"Eccomi!"},
	{MSG_OPEN_WND ,"Finestra aperta."},
	{MSG_CLOSE_WND ,"Finestra chiusa."},
	{MSG_DELETED_WND ,"Finestra eliminata."},
	{MSG_DELETED_ALLWNDS ,"Eliminate tutte le finestre."},
	{MSG_ALREADY_OPEN ,"È già aperta..."},
	{ERR_NOMEMORY ,"Memoria insufficiente!"},
	{ERR_NOWND ,"Impossibile aprire finestra!"},
	{MSG_ABORTED ,"Operazione annullata."},
	{MSG_DONE ,"Modifica effettuata."},
	{ERR_CLOSEWB ,"Impossibile chiudere il WB!"},
	{ERR_NOWB ,"Impossibile riaprire il WB!"},
	{ERR_NOASL ,"Niente requester... Sorry."},
	{ERR_IOERR ,"Errore di I/O !"},
	{MSG_SAVING ,"Salvataggio in corso..."},
	{MSG_SAVED ,"Interfaccia salvata."},
	{MSG_LOADED ,"Interfaccia caricata."},
	{MSG_WND_SAVED ,"Finestra salvata."},
	{ERR_DATA_FORMAT ,"Formato file sconosciuto!"},
	{MSG_LOADING ,"Caricamento in corso..."},
	{MSG_WND_LOADED ,"Finestra caricata."},
	{ERR_NOT_A_WND ,"Non è una finestra!"},
	{ERR_NOT_PROJECT ,"Non è un file Project!"},
	{MSG_DEMO ,"Questa è la versione dimostrativa !\nNon pretenderai che sia completa? ;)"},
	{ANS_DEMO ,"Corro a registrarmi!"},
	{MSG_ABOUT ,"Interface Editor v2 - ©1994-97 Simone Tellini\n\n   Interfaccia del programma disegnata con\n\n          Interface Editor 2.x  ;-)\n\n\n   Questo programma è SHAREWARE, NON PD!!!\n\n    Per registrarti invia LIT. 30.000 a:\n\n           Simone Tellini\n           Piazza Resistenza 2\n           42016  Guastalla  RE\n           ITALY\n\n   FidoNet:   2:332/502.18  (Simone Tellini)\n   InterNet:  wiz@pragmanet.it"},
	{MSG_DELETE_OR_NOT ,"Ciò  che  viene  eliminato\nNON  è  più   recuperabile!\nProcedo con l'eliminazione?"},
	{MSG_GUI_NOT_SAVED ,"L'interfaccia attuale non è stata\nsalvata.   Uscendo  adesso  verrà\npersa."},
	{MSG_WRONG_VERSION ,"Versione del file non supportata!"},
	{ANS_YES_NO ,"_Sì|_No"},
	{ANS_SAVE_QUIT_CANCEL ,"_Salva|_Esci|_Annulla"},
	{MSG_CREATE ,"Genera sorgente..."},
	{MSG_SOURCE_CREATED ,"Sorgente creato."},
	{MSG_GAD_SAVED ,"Gadgets salvati."},
	{MSG_GAD_LOADED ,"Gadgets caricati."},
	{ERR_NOWND2 ,"La finestra non si è aperta!"},
	{MSG_GAD_DELETED ,"Gadgets eliminati!"},
	{MSG_GAD_ALIGNED ,"Gadgets allineati."},
	{MSG_CLICK ,"Click su un gadget..."},
	{MSG_RESIZE ,"Ridimensiona..."},
	{ASL_LOAD_GAD ,"Carica gadgets..."},
	{ASL_SAVE_GAD ,"Salva gadgets..."},
	{ERR_NO_GADGETS ,"Il file non contiene gadgets!"},
	{MSG_DRAW_GAD ,"Traccia il gadget..."},
	{MSG_GAD_ADDED ,"Gadget aggiunto."},
	{MSG_GAD_FAIL ,"Creazione gadget fallita."},
	{MSG_SELECT ,"Selezione..."},
	{REQ_GAD_ITEMS ,"Scelte gadget..."},
	{ASL_GAD_FONT ,"Font per il gadget..."},
	{MSG_TWO_ITEMS ,"Sono necessarie minimo DUE scelte!"},
	{MSG_DELETE_GAD ,"Vuoi davvero eliminare\ni gadgets selezionati?"},
	{ASL_SCR_FONT ,"Scegli un font per lo schermo..."},
	{ASL_SCR_TYPE ,"Scegli il tipo di schermo..."},
	{REQ_MODIFY_PALETTE ,"Modifica palette..."},
	{ASL_LOAD_PALETTE ,"Carica palette..."},
	{ASL_SAVE_PALETTE ,"Salva palette..."},
	{ERR_NOT_ILBM ,"Non è un file ILBM!"},
	{ERR_NO_CMAP ,"CMAP non trovata!"},
	{ERR_NO_ASL ,"Impossibile aprire Asl Req!"},
	{ASL_LOAD_SCR ,"Carica schermo..."},
	{ASL_SAVE_SCR ,"Salva schermo..."},
	{ERR_NO_SCR ,"Non è un file schermo!"},
	{ASL_LOADIMG ,"Carica un'immagine..."},
	{MSG_IMGUSED ,"Questa immagine è utilizzata\nnell'interfaccia   corrente.\n\nProcedo  con l'eliminazione?"},
	{REQ_GETIMG ,"Scegli un'immagine:"},
	{ERR_PRINTERR ,"Errore di stampa!"},
	{MSG_PRINTING ,"Stampa in corso..."},
	{MSG_SYSINFO ,"Questa copia di Interface Editor è registrata a:\n%s\nNumero seriale: %ld\n\n\nNome schermo:   %s\nPorta ARexx:    %s\n\nMemoria libera:\n             CHIP:   %10ld\n             FAST:   %10ld\n             ------------------\n                     %10ld"},
	{ANS_MORE_CONT ,"_Ancora|_Continua"},
	{MSG_UPDATESCR ,"Interface Editor deve aggiornare\nil suo schermo.   Chiudere tutte\nle   finestre    visitatrici   e\nclickare su Ok."},
	{ASL_GET_MACRO ,"Seleziona una macro ARexx..."},
	{ERR_NOREXX ,"Non posso inviare il messaggio a RexxMaster!"},
	{MSG_NOOTHERWND ,"Ora non puoi cambiare finestra!"},
	{MSG_DRAWBBOX ,"Traccia il BevelBox..."},
	{MSG_NO_DISKFONT ,"Non è stato possibile aprire uno o\npiù disk fonts: al loro posto sarà\nusato il font dello schermo.\nSalvando la  GUI  o  generando  il\nsorgente verrà comunque  usato  il\nfont originale."},
	{MSG_SELECTIMG ,"Seleziona un'immagine..."},
	{REQ_GETTEXT ,"Scegli un IntuiText..."},
	{MSG_MOVETEXT ,"Sposta il testo..."},
	{ASL_TEXTFONT ,"Scegli un font per il testo..."},
	{MSG_SELECTBOX ,"Seleziona un Bevel Box..."},
	{ERR_NOT_SUPPORTED ,"Operazione non supportata!"},
	{ASL_GET_CATALOG ,"Seleziona un catalogo..."},
	{MSG_LOADERS_NOTFOUND ,"Loaders non trovati."},
	{MSG_NO_IEX ,"Il loader non ha trovato uno o più moduli esterni\nusati in questa GUI: gli oggetti sconosciuti sono\nquindi  stati   saltati   e  non  sarà  possibile\nsalvarli con resto dell'interfaccia o averli  nel\nsorgente generato."},
	{REQ_GETGADGETBANK ,"Scegli un banco di gadgets:"},
	{ERR_DUPLICATE_KEY ,"Tasto di attivazione duplicato!"},
	{ASL_IMPORT_STRINGS ,"Importa stringhe..."},
	{ASL_SELECT_CT ,"Scegli un file .ct"},
	{MSG_STRING_0,"Interface Editor v2.32 - ©1994-97 Simone Tellini. All Rights Reserved."},
	{MSG_STRING_1,"_Pens"},
	{MSG_STRING_2,"DETAILPEN"},
	{MSG_STRING_3,"BLOCKPEN"},
	{MSG_STRING_4,"TEXTPEN"},
	{MSG_STRING_5,"SHINEPEN"},
	{MSG_STRING_6,"SHADOWPEN"},
	{MSG_STRING_7,"FILLPEN"},
	{MSG_STRING_8,"FILLTEXTPEN"},
	{MSG_STRING_9,"BACKGROUNDPEN"},
	{MSG_STRING_10,"HIGHLIGHTTEXTPEN"},
	{MSG_STRING_11,"BARDETAILPEN"},
	{MSG_STRING_12,"BARBLOCKPEN"},
	{MSG_STRING_13,"BARTRIMPEN"},
	{MSG_STRING_14,"Pa_lette"},
	{MSG_STRING_15,"_Ok"},
	{MSG_STRING_16,"_Annulla"},
	{MSG_STRING_17,"Progetto"},
	{MSG_STRING_18,"Informazioni..."},
	{MSG_STRING_19,"?"},
	{MSG_STRING_20,"Nuovo"},
	{MSG_STRING_21,"Carica..."},
	{MSG_STRING_22,"C"},
	{MSG_STRING_23,"Salva"},
	{MSG_STRING_24,"S"},
	{MSG_STRING_25,"Salva come..."},
	{MSG_STRING_26,"Parametri..."},
	{MSG_STRING_27,"0"},
	{MSG_STRING_28,"Fine"},
	{MSG_STRING_29,"Q"},
	{MSG_STRING_30,"Finestre"},
	{MSG_STRING_31,"Nuova..."},
	{MSG_STRING_32,"F"},
	{MSG_STRING_33,"Apri..."},
	{MSG_STRING_34,"("},
	{MSG_STRING_35,"Chiudi"},
	{MSG_STRING_36,"K"},
	{MSG_STRING_37,"Chiudi tutte"},
	{MSG_STRING_38,")"},
	{MSG_STRING_39,"Elimina"},
	{MSG_STRING_40,"/"},
	{MSG_STRING_41,"Elimina tutte"},
	{MSG_STRING_42,"!"},
	{MSG_STRING_43,"Titolo"},
	{MSG_STRING_44,"Flags..."},
	{MSG_STRING_45,"L"},
	{MSG_STRING_46,"IDCMP..."},
	{MSG_STRING_47,"I"},
	{MSG_STRING_48,"Dimensioni..."},
	{MSG_STRING_49,"Zoom..."},
	{MSG_STRING_50,"Z"},
	{MSG_STRING_51,"Tags..."},
	{MSG_STRING_52,"T"},
	{MSG_STRING_53,"Bevel Box"},
	{MSG_STRING_54,"Aggiungi"},
	{MSG_STRING_55,"J"},
	{MSG_STRING_56,"Modifica..."},
	{MSG_STRING_57,"Immagini"},
	{MSG_STRING_58,"Sposta"},
	{MSG_STRING_59,"Testi"},
	{MSG_STRING_60,"Aggiungi..."},
	{MSG_STRING_61,"Elimina..."},
	{MSG_STRING_62,"Sposta..."},
	{MSG_STRING_63,"Banco di gadget"},
	{MSG_STRING_64,"Crea..."},
	{MSG_STRING_65,"Mostra..."},
	{MSG_STRING_66,"Nascondi..."},
	{MSG_STRING_67,"Stampa"},
	{MSG_STRING_68,"Salva..."},
	{MSG_STRING_69,"Gadgets"},
	{MSG_STRING_70,"G"},
	{MSG_STRING_71,"Rimuovi"},
	{MSG_STRING_72,"R"},
	{MSG_STRING_73,"Seleziona tutti"},
	{MSG_STRING_74,"U"},
	{MSG_STRING_75,"Scelte..."},
	{MSG_STRING_76,"A"},
	{MSG_STRING_77,"D"},
	{MSG_STRING_78,"Font..."},
	{MSG_STRING_79,"Allinea"},
	{MSG_STRING_80,"A destra"},
	{MSG_STRING_81,">"},
	{MSG_STRING_82,"A sinistra"},
	{MSG_STRING_83,"<"},
	{MSG_STRING_84,"In alto"},
	{MSG_STRING_85,"-"},
	{MSG_STRING_86,"In basso"},
	{MSG_STRING_87,"_"},
	{MSG_STRING_88,"Distribuisci"},
	{MSG_STRING_89,"Orizzontalmente"},
	{MSG_STRING_90,"Verticalmente"},
	{MSG_STRING_91,"Spaziatura"},
	{MSG_STRING_92,"Setta X..."},
	{MSG_STRING_93,"Setta Y..."},
	{MSG_STRING_94,"Clona"},
	{MSG_STRING_95,"Larghezza"},
	{MSG_STRING_96,"Altezza"},
	{MSG_STRING_97,"Entrambe"},
	{MSG_STRING_98,"="},
	{MSG_STRING_99,"Copia"},
	{MSG_STRING_100,"Ordine TabCycle..."},
	{MSG_STRING_101,"Schermo"},
	{MSG_STRING_102,"Tipo..."},
	{MSG_STRING_103,"*"},
	{MSG_STRING_104,"DriPens..."},
	{MSG_STRING_105,"+"},
	{MSG_STRING_106,"Colori"},
	{MSG_STRING_107,"Varie"},
	{MSG_STRING_108,"Menu editor..."},
	{MSG_STRING_109,"M"},
	{MSG_STRING_110,"Banco immagini..."},
	{MSG_STRING_111,"E"},
	{MSG_STRING_112,"ARexx editor..."},
	{MSG_STRING_113,"main()..."},
	{MSG_STRING_114,"Localizzazione..."},
	{MSG_STRING_115,"Macros"},
	{MSG_STRING_116,"Tasti funzione..."},
	{MSG_STRING_117,"Rimuovi..."},
	{MSG_STRING_118,"Esegui..."},
	{MSG_STRING_119,"Preferenze"},
	{MSG_STRING_120,"Finestra Strumenti"},
	{MSG_STRING_121,"Usa gadgets"},
	{MSG_STRING_122,","},
	{MSG_STRING_123,"Workbench"},
	{MSG_STRING_124,"Finestra corrente in primo piano"},
	{MSG_STRING_125,"'"},
	{MSG_STRING_126,"Usa i Flags settati"},
	{MSG_STRING_127,"."},
	{MSG_STRING_128,"Generatore..."},
	{MSG_STRING_129,"Crea icone?"},
	{MSG_STRING_130,"Memorizza"},
	{MSG_STRING_131,"Edit"},
	{MSG_STRING_132,"_Immagine"},
	{MSG_STRING_133,"---"},
	{MSG_STRING_134,"_BarLabel"},
	{MSG_STRING_135,"_Disabled"},
	{MSG_STRING_136,"_CheckIt"},
	{MSG_STRING_137,"Chec_ked"},
	{MSG_STRING_138,"_MenuToggle"},
	{MSG_STRING_139,"_Testo"},
	{MSG_STRING_140,"CommKe_y"},
	{MSG_STRING_141,"_Etichetta"},
	{MSG_STRING_142,"Title"},
	{MSG_STRING_143,"Item"},
	{MSG_STRING_144,"Sub"},
	{MSG_STRING_145,"Test"},
	{MSG_STRING_146,"Mutual Exclude"},
	{MSG_STRING_147,"OK"},
	{MSG_STRING_148,"Banco immagini"},
	{MSG_STRING_149,"_Nuova"},
	{MSG_STRING_150,"_Immagini:"},
	{MSG_STRING_151,"_Elimina"},
	{MSG_STRING_152,"_Testo  :"},
	{MSG_STRING_153,"_Draw Mode"},
	{MSG_STRING_154,"RP_JAM1"},
	{MSG_STRING_155,"RP_JAM2"},
	{MSG_STRING_156,"RP_COMPLEMENT"},
	{MSG_STRING_157,"_INVERSVID"},
	{MSG_STRING_158,"_Front Pen"},
	{MSG_STRING_159,"Bac_k Pen"},
	{MSG_STRING_160,"_Gadget Render"},
	{MSG_STRING_161,"Select _Render"},
	{MSG_STRING_162,"High_light"},
	{MSG_STRING_163,"GADGHNONE"},
	{MSG_STRING_164,"GADGHCOMP"},
	{MSG_STRING_165,"GADGHBOX"},
	{MSG_STRING_166,"GADGHIMAGE"},
	{MSG_STRING_167,"TOGGLESELE_CT :"},
	{MSG_STRING_168,"I_MMEDIATE    :"},
	{MSG_STRING_169,"REL_VERIFY    :"},
	{MSG_STRING_170,"FOLLOWMO_USE :"},
	{MSG_STRING_171,"_SELECTED    :"},
	{MSG_STRING_172,"DISA_BLED    :"},
	{MSG_STRING_173,"_*"},
	{MSG_STRING_174,"_OK"},
	{MSG_STRING_175,"_Etichetta :"},
	{MSG_STRING_176,"_X :"},
	{MSG_STRING_177,"_Y :"},
	{MSG_STRING_178,"_W :"},
	{MSG_STRING_179,"_H :"},
	{MSG_STRING_180,"Strumenti"},
	{MSG_STRING_181,"Ignora"},
	{MSG_STRING_182,"Escludi"},
	{MSG_STRING_183,"»"},
	{MSG_STRING_184,"«"},
	{MSG_STRING_185,"Annulla"},
	{MSG_STRING_186,"Parametri sorgente"},
	{MSG_STRING_187,"Genera _schermo"},
	{MSG_STRING_188,"_Font adaptive "},
	{MSG_STRING_189,"Open_DiskFonts "},
	{MSG_STRING_190,"_main()        "},
	{MSG_STRING_191,"Porta IDCMP _Condivisa"},
	{MSG_STRING_192,"_Back Pen "},
	{MSG_STRING_193,"_DrawMode"},
	{MSG_STRING_194,"_Text"},
	{MSG_STRING_195,"Fo_nt"},
	{MSG_STRING_196,"_ScreenFont"},
	{MSG_STRING_197,"_Comandi:"},
	{MSG_STRING_198,"_Nuovo"},
	{MSG_STRING_199,"ARexx _Port"},
	{MSG_STRING_200,"E_xt."},
	{MSG_STRING_201,"Comandi _in:"},
	{MSG_STRING_202,"Array"},
	{MSG_STRING_203,"Lista"},
	{MSG_STRING_204,"_Etichetta:"},
	{MSG_STRING_205,"_Command:"},
	{MSG_STRING_206,"_Template:"},
	{MSG_STRING_207,"arp.library"},
	{MSG_STRING_208,"asl.library"},
	{MSG_STRING_209,"commodities.library"},
	{MSG_STRING_210,"diskfont.library"},
	{MSG_STRING_211,"expansion.library"},
	{MSG_STRING_212,"gadtools.library"},
	{MSG_STRING_213,"graphics.library"},
	{MSG_STRING_214,"icon.library"},
	{MSG_STRING_215,"iffparse.library"},
	{MSG_STRING_216,"intuition.library"},
	{MSG_STRING_217,"keymap.library"},
	{MSG_STRING_218,"layers.library"},
	{MSG_STRING_219,"mathffp.library"},
	{MSG_STRING_220,"mathieeedoubbas.library"},
	{MSG_STRING_221,"mathieeedoubtrans.library"},
	{MSG_STRING_222,"mathieeesingbas.library"},
	{MSG_STRING_223,"mathieeesingtrans.library"},
	{MSG_STRING_224,"rexxsyslib.library"},
	{MSG_STRING_225,"reqtools.library"},
	{MSG_STRING_226,"translator.library"},
	{MSG_STRING_227,"utility.library"},
	{MSG_STRING_228,"workbench.library"},
	{MSG_STRING_229,"locale.library"},
	{MSG_STRING_230,"bullet.library"},
	{MSG_STRING_231,"datatypes.library"},
	{MSG_STRING_232,"xpkmaster.library"},
	{MSG_STRING_233,"dos.library"},
	{MSG_STRING_234,"OpenxxxWindow()"},
	{MSG_STRING_235,"CTRL C"},
	{MSG_STRING_236,"Extra Proc"},
	{MSG_STRING_237,"Extra Signals"},
	{MSG_STRING_238,"_Library"},
	{MSG_STRING_239,"_Base   "},
	{MSG_STRING_240,"_Version"},
	{MSG_STRING_241,"if (!(xBase)) then _FAIL;"},
	{MSG_STRING_242,"Titolo della finestra"},
	{MSG_STRING_243,"_Titolo:"},
	{MSG_STRING_244,"Dimensioni della finestra"},
	{MSG_STRING_245,"_Min Width :"},
	{MSG_STRING_246,"Ma_x Width :"},
	{MSG_STRING_247,"Min _Height:"},
	{MSG_STRING_248,"Max Hei_ght:"},
	{MSG_STRING_249,"_Inner Width :"},
	{MSG_STRING_250,"I_nner Height:"},
	{MSG_STRING_251,"_Left  :"},
	{MSG_STRING_252,"_Top   :"},
	{MSG_STRING_253,"_Width :"},
	{MSG_STRING_254,"_Height:"},
	{MSG_STRING_255,"_Usa             "},
	{MSG_STRING_256,"Tags della finestra"},
	{MSG_STRING_257,"_Screen Title"},
	{MSG_STRING_258,"Auto Ad_just "},
	{MSG_STRING_259,"_Fall Back   "},
	{MSG_STRING_260,"_MouseQueue     "},
	{MSG_STRING_261,"_RptQueue       "},
	{MSG_STRING_262,"Notify _Depth"},
	{MSG_STRING_263,"Menu _Help   "},
	{MSG_STRING_264,"_Tablet Messages"},
	{MSG_STRING_265,"_Gadgets"},
	{MSG_STRING_266,"T_itolo      "},
	{MSG_STRING_267,"Scr_een Title"},
	{MSG_STRING_268,"Men_us  "},
	{MSG_STRING_269,"IntuiTe_xt"},
	{MSG_STRING_270,"Bac_kfill    "},
	{MSG_STRING_271,"Localizza"},
	{MSG_STRING_272,"Dimensioni gadget..."},
	{MSG_STRING_273,"_Titolo"},
	{MSG_STRING_274,"_Label "},
	{MSG_STRING_275,"_Posizione"},
	{MSG_STRING_276,"Left"},
	{MSG_STRING_277,"Right"},
	{MSG_STRING_278,"Above"},
	{MSG_STRING_279,"Below"},
	{MSG_STRING_280,"In"},
	{MSG_STRING_281,"Default"},
	{MSG_STRING_282,"_Underscore"},
	{MSG_STRING_283,"H_ighlight"},
	{MSG_STRING_284,"Imm_ediate"},
	{MSG_STRING_285,"_Checked"},
	{MSG_STRING_286,"_Scaled  "},
	{MSG_STRING_287,"_Number   "},
	{MSG_STRING_288,"_Max Chars"},
	{MSG_STRING_289,"_Justification"},
	{MSG_STRING_290,"LEFT"},
	{MSG_STRING_291,"RIGHT"},
	{MSG_STRING_292,"CENTER"},
	{MSG_STRING_293,"Imm_ediate   "},
	{MSG_STRING_294,"Tab_Cycle"},
	{MSG_STRING_295,"Exit_Help"},
	{MSG_STRING_296,"_Replace Mode"},
	{MSG_STRING_297,"Tito_lo"},
	{MSG_STRING_298,"La_bel "},
	{MSG_STRING_299,"_Top         "},
	{MSG_STRING_300,"Make _Visible"},
	{MSG_STRING_301,"_Selected    "},
	{MSG_STRING_302,"Scroll _Width"},
	{MSG_STRING_303,"Spa_cing     "},
	{MSG_STRING_304,"_Read Only"},
	{MSG_STRING_305,"S_how Selected"},
	{MSG_STRING_306,"Ite_m Height"},
	{MSG_STRING_307,"Ma_x Pen    "},
	{MSG_STRING_308,"Multi S_elect"},
	{MSG_STRING_309,"Acti_ve"},
	{MSG_STRING_310,"_Spacing"},
	{MSG_STRING_311,"Titl_e Place"},
	{MSG_STRING_312,"ABOVE"},
	{MSG_STRING_313,"BELOW"},
	{MSG_STRING_314,"S_caled"},
	{MSG_STRING_315,"Ma_x Number Len"},
	{MSG_STRING_316,"_Front Pen     "},
	{MSG_STRING_317,"_Back Pen      "},
	{MSG_STRING_318,"GTJ_LEFT"},
	{MSG_STRING_319,"GTJ_RIGHT"},
	{MSG_STRING_320,"GTJ_CENTER"},
	{MSG_STRING_321,"Fo_rmat       "},
	{MSG_STRING_322,"Bor_der "},
	{MSG_STRING_323,"_Clipped"},
	{MSG_STRING_324,"A_ctive"},
	{MSG_STRING_325,"_Depth       "},
	{MSG_STRING_326,"_Color       "},
	{MSG_STRING_327,"Color O_ffset"},
	{MSG_STRING_328,"_Num Colors  "},
	{MSG_STRING_329,"Di_sabled"},
	{MSG_STRING_330,"Indicator _Width "},
	{MSG_STRING_331,"Indicator _Height"},
	{MSG_STRING_332,"T_itolo"},
	{MSG_STRING_333,"_Highlight"},
	{MSG_STRING_334,"_Top    "},
	{MSG_STRING_335,"Tota_l  "},
	{MSG_STRING_336,"_Visible"},
	{MSG_STRING_337,"Arro_ws "},
	{MSG_STRING_338,"_Disabled "},
	{MSG_STRING_339,"_RelVerify"},
	{MSG_STRING_340,"I_mmediate"},
	{MSG_STRING_341,"Fr_eedom"},
	{MSG_STRING_342,"LORIENT HORIZ"},
	{MSG_STRING_343,"LORIENT  VERT"},
	{MSG_STRING_344,"_Min"},
	{MSG_STRING_345,"Ma_x"},
	{MSG_STRING_346,"Le_vel"},
	{MSG_STRING_347,"Max L_evel Len"},
	{MSG_STRING_348,"Level _Format "},
	{MSG_STRING_349,"Max Pixel Le_n"},
	{MSG_STRING_350,"Level Pla_ce  "},
	{MSG_STRING_351,"Di_sabled "},
	{MSG_STRING_352,"RelVerif_y"},
	{MSG_STRING_353,"Imme_diate"},
	{MSG_STRING_354,"F_reedom"},
	{MSG_STRING_355,"Max _Chars"},
	{MSG_STRING_356,"_String   "},
	{MSG_STRING_357,"STRING LEFT"},
	{MSG_STRING_358,"STRING RIGHT"},
	{MSG_STRING_359,"STRING CENTER"},
	{MSG_STRING_360,"I_mmediate   "},
	{MSG_STRING_361,"Tab C_ycle"},
	{MSG_STRING_362,"Exit _Help"},
	{MSG_STRING_363,"_Copy Text"},
	{MSG_STRING_364,"Bo_rder   "},
	{MSG_STRING_365,"Clipp_ed  "},
	{MSG_STRING_366,"Te_xt "},
	{MSG_STRING_367,"GTJ LEFT"},
	{MSG_STRING_368,"GTJ RIGHT"},
	{MSG_STRING_369,"GTJ CENTER"},
	{MSG_STRING_370,"Tags dello schermo"},
	{MSG_STRING_371,"Tit_le :"},
	{MSG_STRING_372,"T_ype     :"},
	{MSG_STRING_373,"CUSTOMSCREEN"},
	{MSG_STRING_374,"PUBLICSCREEN"},
	{MSG_STRING_375,"Pub Na_me :"},
	{MSG_STRING_376,"L_eft  :"},
	{MSG_STRING_377,"_Top :"},
	{MSG_STRING_378,"Sho_w Title   :"},
	{MSG_STRING_379,"_Behind     :"},
	{MSG_STRING_380,"_Quiet       :"},
	{MSG_STRING_381,"_Full Palette :"},
	{MSG_STRING_382,"E_rror Code :"},
	{MSG_STRING_383,"_Draggable   :"},
	{MSG_STRING_384,"E_xclusive    :"},
	{MSG_STRING_385,"_Share Pens :"},
	{MSG_STRING_386,"_Interleaved :"},
	{MSG_STRING_387,"Overs_can    :"},
	{MSG_STRING_388,"Like Wor_kbench :"},
	{MSG_STRING_389,"Minimi_ze ISG :"},
	{MSG_STRING_390,"Generatore"},
	{MSG_STRING_391,"_Configura"},
	{MSG_STRING_392,"Localizzazione"},
	{MSG_STRING_393,"A_ttivata"},
	{MSG_STRING_394,"_Catalogo"},
	{MSG_STRING_395,"_Unisci  "},
	{MSG_STRING_396,"_Built In"},
	{MSG_STRING_397,"_Versione"},
	{MSG_STRING_398,"Linguaggi"},
	{MSG_STRING_399,"Stringhe"},
	{MSG_STRING_400,"Nuova"},
	{MSG_STRING_401,"Importa..."},
	{MSG_STRING_402,"Importa"},
	{MSG_STRING_403,"Da catalogo..."},
	{MSG_STRING_404,"Da .ct..."},
	{MSG_STRING_405,"Parametri del banco di gadget"},
	{MSG_STRING_406,"_Mostra all'apertura"},
	{MSG_STRING_407,"_Label"},
	{MSG_STRING_408,"_Nome Classe"},
	{MSG_STRING_409,"_Tipo Classe"},
	{MSG_STRING_410,"Pubblica"},
	{MSG_STRING_411,"Privata"},
	{MSG_STRING_412,"Tags"},
	{MSG_STRING_413,"N_uova"},
	{MSG_STRING_414,"Boolean"},
	{MSG_STRING_415,"String"},
	{MSG_STRING_416,"Objects"},
	{MSG_STRING_417,"Inserisci una LONG"},
	{MSG_STRING_418,"Immagine"},
	{MSG_STRING_419,"Nuovo linguaggio"},
	{MSG_STRING_420,"_Linguaggio:"},
	{MSG_STRING_421,"_File:"},
	{MSG_STRING_422,"Nuova stringa"},
	{MSG_STRING_423,"_Stringa:"},
	{MSG_STRING_424,"_ID:"},
	{MSG_STRING_425,"Traduzioni"},
	{MSG_STRING_426,"Nuova traduzione"},
	{MSG_STRING_427,"_Stringa"},
	{MSG_STRING_428,"Lingua"},
	{MSG_STRING_429,"Stringhe nuove"},
	{MSG_STRING_430,"Associa a..."},
	{MSG_STRING_431,"_Collega"},
};

#endif /* CATCOMP_ARRAY */

#endif /* GUI_LOCALE_H */
