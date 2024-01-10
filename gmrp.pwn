/*
	Основа мода SAMP RP (0.3.7-R2).
	Автор: Shadoman (https://vk.com/pavelkluev).

	Версия 0.1:
	-Система регистрации/авторизации.
	-Аренда мопеда на спавне
*/

#include <a_samp>
#include <a_mysql>
#include <zcmd>
#include <mxdate>
#include <streamer>
#include <a_actor>


#define SERVER_NAME     "MegaMozg Rp"
#define SERVER_NAME2    "MegaMozg Rp"
#define GAMEMODE_NAME   "MegaMozg"

#define bonuslevel      1
#define bonusmoney      0
#define bonusdonate     0

#define MySQL_HOST      "127.0.0.1"
#define MySQL_USER      "root"
#define MySQL_BASE      "RolePlay"
#define MySQL_PASS      ""

#define SERVER_COLOR    0xA70000FF
#define SERVER_COLOR2   {A70000}

#define COLOR_WHITE     0xFFFFFFFF
#define COLOR_RED       0xFF0000FF
#define COLOR_GREY      0xC9C9C9FF
#define COLOR_YELLOW 0xFFFF00AA // 

#define PN(%1) Account[%1][pName]

forward player_kick(playerid); public player_kick(playerid) Kick(playerid);
#define pKick(%1) SetTimerEx("player_kick", 200, false, "i", %1)
#define COLOR_GREEN 0x00FF00FF // ????????? ????.




#pragma tabsize 0


#define COLOR_SYSTEM 0xEFEFF7AA
#define COLOR_LIGHTBLUE 0x33CCFFAA


main() print("Gamemode successfully loaded.");


new MySQL:dbHandle;

enum player_info
{
	pID,
	pName[25],
	pPass[21],
	pMail[36],
	pRDate,
	pIP,
	pSex,
	pSkin,
	pLevel,
	pExp,
	pMoney,
	pDonate,
	pPNum,
	pWanted
}
new Account[MAX_PLAYERS][player_info];

new SkinsMan[6][1] =
{
	{102},
	{103},
	{104},
	{105},
	{107},
	{106}
};
new SkinsGirl[3][1] =
{
    {194},
    {195},
    {192}
};

new bool:playerlogin[MAX_PLAYERS];
new playerip[MAX_PLAYERS];
new attemplogin[MAX_PLAYERS];
new last_pick[MAX_PLAYERS];
new rentplayercar[MAX_PLAYERS];

new jobotaPickupID[3];
new PlayerInJob2[MAX_PLAYERS];
new Meshki2[MAX_PLAYERS];
new Meshok2[MAX_PLAYERS];
new Oldskin1[MAX_PLAYERS];







new Float:GruzX[MAX_PICKUPS], Float:GruzY[MAX_PICKUPS], Float:GruzZ[MAX_PICKUPS];

new arendbike[2];
new Float:Gruz[MAX_PICKUPS];

forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}

