/*


													Very Important Persone [V.I.P]
			                                            System
															 By
												               RyderX
																   Version
																		   1.0
																		   
																																						  */

//]]=========INCLUDES & DEFINES============[[//
#define FILTERSCRIPT
#include <a_samp>
#include <zcmd>
#include <sscanf>
#include <YSI\y_ini>
#include <foreach>
#define PATH "VIPUser/%s.ini"
#define DIALOG_VIPS 15
//]]============ NEW ===============[[//
new Text3D:bronzelabel[MAX_PLAYERS];
new Text3D:silverlabel[MAX_PLAYERS];
new Text3D:goldlabel[MAX_PLAYERS];
//]]==========Enumerator============[[//
enum pInfo
{
	pVIP
}
new PlayerInfo[MAX_PLAYERS][pInfo];
//]]==========Loading user info==============[[//
forward LoadUser_data(playerid,name[],value[]);
public LoadUser_data(playerid,name[],value[])
{
	INI_Int("VIP",PlayerInfo[playerid][pVIP]);
 	return 1;
}
//]]=========== Stocks =================[[//
stock UserPath(playerid)
{
	new string[128],playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid,playername,sizeof(playername));
	format(string,sizeof(string),PATH,playername);
	return string;
}
stock udb_hash(buf[]) {
	new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

stock GetName(playerid)
{
	new uName[24];
	GetPlayerName(playerid, uName, sizeof(uName));
	return uName;
}


//]]=========Beginning of the Script=============[[//
public OnPlayerConnect(playerid)
{
    new string[186];
	new name[MAX_PLAYER_NAME];

    GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	format(string, sizeof(string), "{ffff00}<{00ffff}+{ffff00}> {F00F00}%s {FFFFFF}has joined the server! {00FF00}(Joined)", name);
	SendClientMessageToAll(0xF8F8F8FFF, string);

	new vip[128];
	format(vip,sizeof(vip),"-RegVIP- {ffff00}Hello Mr.{00FF00}%s {ffff00}Your V.I.P Level is {00FF00}%i{ffff00}!",name,PlayerInfo[playerid][pVIP]);
	SendClientMessage(playerid, 0xF8F8F8FFF,vip);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    new string[186];
    new name [MAX_PLAYER_NAME];

    GetPlayerName(playerid, name, MAX_PLAYER_NAME);
    switch(reason)
    {

	   case 0: format(string, sizeof(string), "{ffff00}<{F46F45}-{ffff00}> %s {FFFFFF}Has Left the server! {ff0000}(TimeOut/Crashed)", name);
	   case 1: format(string, sizeof(string), "{ffff00}<{F46F45}-{ffff00}> %s {FFFFFF}Has Left the server! {ff0000}(Leaving)", name);
	   case 2: format(string, sizeof(string), "{ffff00}<{F46F45}-{ffff00}> %s {FFFFFF}Has Left the server! {ff0000}(Kicked/Banned)", name);
    }
    SendClientMessageToAll(-1, string);
	new INI:File = INI_Open(UserPath(playerid));
	INI_SetTag(File,"data");
	INI_WriteInt(File,"VIP",PlayerInfo[playerid][pVIP]);
	INI_Close(File);
	return 1;
}

public OnPlayerText(playerid, text[])
{
   if(PlayerInfo[playerid][pVIP] >= 1)
   {
   new gangstring[128];
   format(gangstring, sizeof(gangstring), "{FF0F89}[V.I.P] {FFFFFF}%s",text);
   SendPlayerMessageToAll(playerid, gangstring);
   }
   else
   {
   new gangstring2[128];
   format(gangstring2, sizeof(gangstring2), "{FF0F89}[%d] {FFFFFF}%s",playerid,  text);
   SendPlayerMessageToAll(playerid, gangstring2);
   }
   return 0;
}


//-----------------------------------------------------------------------------
public OnPlayerSpawn(playerid)
{
  if(PlayerInfo[playerid][pVIP] >= 1)
    {
	SendClientMessage(playerid, 0xf8f8f8fff, "{ff0000}Info: {F00f00}You're a V.I.P Membership, type {ff0ff0}/vipcmds {f00f00}to get your commands!");
	}
	else
	{
	//Nothing
	}
  if(PlayerInfo[playerid][pVIP] >= 0)
    {
	SendClientMessage(playerid, 0xf8f8f8fff, "{ff0000}Info: {FF44ff}type /cmds to get your commands!");
	SendClientMessage(playerid, 0xf8f8f8fff, "{ff0000}Info: {ff0ff0}type /stats to get your stats!");
	}
	else
	{
	//Nothing
	}
  if(PlayerInfo[playerid][pVIP] >= 1)
	{
	new string2[129]; new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(string2,sizeof(string2),"-RegVIP- {00FF00}Mr.%s Has Logged in his V.I.P Account Level %i!",name,PlayerInfo[playerid][pVIP]);
	SendClientMessageToAll(0xF8F8F8FFF,string2);
	}
	else
	{
	new not[128]; new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(not,sizeof(not),"-RegServ- {00FF00}Mr.%s Has Logged in The Server.",name);
	SendClientMessageToAll(0xF8F8F8FFF,not);
	}
  return 1;
}
//-----------------------------------------------------------------------------

//----------------------RCON Commands--------------------------//
CMD:setvip(playerid, params[])
{
    if(IsPlayerAdmin(playerid))
    {
        new string[MAX_PLAYER_NAME+128],
             pname[MAX_PLAYER_NAME],
             tname[MAX_PLAYER_NAME],
             targetid,
             vip;

		if(sscanf(params, "ii", targetid, vip))
        {
            return SendClientMessage(playerid, 0xF8F8F8FFF, "Syntax: {F00f00}/setvip [ID] [Level]");
        }
        for(new i=0;i<MAX_PLAYERS; i++) continue; {
                 if((!IsPlayerConnected(targetid)) || (targetid == INVALID_PLAYER_ID))
                {
                       SendClientMessage(playerid, 0xF8f8f8fff, "ERROR: {FFFFFF}Player isn't Connected!");
                }
	}
        if(vip < 0 || vip > 3)
        {
        	return SendClientMessage( playerid, 0xF8F8F8FFF, "ERROR: {FFFFFF}highest Level is 3.");
		}
        else
        {
            GetPlayerName(playerid, pname, sizeof(pname));
            GetPlayerName(targetid, tname, sizeof(tname));
            format(string, sizeof(string), "{FFFF00}- {ff0000}Adm{00ffff}CMD{FFFF00} - {FFD700}%s {15ff00}has set {FFD700}%s {15ff00}V.I.P Level to {FFD700}%i{15ff00}.", pname, tname, vip);
            SendClientMessageToAll(0xF8F8F8FFF, string);
            new INI:File = INI_Open(UserPath(targetid));
            PlayerInfo[targetid][pVIP] = vip;
            INI_WriteInt(File,"VIP",vip);
       	    INI_Close(File);
            return 1;
        }
    }
    else
    {
	    SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFFFF}You aren't authorized to use this command!");
    }
    return 1;
}
//-------------------------------------------------------------------------

