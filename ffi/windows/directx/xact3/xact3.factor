USING: alien.c-types alien.syntax classes.struct windows.com
windows.com.syntax windows.directx windows.directx.xaudio2
windows.kernel32 windows.types ;
in: windows.directx.xact3

LIBRARY: xactengine

c-type: IXACT3SoundBank
c-type: IXACT3WaveBank
c-type: IXACT3Cue
c-type: IXACT3Wave
c-type: IXACT3Engine
c-type: XACT_NOTIFICATION

TYPEDEF: WORD  XACTINDEX ;
TYPEDEF: BYTE  XACTNOTIFICATIONTYPE ;
TYPEDEF: FLOAT XACTVARIABLEVALUE ;
TYPEDEF: WORD  XACTVARIABLEINDEX ;
TYPEDEF: WORD  XACTCATEGORY ;
TYPEDEF: BYTE  XACTCHANNEL ;
TYPEDEF: FLOAT XACTVOLUME ;
TYPEDEF: LONG  XACTTIME ;
TYPEDEF: SHORT XACTPITCH ;
TYPEDEF: BYTE  XACTLOOPCOUNT ;
TYPEDEF: BYTE  XACTVARIATIONWEIGHT ;
TYPEDEF: BYTE  XACTPRIORITY ;
TYPEDEF: BYTE  XACTINSTANCELIMIT ;

CONSTANT: WAVE_FORMAT_IEEE_FLOAT 0x0003 ;
CONSTANT: WAVE_FORMAT_EXTENSIBLE 0xFFFE ;

STRUCT: WAVEFORMATEX
    { wFormatTag        WORD  }
    { nChannels         WORD  }
    { nSamplesPerSec    DWORD }
    { nAvgBytesPerSec   DWORD }
    { nBlockAlign       WORD  }
    { wBitsPerSample    WORD  }
    { cbSize            WORD  } ;
TYPEDEF: WAVEFORMATEX* PWAVEFORMATEX ;
TYPEDEF: WAVEFORMATEX* NPWAVEFORMATEX ;
TYPEDEF: WAVEFORMATEX* LPWAVEFORMATEX ;

UNION-STRUCT: WAVEFORMATEXTENSIBLE_UNION
    { wValidBitsPerSample        WORD }
    { wSamplesPerBlock           WORD }
    { wReserved                  WORD } ;
STRUCT: WAVEFORMATEXTENSIBLE
    { Format                  WAVEFORMATEX               }
    { Union                   WAVEFORMATEXTENSIBLE_UNION }
    { dwChannelMask           DWORD                      }
    { SubFormat               GUID                       } ;
TYPEDEF: WAVEFORMATEXTENSIBLE* PWAVEFORMATEXTENSIBLE ;

CONSTANT: XACTTIME_MIN                    0x80000001 ;
CONSTANT: XACTTIME_MAX                    0x7fffffff ;
CONSTANT: XACTTIME_INFINITE               0x7fffffff ;
CONSTANT: XACTINSTANCELIMIT_INFINITE      0xff ;
CONSTANT: XACTINSTANCELIMIT_MIN           0x00 ;
CONSTANT: XACTINSTANCELIMIT_MAX           0xfe ;
CONSTANT: XACTINDEX_MIN                   0x0 ;
CONSTANT: XACTINDEX_MAX                   0xfffe ;
CONSTANT: XACTINDEX_INVALID               0xffff ;
CONSTANT: XACTNOTIFICATIONTYPE_MIN        0x00 ;
CONSTANT: XACTNOTIFICATIONTYPE_MAX        0xff ;
CONSTANT: XACTVARIABLEINDEX_MIN           0x0000 ;
CONSTANT: XACTVARIABLEINDEX_MAX           0xfffe ;
CONSTANT: XACTVARIABLEINDEX_INVALID       0xffff ;
CONSTANT: XACTCATEGORY_MIN                0x0 ;
CONSTANT: XACTCATEGORY_MAX                0xfffe ;
CONSTANT: XACTCATEGORY_INVALID            0xffff ;
CONSTANT: XACTCHANNEL_MIN                 0 ;
CONSTANT: XACTCHANNEL_MAX                 0xFF ;
CONSTANT: XACTPITCH_MIN                   -1200 ;
CONSTANT: XACTPITCH_MAX                   1200 ;
CONSTANT: XACTPITCH_MIN_TOTAL             -2400 ;
CONSTANT: XACTPITCH_MAX_TOTAL             2400 ;
CONSTANT: XACTVOLUME_MIN                  0.0 ;
CONSTANT: XACTVOLUME_MAX                  16777216.0 ;
CONSTANT: XACTLOOPCOUNT_MIN               0x0 ;
CONSTANT: XACTLOOPCOUNT_MAX               0xfe ;
CONSTANT: XACTLOOPCOUNT_INFINITE          0xff ;
CONSTANT: XACTWAVEALIGNMENT_MIN           2048 ;

