main()
{
	if ( getdvar( "mapname" ) == "mp_background" )
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	if ( isusingmatchrulesdata() )
	{
		level.initializeMatchRules = ::initializeMatchRules;
		[[ level.initializeMatchRules ]]();
		level thread maps\mp\_utility::reInitializeMatchRulesOnMigration();
	}
	else
	{
		maps\mp\_utility::registerRoundSwitchDvar( level.gameType, 1, 0, 9 );
		maps\mp\_utility::registerTimeLimitDvar( level.gameType, 3 );
		maps\mp\_utility::registerScoreLimitDvar( level.gameType, 0 );
		maps\mp\_utility::registerRoundLimitDvar( level.gameType, 3 );
		maps\mp\_utility::registerWinLimitDvar( level.gameType, 2 );
		maps\mp\_utility::registerNumLivesDvar( level.gameType, 0 );
		maps\mp\_utility::registerHalfTimeDvar( level.gameType, 0 );
		level.matchRules_damageMultiplier = 0;
		level.matchRules_vampirism = 0;
	}

	maps\mp\_utility::setOverTimeLimitDvar( 3 );
	level.objectiveBased = 1;
	level.teamBased = 1;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onDeadEvent = ::onDeadEvent;
	level.onTimeLimit = ::onTimeLimit;
	level.onNormalDeath = ::onNormalDeath;
	level.initGametypeAwards = ::initGametypeAwards;

	if ( level.matchRules_damageMultiplier || level.matchRules_vampirism )
		level.modifyPlayerDamage = maps\mp\gametypes\_damage::gamemodeModifyPlayerDamage;

	level.dd = 1;
	level.bombsPlanted = 0;
	level.ddBombModel = [];
	setBombTimerDvar();
	makedvarserverinfo( "ui_bombtimer_a", -1 );
	makedvarserverinfo( "ui_bombtimer_b", -1 );
	game["dialog"]["gametype"] = "demolition";

	if ( getdvarint( "g_hardcore" ) )
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	else if ( getdvarint( "camera_thirdPerson" ) )
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	else if ( getdvarint( "scr_diehard" ) )
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];
	else if ( getdvarint( "scr_" + level.gameType + "_promode" ) )
		game["dialog"]["gametype"] += "_pro";

	game["dialog"]["offense_obj"] = "obj_destroy";
	game["dialog"]["defense_obj"] = "obj_defend";
}

initializeMatchRules()
{
	maps\mp\_utility::setCommonRulesFromMatchRulesData();
	var_0 = getmatchrulesdata( "demData", "roundSwitch" );
	setdynamicdvar( "scr_dd_roundswitch", var_0 );
	maps\mp\_utility::registerRoundSwitchDvar( "dd", var_0, 0, 9 );
	setdynamicdvar( "scr_dd_bombtimer", getmatchrulesdata( "demData", "bombTimer" ) );
	setdynamicdvar( "scr_dd_planttime", getmatchrulesdata( "demData", "plantTime" ) );
	setdynamicdvar( "scr_dd_defusetime", getmatchrulesdata( "demData", "defuseTime" ) );
	setdynamicdvar( "scr_dd_addtime", getmatchrulesdata( "demData", "extraTime" ) );
	setdynamicdvar( "scr_dd_roundlimit", 3 );
	maps\mp\_utility::registerRoundLimitDvar( "dd", 3 );
	setdynamicdvar( "scr_dd_winlimit", 2 );
	maps\mp\_utility::registerWinLimitDvar( "dd", 2 );
	setdynamicdvar( "scr_dd_halftime", 0 );
	maps\mp\_utility::registerHalfTimeDvar( "dd", 0 );
	setdynamicdvar( "scr_dd_promode", 0 );
}