//---------------------Players & V.I.P Commands----------------------------
CMD:viplist(playerid, params[]) {
	new
	    str[MAX_PLAYER_NAME+250],
	    Count,
	    pname[MAX_PLAYER_NAME];
 	for(new i=0; i<MAX_PLAYERS; i++){
		if(IsPlayerConnected(i) && PlayerInfo[i][pVIP] > 0) {
			GetPlayerName(i, pname, sizeof(pname));
   			Count++;
		}
 	}
	if(Count == 0) return SendClientMessage(playerid, 0xf8f8f8fff, "ERROR: {f00f00}There are no VIPs online at the moment!");
	format(str, sizeof(str),"%s(%i) | VIP Level: {FFFF00}%i",pname,playerid, PlayerInfo[playerid][pVIP]);
	ShowPlayerDialog(playerid, DIALOG_VIPS, DIALOG_STYLE_MSGBOX, "Connected VIPs", str, "Ok", "");
	return 1;
}

CMD:stats(playerid, params[])
{
	new string[250];
	format(string, sizeof(string), "{FFFFFF}Your Stats:\n\n{FF0000}V.I.P Level: {009f07}%d",PlayerInfo[playerid][pVIP]);
    ShowPlayerDialog(playerid, 5, DIALOG_STYLE_MSGBOX, "{00ff00}Your Stats:", string, "Ok", "");
	return 1;
}