CONSTANT: XACT_CUE_NAME_LENGTH        0xFF ;
CONSTANT: XACT_CONTENT_VERSION        46 ;

CONSTANT: XACT_FLAG_STOP_RELEASE       0x00000000 ;
CONSTANT: XACT_FLAG_STOP_IMMEDIATE     0x00000001 ;

CONSTANT: XACT_FLAG_MANAGEDATA         0x00000001 ;

CONSTANT: XACT_FLAG_BACKGROUND_MUSIC   0x00000002 ;
CONSTANT: XACT_FLAG_UNITS_MS           0x00000004 ;
CONSTANT: XACT_FLAG_UNITS_SAMPLES      0x00000008 ;

CONSTANT: XACT_STATE_CREATED           0x00000001 ;
CONSTANT: XACT_STATE_PREPARING         0x00000002 ;
CONSTANT: XACT_STATE_PREPARED          0x00000004 ;
CONSTANT: XACT_STATE_PLAYING           0x00000008 ;
CONSTANT: XACT_STATE_STOPPING          0x00000010 ;
CONSTANT: XACT_STATE_STOPPED           0x00000020 ;
CONSTANT: XACT_STATE_PAUSED            0x00000040 ;
CONSTANT: XACT_STATE_INUSE             0x00000080 ;
CONSTANT: XACT_STATE_PREPAREFAILED     0x80000000 ;

c-type: XACT_READFILE_CB
c-type: XACT_GETOVERLAPPEDRESULT_CB

: XACT_FLAG_GLOBAL_SETTINGS_MANAGEDATA ( -- z ) XACT_FLAG_MANAGEDATA ; inline


STRUCT: XACT_FILEIO_CALLBACKS
    { readFileCallback              XACT_READFILE_CB* }
    { getOverlappedResultCallback   XACT_GETOVERLAPPEDRESULT_CB* } ;
TYPEDEF: XACT_FILEIO_CALLBACKS* PXACT_FILEIO_CALLBACKS ;

c-type: XACT_NOTIFICATION_CALLBACK

CONSTANT: XACT_RENDERER_ID_LENGTH                 0xff ;
CONSTANT: XACT_RENDERER_NAME_LENGTH               0xff ;

STRUCT: XACT_RENDERER_DETAILS
    { rendererID     WCHAR[255] }
    { displayName    WCHAR[255] }
    { defaultDevice  BOOL       } ;
TYPEDEF: XACT_RENDERER_DETAILS* LPXACT_RENDERER_DETAILS ;

CONSTANT: XACT_ENGINE_LOOKAHEAD_DEFAULT 250 ;

STRUCT: XACT_RUNTIME_PARAMETERS
    { lookAheadTime                  DWORD                       }
    { pGlobalSettingsBuffer          void*                       }
    { globalSettingsBufferSize       DWORD                       }
    { globalSettingsFlags            DWORD                       }
    { globalSettingsAllocAttributes  DWORD                       }
    { fileIOCallbacks                XACT_FILEIO_CALLBACKS       }
    { fnNotificationCallback         XACT_NOTIFICATION_CALLBACK* }
    { pRendererID                    PWSTR                       }
    { pXAudio2                       IXAudio2*                   }
    { pMasteringVoice                IXAudio2MasteringVoice*     } ;
TYPEDEF: XACT_RUNTIME_PARAMETERS* LPXACT_RUNTIME_PARAMETERS ;