onPrecacheGameType()
{
	game["bomb_dropped_sound"] = "mp_war_objective_lost";
	game["bomb_recovered_sound"] = "mp_war_objective_taken";
	precacheshader( "waypoint_bomb" );
	precacheshader( "hud_suitcase_bomb" );
	precacheshader( "waypoint_target" );
	precacheshader( "waypoint_target_a" );
	precacheshader( "waypoint_target_b" );
	precacheshader( "waypoint_defend" );
	precacheshader( "waypoint_defend_a" );
	precacheshader( "waypoint_defend_b" );
	precacheshader( "waypoint_defuse_a" );
	precacheshader( "waypoint_defuse_b" );
	precacheshader( "waypoint_target" );
	precacheshader( "waypoint_target_a" );
	precacheshader( "waypoint_target_b" );
	precacheshader( "waypoint_defend" );
	precacheshader( "waypoint_defend_a" );
	precacheshader( "waypoint_defend_b" );
	precacheshader( "waypoint_defuse" );
	precacheshader( "waypoint_defuse_a" );
	precacheshader( "waypoint_defuse_b" );
	precachestring( &"MP_EXPLOSIVES_RECOVERED_BY" );
	precachestring( &"MP_EXPLOSIVES_DROPPED_BY" );
	precachestring( &"MP_EXPLOSIVES_PLANTED_BY" );
	precachestring( &"MP_EXPLOSIVES_DEFUSED_BY" );
	precachestring( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
	precachestring( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	precachestring( &"MP_CANT_PLANT_WITHOUT_BOMB" );
	precachestring( &"MP_PLANTING_EXPLOSIVE" );
	precachestring( &"MP_DEFUSING_EXPLOSIVE" );
	precachestring( &"MP_BOMB_A_TIMER" );
	precachestring( &"MP_BOMB_B_TIMER" );
	precachestring( &"MP_BOMBSITE_IN_USE" );
}

onStartGameType()
{
	if ( game["roundsPlayed"] == 2 )
	{
		game["status"] = "overtime";
		setdvar( "ui_overtime", 1 );
	}

	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = 0;

	if ( game["switchedsides"] )
	{
		var_0 = game["attackers"];
		var_1 = game["defenders"];
		game["attackers"] = var_1;
		game["defenders"] = var_0;
	}

	level.useStartSpawn = 1;
	setclientnamemode( "manual_change" );
	game["strings"]["target_destroyed"] = &"MP_TARGET_DESTROYED";
	game["strings"]["bomb_defused"] = &"MP_BOMB_DEFUSED";

	if ( maps\mp\_utility::inOvertime() )
		game["dialog"]["defense_obj"] = "obj_destroy";

	precachestring( game["strings"]["target_destroyed"] );
	precachestring( game["strings"]["bomb_defused"] );
	level._effect["bombexplosion"] = loadfx( "explosions/tanker_explosion" );
	maps\mp\_utility::setObjectiveText( game["attackers"], &"OBJECTIVES_DD_ATTACKER" );
	maps\mp\_utility::setObjectiveText( game["defenders"], &"OBJECTIVES_DD_DEFENDER" );

	if ( level.splitscreen )
	{
		maps\mp\_utility::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_DD_ATTACKER" );
		maps\mp\_utility::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_DD_DEFENDER" );
	}
	else
	{
		maps\mp\_utility::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_DD_ATTACKER_SCORE" );
		maps\mp\_utility::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_DD_DEFENDER_SCORE" );
	}

	if ( maps\mp\_utility::inOvertime() )
	{
		maps\mp\_utility::setObjectiveHintText( game["attackers"], &"OBJECTIVES_DD_OVERTIME_HINT" );
		maps\mp\_utility::setObjectiveHintText( game["defenders"], &"OBJECTIVES_DD_OVERTIME_HINT" );
	}
	else
	{
		maps\mp\_utility::setObjectiveHintText( game["attackers"], &"OBJECTIVES_DD_ATTACKER_HINT" );
		maps\mp\_utility::setObjectiveHintText( game["defenders"], &"OBJECTIVES_DD_DEFENDER_HINT" );
	}

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["defenders"], "mp_dd_spawn_defender" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["defenders"], "mp_dd_spawn_defender_a", 1 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["defenders"], "mp_dd_spawn_defender_b", 1 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["defenders"], "mp_tdm_spawn" );
	level.favorclosespawnscalardefender = 2;
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_dd_spawn_defender_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["attackers"], "mp_dd_spawn_attacker" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["attackers"], "mp_dd_spawn_attacker_a", 1 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["attackers"], "mp_dd_spawn_attacker_b", 1 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["attackers"], "mp_tdm_spawn" );
	level.favorclosespawnscalarattacker = 2;
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_dd_spawn_attacker_start" );
	level.tdmspawns = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn" );
	level.spawn_defenders = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_defender" );
	level.defenderdefaultentorigin = level.spawn_defenders[0];
	level.spawn_defenders = common_scripts\utility::array_combine( level.spawn_defenders, level.tdmspawns );
	level.spawn_defenders_a = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_defender_a" );

	if ( isdefined( level.spawn_defenders_a[0] ) )
		level.defenderaentorigin = level.spawn_defenders_a[0];

	level.spawn_defenders_a = common_scripts\utility::array_combine( level.spawn_defenders, level.spawn_defenders_a );
	level.spawn_defenders_b = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_defender_b" );

	if ( isdefined( level.spawn_defenders_b[0] ) )
		level.defenderbentorigin = level.spawn_defenders_b[0];

	level.spawn_defenders_b = common_scripts\utility::array_combine( level.spawn_defenders, level.spawn_defenders_b );
	level.spawn_attackers = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_attacker" );
	level.attackerdefaultentorigin = level.spawn_attackers[0];
	level.spawn_attackers = common_scripts\utility::array_combine( level.spawn_defenders, level.tdmspawns );
	level.spawn_attackers_a = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_attacker_a" );

	if ( isdefined( level.spawn_attackers_a[0] ) )
		level.attackeraentorigin = level.spawn_attackers_a[0];

	level.spawn_attackers_a = common_scripts\utility::array_combine( level.spawn_attackers, level.spawn_attackers_a );
	level.spawn_attackers_b = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_attacker_b" );

	if ( isdefined( level.spawn_attackers_b[0] ) )
		level.attackerbentorigin = level.spawn_attackers_b[0];

	level.spawn_attackers_b = common_scripts\utility::array_combine( level.spawn_attackers, level.spawn_attackers_b );
	level.spawn_defenders_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_defender_start" );
	level.spawn_attackers_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_attacker_start" );
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	level.aPlanted = 0;
	level.bPlanted = 0;
	setmapcenter( level.mapCenter );
	maps\mp\gametypes\_rank::registerScoreInfo( "win", 2 );
	maps\mp\gametypes\_rank::registerScoreInfo( "loss", 1 );
	maps\mp\gametypes\_rank::registerScoreInfo( "tie", 1.5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 20 );
	maps\mp\gametypes\_rank::registerScoreInfo( "plant", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defuse", 100 );
	thread updateGametypeDvars();
	thread waitToProcess();
	var_2 = maps\mp\_utility::getWatchedDvar( "winlimit" );
	var_3[0] = "dd";
	var_3[1] = "dd_bombzone";
	var_3[2] = "bombzone";
	var_3[3] = "blocker";
	maps\mp\gametypes\_gameobjects::main( var_3 );
	thread bombs();
}

waitToProcess()
{
	level endon( "game_end" );

	for ( ;; )
	{
		if ( level.inGracePeriod == 0 )
			break;

		wait 0.05;
	}

	level.useStartSpawn = 0;
}

getSpawnPoint()
{
	var_0 = self.pers["team"];

	if ( level.useStartSpawn )
	{
		if ( var_0 == game["attackers"] )
			var_1 = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( level.spawn_attackers_start );
		else
			var_1 = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( level.spawn_defenders_start );
	}
	else
	{
		var_2 = level.tdmspawns;

		if ( var_0 == game["attackers"] )
		{
			if ( maps\mp\_utility::inOvertime() )
				var_2 = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( var_0 );
			else if ( !level.aPlanted && !level.bPlanted )
				level.favorclosespawnentattacker = level.attackerdefaultentorigin;
			else if ( level.aPlanted && !level.bPlanted )
			{
				if ( isdefined( level.attackeraentorigin ) )
					level.favorclosespawnentattacker = level.attackeraentorigin;
				else
					level.favorclosespawnentattacker = level.attackerdefaultentorigin;
			}
			else if ( level.bPlanted && !level.aPlanted )
			{
				if ( isdefined( level.attackerbentorigin ) )
					level.favorclosespawnentattacker = level.attackerbentorigin;
				else
					level.favorclosespawnentattacker = level.attackerdefaultentorigin;
			}
			else if ( isdefined( level.attackeraentorigin ) )
				level.favorclosespawnentattacker = level.attackeraentorigin;
			else if ( isdefined( level.attackerbentorigin ) )
				level.favorclosespawnentattacker = level.attackerbentorigin;
			else
				level.favorclosespawnentattacker = level.attackerdefaultentorigin;

			var_1 = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( var_2 );
		}
		else
		{
			if ( maps\mp\_utility::inOvertime() )
				var_2 = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( var_0 );
			else if ( !level.aPlanted && !level.bPlanted )
				level.favorclosespawnentdefender = level.defenderdefaultentorigin;
			else if ( level.aPlanted && !level.bPlanted )
			{
				if ( isdefined( level.defenderaentorigin ) )
					level.favorclosespawnentdefender = level.defenderaentorigin;
				else
					level.favorclosespawnentdefender = level.defenderdefaultentorigin;
			}
			else if ( level.bPlanted && !level.aPlanted )
			{
				if ( isdefined( level.defenderbentorigin ) )
					level.favorclosespawnentdefender = level.defenderbentorigin;
				else
					level.favorclosespawnentdefender = level.defenderdefaultentorigin;
			}
			else if ( isdefined( level.defenderaentorigin ) )
				level.favorclosespawnentdefender = level.defenderaentorigin;
			else if ( isdefined( level.defenderbentorigin ) )
				level.favorclosespawnentdefender = level.defenderbentorigin;
			else
				level.favorclosespawnentdefender = level.defenderdefaultentorigin;

			var_1 = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( var_2 );
		}
	}

	return var_1;
}

onSpawnPlayer()
{
	if ( maps\mp\_utility::inOvertime() || self.pers["team"] == game["attackers"] )
	{
		self.isPlanting = 0;
		self.isDefusing = 0;
		self.isBombCarrier = 1;

		if ( level.splitscreen )
		{
			self.carryIcon = maps\mp\gametypes\_hud_util::createIcon( "hud_suitcase_bomb", 33, 33 );
			self.carryIcon maps\mp\gametypes\_hud_util::setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", -50, -78 );
			self.carryIcon.alpha = 0.75;
		}
		else
		{
			self.carryIcon = maps\mp\gametypes\_hud_util::createIcon( "hud_suitcase_bomb", 50, 50 );
			self.carryIcon maps\mp\gametypes\_hud_util::setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", -50, -65 );
			self.carryIcon.alpha = 0.75;
		}

		self.carryIcon.hidewheninmenu = 1;
		thread hideCarryIconOnGameEnd();
	}
	else
	{
		self.isPlanting = 0;
		self.isDefusing = 0;
		self.isBombCarrier = 0;

		if ( isdefined( self.carryIcon ) )
			self.carryIcon destroy();
	}

	level notify( "spawned_player" );
}

hideCarryIconOnGameEnd()
{
	self endon( "disconnect" );
	level waittill( "game_ended" );

	if ( isdefined( self.carryIcon ) )
		self.carryIcon.alpha = 0;
}

dd_endGame( var_0, var_1 )
{
	if ( var_0 == "tie" )
		level.finalKillCam_winner = "none";
	else
		level.finalKillCam_winner = var_0;

	thread maps\mp\gametypes\_gamelogic::endGame( var_0, var_1 );
}

onDeadEvent( var_0 )
{
	if ( level.bombexploded || level.bombDefused )
		return;

	if ( var_0 == "all" )
	{
		if ( level.bombPlanted )
			dd_endGame( game["attackers"], game["strings"][game["defenders"] + "_eliminated"] );
		else
			dd_endGame( game["defenders"], game["strings"][game["attackers"] + "_eliminated"] );
	}
	else if ( var_0 == game["attackers"] )
	{
		if ( level.bombPlanted )
			return;

		level thread dd_endGame( game["defenders"], game["strings"][game["attackers"] + "_eliminated"] );
	}
	else if ( var_0 == game["defenders"] )
		level thread dd_endGame( game["attackers"], game["strings"][game["defenders"] + "_eliminated"] );
}

onNormalDeath( var_0, var_1, var_2 )
{
	var_3 = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	var_4 = var_0.team;

	if ( game["state"] == "postgame" && ( var_0.team == game["defenders"] || !level.bombPlanted ) )
		var_1.finalKill = 1;

	if ( var_0.isPlanting )
	{
		thread maps\mp\_matchdata::logKillEvent( var_2, "planting" );
		var_1 maps\mp\_utility::incPersStat( "defends", 1 );
		var_1 maps\mp\gametypes\_persistence::statSetChild( "round", "defends", var_1.pers["defends"] );
	}
	else if ( var_0.isDefusing )
	{
		thread maps\mp\_matchdata::logKillEvent( var_2, "defusing" );
		var_1 maps\mp\_utility::incPersStat( "defends", 1 );
		var_1 maps\mp\gametypes\_persistence::statSetChild( "round", "defends", var_1.pers["defends"] );
	}
}

onTimeLimit()
{
	if ( maps\mp\_utility::inOvertime() )
		dd_endGame( "tie", game["strings"]["time_limit_reached"] );
	else
		dd_endGame( game["defenders"], game["strings"]["time_limit_reached"] );
}

updateGametypeDvars()
{
	level.plantTime = maps\mp\_utility::dvarFloatValue( "planttime", 5, 0, 20 );
	level.defuseTime = maps\mp\_utility::dvarFloatValue( "defusetime", 5, 0, 20 );
	level.bombTimer = maps\mp\_utility::dvarIntValue( "bombtimer", 45, 1, 300 );
	level.ddTimeToAdd = maps\mp\_utility::dvarFloatValue( "addtime", 2, 0, 5 );
}

verifyBombzones( var_0 )
{
	var_1 = "";

	if ( var_0.size != 3 )
	{
		var_2 = 0;
		var_3 = 0;
		var_4 = 0;

		foreach ( var_6 in var_0 )
		{
			if ( issubstr( tolower( var_6.script_label ), "a" ) )
			{
				var_2 = 1;
				continue;
			}

			if ( issubstr( tolower( var_6.script_label ), "b" ) )
			{
				var_3 = 1;
				continue;
			}

			if ( issubstr( tolower( var_6.script_label ), "c" ) )
				var_4 = 1;
		}

		if ( !var_2 )
			var_1 += " A ";

		if ( !var_3 )
			var_1 += " B ";

		if ( !var_4 )
			var_1 += " C ";
	}

	if ( var_1 != "" )
		return;
}

bombs()
{
	level.bombPlanted = 0;
	level.bombDefused = 0;
	level.bombexploded = 0;
	level.bombZones = [];
	var_0 = getentarray( "dd_bombzone", "targetname" );
	verifyBombzones( var_0 );

	if ( !var_0.size )
	{
		var_0 = getentarray( "bombzone", "targetname" );
		verifyBombzones( var_0 );
	}
	else
	{
		var_3[0] = "dd";
		var_3[1] = "dd_bombzone";
		var_3[2] = "blocker";
		maps\mp\gametypes\_gameobjects::main( var_3 );
	}

	deleted = false;

	for ( var_1 = 0; var_1 < var_0.size; var_1++ )
	{
		var_2 = var_0[var_1];
		var_3 = getentarray( var_0[var_1].target, "targetname" );
		var_4 = var_0[var_1].script_label;
		var_5 = getent( "dd_bombzone_clip" + var_4, "targetname" );

		if ( maps\mp\_utility::inOvertime() )
		{
			if ( ( var_0.size > 2 && ( var_4 == "_a" || var_4 == "_b" ) ) || ( var_0.size < 3 && !deleted ) )
			{
				deleted = true;
				var_2 delete ();
				var_3[0] delete ();
				var_5 delete ();
				continue;
			}

			var_6 = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", var_2, var_3, ( 0, 0, 64 ) );
			var_6 maps\mp\gametypes\_gameobjects::allowUse( "any" );
		}
		else
		{
			if ( var_4 == "_c" )
			{
				var_2 delete ();
				var_3[0] delete ();
				var_5 delete ();
				continue;
			}

			var_6 = maps\mp\gametypes\_gameobjects::createUseObject( game["defenders"], var_2, var_3, ( 0, 0, 64 ) );
			var_6 maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
		}

		var_6 maps\mp\gametypes\_gameobjects::setUseTime( level.plantTime );
		var_6 maps\mp\gametypes\_gameobjects::setUseText( &"MP_PLANTING_EXPLOSIVE" );
		var_6 maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
		var_6 maps\mp\gametypes\_gameobjects::setKeyObject( level.ddBomb );

		if ( maps\mp\_utility::inOvertime() )
			var_4 = "_a";

		var_6.label = var_4;
		var_6.index = var_1;

		if ( maps\mp\_utility::inOvertime() )
		{
			var_6 maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_target" );
			var_6 maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_target" );
			var_6 maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_target" );
			var_6 maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_target" );
		}
		else
		{
			var_6 maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_defend" + var_4 );
			var_6 maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" + var_4 );
			var_6 maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_target" + var_4 );
			var_6 maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_target" + var_4 );
		}

		var_6 maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		var_6.onBeginUse = ::onBeginUse;
		var_6.onEndUse = ::onEndUse;
		var_6.onUse = ::onUseObject;
		var_6.onCantUse = ::onCantUse;
		var_6.useWeapon = "briefcase_bomb_mp";
		var_6.bombPlanted = 0;
		var_6.visuals[0] thread setupKillCamEnt();

		for ( var_7 = 0; var_7 < var_3.size; var_7++ )
		{
			if ( isdefined( var_3[var_7].script_exploder ) )
			{
				var_6.exploderIndex = var_3[var_7].script_exploder;
				break;
			}
		}

		level.bombZones[level.bombZones.size] = var_6;
		var_6.bombDefuseTrig = getent( var_3[0].target, "targetname" );
		var_6.bombDefuseTrig.origin = var_6.bombDefuseTrig.origin + ( 0, 0, -10000 );
		var_6.bombDefuseTrig.label = var_4;
	}

	for ( var_1 = 0; var_1 < level.bombZones.size; var_1++ )
	{
		var_8 = [];

		for ( var_9 = 0; var_9 < level.bombZones.size; var_9++ )
		{
			if ( var_9 != var_1 )
				var_8[var_8.size] = level.bombZones[var_9];
		}

		level.bombZones[var_1].otherBombZones = var_8;
	}
}

setupKillCamEnt()
{
	var_0 = spawn( "script_origin", self.origin );
	var_0.angles = self.angles;
	var_0 rotateyaw( -45, 0.05 );
	wait 0.05;
	var_1 = self.origin + ( 0, 0, 5 );
	var_2 = self.origin + anglestoforward( var_0.angles ) * 100 + ( 0, 0, 128 );
	var_3 = bullettrace( var_1, var_2, 0, self );
	self.killCamEnt = spawn( "script_model", var_3["position"] );
	self.killCamEnt setscriptmoverkillcam( "explosive" );
	var_0 delete ();
}

onUseObject( var_0 )
{
	var_1 = var_0.pers["team"];
	var_2 = level.otherTeam[var_1];

	if ( maps\mp\_utility::inOvertime() && self.bombPlanted == 0 || !maps\mp\_utility::inOvertime() && !maps\mp\gametypes\_gameobjects::isFriendlyTeam( var_0.pers["team"] ) )
	{
		self.bombPlanted = 1;
		var_0 notify( "bomb_planted" );
		var_0 playsound( "mp_bomb_plant" );
		thread maps\mp\_utility::teamPlayerCardSplash( "callout_bombplanted", var_0 );
		var_0 notify( "objective",  "plant"  );
		maps\mp\_utility::leaderDialog( "bomb_planted" );
		var_0 thread maps\mp\gametypes\_hud_message::splashNotify( "plant", maps\mp\gametypes\_rank::getScoreInfoValue( "plant" ) );
		var_0 thread maps\mp\gametypes\_rank::giveRankXP( "plant" );
		maps\mp\gametypes\_gamescore::givePlayerScore( "plant", var_0 );
		var_0 maps\mp\_utility::incPlayerStat( "bombsplanted", 1 );
		var_0 thread maps\mp\_matchdata::logGameEvent( "plant", var_0.origin );
		var_0.bombPlantedTime = gettime();
		var_0 maps\mp\_utility::incPersStat( "plants", 1 );
		var_0 maps\mp\gametypes\_persistence::statSetChild( "round", "plants", var_0.pers["plants"] );
		level thread bombPlanted( self, var_0 );
		level.bombOwner = var_0;
		self.useWeapon = "briefcase_bomb_defuse_mp";
	}
	else
	{
		self.bombPlanted = 0;
		thread bombHandler( var_0, "defused" );
		var_0 notify( "objective",  "defuse"  );
	}
}

resetBombZone()
{
	if ( maps\mp\_utility::inOvertime() )
	{
		maps\mp\gametypes\_gameobjects::setOwnerTeam( "neutral" );
		maps\mp\gametypes\_gameobjects::allowUse( "any" );
		var_0 = "waypoint_target";
		var_1 = "waypoint_target";
	}
	else
	{
		maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
		var_0 = "waypoint_defend" + self.label;
		var_1 = "waypoint_target" + self.label;
	}

	maps\mp\gametypes\_gameobjects::setUseTime( level.plantTime );
	maps\mp\gametypes\_gameobjects::setUseText( &"MP_PLANTING_EXPLOSIVE" );
	maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
	maps\mp\gametypes\_gameobjects::setKeyObject( level.ddBomb );
	maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", var_0 );
	maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", var_0 );
	maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", var_1 );
	maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", var_1 );
	maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	self.useWeapon = "briefcase_bomb_mp";
}

setUpForDefusing()
{
	if ( maps\mp\_utility::inOvertime() )
	{
		var_0 = "waypoint_defuse";
		var_1 = "waypoint_defend";
	}
	else
	{
		var_0 = "waypoint_defuse" + self.label;
		var_1 = "waypoint_defend" + self.label;
	}

	maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	maps\mp\gametypes\_gameobjects::setUseTime( level.defuseTime );
	maps\mp\gametypes\_gameobjects::setUseText( &"MP_DEFUSING_EXPLOSIVE" );
	maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	maps\mp\gametypes\_gameobjects::setKeyObject( undefined );
	maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", var_0 );
	maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", var_0 );
	maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", var_1 );
	maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", var_1 );
	maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
}

onBeginUse( var_0 )
{
	if ( maps\mp\_utility::inOvertime() && self.bombPlanted == 1 || !maps\mp\_utility::inOvertime() && maps\mp\gametypes\_gameobjects::isFriendlyTeam( var_0.pers["team"] ) )
	{
		var_0 playsound( "mp_bomb_defuse" );
		var_0.isDefusing = 1;
		var_1 = 9000000;
		var_2 = undefined;

		if ( isdefined( level.ddBombModel ) )
		{
			foreach ( var_4 in level.ddBombModel )
			{
				if ( !isdefined( var_4 ) )
					continue;

				var_5 = distancesquared( var_0.origin, var_4.origin );

				if ( var_5 < var_1 )
				{
					var_1 = var_5;
					var_2 = var_4;
				}
			}

			var_0.defusing = var_2;
			var_2 hide();
			return;
		}
	}
	else
		var_0.isPlanting = 1;
}

onEndUse( var_0, var_1, var_2 )
{
	if ( !isdefined( var_1 ) )
		return;

	if ( var_1.isDefusing )
	{
		if ( isdefined( var_1.defusing ) && !var_2 )
			var_1.defusing show();
	}

	if ( isalive( var_1 ) )
	{
		var_1.isDefusing = 0;
		var_1.isPlanting = 0;
	}
}

onCantUse( var_0 )
{
	var_0 iprintlnbold( &"MP_BOMBSITE_IN_USE" );
}

onReset()
{

}

bombPlanted( var_0, var_1 )
{
	var_0 endon( "defused" );
	var_2 = var_1.team;
	level.bombsPlanted = level.bombsPlanted + 1;
	setBombTimerDvar();
	maps\mp\gametypes\_gamelogic::pauseTimer();
	level.timePauseStart = gettime();
	level.timeLimitOverride = 1;
	level.bombPlanted = 1;
	level.destroyedObject = var_0;

	if ( level.destroyedObject.label == "_a" )
		level.aPlanted = 1;
	else
		level.bPlanted = 1;

	level.destroyedObject.bombPlanted = 1;
	var_0.visuals[0] thread playDemolitionTickingSound( var_0 );
	level.tickingObject = var_0.visuals[0];
	dropBombModel( var_1, var_0.label );
	var_0.bombDefused = 0;
	var_0 maps\mp\gametypes\_gameobjects::allowUse( "none" );
	var_0 maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );

	if ( maps\mp\_utility::inOvertime() )
		var_0 maps\mp\gametypes\_gameobjects::setOwnerTeam( level.otherTeam[var_1.team] );

	var_0 setUpForDefusing();
	var_0 BombTimerWait( var_0 );
	var_0 thread bombHandler( var_1, "explode", var_2 );
}