CMD:cmds(playerid, params[])
{
    ShowPlayerDialog(playerid, 4, DIALOG_STYLE_MSGBOX, "{00ff00}Server Commands:", "-/stats -> to see your Stats.\n\n-/viplist -> to see Online V.I.P list.\n\n-/vipcost -> to see V.I.P How much it coast.\n\n","Ok", "");
    return 1;
}

CMD:vipcmds(playerid, params[])
{
	if(PlayerInfo[playerid][pVIP] >= 1)
		{
		new string[1200];
		format(string, sizeof(string), "%s{F00F00}•Bronze V.I.P•\n\n",string);
		format(string, sizeof(string), "%s{98B0CD}1. {FFFF00}/vc -> V.I.P Chat\n", string);
		format(string, sizeof(string), "%s{98B0CD}2. {FFFF00}/vipskin -> to change your skin.\n", string);
		format(string, sizeof(string), "%s{98B0CD}3. {FFFF00}/vheal -> Heal yourself.\n", string);
		format(string, sizeof(string), "%s{98B0CD}4. {FFFF00}/varmour -> Armour yourself.\n", string);
		format(string, sizeof(string), "%s{98B0CD}4. {FFFF00}/blabel -> enable Bronze V.I.P 3D Tag.\n", string);
		format(string, sizeof(string), "%s{FFFF00}--------------------------------------------------\n", string);
		format(string, sizeof(string), "%s{F00F00}•Silver V.I.P•\n\n",string);
		format(string, sizeof(string), "%s{98B0CD}1. {FFFF00}/changemytime -> Change your Time.\n", string);
		format(string, sizeof(string), "%s{98B0CD}2. {FFFF00}/changemyweather -> Change your weather.\n", string);
		format(string, sizeof(string), "%s{98B0CD}3. {FFFF00}/vipcolor -> enable V.I.P Color.\n", string);
		format(string, sizeof(string), "%s{98B0CD}4. {FFFF00}/vgodon -> enable God Mode.\n", string);
		format(string, sizeof(string), "%s{98B0CD}5. {FFFF00}/vgodoff -> disable God Mode.\n", string);
		format(string, sizeof(string), "%s{98B0CD}4. {FFFF00}/slabel -> enable Silver V.I.P 3D Tag.\n", string);
		format(string, sizeof(string), "%s{FFFF00}--------------------------------------------------\n", string);
		format(string, sizeof(string), "%s{F00F00}•Gold V.I.P•\n\n",string);
		format(string, sizeof(string), "%s{98B0CD}1. {FFFF00}/vweapons -> get V.I.P Weapon Pack.\n", string);
		format(string, sizeof(string), "%s{98B0CD}2. {FFFF00}/glabel -> enable Gold V.I.P 3D Tag.\n", string);
		format(string, sizeof(string), "%s{98B0CD}3. {FFFF00}/vsay -> Talk As V.I.P in Global Chat.\n", string);
		format(string, sizeof(string), "%s{FFFF00}--------------------------------------------------\n", string);
		
		ShowPlayerDialog(playerid, 188, DIALOG_STYLE_MSGBOX, "VIP Commands", string, "OK", "Leave");
		}
		else
		{
			SendClientMessage(playerid, 0xF8F8f8FFF, "ERROR: {FFFF00}You must be a V.I.P membership to use this command!");
		}
    return 1;
}