public OnGameModeInit()
{
	SetGameModeText("MEGAMOZG RP");
	SendRconCommand("hostname MegaMozg RolePlay");
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	dbHandle = mysql_connect(MySQL_HOST, MySQL_USER, MySQL_PASS, MySQL_BASE);
	SetTimer("update_second", 1000, true);
	

	load();

    return 1;

}
public OnGameModeExit()
{
 	SetGameModeText("Blank Script");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case 1:
	    {
	        if(!response) { SendClientMessage(playerid, COLOR_RED, "Вы были отключены от сервера. Причина: отказ от регистрации."); pKick(playerid); return 1; }
	        if(!strlen(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 20) return SendClientMessage(playerid, COLOR_GREY, "Пароль должен содержать от 6 до 20 символов!"); connect_dialog(playerid, 0);
	        for(new i = strlen(inputtext)-1; i != -1; i--)
	        {
	            switch(inputtext[i])
	            {
	                case '0'..'9', 'a'..'z', 'A'..'Z': continue;
	                default: { SendClientMessage(playerid, COLOR_GREY, "Пароль должен содержать только английские символы!"); connect_dialog(playerid, 0); return 1; }
	            }
	        }
	        strmid(Account[playerid][pPass], inputtext, 0, strlen(inputtext), 20);
	        connect_dialog(playerid, 1);
	    }
	    case 2:
	    {
	        if(!response) { SendClientMessage(playerid, COLOR_RED, "Вы были отключены от сервера. Причина: отказ от регистрации."); pKick(playerid); return 1; }
	        if(!strlen(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 20) return SendClientMessage(playerid, COLOR_GREY, "Адрес электронной почты должен содержать от 6 до 35 символов!"); connect_dialog(playerid, 1);
	        for(new i = strlen(inputtext)-1; i != -1; i--)
	        {
	            switch(inputtext[i])
	            {
	                case '0'..'9', 'a'..'z', 'A'..'Z', '@', '.': continue;
	                default: { SendClientMessage(playerid, COLOR_GREY, "Адрес электронной почты должен содержать только английские символы!"); connect_dialog(playerid, 1); return 1; }
	            }
	        }
	        if(strfind(inputtext, "@", false))
	        {
				if(strfind(inputtext, ".", false))
				{
					strmid(Account[playerid][pMail], inputtext, 0, strlen(inputtext), 35);
					connect_dialog(playerid, 2);
				}
			}
	        else { SendClientMessage(playerid, COLOR_GREY, "Адрес электронной почты не соответствует требованиям!"); connect_dialog(playerid, 1); return 1; }
	    }
		case 3:
		{
		    if(response)
			{
				Account[playerid][pSex] = 1;
				new rand = random(6);
				Account[playerid][pSkin] = SkinsMan[rand][0];
				create_account(playerid, Account[playerid][pPass]);
			}
		    else
			{
				Account[playerid][pSex] = 2;
				new rand = random(3);
				Account[playerid][pSkin] = SkinsGirl[rand][0];
				create_account(playerid, Account[playerid][pPass]);
			}
		}
		case 4:
		{
		    if(!response) { SendClientMessage(playerid, COLOR_RED, "Вы были отключены от сервера. Причина: отказ от авторизации."); pKick(playerid); return 1; }
		    if(!strlen(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 20) { SendClientMessage(playerid, COLOR_GREY, "Вы ничего не ввели!"); connect_dialog(playerid, 3); return 1; }
		    for(new i = strlen(inputtext)-1; i != -1; i--)
	        {
	            switch(inputtext[i])
	            {
	                case '0'..'9', 'a'..'z', 'A'..'Z': continue;
	                default: { SendClientMessage(playerid, COLOR_GREY, "Пароль может содержать только английские символы!"); connect_dialog(playerid, 3); return 1; }
	            }
	        }
		    if(!strcmp(Account[playerid][pPass], inputtext))
	        {
	            static const fmt_query[] = "SELECT * FROM `accounts` WHERE `name` = '%s'";
				new query[sizeof(fmt_query)-2+MAX_PLAYER_NAME];
				format(query, sizeof(query), fmt_query, Account[playerid][pName]);
				mysql_tquery(dbHandle, query, "upload_player_account","i", playerid);
	        }
	        else
	        {
	            attemplogin[playerid]++;

	            static const fmt_str[] = "Вы ввели неверный пароль! Попытка {FFBA00}%d/3";
				new string[sizeof(fmt_str)-2+1];
				format(string, sizeof(string), fmt_str, attemplogin[playerid]);
				SendClientMessage(playerid, COLOR_GREY, string);
				if(attemplogin[playerid] == 3) { SendClientMessage(playerid, COLOR_RED, "Вы были отключенны от сервера. Причина: попытка взлома."); pKick(playerid); return 1; }

				connect_dialog(playerid, 3);
	        }
		}
		case 9999:
		{
		    if(response)
		    {
		        new Float:posx,Float:posy,Float:posz,Float:angle;
		        GetPlayerPos(playerid, posx, posy, posz);
		        GetPlayerFacingAngle(playerid, angle);
		        rentplayercar[playerid] = AddStaticVehicle(462, posx, posy, posz, angle, 1, 1);
		        PutPlayerInVehicle(playerid, rentplayercar[playerid], 0);
		        SendClientMessage(playerid, SERVER_COLOR, "Вам был выдан мопед.");
		    }
		}



 }
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{

	return 0;
}

public OnPlayerConnect(playerid)
{
	SetSpawnInfo(playerid,0,0,0.0,0.0,0.0,0.0, 0, 0, 0, 0, 0, 0);
	GameTextForPlayer(playerid, "~w~Welcome to~n~~p~"SERVER_NAME2"", 3000, 4);
	SetTimerEx("player_connect", 2000, false, "i", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	attemplogin[playerid] = 0;
	PlayerInJob2[playerid] = 0;
	Meshok2[playerid] = 0;
    Meshki2[playerid] = 0;
    Oldskin1[playerid] = 0;


	
	return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerPos(playerid,1655.6780,-1661.3866,22.5156);
   	SetPlayerFacingAngle(playerid, 37.0911);
    SetCameraBehindPlayer(playerid);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    
    SetPlayerScore(playerid, Account[playerid][pLevel]);
	GivePlayerMoney(playerid, Account[playerid][pMoney]);
	SetPlayerSkin(playerid, Account[playerid][pSkin]);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    new string[256];

    
    if(PlayerToPoint(2.0, playerid,1949.7305, -1833.7787, 7.0781))
	  {
	  Meshok2[playerid] = 1;
   ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,0,1,1,1,1);
	  SetPlayerAttachedObject(playerid, 2, 2060, 5, 0.01, 0.1, 0.2, 100, 10, 85);
    SetPlayerCheckpoint(playerid,1948.8527, -1839.9474, 3.9844,2.0);
    }

    if(PlayerToPoint(2.0, playerid,1948.8527, -1839.9474, 3.9844))
	  {
	  Meshok2[playerid] = 0;
	  ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);
	  Meshki2[playerid]++;
	  if(IsPlayerAttachedObjectSlotUsed(playerid,2)) RemovePlayerAttachedObject(playerid,2);
	  format(string, sizeof(string), "Мешков перетащено {A52A2A}%d",Meshki2[playerid]);
	  SendClientMessage(playerid, COLOR_SYSTEM, string);
    SetPlayerCheckpoint(playerid,1949.7305, -1833.7787, 7.0781,2.0);
    GivePlayerMoney(playerid, Meshki2[playerid]*5); // 
    format(string, sizeof(string), "{FFFAFA}Вы получили {228B22}%d$ {FFFAFA}за {A52A2A}%d {FFFAFA}мешка(ов)",Meshki2[playerid]*5,Meshki2[playerid]);
    }

    return 1;
}


public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

new GruzMessageShown[MAX_PLAYERS];
new GruzWeaponGiven[MAX_PLAYERS];





forward OnPlayerPickUpPickup(playerid, pickupid);
public OnPlayerPickUpPickup(playerid, pickupid)
{



	
	return 1;
  }

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if (pickupid == arendbike[0])
    {
        if (last_pick[playerid] > gettime())
            return 1;

        if (rentplayercar[playerid] != 0)
        {
            DestroyVehicle(rentplayercar[playerid]);
            rentplayercar[playerid] = 0;
            SendClientMessage(playerid, COLOR_GREY, "Ваш арендованный мопед был удален!");
            return 1;
        }

        ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "{A70000}Аренда мопедов",
            "\
                {FFFFFF}Аренда мопедов.\n\n\
                Информация:\n\
                - Если арендованный транспорт не будет использоваться в течении 5-ти минут,\n\
                - Он будет удален автоматически!\
            ",
            "Арендовать", "Отмена");

        last_pick[playerid] = gettime() + 5;
    }

    
    

    if (pickupid == Gruz[0])
    {
        if (!GruzMessageShown[playerid])
        {
            SendClientMessage(playerid, COLOR_GREEN, "Здесь Можно купить оружие!");
            GruzMessageShown[playerid] = 1;
        }
        if (GetPlayerMoney(playerid) >= 1)
		{
		GivePlayerMoney(playerid, -1); // Снимаем 1 виртуальную денежную единицу
        GivePlayerWeapon(playerid, 10, 1);
        GivePlayerWeapon(playerid, 22, 1);
        GruzWeaponGiven[playerid] = 1; // Тут ваш комментарий
        }
    else
    {
    if (last_pick[playerid] > gettime())
	return 1;
        SendClientMessage(playerid, COLOR_RED, "Идите работать, у вас нет денег!");
        
    last_pick[playerid] = gettime() + 5;
        return 0; // Отменяем действие, так как у игрока нет денег
    }
        return 1;
    } // Закрываем фигурную скобку для первого блока

    if (pickupid == jobotaPickupID[0])
    {
    if (last_pick[playerid] > gettime())
            return 1;
        // Обработка поднятия первого пикапа "Jobota"
        SendClientMessage(playerid, COLOR_YELLOW, "Go to the work");
        
        PlayerInJob2[playerid] = 1;

        
        
        
        //  PlayerInJob[playerid] = 1;
	Oldskin1[playerid] = GetPlayerSkin(playerid);
	SetPlayerSkin(playerid, 16);
	SetPlayerCheckpoint(playerid,1949.7305,-1833.7787,7.0781,2.0);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "На вашей карте отмечен чекпоинт");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "Идите к нему чтобы взять мешок");
	last_pick[playerid] = gettime() + 5;
	return 1;

    }
    if (pickupid == jobotaPickupID[1])
    {
    new string[128];
	if (PlayerInJob2[playerid])
	{

       PlayerInJob2[playerid] = 0;
	SetPlayerSkin(playerid, Oldskin1[playerid]);
    DisablePlayerCheckpoint(playerid);
    format(string, sizeof(string), "{FFFAFA}Вы получили {228B22}%d$ {FFFAFA}за {A52A2A}%d {FFFAFA}мешка(ов)",Meshki2[playerid]*5*3,Meshki2[playerid]);
    SendClientMessage(playerid, COLOR_SYSTEM, string);
    Meshki2[playerid] = 0;
    }
    }
  
    

	return 1;
} // Закрываем фигурную скобку для второго блока