bombHandler( var_0, var_1, var_2 )
{
	self.visuals[0] notify( "stopTicking" );
	level.bombsPlanted = level.bombsPlanted - 1;

	if ( self.label == "_a" )
		level.aPlanted = 0;
	else
		level.bPlanted = 0;

	restartTimer();
	setBombTimerDvar();
	setdvar( "ui_bombtimer" + self.label, -1 );

	if ( level.gameEnded )
		return;

	if ( var_1 == "explode" )
	{
		level notify( "bomb_exploded" + self.label );
		level.bombexploded = level.bombexploded + 1;
		var_3 = self.curOrigin;
		level.ddBombModel[self.label] delete ();

		if ( isdefined( var_0 ) )
		{
			self.visuals[0] radiusdamage( var_3, 512, 200, 20, var_0, "MOD_EXPLOSIVE", "bomb_site_mp" );
			var_0 maps\mp\_utility::incPlayerStat( "targetsdestroyed", 1 );
			var_0 maps\mp\_utility::incPersStat( "destructions", 1 );
			var_0 maps\mp\gametypes\_persistence::statSetChild( "round", "destructions", var_0.pers["destructions"] );
		}
		else
			self.visuals[0] radiusdamage( var_3, 512, 200, 20, undefined, "MOD_EXPLOSIVE", "bomb_site_mp" );

		var_4 = randomfloat( 360 );
		var_5 = spawnfx( level._effect["bombexplosion"], var_3 + ( 0, 0, 50 ), ( 0, 0, 1 ), ( cos( var_4 ), sin( var_4 ), 0 ) );
		triggerfx( var_5 );
		playrumbleonposition( "grenade_rumble", var_3 );
		earthquake( 0.75, 2.0, var_3, 2000 );
		thread maps\mp\_utility::playSoundinSpace( "exp_suitcase_bomb_main", var_3 );

		if ( isdefined( self.exploderIndex ) )
			common_scripts\utility::exploder( self.exploderIndex );

		maps\mp\gametypes\_gameobjects::disableObject();

		if ( !maps\mp\_utility::inOvertime() && level.bombexploded < 2 && level.ddTimeToAdd > 0 )
		{
			foreach ( var_7 in level.players )
				var_7 thread maps\mp\gametypes\_hud_message::splashNotify( "time_added" );
		}

		wait 2;

		if ( maps\mp\_utility::inOvertime() || level.bombexploded > 1 )
		{
			dd_endGame( var_2, game["strings"]["target_destroyed"] );
			return;
		}

		if ( level.ddTimeToAdd > 0 )
		{
			level thread maps\mp\_utility::teamPlayerCardSplash( "callout_time_added", var_0 );
			return;
		}

		return;
	}
	else
	{
		var_0 notify( "bomb_defused" );
		self notify( "defused" );
		maps\mp\_utility::leaderDialog( "bomb_defused" );
		level thread maps\mp\_utility::teamPlayerCardSplash( "callout_bombdefused", var_0 );
		level thread bombDefused( self );
		resetBombZone();

		if ( isdefined( level.bombOwner ) && level.bombOwner.bombPlantedTime + 4000 + level.defuseTime * 1000 > gettime() && maps\mp\_utility::isReallyAlive( level.bombOwner ) )
			var_0 thread maps\mp\gametypes\_hud_message::splashNotify( "ninja_defuse", maps\mp\gametypes\_rank::getScoreInfoValue( "defuse" ) );
		else
			var_0 thread maps\mp\gametypes\_hud_message::splashNotify( "defuse", maps\mp\gametypes\_rank::getScoreInfoValue( "defuse" ) );

		var_0 thread maps\mp\gametypes\_rank::giveRankXP( "defuse" );
		maps\mp\gametypes\_gamescore::givePlayerScore( "defuse", var_0 );
		var_0 maps\mp\_utility::incPlayerStat( "bombsdefused", 1 );
		var_0 maps\mp\_utility::incPersStat( "defuses", 1 );
		var_0 maps\mp\gametypes\_persistence::statSetChild( "round", "defuses", var_0.pers["defuses"] );
		var_0 thread maps\mp\_matchdata::logGameEvent( "defuse", var_0.origin );
	}
}