STRUCT: XACT_STREAMING_PARAMETERS
    { file          HANDLE }
    { offset        DWORD  }
    { flags         DWORD  }
    { packetSize    WORD   } ;
TYPEDEF: XACT_STREAMING_PARAMETERS XACT_WAVEBANK_STREAMING_PARAMETERS ;
TYPEDEF: XACT_WAVEBANK_STREAMING_PARAMETERS* LPXACT_WAVEBANK_STREAMING_PARAMETERS ;
TYPEDEF: XACT_STREAMING_PARAMETERS* LPXACT_STREAMING_PARAMETERS ;

STRUCT: XACT_CUE_PROPERTIES
    { friendlyName     CHAR[255] }
    { interactive      BOOL }
    { iaVariableIndex  XACTINDEX }
    { numVariations    XACTINDEX }
    { maxInstances     XACTINSTANCELIMIT }
    { currentInstances XACTINSTANCELIMIT } ;
TYPEDEF: XACT_CUE_PROPERTIES* LPXACT_CUE_PROPERTIES ;

STRUCT: XACT_TRACK_PROPERTIES
    { duration            XACTTIME      }
    { numVariations       XACTINDEX     }
    { numChannels         XACTCHANNEL   }
    { waveVariation       XACTINDEX     }
    { loopCount           XACTLOOPCOUNT } ;
TYPEDEF: XACT_TRACK_PROPERTIES* LPXACT_TRACK_PROPERTIES ;

STRUCT: XACT_VARIATION_PROPERTIES
    { index                     XACTINDEX           }
    { weight                    XACTVARIATIONWEIGHT }
    { iaVariableMin             XACTVARIABLEVALUE   }
    { iaVariableMax             XACTVARIABLEVALUE   }
    { linger                    BOOL                } ;
TYPEDEF: XACT_VARIATION_PROPERTIES* LPXACT_VARIATION_PROPERTIES ;

STRUCT: XACT_SOUND_PROPERTIES
    { category            XACTCATEGORY          }
    { priority            BYTE                  }
    { pitch               XACTPITCH             }
    { volume              XACTVOLUME            }
    { numTracks           XACTINDEX             }
    { arrTrackProperties  XACT_TRACK_PROPERTIES } ;
TYPEDEF: XACT_SOUND_PROPERTIES* LPXACT_SOUND_PROPERTIES ;

STRUCT: XACT_SOUND_VARIATION_PROPERTIES
    { variationProperties   XACT_VARIATION_PROPERTIES }
    { soundProperties       XACT_SOUND_PROPERTIES     } ;
TYPEDEF: XACT_SOUND_VARIATION_PROPERTIES* LPXACT_SOUND_VARIATION_PROPERTIES ;

STRUCT: XACT_CUE_INSTANCE_PROPERTIES
    { allocAttributes           DWORD                           }
    { cueProperties             XACT_CUE_PROPERTIES             }
    { activeVariationProperties XACT_SOUND_VARIATION_PROPERTIES } ;
TYPEDEF: XACT_CUE_INSTANCE_PROPERTIES* LPXACT_CUE_INSTANCE_PROPERTIES ;

STRUCT: WAVEBANKMINIWAVEFORMAT
    { dwValue DWORD } ;

STRUCT: WAVEBANKSAMPLEREGION
    { dwStartSample  DWORD }
    { dwTotalSamples DWORD } ;

STRUCT: XACT_WAVE_PROPERTIES
    { friendlyName      char[64]               }
    { format            WAVEBANKMINIWAVEFORMAT }
    { durationInSamples DWORD                  }
    { loopRegion        WAVEBANKSAMPLEREGION   }
    { streaming         BOOL                   } ;
TYPEDEF: XACT_WAVE_PROPERTIES* LPXACT_WAVE_PROPERTIES ;

STRUCT: XACT_WAVE_INSTANCE_PROPERTIES
    { properties      XACT_WAVE_PROPERTIES }
    { backgroundMusic BOOL                 } ;
TYPEDEF: XACT_WAVE_INSTANCE_PROPERTIES* LPXACT_WAVE_INSTANCE_PROPERTIES ;