public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
    new animlib[32];
    new animname[32];
    

    
    if(Meshok2[playerid] == 1 && !PlayerToPoint(6.0,playerid,1949.7305, -1833.7787, 7.0781))
                {
                        GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));//???????? ?? ????????
                        if(strcmp(animname, "IDLE_STANCE", true) != 0 && strcmp(animname, "RUN_CIVI", true) != 0 && strcmp(animname, "WALK_CIVI", true) != 0 && strcmp(animname, "crry_prtial", true) != 0 && strcmp(animname, "SPRINT_PANIC", true) != 0 && strcmp(animname, "RUN_PLAYER", true) != 0 && strcmp(animname, "WALK_PLAYER", true) != 0 && strcmp(animname, "SPRINT_CIVI", true) != 0)
                        {
                         Meshok2[playerid] = 0;
            SendClientMessage(playerid, COLOR_RED, "Вы уронили мешок!");
            if (IsPlayerAttachedObjectSlotUsed(playerid, 2)) RemovePlayerAttachedObject(playerid, 2);
            ApplyAnimation(playerid, "PED", "IDLE_tired", 4.1, 0, 1, 1, 0, 1);
                    SetPlayerAttachedObject(playerid,1, 18634, 14, 0.333391, 0.000000, 0.042249, 358.219909, 268.014739, 170.032974, 2.003867, 1.764811, 1.579773);// ???? ?????
                                SetPlayerCheckpoint(playerid,1948.8527, -1839.9474, 3.9844,6.0);

                        }
                }

    return 1;
}


