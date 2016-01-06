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
	version = "1.1"
}

bool HOSTAGES_ENTITY_SET = false;
bool HOSTAGES_EXIST = false;

int MODELS_ENTITIES[4];

/// Will be changed to read from file
static char MODELS_PATHS[4][256] = {"models/csgo_hosty/hostage_01.mdl", "models/csgo_hosty/hostage_02.mdl", "models/csgo_hosty/hostage_03.mdl", "models/csgo_hosty/hostage_04.mdl"};

/*
 * Plugin Events
 */
public void OnPluginStart() 
{
	HookEvent("round_start", OnRoundStart);
}

/*
 * Game Events
 */
public void OnMapStart() 
{
	HOSTAGES_ENTITY_SET = false;
	HOSTAGES_EXIST = false;

	GetHostagesModelsEntities();
	
	if(HOSTAGES_EXIST)
		PrecacheModels();
}

public void OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	if(HOSTAGES_EXIST)
	{
		GetHostagesModelsEntities();
		SetRandomHostagesModels();
	}	
}

public Action CS_OnTerminateRound(float &delay, CSRoundEndReason &reason)
{
	if(reason == CSRoundEnd_GameStart)
	{
		if(HOSTAGES_EXIST)
		{
			GetHostagesModelsEntities();
			SetRandomHostagesModels();
		}	
	}

	return Plugin_Continue;
}

/*
 * Usefull Functions
 */

/// Traing to get entities hostages standard models and check are hostages exists on map.
public void GetHostagesModelsEntities()
{
	int entity = -1;
	int entity_count = 0;
	
	while ( (entity = FindEntityByClassname(entity, "hostage_entity")) > -1)
	{
		MODELS_ENTITIES[entity_count] = entity;
		entity_count++;
	}
	
	if(!HOSTAGES_ENTITY_SET)
	{
		if(entity_count > 0)
		{
			HOSTAGES_EXIST = true;
			PrintToServer("Hosty znalezione: %d", entity_count);
		}
		else
		{
			HOSTAGES_EXIST = false;
		}
		
		HOSTAGES_ENTITY_SET = true;
	}
}

/// Precashing models - used on map start.
public void PrecacheModels()
{
	PrecacheModel(MODELS_PATHS[0], true);
	PrecacheModel(MODELS_PATHS[1], true);
	PrecacheModel(MODELS_PATHS[2], true);
	PrecacheModel(MODELS_PATHS[3], true);
}

/// Set hostages as random models
public void SetRandomHostagesModels() 
{
	for(int entity_count = 0; entity_count < sizeof(MODELS_ENTITIES); entity_count++)
	{
		int random = GetRandomInt(0, 3);
		SetEntityModel(MODELS_ENTITIES[entity_count], MODELS_PATHS[random]);
		SetEntityRenderColor(MODELS_ENTITIES[entity_count], 255, 255, 255, 255);
	}
}