STRUCT: XACTCHANNELMAPENTRY
    { InputChannel    XACTCHANNEL }
    { OutputChannel   XACTCHANNEL }
    { Volume          XACTVOLUME  } ;
TYPEDEF: XACTCHANNELMAPENTRY* LPXACTCHANNELMAPENTRY ;

STRUCT: XACTCHANNELMAP
    { EntryCount             XACTCHANNEL          }
    { paEntries              XACTCHANNELMAPENTRY* } ;
TYPEDEF: XACTCHANNELMAP* LPXACTCHANNELMAP ;

STRUCT: XACTCHANNELVOLUMEENTRY
    { EntryIndex   XACTCHANNEL }
    { Volume       XACTVOLUME  } ;
TYPEDEF: XACTCHANNELVOLUMEENTRY* LPXACTCHANNELVOLUMEENTRY ;

STRUCT: XACTCHANNELVOLUME
    { EntryCount             XACTCHANNEL             }
    { paEntries              XACTCHANNELVOLUMEENTRY* } ;
TYPEDEF: XACTCHANNELVOLUME* LPXACTCHANNELVOLUME ;

CONSTANT: XACTNOTIFICATIONTYPE_CUEPREPARED                      1 ;
CONSTANT: XACTNOTIFICATIONTYPE_CUEPLAY                          2 ;
CONSTANT: XACTNOTIFICATIONTYPE_CUESTOP                          3 ;
CONSTANT: XACTNOTIFICATIONTYPE_CUEDESTROYED                     4 ;
CONSTANT: XACTNOTIFICATIONTYPE_MARKER                           5 ;
CONSTANT: XACTNOTIFICATIONTYPE_SOUNDBANKDESTROYED               6 ;
CONSTANT: XACTNOTIFICATIONTYPE_WAVEBANKDESTROYED                7 ;
CONSTANT: XACTNOTIFICATIONTYPE_LOCALVARIABLECHANGED             8 ;
CONSTANT: XACTNOTIFICATIONTYPE_GLOBALVARIABLECHANGED            9 ;
CONSTANT: XACTNOTIFICATIONTYPE_GUICONNECTED                     10 ;
CONSTANT: XACTNOTIFICATIONTYPE_GUIDISCONNECTED                  11 ;
CONSTANT: XACTNOTIFICATIONTYPE_WAVEPREPARED                     12 ;
CONSTANT: XACTNOTIFICATIONTYPE_WAVEPLAY                         13 ;
CONSTANT: XACTNOTIFICATIONTYPE_WAVESTOP                         14 ;
CONSTANT: XACTNOTIFICATIONTYPE_WAVELOOPED                       15 ;
CONSTANT: XACTNOTIFICATIONTYPE_WAVEDESTROYED                    16 ;
CONSTANT: XACTNOTIFICATIONTYPE_WAVEBANKPREPARED                 17 ;
CONSTANT: XACTNOTIFICATIONTYPE_WAVEBANKSTREAMING_INVALIDCONTENT 18 ;

CONSTANT: XACT_FLAG_NOTIFICATION_PERSIST 0x01 ;

STRUCT: XACT_NOTIFICATION_DESCRIPTION
    { type                     XACTNOTIFICATIONTYPE }
    { flags                    BYTE                 }
    { pSoundBank               IXACT3SoundBank*     }
    { pWaveBank                IXACT3WaveBank*      }
    { pCue                     IXACT3Cue*           }
    { pWave                    IXACT3Wave*          }
    { cueIndex                 XACTINDEX            }
    { waveIndex                XACTINDEX            }
    { pvContext                PVOID                } ;
TYPEDEF: XACT_NOTIFICATION_DESCRIPTION* LPXACT_NOTIFICATION_DESCRIPTION ;

STRUCT: XACT_NOTIFICATION_CUE
    { cueIndex       XACTINDEX        }
    { pSoundBank     IXACT3SoundBank* }
    { pCue           IXACT3Cue*       } ;
TYPEDEF: XACT_NOTIFICATION_CUE* LPXACT_NOTIFICATION_CUE ;