public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

forward player_connect(playerid);
public player_connect(playerid)
{
    SetPlayerCameraPos(playerid, 1404.1823, -1583.4518, 82.3703);
	SetPlayerCameraLookAt(playerid, 1404.6460, -1584.3406, 82.1597);
	for(new i; i < 25; i++) SendClientMessage(playerid, 0xFFFFFFFF, "");
	SendClientMessage(playerid, SERVER_COLOR, "Добро пожаловать на сервер!");
	playerlogin[playerid] = false;
	
	GetPlayerName(playerid, Account[playerid][pName], 24);
	
	static const fmt_query[] = "SELECT * FROM `accounts` WHERE `name` = '%s'";
	new query[sizeof(fmt_query)-2+MAX_PLAYER_NAME];
	format(query, sizeof(query), fmt_query, PN(playerid));
	mysql_tquery(dbHandle, query, "find_in_table","i", playerid);
	
}

forward find_in_table(playerid);
public find_in_table(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows) { connect_dialog(playerid, 3); cache_get_value_name(0, "password", Account[playerid][pPass], 20); }
	else connect_dialog(playerid, 0);
	return 1;
}

forward upload_player_account(playerid);
public upload_player_account(playerid)
{
    cache_get_value_name_int(0, "id", Account[playerid][pID]);
	cache_get_value_name(0, "mail", Account[playerid][pMail], 35);
	cache_get_value_name(0, "accountip", Account[playerid][pIP], 16);
	cache_get_value_name(0, "datareg", Account[playerid][pRDate], 16);
	cache_get_value_name_int(0, "sex", Account[playerid][pSex]);
	cache_get_value_name_int(0, "skin", Account[playerid][pSkin]);
	cache_get_value_name_int(0, "level", Account[playerid][pLevel]);
	cache_get_value_name_int(0, "exp", Account[playerid][pExp]);
	cache_get_value_name_int(0, "money", Account[playerid][pMoney]);
	cache_get_value_name_int(0, "phonenum", Account[playerid][pPNum]);
	cache_get_value_name_int(0, "donate", Account[playerid][pDonate]);
	
	playerlogin[playerid] = true;
	SpawnPlayer(playerid);
	static const fmt_str[] = "~w~Welcome~n~~b~%s";
	new string[sizeof(fmt_str)-2+MAX_PLAYER_NAME];
	format(string, sizeof(string), fmt_str, PN(playerid));
	GameTextForPlayer(playerid, string, 3000, 1);
	SendClientMessage(playerid, SERVER_COLOR, "Ваш аккаунт успешно загружен. Приятной игры!");
	return 1;
}

