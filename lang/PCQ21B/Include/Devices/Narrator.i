{
        Narrator.i for PCQ Pascal
}

{$I "Include:Exec/IO.i"}

Const
                {          Device Options      }

    NDB_NEWIORB   =  0;       { Use new extended IORB                }
    NDB_WORDSYNC  =  1;       { Generate word sync messages          }
    NDB_SYLSYNC   =  2;      { Generate syllable sync messages      }


    NDF_NEWIORB   =  1;
    NDF_WORDSYNC  =  2;
    NDF_SYLSYNC   =  4;


                {           Error Codes         }

    ND_NoMem            = -2;   { Can't allocate memory         }
    ND_NoAudLib         = -3;   { Can't open audio device               }
    ND_MakeBad          = -4;   { Error in MakeLibrary call             }
    ND_UnitErr          = -5;   { Unit other than 0                     }
    ND_CantAlloc        = -6;   { Can't allocate audio channel(s)       }
    ND_Unimpl           = -7;   { Unimplemented command         }
    ND_NoWrite          = -8;   { Read for mouth without write first    }
    ND_Expunged         = -9;   { Can't open, deferred expunge bit set }
    ND_PhonErr          = -20;  { Phoneme code spelling error           }
    ND_RateErr          = -21;  { Rate out of bounds                    }
    ND_PitchErr         = -22;  { Pitch out of bounds                   }
    ND_SexErr           = -23;  { Sex not valid                 }
    ND_ModeErr          = -24;  { Mode not valid                        }
    ND_FreqErr          = -25;  { Sampling frequency out of bounds      }
    ND_VolErr           = -26;  { Volume out of bounds                  }
    ND_DCentErr         = -27;      { Degree of centralization out of bounds }
    ND_CentPhonErr      = -28;      { Invalid central phon                 }



                { Input parameters and defaults }

    DEFPITCH            = 110;  { Default pitch                 }
    DEFRATE             = 150;  { Default speaking rate (wpm)           }
    DEFVOL              = 64;   { Default volume (full)         }
    DEFFREQ             = 22200; { Default sampling frequency (Hz)      }
    MALE                = 0;    { Male vocal tract                      }
    FEMALE              = 1;    { Female vocal tract                    }
    NATURALF0           = 0;    { Natural pitch contours                }
    ROBOTICF0           = 1;    { Monotone                              }
    DEFSEX              = MALE; { Default sex                           }
    DEFMODE             = NATURALF0;    { Default mode                          }
    DEFARTIC            = 100;         { 100% articulation (normal)           }
    DEFCENTRAL          = 0;           { No centralization                    }
    DEFF0PERT           = 0;           { No F0 Perturbation                   }
    DEFF0ENTHUS         = 32;          { Default F0 enthusiasm (in 32nds)     }
    DEFPRIORITY         = 100;         { Default speaking priority            }



                {       Parameter bounds        }

    MINRATE             = 40;   { Minimum speaking rate         }
    MAXRATE             = 400;  { Maximum speaking rate         }
    MINPITCH            = 65;   { Minimum pitch                 }
    MAXPITCH            = 320;  { Maximum pitch                 }
    MINFREQ             = 5000; { Minimum sampling frequency            }
    MAXFREQ             = 28000; { Maximum sampling frequency           }
    MINVOL              = 0;    { Minimum volume                        }
    MAXVOL              = 64;   { Maximum volume                        }
    MINCENT             = 0;          { Minimum degree of centralization     }
    MAXCENT             = 100;          { Maximum degree of centralization     }



Type

                {    Standard Write request     }

    narrator_rb = record
        message         : IOStdReq;     { Standard IORB         }
        rate            : Short;        { Speaking rate (words/minute) }
        pitch           : Short;        { Baseline pitch in Hertz       }
        mode            : Short;        { Pitch mode                    }
        sex             : Short;        { Sex of voice                  }
        ch_masks        : Address;      { Pointer to audio alloc maps   }
        nm_masks        : Short;        { Number of audio alloc maps    }
        volume          : Short;        { Volume. 0 (off) thru 64       }
        sampfreq        : Short;        { Audio sampling freq           }
        mouths          : Boolean;      { If non-zero, generate mouths }
        chanmask,                       { Which ch mask used (internal)}
        numchan,                        { Num ch masks used (internal) }
        flags,                          { New feature flags            }
        F0enthusiasm,                   { F0 excursion factor          }
        F0perturb,                      { Amount of F0 perturbation    }
        F1adj,                          { F1 adjustment in ±5% steps   }
        F2adj,                          { F2 adjustment in ±5% steps   }
        F3adj,                          { F3 adjustment in ±5% steps   }
        A1adj,                          { A1 adjustment in decibels    }
        A2adj,                          { A2 adjustment in decibels    }
        A3adj,                          { A3 adjustment in decibels    }
        articulate,                     { Transition time multiplier   }
        centralize      : Byte;         { Degree of vowel centralization }
        centphon        : String;       { Pointer to central ASCII phon  }
        AVbias,                         { AV bias                      }
        AFbias,                         { AF bias                      }
        priority,                       { Priority WHILE speaking      }
        pad1            : Byte;         { For alignment                }
    end;
    narrator_rbPtr = ^narrator_rb;


                {    Standard Read request      }

    mouth_rb = record
        voice   : narrator_rb;          { Speech IORB                   }
        width   : Byte;                 { Width (returned value)        }
        height  : Byte;                 { Height (returned value)       }
        shape   : Byte;                 { Internal use, do not modify   }
        sync    : Byte;                 { Returned sync events          }
    end;
    mouth_rbPtr = ^mouth_rb;