STRUCT: XACT_NOTIFICATION_MARKER
    { cueIndex         XACTINDEX        }
    { pSoundBank       IXACT3SoundBank* }
    { pCue             IXACT3Cue*       }
    { marker           DWORD            } ;
TYPEDEF: XACT_NOTIFICATION_MARKER* LPXACT_NOTIFICATION_MARKER ;

STRUCT: XACT_NOTIFICATION_SOUNDBANK
    { pSoundBank IXACT3SoundBank* } ;
TYPEDEF: XACT_NOTIFICATION_SOUNDBANK* LPXACT_NOTIFICATION_SOUNDBANK ;

STRUCT: XACT_NOTIFICATION_WAVEBANK
    { pWaveBank  IXACT3WaveBank* } ;
TYPEDEF: XACT_NOTIFICATION_WAVEBANK* LPXACT_NOTIFICATION_WAVEBANK ;

STRUCT: XACT_NOTIFICATION_VARIABLE
    { cueIndex             XACTINDEX         }
    { pSoundBank           IXACT3SoundBank*  }
    { pCue                 IXACT3Cue*        }
    { variableIndex        XACTVARIABLEINDEX }
    { variableValue        XACTVARIABLEVALUE }
    { local                BOOL              } ;
TYPEDEF: XACT_NOTIFICATION_VARIABLE* LPXACT_NOTIFICATION_VARIABLE ;

STRUCT: XACT_NOTIFICATION_GUI
    { reserved   DWORD } ;
TYPEDEF: XACT_NOTIFICATION_GUI* LPXACT_NOTIFICATION_GUI ;

STRUCT: XACT_NOTIFICATION_WAVE
    { pWaveBank       IXACT3WaveBank*  }
    { waveIndex       XACTINDEX        }
    { cueIndex        XACTINDEX        }
    { pSoundBank      IXACT3SoundBank* }
    { pCue            IXACT3Cue*       }
    { pWave           IXACT3Wave*      } ;
TYPEDEF: XACT_NOTIFICATION_WAVE* LPXACT_NOTIFICATION_WAVE ;

UNION-STRUCT: XACT_NOTIFICATION_UNION
    { cue       XACT_NOTIFICATION_CUE }
    { marker    XACT_NOTIFICATION_MARKER }
    { soundBank XACT_NOTIFICATION_SOUNDBANK }
    { waveBank  XACT_NOTIFICATION_WAVEBANK }
    { variable  XACT_NOTIFICATION_VARIABLE }
    { gui       XACT_NOTIFICATION_GUI }
    { wave      XACT_NOTIFICATION_WAVE } ;
STRUCT: XACT_NOTIFICATION
    { type                         XACTNOTIFICATIONTYPE    }
    { timeStamp                    LONG                    }
    { pvContext                    PVOID                   }
    { union                        XACT_NOTIFICATION_UNION } ;
TYPEDEF: XACT_NOTIFICATION* LPXACT_NOTIFICATION ;

CONSTANT: XACT_FLAG_SOUNDBANK_STOP_IMMEDIATE  0x00000001 ;
CONSTANT: XACT_SOUNDBANKSTATE_INUSE           0x00000080 ;

COM-INTERFACE: IXACT3SoundBank f {00000000-0000-0000-0000-000000000000}
    XACTINDEX GetCueIndex ( PCSTR szFriendlyName )
    HRESULT GetNumCues ( XACTINDEX* pnNumCues )
    HRESULT GetCueProperties ( XACTINDEX nCueIndex, LPXACT_CUE_PROPERTIES pProperties )
    HRESULT Prepare ( XACTINDEX nCueIndex, DWORD dwFlags, XACTTIME timeOffset, IXACT3Cue** ppCue )
    HRESULT Play ( XACTINDEX nCueIndex, DWORD dwFlags, XACTTIME timeOffset, IXACT3Cue** ppCue )
    HRESULT Stop ( XACTINDEX nCueIndex, DWORD dwFlags )
    HRESULT Destroy ( )
    HRESULT GetState ( DWORD* pdwState ) ;