forward update_second(playerid);
public update_second(playerid)
{

}

stock connect_dialog(playerid, dialogid)
{
	switch(dialogid)
	{
	    case 0:
	    {
	        static const fmt_str[] =
			"\
				{A70000}Добро пожаловать на сервер "SERVER_NAME2".\n\n\
				{FFFFFF}Ваш аккаунт {A70000}не зарегистрирован{FFFFFF} на сервере.\n\n\
				{FFFFFF}Ваш логин: {A70000}%s.\n\
				{FFFFFF}Статус аккаунта: {A70000}Свободен.\n\n\
				{FFFFFF}Для продолжения придумайте пароль:\n\
				{A70000}-{FFFFFF}Пароль должен содержать от {A70000}6{FFFFFF} до {A70000}20{FFFFFF} символов.\n\
				{A70000}-{FFFFFF}Пароль должен содержать только символы английского алфавита.\
			";
			new string[sizeof(fmt_str)-2+MAX_PLAYER_NAME];
			format(string, sizeof(string), fmt_str, PN(playerid));
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, "{FFFFFF}Регистрация {A70000}[1/3]{FFFFFF} | Пароль", string, "Далее", "Выход");
	    }
	    case 1:
	    {
			ShowPlayerDialog(playerid, 2, DIALOG_STYLE_INPUT, "{FFFFFF}Регистрация {A70000}[2/3]{FFFFFF} | Почта",
			"\
                {FFFFFF}Введите ваш {A70000}настоящий{FFFFFF} адрес электронной почты\n\n\
				{FFFFFF}Примечание:\n\
				{A70000}-{FFFFFF}Почта нужна для восстановления пароля от аккаунта\n\
				{A70000}-{FFFFFF}Почта нужна для связи администрации с вами\
			",
			"Далее", "Выход");
	    }
	    case 2: ShowPlayerDialog(playerid, 3, DIALOG_STYLE_MSGBOX, "{FFFFFF}Регистрация {A70000}[3/3]{FFFFFF} | Выбор пола", "{FFFFFF}Выберите пол вашего будущего персонажа", "Мужской", "Женский");
	    case 3:
	    {
	        static const fmt_str[] =
			"\
				{A70000}Добро пожаловать на сервер "SERVER_NAME2".\n\n\
				{FFFFFF}Ваш аккаунт {A70000}зарегистрирован{FFFFFF} на сервере.\n\n\
				{FFFFFF}Ваш логин: {A70000}%s.\n\
				{FFFFFF}Статус аккаунта:{A70000}Зарегистрирован.\n\n\
				{FFFFFF}Для продолжения введите пароль:\
			";
			new string[sizeof(fmt_str)-2+MAX_PLAYER_NAME];
			format(string, sizeof(string), fmt_str, PN(playerid));
			ShowPlayerDialog(playerid, 4, DIALOG_STYLE_INPUT, "{FFFFFF}Авторизация", string, "Далее", "Выход");
	    }
	}
}