CMD:vipcost(playerid, params[])
{
		new string[2200];
		format(string, sizeof(string), "%s{FFDC2E}Bronze VIP [$5.00 USD]\n\n", string);

		format(string, sizeof(string), "%s{FFFFFF}-------------------------------------------------------------------\n\n", string);

		format(string, sizeof(string), "%s{FFDC2E}Silver VIP [$10.00 USD]{FFFFFF}\n\n", string);

		format(string, sizeof(string), "%s{FFFFFF}-------------------------------------------------------------------\n\n", string);

		format(string, sizeof(string), "%s{FFDC2E}Gold VIP [$15.00 USD]{FFFFFF}\n\n", string);

		format(string, sizeof(string), "%s{FFFFFF}-------------------------------------------------------------------\n\n", string);

		ShowPlayerDialog(playerid, 150, DIALOG_STYLE_MSGBOX, "V.I.P Packages", string, "OK", "");
        return 1;
}


//===============V.I.P Bronze Commands===============//

CMD:vc(playerid, params[])
{

	if(PlayerInfo[playerid][pVIP] >= 1)
	{
		new msg[100], str[128], pname[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pname,sizeof( pname));
		if(sscanf(params,"s",msg)) SendClientMessage(playerid, 0xF8f8f8fff,"Syntax: {F00f00}/vc <message>");
        format(str,sizeof(str),"<V.I.P Chat> {8a7ea8}%s(%i): {008000}%s", pname,playerid, msg);
		for(new i; i<MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i) && PlayerInfo[i][pVIP] > 0)
 		  	{
 			  	SendClientMessage(i,0xFA9205FF,str);
 		  	}
		}
	}
	else
	{
	    SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a V.I.P membership to use this command!");
	}
	return 1;
}

CMD:blabel(playerid,params[])
{
	if(PlayerInfo[playerid][pVIP] >= 1)
	{
	new string[128];
	bronzelabel[playerid] = Create3DTextLabel("Bronze {00f88a}V.I.P", 0xF47A00FF, 30.0, 40.0, 50.0, 40.0, 0);
    Attach3DTextLabelToPlayer(bronzelabel[playerid], playerid, 0.0, 0.0, 0.7);
    format(string, sizeof(string), "{FFFF00}- {ff0000}v{00ffff}CMD{FFFF00} - You have enabled your Bronze V.I.P 3D Tag.");
    SendClientMessage(playerid, 0xf8f8f8fff, string);
    }
    else
    {
	SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a Bronze V.I.P membership to use this command!");
	}
	return 1;
}
    
CMD:vheal(playerid,params[])
{
	if(PlayerInfo[playerid][pVIP] >= 1)
	{
	new string[128];
	SetPlayerHealth(playerid, 100);
    format(string, sizeof(string), "{FFFF00}- {ff0000}v{00ffff}CMD{FFFF00} - Your Health-Bare Has been Refilled!");
    SendClientMessage(playerid, 0xf8f8f8fff, string);
	}
	else
	{
	SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a V.I.P membership to use this command!");
	}
	return 1;
}

CMD:varmour(playerid,params[])
{
	if(PlayerInfo[playerid][pVIP] >= 1)
	{
	new string[128];
	SetPlayerArmour(playerid, 100);
    format(string, sizeof(string), "{FFFF00}- {ff0000}v{00ffff}CMD{FFFF00} - Your Armour Has been Refilled!");
    SendClientMessage(playerid, 0xf8f8f8fff, string);
	}
	else
	{
	SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a V.I.P membership to use this command!");
	}
	return 1;
}