CONSTANT: XACT_WAVEBANKSTATE_INUSE            0x00000080 ;
CONSTANT: XACT_WAVEBANKSTATE_PREPARED         0x00000004 ;
CONSTANT: XACT_WAVEBANKSTATE_PREPAREFAILED    0x80000000 ;

COM-INTERFACE: IXACT3WaveBank f {00000000-0000-0000-0000-000000000000}
    HRESULT Destroy ( )
    HRESULT GetNumWaves ( XACTINDEX* pnNumWaves )
    XACTINDEX GetWaveIndex ( PCSTR szFriendlyName )
    HRESULT GetWaveProperties ( XACTINDEX nWaveIndex, LPXACT_WAVE_PROPERTIES pWaveProperties )
    HRESULT Prepare ( XACTINDEX nWaveIndex, DWORD dwFlags, DWORD dwPlayOffset, XACTLOOPCOUNT nLoopCount, IXACT3Wave** ppWave )
    HRESULT Play ( XACTINDEX nWaveIndex, DWORD dwFlags, DWORD dwPlayOffset, XACTLOOPCOUNT nLoopCount, IXACT3Wave** ppWave )
    HRESULT Stop ( XACTINDEX nWaveIndex, DWORD dwFlags )
    HRESULT GetState ( DWORD* pdwState ) ;

COM-INTERFACE: IXACT3Wave f {00000000-0000-0000-0000-000000000000}
    HRESULT Destroy ( )
    HRESULT Play ( )
    HRESULT Stop ( DWORD dwFlags )
    HRESULT Pause ( BOOL fPause )
    HRESULT GetState ( DWORD* pdwState )
    HRESULT SetPitch ( XACTPITCH pitch )
    HRESULT SetVolume ( XACTVOLUME volume )
    HRESULT SetMatrixCoefficients ( UINT32 uSrcChannelCount, UINT32 uDstChannelCount,  float* pMatrixCoefficients )
    HRESULT GetProperties ( LPXACT_WAVE_INSTANCE_PROPERTIES pProperties ) ;

: XACT_FLAG_CUE_STOP_RELEASE      ( -- z ) XACT_FLAG_STOP_RELEASE ; inline
: XACT_FLAG_CUE_STOP_IMMEDIATE    ( -- z ) XACT_FLAG_STOP_IMMEDIATE ; inline

: XACT_CUESTATE_CREATED           ( -- z ) XACT_STATE_CREATED ; inline
: XACT_CUESTATE_PREPARING         ( -- z ) XACT_STATE_PREPARING ; inline
: XACT_CUESTATE_PREPARED          ( -- z ) XACT_STATE_PREPARED ; inline
: XACT_CUESTATE_PLAYING           ( -- z ) XACT_STATE_PLAYING ; inline
: XACT_CUESTATE_STOPPING          ( -- z ) XACT_STATE_STOPPING ; inline
: XACT_CUESTATE_STOPPED           ( -- z ) XACT_STATE_STOPPED ; inline
: XACT_CUESTATE_PAUSED            ( -- z ) XACT_STATE_PAUSED ; inline

COM-INTERFACE: IXACT3Cue f {00000000-0000-0000-0000-000000000000}
    HRESULT Play ( )
    HRESULT Stop ( DWORD dwFlags )
    HRESULT GetState ( DWORD* pdwState )
    HRESULT Destroy ( )
    HRESULT SetMatrixCoefficients ( UINT32 uSrcChannelCount, UINT32 uDstChannelCount,  float* pMatrixCoefficients )
    XACTVARIABLEINDEX GetVariableIndex ( PCSTR szFriendlyName )
    HRESULT SetVariable ( XACTVARIABLEINDEX nIndex, XACTVARIABLEVALUE nValue )
    HRESULT GetVariable ( XACTVARIABLEINDEX nIndex, XACTVARIABLEVALUE* nValue )
    HRESULT Pause ( BOOL fPause )
    HRESULT GetProperties ( LPXACT_CUE_INSTANCE_PROPERTIES* ppProperties )
    HRESULT SetOutputVoices ( XAUDIO2_VOICE_SENDS* pSendList )
    HRESULT SetOutputVoiceMatrix ( IXAudio2Voice* pDestinationVoice, UINT32 SourceChannels, UINT32 DestinationChannels, float* pLevelMatrix ) ;