playDemolitionTickingSound( var_0 )
{
	self endon( "death" );
	self endon( "stopTicking" );
	level endon( "game_ended" );

	for ( ;; )
	{
		self playsound( "ui_mp_suitcasebomb_timer" );

		if ( !isdefined( var_0.waitTime ) || var_0.waitTime > 10 )
			wait 1.0;
		else if ( isdefined( var_0.waitTime ) && var_0.waitTime > 5 )
			wait 0.5;
		else
			wait 0.25;

		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
	}
}

setBombTimerDvar()
{
	if ( level.bombsPlanted == 1 )
		setdvar( "ui_bomb_timer", 2 );
	else if ( level.bombsPlanted == 2 )
		setdvar( "ui_bomb_timer", 3 );
	else
		setdvar( "ui_bomb_timer", 0 );
}

dropBombModel( var_0, var_1 )
{
	var_2 = bullettrace( var_0.origin + ( 0, 0, 20 ), var_0.origin - ( 0, 0, 2000 ), 0, var_0 );
	var_3 = randomfloat( 360 );
	var_4 = ( cos( var_3 ), sin( var_3 ), 0 );
	var_4 = vectornormalize( var_4 - var_2["normal"] * vectordot( var_4, var_2["normal"] ) );
	var_5 = vectortoangles( var_4 );
	level.ddBombModel[var_1] = spawn( "script_model", var_2["position"] );
	level.ddBombModel[var_1].angles = var_5;
	level.ddBombModel[var_1] setmodel( "prop_suitcase_bomb" );
}

