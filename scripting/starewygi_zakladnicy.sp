/*
 * Fixed by Nerus
 */
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
	name = "Stare-Wygi.pl - Zakladnicy",
	author = "Xseba360, fixed by Nerus",
	version = "1.2"
}

bool IS_MAP_WITH_HOSTAGES = false;

/// Will be changed to read from file
static char MODELS[4][256] = {"models/csgo_hosty/hostage_01.mdl", "models/csgo_hosty/hostage_02.mdl", "models/csgo_hosty/hostage_03.mdl", "models/csgo_hosty/hostage_04.mdl"};

/*
 * Plugin Events
 */
public void OnPluginStart() 
{
	SetHooks();
}

public void SetHooks()
{
	HookEvent("round_start", OnRoundStart);
}

/*
 * Game Events
 */
public void OnMapStart() 
{
	IS_MAP_WITH_HOSTAGES = IsHostageMap();
	
	if(IS_MAP_WITH_HOSTAGES)
		PrecacheModels();
}

public void OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	if(IS_MAP_WITH_HOSTAGES)
		SetRandomHostagesModels();
}

public Action CS_OnTerminateRound(float &delay, CSRoundEndReason &reason)
{
	if(reason == CSRoundEnd_GameStart && IS_MAP_WITH_HOSTAGES)
		SetRandomHostagesModels();

	return Plugin_Continue;
}

/*
 * Usefull Functions
 */

/// Precashing models - used on map start.
public void PrecacheModels()
{
	if(!(PrecacheModel(MODELS[0], true) > 0))
		LogErrorStateOnPrecache(0);
	
	if(!(PrecacheModel(MODELS[1], true) > 0))
		LogErrorStateOnPrecache(1);
		
	if(!(PrecacheModel(MODELS[2], true) > 0))
		LogErrorStateOnPrecache(2);
	
	if(!(PrecacheModel(MODELS[3], true) > 0))
		LogErrorStateOnPrecache(3);
}

/// Set hostages as random models
public void SetRandomHostagesModels() 
{
	int entity = -1;

	while ( (entity = FindEntityByClassname(entity, "hostage_entity")) > -1)
	{
		int random = GetRandomInt(0, 3);
		SetEntityModel(entity, MODELS[random]);
		SetEntityRenderColor(entity, 255, 255, 255, 255);
	}
}

public bool IsHostageMap()
{
	char map[32];
	
	if(GetCurrentMap(map, 32) > 0 && StrContains(map, "cs_", false) > -1)
	{
		PrintToServer(map);
		return true;
	}		
	
	return false;
}

public void LogErrorStateOnPrecache(int model_index)
{
	char error[512];
	Format(error, 512, "[S-W:Z] ERROR on precache a given model: %s", MODELS[model_index]);

	LogError(error);
	SetFailState(error);
}