: XACT_FLAG_ENGINE_CREATE_MANAGEDATA    ( -- z ) XACT_FLAG_MANAGEDATA ; inline
: XACT_FLAG_ENGINE_STOP_IMMEDIATE       ( -- z ) XACT_FLAG_STOP_IMMEDIATE ; inline

STRUCT: WAVEBANKREGION
    { dwOffset       DWORD }
    { dwLength       DWORD } ;

STRUCT: WAVEBANKENTRY
    { dwFlagsAndDuration  DWORD                  }
    { Format              WAVEBANKMINIWAVEFORMAT }
    { PlayRegion          WAVEBANKREGION         }
    { LoopRegion          WAVEBANKSAMPLEREGION   } ;

COM-INTERFACE: IXACT3Engine IUnknown {b1ee676a-d9cd-4d2a-89a8-fa53eb9e480b}
    HRESULT GetRendererCount ( XACTINDEX* pnRendererCount )
    HRESULT GetRendererDetails ( XACTINDEX nRendererIndex, LPXACT_RENDERER_DETAILS pRendererDetails )
    HRESULT GetFinalMixFormat ( WAVEFORMATEXTENSIBLE* pFinalMixFormat )
    HRESULT Initialize ( XACT_RUNTIME_PARAMETERS* pParams )
    HRESULT ShutDown ( )
    HRESULT DoWork ( )
    HRESULT CreateSoundBank ( void* pvBuffer, DWORD dwSize, DWORD dwFlags, DWORD dwAllocAttributes, IXACT3SoundBank** ppSoundBank )
    HRESULT CreateInMemoryWaveBank ( void* pvBuffer, DWORD dwSize, DWORD dwFlags, DWORD dwAllocAttributes, IXACT3WaveBank** ppWaveBank )
    HRESULT CreateStreamingWaveBank ( XACT_WAVEBANK_STREAMING_PARAMETERS* pParms, IXACT3WaveBank** ppWaveBank )
    HRESULT PrepareWave ( DWORD dwFlags,  PCSTR szWavePath, WORD wStreamingPacketSize, DWORD dwAlignment, DWORD dwPlayOffset, XACTLOOPCOUNT nLoopCount, IXACT3Wave** ppWave )
    HRESULT PrepareInMemoryWave ( DWORD dwFlags, WAVEBANKENTRY entry, DWORD* pdwSeekTable, BYTE* pbWaveData, DWORD dwPlayOffset, XACTLOOPCOUNT nLoopCount, IXACT3Wave** ppWave )
    HRESULT PrepareStreamingWave ( DWORD dwFlags, WAVEBANKENTRY entry, XACT_STREAMING_PARAMETERS streamingParams, DWORD dwAlignment, DWORD* pdwSeekTable, DWORD dwPlayOffset, XACTLOOPCOUNT nLoopCount, IXACT3Wave** ppWave )
    HRESULT RegisterNotification ( XACT_NOTIFICATION_DESCRIPTION* pNotificationDesc )
    HRESULT UnRegisterNotification ( XACT_NOTIFICATION_DESCRIPTION* pNotificationDesc )
    XACTCATEGORY GetCategory ( PCSTR szFriendlyName )
    HRESULT Stop ( XACTCATEGORY nCategory, DWORD dwFlags )
    HRESULT SetVolume ( XACTCATEGORY nCategory, XACTVOLUME nVolume )
    HRESULT Pause ( XACTCATEGORY nCategory, BOOL fPause )
    XACTVARIABLEINDEX GetGlobalVariableIndex ( PCSTR szFriendlyName )
    HRESULT SetGlobalVariable ( XACTVARIABLEINDEX nIndex, XACTVARIABLEVALUE nValue )
    HRESULT GetGlobalVariable ( XACTVARIABLEINDEX nIndex,  XACTVARIABLEVALUE* nValue ) ;

CONSTANT: XACT_FLAG_API_AUDITION_MODE 1 ;
CONSTANT: XACT_FLAG_API_DEBUG_MODE    2 ;

