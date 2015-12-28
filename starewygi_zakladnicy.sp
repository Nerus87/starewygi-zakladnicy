#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

/* modele choinki */
new String:modelZakladnik1[256] = "models/csgo_hosty/Hostage_01.mdl";
new String:modelZakladnik2[256] = "models/csgo_hosty/Hostage_02.mdl";
new String:modelZakladnik3[256] = "models/csgo_hosty/hostage_03.mdl";
new String:modelZakladnik4[256] = "models/csgo_hosty/hostage_04.mdl";

static String:ModelFile[256];

public Plugin:myinfo = {
	name = "Stare-Wygi.pl - Zakladnicy",
	author = "Xseba360",
	version = "1.0"
}

public OnPluginStart() {
	HookEvent("round_start", Event_RoundStart, EventHookMode_Post);
}

public OnMapStart() {
	PrecacheModel(modelZakladnik1,true);
	PrecacheModel(modelZakladnik2,true);
	PrecacheModel(modelZakladnik3,true);
	PrecacheModel(modelZakladnik4,true);
}

public Action:SetHostageModel() {
	new ent = -1;

	while (ent = FindEntityByClassname(ent,"hostage_entity")){
		new randomModelZakladnik = GetRandomInt(1,4);
		if(randomModelZakladnik == 1) {
			ModelFile = modelZakladnik1;
		} else if(randomModelZakladnik == 2) {
			ModelFile = modelZakladnik2;
		} else if(randomModelZakladnik == 3) {
			ModelFile = modelZakladnik3;
		} else if(randomModelZakladnik == 4) {
			ModelFile = modelZakladnik4;
		} else {
			return Plugin_Handled;
		}
		SetEntityModel(ent, ModelFile);
		SetEntityRenderColor(ent, 255, 255, 255, 255);
	}
	return Plugin_Handled;

}

public Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast){
	SetHostageModel();
}