restartTimer()
{
	if ( level.bombsPlanted <= 0 )
	{
		maps\mp\gametypes\_gamelogic::resumeTimer();
		level.timePaused = gettime() - level.timePauseStart;
		level.timeLimitOverride = 0;
	}
}

BombTimerWait( var_0 )
{
	level endon( "game_ended" );
	level endon( "bomb_defused" + var_0.label );

	if ( maps\mp\_utility::inOvertime() )
		var_0.waitTime = level.bombTimer;
	else
		var_0.waitTime = level.bombTimer;

	level thread update_ui_timers( var_0 );

	while ( var_0.waitTime >= 0 )
	{
		var_0.waitTime--;

		if ( var_0.waitTime >= 0 )
			wait 1;

		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
	}
}

update_ui_timers( var_0 )
{
	level endon( "game_ended" );
	level endon( "disconnect" );
	level endon( "bomb_defused" + var_0.label );
	level endon( "bomb_exploded" + var_0.label );
	var_1 = var_0.waitTime * 1000 + gettime();
	setdvar( "ui_bombtimer" + var_0.label, var_1 );
	level waittill( "host_migration_begin" );
	var_2 = maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();

	if ( var_2 > 0 )
		setdvar( "ui_bombtimer" + var_0.label, var_1 + var_2 );
}

bombDefused( var_0 )
{
	level.tickingObject maps\mp\gametypes\_gamelogic::stopTickingSound();
	var_0.bombDefused = 1;
	setBombTimerDvar();
	setdvar( "ui_bombtimer" + var_0.label, -1 );
	level notify( "bomb_defused" + var_0.label );
}

initGametypeAwards()
{
	maps\mp\_awards::initStatAward( "targetsdestroyed", 0, maps\mp\_awards::highestWins );
	maps\mp\_awards::initStatAward( "bombsplanted", 0, maps\mp\_awards::highestWins );
	maps\mp\_awards::initStatAward( "bombsdefused", 0, maps\mp\_awards::highestWins );
	maps\mp\_awards::initStatAward( "bombcarrierkills", 0, maps\mp\_awards::highestWins );
	maps\mp\_awards::initStatAward( "bombscarried", 0, maps\mp\_awards::highestWins );
	maps\mp\_awards::initStatAward( "killsasbombcarrier", 0, maps\mp\_awards::highestWins );
}