CONSTANT: XACTENGINE_E_OUTOFMEMORY               0x80070000 ;
CONSTANT: XACTENGINE_E_INVALIDARG                0x80070057 ;
CONSTANT: XACTENGINE_E_NOTIMPL                   0x80004001 ;
CONSTANT: XACTENGINE_E_FAIL                      0x80004005 ;

CONSTANT: XACTENGINE_E_ALREADYINITIALIZED        0x8AC70001 ;
CONSTANT: XACTENGINE_E_NOTINITIALIZED            0x8AC70002 ;
CONSTANT: XACTENGINE_E_EXPIRED                   0x8AC70003 ;
CONSTANT: XACTENGINE_E_NONOTIFICATIONCALLBACK    0x8AC70004 ;
CONSTANT: XACTENGINE_E_NOTIFICATIONREGISTERED    0x8AC70005 ;
CONSTANT: XACTENGINE_E_INVALIDUSAGE              0x8AC70006 ;
CONSTANT: XACTENGINE_E_INVALIDDATA               0x8AC70007 ;
CONSTANT: XACTENGINE_E_INSTANCELIMITFAILTOPLAY   0x8AC70008 ;
CONSTANT: XACTENGINE_E_NOGLOBALSETTINGS          0x8AC70009 ;
CONSTANT: XACTENGINE_E_INVALIDVARIABLEINDEX      0x8AC7000a ;
CONSTANT: XACTENGINE_E_INVALIDCATEGORY           0x8AC7000b ;
CONSTANT: XACTENGINE_E_INVALIDCUEINDEX           0x8AC7000c ;
CONSTANT: XACTENGINE_E_INVALIDWAVEINDEX          0x8AC7000d ;
CONSTANT: XACTENGINE_E_INVALIDTRACKINDEX         0x8AC7000e ;
CONSTANT: XACTENGINE_E_INVALIDSOUNDOFFSETORINDEX 0x8AC7000f ;
CONSTANT: XACTENGINE_E_READFILE                  0x8AC70010 ;
CONSTANT: XACTENGINE_E_UNKNOWNEVENT              0x8AC70011 ;
CONSTANT: XACTENGINE_E_INCALLBACK                0x8AC70012 ;
CONSTANT: XACTENGINE_E_NOWAVEBANK                0x8AC70013 ;
CONSTANT: XACTENGINE_E_SELECTVARIATION           0x8AC70014 ;
CONSTANT: XACTENGINE_E_MULTIPLEAUDITIONENGINES   0x8AC70015 ;
CONSTANT: XACTENGINE_E_WAVEBANKNOTPREPARED       0x8AC70016 ;
CONSTANT: XACTENGINE_E_NORENDERER                0x8AC70017 ;
CONSTANT: XACTENGINE_E_INVALIDENTRYCOUNT         0x8AC70018 ;
CONSTANT: XACTENGINE_E_SEEKTIMEBEYONDCUEEND      0x8AC70019 ;
CONSTANT: XACTENGINE_E_SEEKTIMEBEYONDWAVEEND     0x8AC7001a ;
CONSTANT: XACTENGINE_E_NOFRIENDLYNAMES           0x8AC7001b ;

CONSTANT: XACTENGINE_E_AUDITION_WRITEFILE             0x8AC70101 ;
CONSTANT: XACTENGINE_E_AUDITION_NOSOUNDBANK           0x8AC70102 ;
CONSTANT: XACTENGINE_E_AUDITION_INVALIDRPCINDEX       0x8AC70103 ;
CONSTANT: XACTENGINE_E_AUDITION_MISSINGDATA           0x8AC70104 ;
CONSTANT: XACTENGINE_E_AUDITION_UNKNOWNCOMMAND        0x8AC70105 ;
CONSTANT: XACTENGINE_E_AUDITION_INVALIDDSPINDEX       0x8AC70106 ;
CONSTANT: XACTENGINE_E_AUDITION_MISSINGWAVE           0x8AC70107 ;
CONSTANT: XACTENGINE_E_AUDITION_CREATEDIRECTORYFAILED 0x8AC70108 ;
CONSTANT: XACTENGINE_E_AUDITION_INVALIDSESSION        0x8AC70109 ;
