#include "settings.h"
#include <xmms/util.h>
#include <xmms/configfile.h>

#define CUBE_CONFIG_TAG "cube"

static ConfigFile *GetConfigFile(gchar **ppFileName)
{
  ConfigFile *cfg;
  *ppFileName = g_strconcat(g_get_home_dir(),"/.xmms/config",NULL);
  cfg = xmms_cfg_open_file(*ppFileName);
  return cfg;
}

bool LoadSettings(LPSETTINGS pSettings)
{
  gchar *pFileName;
  bool bRet;
  ConfigFile *cfg = GetConfigFile(&pFileName);
  g_free(pFileName);
  if (!cfg)
    return false;
  
  bRet = (xmms_cfg_read_int(cfg,CUBE_CONFIG_TAG,"looptimes",&pSettings->looptimes) && 
	  xmms_cfg_read_int(cfg,CUBE_CONFIG_TAG,"fadelength",&pSettings->fadelength) &&
	  xmms_cfg_read_int(cfg,CUBE_CONFIG_TAG,"fadedelay",&pSettings->fadedelay) &&
	  xmms_cfg_read_int(cfg,CUBE_CONFIG_TAG,"adxonechan",(int*)&pSettings->ADXChannel) &&
	  xmms_cfg_read_int(cfg,CUBE_CONFIG_TAG,"adxvolume",(int*)&pSettings->ADXVolume));
  
  xmms_cfg_free(cfg); 
  return bRet;
}

bool SaveSettings(LPSETTINGS pSettings)
{
  gchar *pFileName;
  ConfigFile *cfg = GetConfigFile(&pFileName);
  if (!cfg)
  {
    // create a new one
    if (!(cfg = xmms_cfg_new()))
    {
      g_free(pFileName);
      return false;
    }
  }
  
  xmms_cfg_write_int(cfg,CUBE_CONFIG_TAG,"looptimes",pSettings->looptimes);
  xmms_cfg_write_int(cfg,CUBE_CONFIG_TAG,"fadelength",pSettings->fadelength);
  xmms_cfg_write_int(cfg,CUBE_CONFIG_TAG,"fadedelay",pSettings->fadedelay);
  xmms_cfg_write_int(cfg,CUBE_CONFIG_TAG,"adxonechan",pSettings->ADXChannel);
  xmms_cfg_write_int(cfg,CUBE_CONFIG_TAG,"adxvolume",pSettings->ADXVolume);

  xmms_cfg_write_file(cfg,pFileName);

  xmms_cfg_free(cfg);
  g_free(pFileName);
  return true;
}
