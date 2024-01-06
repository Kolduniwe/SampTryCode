// This is a comment
// Uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
    print("\n--------------------------------------");
    print(" Blank Filterscript by your name here");
    print("--------------------------------------\n");
    return 1;
}

public OnFilterScriptExit()
{
    return 1;
}

#else

main()
{
    print("\n----------------------------------");
    print(" Blank Gamemode by your name here");
    print("----------------------------------\n");
}

#endif

public OnGameModeInit()
{
    SetGameModeText("Blank Script");
    AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);

    // Добавим спавн на Grove Street
    AddPlayerClass(1, 2490.0, -1665.0, 13.5, 90.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(2, 2490.0, -1665.0, 13.5, 90.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(3, 2490.0, -1665.0, 13.5, 90.0, 0, 0, 0, 0, 0, 0);

    return 1;
}

public OnGameModeExit()
{
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    // Координаты Grove Street
    new Float:spawnPos[3][3] = {
        {2490.0, -1665.0, 13.5}, // Координаты для класса 1
        {2490.0, -1665.0, 13.5}, // Координаты для класса 2
        {2490.0, -1665.0, 13.5}  // Координаты для класса 3
    };

    SetPlayerPos(playerid, spawnPos[classid][0], spawnPos[classid][1], spawnPos[classid][2]);
    SetPlayerCameraPos(playerid, spawnPos[classid][0], spawnPos[classid][1], spawnPos[classid][2]);
    SetPlayerCameraLookAt(playerid, spawnPos[classid][0], spawnPos[classid][1], spawnPos[classid][2]);

    return 1;
}

public OnPlayerConnect(playerid)
{
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    return 1;
}

public OnPlayerSpawn(playerid)
{
    // Координаты Grove Street
    new Float:spawnPos[3][3] = {
        {2490.0, -1665.0, 13.5}, // Координаты для класса 1
        {2490.0, -1665.0, 13.5}, // Координаты для класса 2
        {2490.0, -1665.0, 13.5}  // Координаты для класса 3
    };

    SetPlayerPos(playerid, spawnPos[0][0], spawnPos[0][1], spawnPos[0][2]);
    SetPlayerCameraPos(playerid, spawnPos[0][0], spawnPos[0][1], spawnPos[0][2]);
    SetPlayerCameraLookAt(playerid, spawnPos[0][0], spawnPos[0][1], spawnPos[0][2]);

    return 1;
}

// Другие обработчики событий оставьте без изменений

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
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
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

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

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

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