CMD:vipskin(playerid, params[])
{
    if(PlayerInfo[playerid][pVIP] >= 1)
    {
    new string[128];
    new SkinID;

    if(sscanf(params, "i", SkinID)) return SendClientMessage(playerid, 0xf8f8f8fff, "Syntax: {F00f00}/vipskin (SkinID)");
    if(SkinID < 0 || SkinID > 311) return SendClientMessage(playerid, 0xf8f8f8fff, "ERROR: {FFFFFF}Invalid skinID (0 -> 311).");
    format(string, sizeof(string), "{FFFF00}- {ff0000}v{00ffff}CMD{FFFF00} - {ff0ff0}Your Skin has set to %d.", SkinID);
    SendClientMessage(playerid, 0xf8f8f8fff, string);
    SetPlayerSkin(playerid, SkinID);
    }
    else
    {
	SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a V.I.P membership to use this command!");
    }
    return 1;
}
//=============Silver V.I.P Commands=============//
CMD:changemyweather(playerid, params[])
{
    if(PlayerInfo[playerid][pVIP] >= 2)
    {
    new weather, string[128];
    if(sscanf(params, "i", weather)) return SendClientMessage(playerid, 0xf8f8f8fff, "Syntax: /changemyweather <0 - 45>");
    if(weather < 0 || weather > 45) return SendClientMessage(playerid, 0xf8f8f8fff, "ERROR: {FFFFFF}Invalid Weather! <0 - 45>");
    SetPlayerWeather(playerid, weather);
    format(string, sizeof(string), "{FFFF00}- {ff0000}v{00ffff}CMD{FFFF00} - Your Weather has changed to Weather %d!",weather);
    SendClientMessage(playerid, 0xf8f8f8fff, string);
    }
    else
    {
	SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a V.I.P membership to use this command!");
    }
    return 1;
}

CMD:changemytime(playerid, params[])
{
    if(PlayerInfo[playerid][pVIP] >= 2)
    {
    new time, string[128];
    if(sscanf(params, "i", time)) return SendClientMessage(playerid, 0xf8f8f8fff, "Syntax: {f00f00}/changemytime <0 - 23>");
    if(time < 0 || time > 23) return SendClientMessage(playerid, 0xf8f8f8fff, "ERROR: {FFFFFF}Invalid Time <0 - 23>.");
    format(string, sizeof(string), "{FFFF00}- {ff0000}v{00ffff}CMD{FFFF00} - {ff0ff0}Your time has changed to %d!",time);
    SendClientMessage(playerid, 0xf8f8f8fff, string);
    SetPlayerTime(playerid, time, 0);
    }
    else
    {
	SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a V.I.P membership to use this command!");
    }
    return 1;
}

CMD:vipcolor(playerid,params[])
{
	if(PlayerInfo[playerid][pVIP] >= 2)
	{
	new string[128];
	new name[128];
	GetPlayerName(playerid,name,sizeof(name));
	SetPlayerColor(playerid,0x00FFFFFF);
	format(string,sizeof(string),"{FFFF00}- {ff0000}v{00ffff}CMD{FFFF00} - {f00f00}Hello Mr.{ff4ff4}%s! {F00F00}You have enabled V.I.P Color!",name);
	SendClientMessage(playerid, 0xf8f8f8fff,string);
	}
	else
	{
	SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a V.I.P membership to use this command!");
    }
    return 1;
}

CMD:vgodon(playerid,params[])
{
	if(PlayerInfo[playerid][pVIP] >= 2)
	{
	new string[128];
	new name[128];
	GetPlayerName(playerid,name,sizeof(name));
	SetPlayerHealth(playerid,199999999);
	format(string,sizeof(string),"{FFFF00}- {ff0000}v{00ffff}CMD{FFFF00} - {f00f00}Hello Mr.{ff4ff4}%s! {F00F00}You have enabled God Mode!",name);
	SendClientMessage(playerid, 0xf8f8f8fff,string);
	GameTextForPlayer(playerid, "~W~!~W~GODMODE ~G~ON~W~!",3000,3);
	}
	else
	{
	SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a V.I.P membership to use this command!");
    }
    return 1;
}