stock create_account(playerid, password[])
{
    new strdate[24];
	new year,month,day;

	Account[playerid][pMoney] = bonusmoney;
	Account[playerid][pLevel] = bonuslevel;
	Account[playerid][pDonate] = bonusdonate;
	Account[playerid][pPNum] = random(999999);
	if(Account[playerid][pPNum] < 100000) return Account[playerid][pPNum] += 100001;
	
	GetPlayerIp(playerid, playerip[playerid], 32);
    getdate(year, month, day);
    format(strdate, sizeof(strdate), "%d.%d.%d",day,month,year);
    
    static const fmt_query[] =
	"\
		INSERT INTO `accounts` (`name`, `password`, `accountip`, `datareg`, `mail`, `sex`, `skin`, `level`, `exp`, `money`, `phonenum`, `donate`)\
		VALUES ('%s', '%s', '%s', '%s', '%s', '%d', '%d', '%d', '%d', '%d', '%d', '%d')\
	";
    new query[sizeof(fmt_query)-2+MAX_PLAYER_NAME-2+20-2+32-2+24-2+35-2+1-2+3-2+4-2+8-2+11-2+6-2+11];
    format(query, sizeof(query), fmt_query
	,
		Account[playerid][pName],
		password,
		playerip[playerid],
		strdate,
		Account[playerid][pMail],
		Account[playerid][pSex],
		Account[playerid][pSkin],
		Account[playerid][pLevel],
		Account[playerid][pExp],
		Account[playerid][pMoney],
		Account[playerid][pPNum],
		Account[playerid][pDonate]
	);
    mysql_tquery(dbHandle, query, "", "");
    
    playerlogin[playerid] = true;
	SpawnPlayer(playerid);
	static const fmt_str[] = "~w~Welcome~n~~b~%s";
	new string[sizeof(fmt_str)-2+MAX_PLAYER_NAME];
	format(string, sizeof(string), fmt_str, PN(playerid));
	GameTextForPlayer(playerid, string, 3000, 1);
	SendClientMessage(playerid, SERVER_COLOR, "Вы успешно завершили регистрацию. Приятной игры!");
	return 1;
}

stock load()
{
    arendbike[0] = CreateDynamicPickup(19134, 23, 1659.0771,-1685.1560,21.4306);

    Create3DTextLabel("{EB9500}?????? ??????", -1, 1659.0771,-1685.1560,13.3884, 21.4306, 0, 1);
    
	GruzX[0] = 1658.3070;
	GruzY[0] = -1692.1095;
	GruzZ[0] = 15.6094;
	Gruz[0] = CreateDynamicPickup(1254, 1, GruzX[0], GruzY[0], GruzZ[0], -1);
	Create3DTextLabel("устроиться на роботу", COLOR_GREEN, GruzX[0], GruzY[0], GruzZ[0], 0, 1);

// Функция для создания трех пикапов "Jobota"

    // Первый пикап
    jobotaPickupID[0] = CreateDynamicPickup(1239, 1, 1986.8145,-1856.9623,3.9844);
    jobotaPickupID[1] = CreateDynamicPickup(2060, 1, 1992.8214,-1857.6216,3.9844);
    
   
	Create3DTextLabel("[Раздевалка]\nВстань на иконку чтобы надеть рабочую одежду",0x0000FFAA,2137.8227539063,-2282.4379882813,20.671875,40.0,0, 1);
	Create3DTextLabel("[Касса]\nВстань на иконку чтобы получить зарплату",0x0000FFAA,2127.6430664063,-2275.4113769531,20.671875,40.0,0, 1);
	Create3DTextLabel("Помощь по работе",0x0000FFAA,2182.0974121094,-2252.8625488281,14.7734375,40.0,0, 1);
    


    return 1;
}