CMD:vgodoff(playerid,params[])
{
	if(PlayerInfo[playerid][pVIP] >= 2)
	{
	new string[128];
	new name[128];
	GetPlayerName(playerid,name,sizeof(name));
	SetPlayerHealth(playerid,199999999);
	format(string,sizeof(string),"{FFFF00}- {ff0000}v{00ffff}CMD{FFFF00} - {f00f00}Hello Mr.{ff4ff4}%s! {F00F00}You have Disabled God Mode!",name);
	SendClientMessage(playerid, 0xf8f8f8fff,string);
	GameTextForPlayer(playerid, "~W~!~W~GODMODE ~R~OFF~W~!",3000,3);
	}
	else
	{
	SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a V.I.P membership to use this command!");
    }
    return 1;
}

CMD:slabel(playerid,params[])
{
	if(PlayerInfo[playerid][pVIP] >= 1)
	{
	new string[128];
    silverlabel[playerid] = Create3DTextLabel("Silver {00f88a}V.I.P", 0x808080FF, 30.0, 40.0, 50.0, 40.0, 0);
    Attach3DTextLabelToPlayer(silverlabel[playerid], playerid, 0.0, 0.0, 0.7);
    format(string, sizeof(string), "{FFFF00}- {ff0000}v{00ffff}CMD{FFFF00} - You have enabled your Silver V.I.P 3D Tag.");
    SendClientMessage(playerid, 0xf8f8f8fff, string);
    }
    else
    {
	SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a Silver V.I.P membership to use this command!");
	}
	return 1;
}
//===================Gold V.I.P Commands==================//
CMD:vweapons(playerid,params[])
{
	if(PlayerInfo[playerid][pVIP] >= 3)
	{
	new string[128];
	new name[128];
	GetPlayerName(playerid,name,sizeof(name));
	GivePlayerWeapon(playerid, 35, 99999999);
	GivePlayerWeapon(playerid, 24, 99999999);
	GivePlayerWeapon(playerid, 26,9999999);
	GivePlayerWeapon(playerid, 9, 99999999);
	GivePlayerWeapon(playerid, 16,999999999);
	GivePlayerWeapon(playerid, 28,99999999);
	GivePlayerWeapon(playerid, 34,99999999);
	GivePlayerWeapon(playerid, 38,99999999);
	GivePlayerWeapon(playerid, 43,99999);
	format(string,sizeof(string),"{FFFF00}- {ff0000}v{00ffff}CMD{FFFF00} - {f00f00}Hello Mr.{ff4ff4}%s! {F00F00}You have got V.I.P Weapons Pack.",name);
	SendClientMessage(playerid, 0xf8f8f8fff,string);
	}
	else
	{
	SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a V.I.P membership to use this command!");
    }
    return 1;
}

CMD:glabel(playerid,params[])
{
	if(PlayerInfo[playerid][pVIP] >= 3)
	{
	new string[128];
    goldlabel[playerid] = Create3DTextLabel("Gold {00f88a}V.I.P", 0xF5AE0AFF, 30.0, 40.0, 50.0, 40.0, 0);
    Attach3DTextLabelToPlayer(goldlabel[playerid], playerid, 0.0, 0.0, 0.7);
    format(string, sizeof(string), "{FFFF00}- {ff0000}v{00ffff}CMD{FFFF00} - You have enabled your Gold V.I.P 3D Tag.");
    SendClientMessage(playerid, 0xf8f8f8fff, string);
    }
    else
    {
	SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a Gold V.I.P membership to use this command!");
	}
	return 1;
}

CMD:vsay(playerid, params[])
{
    if (PlayerInfo[playerid][pVIP] < 3)
        return SendClientMessage(playerid, 0xf8F8F8FFF,"ERROR: {FFFF00}You must be a Gold V.I.P membership to use this command!");

    if (isnull(params))
        return SendClientMessage(playerid, 0xf8f8f8fff, "Syntax: {ff0ff0}/vsay <text>");

    new string[128], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(string, sizeof(string),"{ff0000}(V.I.P){00ffff} %s(%i): {FFFF00}%s", name, playerid, params);
    SendClientMessageToAll(0xF8f8F8FFF, string);
    return 1;
}
//---------------------------------------------------------------------------------
