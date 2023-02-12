// IW5 PC GSC
// Decompiled by https://github.com/xensik/gsc-tool

init()
{
    precachestring( &"MP_KILLSTREAK_N" );
    precachestring( &"MP_NUKE_ALREADY_INBOUND" );
    precachestring( &"MP_UNAVILABLE_IN_LASTSTAND" );
    precachestring( &"MP_UNAVAILABLE_FOR_N_WHEN_EMP" );
    precachestring( &"MP_UNAVAILABLE_FOR_N_WHEN_NUKE" );
    precachestring( &"MP_UNAVAILABLE_USING_TURRET" );
    precachestring( &"MP_UNAVAILABLE_WHEN_INCAP" );
    precachestring( &"MP_HELI_IN_QUEUE" );
    precachestring( &"MP_SPECIALIST_STREAKING_XP" );
    precachestring( &"MP_AIR_SPACE_TOO_CROWDED" );
    precachestring( &"MP_CIVILIAN_AIR_TRAFFIC" );
    precachestring( &"MP_TOO_MANY_VEHICLES" );
    precachestring( &"SPLASHES_HEADSHOT" );
    precachestring( &"SPLASHES_FIRSTBLOOD" );
    precachestring( &"MP_ASSIST" );
    precachestring( &"MP_ASSIST_TO_KILL" );
    precacheshader( "hud_killstreak_dpad_arrow_down" );
    precacheshader( "hud_killstreak_dpad_arrow_right" );
    precacheshader( "hud_killstreak_dpad_arrow_up" );
    precacheshader( "hud_killstreak_frame" );
    precacheshader( "hud_killstreak_frame_fade_top" );
    precacheshader( "hud_killstreak_highlight" );
    precacheshader( "hud_killstreak_bar_empty" );
    precacheshader( "hud_killstreak_bar_full" );
    initKillstreakData();
    level.killstreakFuncs = [];
    level.killstreakSetupFuncs = [];
    level.killstreakWeapons = [];
    thread maps\mp\killstreaks\_ac130::init();
    thread maps\mp\killstreaks\_remotemissile::init();
    thread maps\mp\killstreaks\_uav::init();
    thread maps\mp\killstreaks\_airstrike::init();
    thread maps\mp\killstreaks\_airdrop::init();
    thread maps\mp\killstreaks\_helicopter::init();
    thread maps\mp\killstreaks\_helicopter_flock::init();
    thread maps\mp\killstreaks\_helicopter_guard::init();
    thread maps\mp\killstreaks\_autosentry::init();
    thread maps\mp\killstreaks\_emp::init();
    thread maps\mp\killstreaks\_nuke::init();
    thread maps\mp\killstreaks\_escortairdrop::init();
    thread maps\mp\killstreaks\_remotemortar::init();
    thread maps\mp\killstreaks\_deployablebox::init();
    thread maps\mp\killstreaks\_ims::init();
    thread maps\mp\killstreaks\_perkstreaks::init();
    thread maps\mp\killstreaks\_remoteturret::init();
    thread maps\mp\killstreaks\_remoteuav::init();
    thread maps\mp\killstreaks\_remotetank::init();
    thread maps\mp\killstreaks\_juggernaut::init();
    level.killstreakWeildWeapons = [];
    level.killstreakWeildWeapons["cobra_player_minigun_mp"] = 1;
    level.killstreakWeildWeapons["artillery_mp"] = 1;
    level.killstreakWeildWeapons["stealth_bomb_mp"] = 1;
    level.killstreakWeildWeapons["pavelow_minigun_mp"] = 1;
    level.killstreakWeildWeapons["sentry_minigun_mp"] = 1;
    level.killstreakWeildWeapons["harrier_20mm_mp"] = 1;
    level.killstreakWeildWeapons["ac130_105mm_mp"] = 1;
    level.killstreakWeildWeapons["ac130_40mm_mp"] = 1;
    level.killstreakWeildWeapons["ac130_25mm_mp"] = 1;
    level.killstreakWeildWeapons["remotemissile_projectile_mp"] = 1;
    level.killstreakWeildWeapons["cobra_20mm_mp"] = 1;
    level.killstreakWeildWeapons["nuke_mp"] = 1;
    level.killstreakWeildWeapons["apache_minigun_mp"] = 1;
    level.killstreakWeildWeapons["littlebird_guard_minigun_mp"] = 1;
    level.killstreakWeildWeapons["uav_strike_marker_mp"] = 1;
    level.killstreakWeildWeapons["osprey_minigun_mp"] = 1;
    level.killstreakWeildWeapons["strike_marker_mp"] = 1;
    level.killstreakWeildWeapons["a10_30mm_mp"] = 1;
    level.killstreakWeildWeapons["manned_minigun_turret_mp"] = 1;
    level.killstreakWeildWeapons["manned_gl_turret_mp"] = 1;
    level.killstreakWeildWeapons["airdrop_trap_explosive_mp"] = 1;
    level.killstreakWeildWeapons["uav_strike_projectile_mp"] = 1;
    level.killstreakWeildWeapons["remote_mortar_missile_mp"] = 1;
    level.killstreakWeildWeapons["manned_littlebird_sniper_mp"] = 1;
    level.killstreakWeildWeapons["iw5_m60jugg_mp"] = 1;
    level.killstreakWeildWeapons["iw5_mp412jugg_mp"] = 1;
    level.killstreakWeildWeapons["iw5_riotshieldjugg_mp"] = 1;
    level.killstreakWeildWeapons["iw5_usp45jugg_mp"] = 1;
    level.killstreakWeildWeapons["remote_turret_mp"] = 1;
    level.killstreakWeildWeapons["osprey_player_minigun_mp"] = 1;
    level.killstreakWeildWeapons["deployable_vest_marker_mp"] = 1;
    level.killstreakWeildWeapons["ugv_turret_mp"] = 1;
    level.killstreakWeildWeapons["ugv_gl_turret_mp"] = 1;
    level.killstreakWeildWeapons["uav_remote_mp"] = 1;
    level.killstreakChainingWeapons = [];
    level.killstreakChainingWeapons["remotemissile_projectile_mp"] = "predator_missile";
    level.killstreakChainingWeapons["ims_projectile_mp"] = "ims";
    level.killstreakChainingWeapons["sentry_minigun_mp"] = "airdrop_sentry_minigun";
    level.killstreakChainingWeapons["artillery_mp"] = "precision_airstrike";
    level.killstreakChainingWeapons["cobra_20mm_mp"] = "helicopter";
    level.killstreakChainingWeapons["apache_minigun_mp"] = "littlebird_flock";
    level.killstreakChainingWeapons["littlebird_guard_minigun_mp"] = "littlebird_support";
    level.killstreakChainingWeapons["remote_mortar_missile_mp"] = "remote_mortar";
    level.killstreakChainingWeapons["ugv_turret_mp"] = "airdrop_remote_tank";
    level.killstreakChainingWeapons["ugv_gl_turret_mp"] = "airdrop_remote_tank";
    level.killstreakChainingWeapons["pavelow_minigun_mp"] = "helicopter_flares";
    level.killstreakChainingWeapons["ac130_105mm_mp"] = "ac130";
    level.killstreakChainingWeapons["ac130_40mm_mp"] = "ac130";
    level.killstreakChainingWeapons["ac130_25mm_mp"] = "ac130";
    level.killstreakChainingWeapons["iw5_m60jugg_mp"] = "airdrop_juggernaut";
    level.killstreakChainingWeapons["iw5_mp412jugg_mp"] = "airdrop_juggernaut";
    level.killstreakChainingWeapons["osprey_player_minigun_mp"] = "osprey_gunner";
    level.killstreakRoundDelay = maps\mp\_utility::getIntProperty( "scr_game_killstreakdelay", 8 );
    level thread onPlayerConnect();
}

initKillstreakData()
{
    var_0 = 1;

    for (;;)
    {
        var_1 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 1 );

        if ( !isdefined( var_1 ) || var_1 == "" )
            break;

        var_2 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 1 );
        var_3 = tablelookupistring( "mp/killstreakTable.csv", 0, var_0, 6 );
        precachestring( var_3 );
        var_4 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 8 );
        game["dialog"][var_2] = var_4;
        var_5 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 9 );
        game["dialog"]["allies_friendly_" + var_2 + "_inbound"] = "use_" + var_5;
        game["dialog"]["allies_enemy_" + var_2 + "_inbound"] = "enemy_" + var_5;
        var_6 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 10 );
        game["dialog"]["axis_friendly_" + var_2 + "_inbound"] = "use_" + var_6;
        game["dialog"]["axis_enemy_" + var_2 + "_inbound"] = "enemy_" + var_6;
        var_7 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 12 );
        precacheitem( var_7 );
        var_8 = int( tablelookup( "mp/killstreakTable.csv", 0, var_0, 13 ) );
        maps\mp\gametypes\_rank::registerScoreInfo( "killstreak_" + var_2, var_8 );
        var_9 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 14 );
        precacheshader( var_9 );
        var_9 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 15 );

        if ( var_9 != "" )
            precacheshader( var_9 );

        var_9 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 16 );

        if ( var_9 != "" )
            precacheshader( var_9 );

        var_9 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 17 );

        if ( var_9 != "" )
            precacheshader( var_9 );

        var_0++;
    }
}

onPlayerConnect()
{
    for (;;)
    {
        level waittill( "connected",  var_0  );

        if ( !isdefined( var_0.pers["killstreaks"] ) )
            var_0.pers["killstreaks"] = [];

        if ( !isdefined( var_0.pers["kID"] ) )
            var_0.pers["kID"] = 10;

        var_0.lifeId = 0;
        var_0.curDefValue = 0;

        if ( isdefined( var_0.pers["deaths"] ) )
            var_0.lifeId = var_0.pers["deaths"];

        var_0 visionsetmissilecamforplayer( game["thermal_vision"] );
        var_0 thread onPlayerSpawned();
        var_0.spUpdateTotal = 0;
    }
}

onPlayerSpawned()
{
    self endon( "disconnect" );

    for (;;)
    {
        self waittill( "spawned_player" );
        thread killstreakUseWaiter();
        thread waitForChangeTeam();

        if ( level.console )
        {
            thread streakSelectUpTracker();
            thread streakSelectDownTracker();
            thread streakusetimetracker();
        }
        else
            thread pc_watchstreakuse();

        thread streakNotifyTracker();

        if ( !isdefined( self.pers["killstreaks"][0] ) )
            initPlayerKillstreaks();

        if ( !isdefined( self.earnedStreakLevel ) )
            self.earnedStreakLevel = 0;

        if ( !isdefined( self.adrenaline ) )
            self.adrenaline = self getplayerdata( "killstreaksState", "count" );

        setStreakCountToNext();
        updateStreakSlots();

        if ( self.streakType == "specialist" )
        {
            updateSpecialistKillstreaks();
            continue;
        }

        giveOwnedKillstreakItem();
    }
}

initPlayerKillstreaks()
{
    if ( !isdefined( self.streakType ) )
        return;

    if ( self.streakType == "specialist" )
        self setplayerdata( "killstreaksState", "isSpecialist", 1 );
    else
        self setplayerdata( "killstreaksState", "isSpecialist", 0 );

    self.pers["killstreaks"][0] = spawnstruct();
    self.pers["killstreaks"][0].available = 0;
    self.pers["killstreaks"][0].streakName = undefined;
    self.pers["killstreaks"][0].earned = 0;
    self.pers["killstreaks"][0].awardxp = undefined;
    self.pers["killstreaks"][0].owner = undefined;
    self.pers["killstreaks"][0].kID = undefined;
    self.pers["killstreaks"][0].lifeId = undefined;
    self.pers["killstreaks"][0].isGimme = 1;
    self.pers["killstreaks"][0].isSpecialist = 0;
    self.pers["killstreaks"][0].nextSlot = undefined;

    for ( var_0 = 1; var_0 < 4; var_0++ )
    {
        self.pers["killstreaks"][var_0] = spawnstruct();
        self.pers["killstreaks"][var_0].available = 0;
        self.pers["killstreaks"][var_0].streakName = undefined;
        self.pers["killstreaks"][var_0].earned = 1;
        self.pers["killstreaks"][var_0].awardxp = 1;
        self.pers["killstreaks"][var_0].owner = undefined;
        self.pers["killstreaks"][var_0].kID = undefined;
        self.pers["killstreaks"][var_0].lifeId = -1;
        self.pers["killstreaks"][var_0].isGimme = 0;
        self.pers["killstreaks"][var_0].isSpecialist = 0;
    }

    self.pers["killstreaks"][4] = spawnstruct();
    self.pers["killstreaks"][4].available = 0;
    self.pers["killstreaks"][4].streakName = "all_perks_bonus";
    self.pers["killstreaks"][4].earned = 1;
    self.pers["killstreaks"][4].awardxp = 0;
    self.pers["killstreaks"][4].owner = undefined;
    self.pers["killstreaks"][4].kID = undefined;
    self.pers["killstreaks"][4].lifeId = -1;
    self.pers["killstreaks"][4].isGimme = 0;
    self.pers["killstreaks"][4].isSpecialist = 1;

    for ( var_0 = 0; var_0 < 4; var_0++ )
    {
        self setplayerdata( "killstreaksState", "icons", var_0, 0 );
        self setplayerdata( "killstreaksState", "hasStreak", var_0, 0 );
    }

    self setplayerdata( "killstreaksState", "hasStreak", 0, 0 );
    var_1 = 1;

    foreach ( var_3 in self.killstreaks )
    {
        self.pers["killstreaks"][var_1].streakName = var_3;
        self.pers["killstreaks"][var_1].isSpecialist = self.streakType == "specialist";
        var_4 = self.pers["killstreaks"][var_1].streakName;

        if ( self.streakType == "specialist" )
        {
            var_5 = strtok( self.pers["killstreaks"][var_1].streakName, "_" );

            if ( var_5[var_5.size - 1] == "ks" )
            {
                var_6 = undefined;

                foreach ( var_8 in var_5 )
                {
                    if ( var_8 != "ks" )
                    {
                        if ( !isdefined( var_6 ) )
                        {
                            var_6 = var_8;
                            continue;
                        }

                        var_6 += ( "_" + var_8 );
                    }
                }

                if ( maps\mp\_utility::isStrStart( self.pers["killstreaks"][var_1].streakName, "_" ) )
                    var_6 = "_" + var_6;

                if ( isdefined( var_6 ) && maps\mp\gametypes\_class::getPerkUpgrade( var_6 ) != "specialty_null" )
                    var_4 = self.pers["killstreaks"][var_1].streakName + "_pro";
            }
        }

        self setplayerdata( "killstreaksState", "icons", var_1, getKillstreakIndex( var_4 ) );
        self setplayerdata( "killstreaksState", "hasStreak", var_1, 0 );
        var_1++;
    }

    self setplayerdata( "killstreaksState", "nextIndex", 1 );
    self setplayerdata( "killstreaksState", "selectedIndex", -1 );
    self setplayerdata( "killstreaksState", "numAvailable", 0 );
    self setplayerdata( "killstreaksState", "hasStreak", 4, 0 );
}

updateStreakCount()
{
    if ( !isdefined( self.pers["killstreaks"] ) )
        return;

    if ( self.adrenaline == self.previousAdrenaline )
        return;

    var_0 = self.adrenaline;
    self setplayerdata( "killstreaksState", "count", self.adrenaline );

    if ( self.adrenaline >= self getplayerdata( "killstreaksState", "countToNext" ) )
        setStreakCountToNext();
}

resetStreakCount()
{
    self setplayerdata( "killstreaksState", "count", 0 );
    setStreakCountToNext();
}

setStreakCountToNext()
{
    if ( !isdefined( self.streakType ) )
    {
        self setplayerdata( "killstreaksState", "countToNext", 0 );
        return;
    }

    if ( getMaxStreakCost() == 0 )
    {
        self setplayerdata( "killstreaksState", "countToNext", 0 );
        return;
    }

    if ( self.streakType == "specialist" )
    {
        if ( self.adrenaline >= getMaxStreakCost() )
            return;
    }

    var_0 = getNextStreakName();

    if ( !isdefined( var_0 ) )
        return;

    var_1 = getStreakCost( var_0 );
    self setplayerdata( "killstreaksState", "countToNext", var_1 );
}

getNextStreakName()
{
    if ( self.adrenaline == getMaxStreakCost() && self.streakType != "specialist" )
        var_0 = 0;
    else
        var_0 = self.adrenaline;

    foreach ( var_2 in self.killstreaks )
    {
        var_3 = getStreakCost( var_2 );

        if ( var_3 > var_0 )
            return var_2;
    }

    return undefined;
}

getMaxStreakCost()
{
    var_0 = 0;

    foreach ( var_2 in self.killstreaks )
    {
        var_3 = getStreakCost( var_2 );

        if ( var_3 > var_0 )
            var_0 = var_3;
    }

    return var_0;
}

updateStreakSlots()
{
    if ( !isdefined( self.streakType ) )
        return;

    if ( !maps\mp\_utility::isReallyAlive( self ) )
        return;

    var_0 = 0;

    for ( var_1 = 0; var_1 < 4; var_1++ )
    {
        if ( isdefined( self.pers["killstreaks"][var_1] ) && isdefined( self.pers["killstreaks"][var_1].streakName ) )
        {
            self setplayerdata( "killstreaksState", "hasStreak", var_1, self.pers["killstreaks"][var_1].available );

            if ( self.pers["killstreaks"][var_1].available == 1 )
                var_0++;
        }
    }

    if ( self.streakType != "specialist" )
        self setplayerdata( "killstreaksState", "numAvailable", var_0 );

    var_2 = self.earnedStreakLevel;
    var_3 = getMaxStreakCost();

    if ( self.earnedStreakLevel == var_3 && self.streakType != "specialist" )
        var_2 = 0;

    var_4 = 1;

    foreach ( var_6 in self.killstreaks )
    {
        var_7 = getStreakCost( var_6 );

        if ( var_7 > var_2 )
        {
            var_8 = var_6;
            break;
        }

        if ( self.streakType == "specialist" )
        {
            if ( self.earnedStreakLevel == var_3 )
                break;
        }

        var_4++;
    }

    self setplayerdata( "killstreaksState", "nextIndex", var_4 );

    if ( isdefined( self.killstreakIndexWeapon ) && self.streakType != "specialist" )
        self setplayerdata( "killstreaksState", "selectedIndex", self.killstreakIndexWeapon );
    else if ( self.streakType == "specialist" && self.pers["killstreaks"][0].available )
        self setplayerdata( "killstreaksState", "selectedIndex", 0 );
    else
        self setplayerdata( "killstreaksState", "selectedIndex", -1 );
}

waitForChangeTeam()
{
    self endon( "disconnect" );
    self endon( "faux_spawn" );
    self notify( "waitForChangeTeam" );
    self endon( "waitForChangeTeam" );

    for (;;)
    {
        self waittill( "joined_team" );
        clearKillstreaks();
    }
}

isRideKillstreak( var_0 )
{
    switch ( var_0 )
    {
        case "ac130":
        case "predator_missile":
        case "osprey_gunner":
        case "remote_mortar":
        case "remote_tank":
        case "remote_uav":
        case "helicopter_minigun":
        case "helicopter_mk19":
            return 1;
        default:
            return 0;
    }
}

isCarryKillstreak( var_0 )
{
    switch ( var_0 )
    {
        case "sentry":
        case "minigun_turret":
        case "ims":
        case "deployable_vest":
        case "sentry_gl":
        case "gl_turret":
        case "deployable_exp_ammo":
            return 1;
        default:
            return 0;
    }
}

deadlyKillstreak( var_0 )
{
    switch ( var_0 )
    {
        case "ac130":
        case "precision_airstrike":
        case "predator_missile":
        case "helicopter_flares":
        case "littlebird_flock":
        case "osprey_gunner":
        case "remote_mortar":
        case "remote_tank":
        case "helicopter":
        case "littlebird_support":
        case "stealth_airstrike":
        case "helicopter_minigun":
        case "harrier_airstrike":
            return 1;
    }

    return 0;
}

killstreakUsePressed()
{
    var_0 = self.pers["killstreaks"][self.killstreakIndexWeapon].streakName;
    var_1 = self.pers["killstreaks"][self.killstreakIndexWeapon].lifeId;
    var_2 = self.pers["killstreaks"][self.killstreakIndexWeapon].earned;
    var_3 = self.pers["killstreaks"][self.killstreakIndexWeapon].awardxp;
    var_4 = self.pers["killstreaks"][self.killstreakIndexWeapon].kID;
    var_5 = self.pers["killstreaks"][self.killstreakIndexWeapon].isGimme;

    if ( !self isonground() && ( isRideKillstreak( var_0 ) || isCarryKillstreak( var_0 ) ) )
        return 0;

    if ( maps\mp\_utility::isUsingRemote() )
        return 0;

    if ( isdefined( self.selectingLocation ) )
        return 0;

    if ( deadlyKillstreak( var_0 ) && level.killstreakRoundDelay && maps\mp\_utility::getGametypeNumLives() )
    {
        if ( level.gracePeriod - level.inGracePeriod < level.killstreakRoundDelay )
        {
            self iprintlnbold( &"MP_UNAVAILABLE_FOR_N", level.killstreakRoundDelay - ( level.gracePeriod - level.inGracePeriod ) );
            return 0;
        }
    }

    if ( level.teamBased && level.teamEMPed[self.team] || !level.teamBased && isdefined( level.EMPPlayer ) && level.EMPPlayer != self )
    {
        if ( var_0 != "deployable_vest" )
        {
            self iprintlnbold( &"MP_UNAVAILABLE_FOR_N_WHEN_EMP", level.empTimeRemaining );
            return 0;
        }
    }

    if ( isdefined( self.nuked ) && self.nuked )
    {
        if ( var_0 != "deployable_vest" )
        {
            self iprintlnbold( &"MP_UNAVAILABLE_FOR_N_WHEN_NUKE", level.nukeEmpTimeRemaining );
            return 0;
        }
    }

    if ( self isusingturret() && ( isRideKillstreak( var_0 ) || isCarryKillstreak( var_0 ) ) )
    {
        self iprintlnbold( &"MP_UNAVAILABLE_USING_TURRET" );
        return 0;
    }

    if ( isdefined( self.laststand ) && isRideKillstreak( var_0 ) )
    {
        self iprintlnbold( &"MP_UNAVILABLE_IN_LASTSTAND" );
        return 0;
    }

    if ( !common_scripts\utility::isWeaponEnabled() )
        return 0;

    var_6 = 0;

    if ( maps\mp\_utility::_hasPerk( "specialty_explosivebullets" ) && !issubstr( var_0, "explosive_ammo" ) )
        var_6 = 1;

    if ( issubstr( var_0, "airdrop" ) || var_0 == "littlebird_flock" )
    {
        if ( !self [[ level.killstreakFuncs[var_0] ]]( var_1, var_4 ) )
            return 0;
    }
    else if ( !self [[ level.killstreakFuncs[var_0] ]]( var_1 ) )
        return 0;

    if ( var_6 )
        maps\mp\_utility::_unsetPerk( "specialty_explosivebullets" );

    thread updateKillstreaks();
    usedKillstreak( var_0, var_3 );
    return 1;
}

usedKillstreak( var_0, var_1 )
{
    self playlocalsound( "weap_c4detpack_trigger_plr" );

    if ( var_1 )
    {
        self thread [[ level.onXPEvent ]]( "killstreak_" + var_0 );
        thread maps\mp\gametypes\_missions::useHardpoint( var_0 );
    }

    var_2 = maps\mp\_awards::getKillstreakAwardRef( var_0 );

    if ( isdefined( var_2 ) )
        thread maps\mp\_utility::incPlayerStat( var_2, 1 );

    if ( isAssaultKillstreak( var_0 ) )
        thread maps\mp\_utility::incPlayerStat( "assaultkillstreaksused", 1 );
    else if ( isSupportKillstreak( var_0 ) )
        thread maps\mp\_utility::incPlayerStat( "supportkillstreaksused", 1 );
    else if ( isSpecialistKillstreak( var_0 ) )
    {
        thread maps\mp\_utility::incPlayerStat( "specialistkillstreaksearned", 1 );
        return;
    }

    var_3 = self.team;

    if ( level.teamBased )
    {
        thread maps\mp\_utility::leaderDialog( var_3 + "_friendly_" + var_0 + "_inbound", var_3 );

        if ( getKillstreakInformEnemy( var_0 ) )
            thread maps\mp\_utility::leaderDialog( var_3 + "_enemy_" + var_0 + "_inbound", level.otherTeam[var_3] );
    }
    else
    {
        thread maps\mp\_utility::leaderDialogOnPlayer( var_3 + "_friendly_" + var_0 + "_inbound" );

        if ( getKillstreakInformEnemy( var_0 ) )
        {
            var_4[0] = self;
            thread maps\mp\_utility::leaderDialog( var_3 + "_enemy_" + var_0 + "_inbound", undefined, undefined, var_4 );
        }
    }
}

updateKillstreaks( var_0 )
{
    if ( !isdefined( var_0 ) )
    {
        self.pers["killstreaks"][self.killstreakIndexWeapon].available = 0;

        if ( self.killstreakIndexWeapon == 0 )
        {
            self.pers["killstreaks"][self.pers["killstreaks"][0].nextSlot] = undefined;
            var_1 = undefined;

            for ( var_2 = 5; var_2 < self.pers["killstreaks"].size; var_2++ )
            {
                if ( !isdefined( self.pers["killstreaks"][var_2] ) || !isdefined( self.pers["killstreaks"][var_2].streakName ) )
                    continue;

                var_1 = self.pers["killstreaks"][var_2].streakName;
                self.pers["killstreaks"][0].nextSlot = var_2;
            }

            if ( isdefined( var_1 ) )
            {
                self.pers["killstreaks"][0].available = 1;
                self.pers["killstreaks"][0].streakName = var_1;
                var_3 = getKillstreakIndex( var_1 );
                self setplayerdata( "killstreaksState", "icons", 0, var_3 );

                if ( !level.console )
                {
                    var_4 = getKillstreakWeapon( var_1 );
                    maps\mp\_utility::_setActionSlot( 4, "weapon", var_4 );
                }
            }
        }
    }

    var_5 = undefined;

    if ( self.streakType == "specialist" )
    {
        if ( self.pers["killstreaks"][0].available )
            var_5 = 0;
    }
    else
    {
        for ( var_2 = 0; var_2 < 4; var_2++ )
        {
            if ( isdefined( self.pers["killstreaks"][var_2] ) && isdefined( self.pers["killstreaks"][var_2].streakName ) && self.pers["killstreaks"][var_2].available )
                var_5 = var_2;
        }
    }

    if ( isdefined( var_5 ) )
    {
        if ( level.console )
        {
            self.killstreakIndexWeapon = var_5;
            self.pers["lastEarnedStreak"] = self.pers["killstreaks"][var_5].streakName;
            giveSelectedKillstreakItem();
        }
        else
        {
            for ( var_2 = 0; var_2 < 4; var_2++ )
            {
                if ( isdefined( self.pers["killstreaks"][var_2] ) && isdefined( self.pers["killstreaks"][var_2].streakName ) && self.pers["killstreaks"][var_2].available )
                {
                    var_4 = getKillstreakWeapon( self.pers["killstreaks"][var_2].streakName );
                    var_6 = self getweaponslistitems();
                    var_7 = 0;

                    for ( var_8 = 0; var_8 < var_6.size; var_8++ )
                    {
                        if ( var_4 == var_6[var_8] )
                        {
                            var_7 = 1;
                            break;
                        }
                    }

                    if ( !var_7 )
                        maps\mp\_utility::_giveWeapon( var_4 );
                    else if ( issubstr( var_4, "airdrop_" ) )
                        self setweaponammoclip( var_4, 1 );

                    maps\mp\_utility::_setActionSlot( var_2 + 4, "weapon", var_4 );
                }
            }

            self.killstreakIndexWeapon = undefined;
            self.pers["lastEarnedStreak"] = self.pers["killstreaks"][var_5].streakName;
            updateStreakSlots();
        }
    }
    else
    {
        self.killstreakIndexWeapon = undefined;
        self.pers["lastEarnedStreak"] = undefined;
        updateStreakSlots();
    }
}

clearKillstreaks()
{
    for ( var_0 = self.pers["killstreaks"].size - 1; var_0 > -1; var_0-- )
    {
        if ( isdefined( self.pers["killstreaks"][var_0] ) )
            self.pers["killstreaks"][var_0] = undefined;
    }

    initPlayerKillstreaks();
    resetAdrenaline();
    self.killstreakIndexWeapon = undefined;
    updateStreakSlots();
}

updateSpecialistKillstreaks()
{
    if ( self.adrenaline == 0 )
    {
        for ( var_0 = 1; var_0 < 4; var_0++ )
        {
            if ( isdefined( self.pers["killstreaks"][var_0] ) )
            {
                self.pers["killstreaks"][var_0].available = 0;
                self setplayerdata( "killstreaksState", "hasStreak", var_0, 0 );
            }
        }

        self setplayerdata( "killstreaksState", "nextIndex", 1 );
        self setplayerdata( "killstreaksState", "hasStreak", 4, 0 );
    }
    else
    {
        for ( var_0 = 1; var_0 < 4; var_0++ )
        {
            if ( isdefined( self.pers["killstreaks"][var_0] ) && isdefined( self.pers["killstreaks"][var_0].streakName ) && self.pers["killstreaks"][var_0].available )
            {
                var_1 = getStreakCost( self.pers["killstreaks"][var_0].streakName );

                if ( var_1 > self.adrenaline )
                {
                    self.pers["killstreaks"][var_0].available = 0;
                    self setplayerdata( "killstreaksState", "hasStreak", var_0, 0 );
                    continue;
                }

                if ( self.adrenaline >= var_1 )
                {
                    if ( self getplayerdata( "killstreaksState", "hasStreak", var_0 ) )
                    {
                        if ( isdefined( level.killstreakFuncs[self.pers["killstreaks"][var_0].streakName] ) )
                            self [[ level.killstreakFuncs[self.pers["killstreaks"][var_0].streakName] ]]();

                        continue;
                    }

                    giveKillstreak( self.pers["killstreaks"][var_0].streakName, self.pers["killstreaks"][var_0].earned, 0, self, 1 );
                }
            }
        }

        var_2 = 8;

        if ( maps\mp\_utility::_hasPerk( "specialty_hardline" ) )
            var_2--;

        if ( self.adrenaline >= var_2 )
        {
            self setplayerdata( "killstreaksState", "hasStreak", 4, 1 );
            self.spawnperk = 0;
            giveAllPerks();
        }
        else
            self setplayerdata( "killstreaksState", "hasStreak", 4, 0 );
    }

    if ( self.pers["killstreaks"][0].available )
    {
        var_3 = self.pers["killstreaks"][0].streakName;
        var_4 = getKillstreakWeapon( var_3 );

        if ( level.console )
        {
            giveKillstreakWeapon( var_4 );
            self.killstreakIndexWeapon = 0;
        }
        else
        {
            maps\mp\_utility::_giveWeapon( var_4 );
            maps\mp\_utility::_setActionSlot( 4, "weapon", var_4 );
            self.killstreakIndexWeapon = undefined;
        }
    }
}

getFirstPrimaryWeapon()
{
    var_0 = self getweaponslistprimaries();
    return var_0[0];
}

killstreakUseWaiter()
{
    self endon( "disconnect" );
    self endon( "finish_death" );
    self endon( "joined_team" );
    self endon( "faux_spawn" );
    level endon( "game_ended" );
    self notify( "killstreakUseWaiter" );
    self endon( "killstreakUseWaiter" );
    self.lastKillStreak = 0;

    if ( !isdefined( self.pers["lastEarnedStreak"] ) )
        self.pers["lastEarnedStreak"] = undefined;

    thread finishDeathWaiter();

    for (;;)
    {
        self waittill( "weapon_change",  var_0  );

        if ( !isalive( self ) )
            continue;

        if ( !isdefined( self.killstreakIndexWeapon ) )
            continue;

        if ( !isdefined( self.pers["killstreaks"][self.killstreakIndexWeapon] ) || !isdefined( self.pers["killstreaks"][self.killstreakIndexWeapon].streakName ) )
            continue;

        var_1 = getKillstreakWeapon( self.pers["killstreaks"][self.killstreakIndexWeapon].streakName );

        if ( var_0 != var_1 )
        {
            if ( maps\mp\_utility::isStrStart( var_0, "airdrop_" ) )
            {
                self takeweapon( var_0 );
                self switchtoweapon( self.lastDroppableWeapon );
            }

            continue;
        }

        waittillframeend;
        var_2 = self.pers["killstreaks"][self.killstreakIndexWeapon].streakName;
        var_3 = self.pers["killstreaks"][self.killstreakIndexWeapon].isGimme;
        var_4 = killstreakUsePressed();
        var_5 = undefined;

        if ( !var_4 && !isalive( self ) && !self hasweapon( common_scripts\utility::getLastWeapon() ) )
        {
            var_5 = common_scripts\utility::getLastWeapon();
            maps\mp\_utility::_giveWeapon( var_5 );
        }
        else if ( !self hasweapon( common_scripts\utility::getLastWeapon() ) )
            var_5 = getFirstPrimaryWeapon();
        else
            var_5 = common_scripts\utility::getLastWeapon();

        if ( var_4 )
            thread waitTakeKillstreakWeapon( var_1, var_5 );

        if ( shouldSwitchWeaponPostKillstreak( var_4, var_2 ) )
            self switchtoweapon( var_5 );

        if ( self getcurrentweapon() == "none" )
        {
            while ( self getcurrentweapon() == "none" )
                wait 0.05;

            waittillframeend;
        }
    }
}

waitTakeKillstreakWeapon( var_0, var_1 )
{
    self endon( "disconnect" );
    self endon( "finish_death" );
    self endon( "joined_team" );
    level endon( "game_ended" );
    self notify( "waitTakeKillstreakWeapon" );
    self endon( "waitTakeKillstreakWeapon" );
    var_2 = self getcurrentweapon() == "none";
    self waittill( "weapon_change",  var_3  );

    if ( var_3 == var_1 )
    {
        takeKillstreakWeaponIfNoDupe( var_0 );

        if ( !level.console )
            self.killstreakIndexWeapon = undefined;
    }
    else if ( var_3 != var_0 )
        thread waitTakeKillstreakWeapon( var_0, var_1 );
    else if ( var_2 && self getcurrentweapon() == var_0 )
        thread waitTakeKillstreakWeapon( var_0, var_1 );
}

takeKillstreakWeaponIfNoDupe( var_0 )
{
    var_1 = 0;

    for ( var_2 = 0; var_2 < self.pers["killstreaks"].size; var_2++ )
    {
        if ( isdefined( self.pers["killstreaks"][var_2] ) && isdefined( self.pers["killstreaks"][var_2].streakName ) && self.pers["killstreaks"][var_2].available )
        {
            if ( !isSpecialistKillstreak( self.pers["killstreaks"][var_2].streakName ) && var_0 == getKillstreakWeapon( self.pers["killstreaks"][var_2].streakName ) )
            {
                var_1 = 1;
                break;
            }
        }
    }

    if ( var_1 )
    {
        if ( level.console )
        {
            if ( isdefined( self.killstreakIndexWeapon ) && var_0 != getKillstreakWeapon( self.pers["killstreaks"][self.killstreakIndexWeapon].streakName ) )
                self takeweapon( var_0 );
            else if ( isdefined( self.killstreakIndexWeapon ) && var_0 == getKillstreakWeapon( self.pers["killstreaks"][self.killstreakIndexWeapon].streakName ) )
            {
                self takeweapon( var_0 );
                maps\mp\_utility::_giveWeapon( var_0, 0 );
                maps\mp\_utility::_setActionSlot( 4, "weapon", var_0 );
            }
        }
        else
        {
            self takeweapon( var_0 );
            maps\mp\_utility::_giveWeapon( var_0, 0 );
        }
    }
    else
        self takeweapon( var_0 );
}

shouldSwitchWeaponPostKillstreak( var_0, var_1 )
{
    switch ( var_1 )
    {
        case "uav_strike":
            if ( !var_0 )
                return 0;
    }

    if ( !var_0 )
        return 1;

    if ( isRideKillstreak( var_1 ) )
        return 0;

    return 1;
}

finishDeathWaiter()
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    self notify( "finishDeathWaiter" );
    self endon( "finishDeathWaiter" );
    self waittill( "death" );
    wait 0.05;
    self notify( "finish_death" );
    self.pers["lastEarnedStreak"] = undefined;
}

checkStreakReward()
{
    foreach ( var_1 in self.killstreaks )
    {
        var_2 = getStreakCost( var_1 );

        if ( var_2 > self.adrenaline )
            break;

        if ( self.previousAdrenaline < var_2 && self.adrenaline >= var_2 )
        {
            earnKillstreak( var_1, var_2 );
            break;
        }
    }
}

getCustomClassLoc()
{
    if ( getdvarint( "xblive_privatematch" ) || getdvarint( "xblive_competitionmatch" ) && getdvarint( "systemlink" ) )
        return "privateMatchCustomClasses";
    else if ( getdvarint( "xblive_competitionmatch" ) && ( !level.console && ( getdvar( "dedicated" ) == "dedicated LAN server" || getdvar( "dedicated" ) == "dedicated internet server" ) ) )
        return "privateMatchCustomClasses";
    else
        return "customClasses";
}

killstreakEarned( var_0 )
{
    var_1 = "assault";

    switch ( self.streakType )
    {
        case "assault":
            var_1 = "assaultStreaks";
            break;
        case "support":
            var_1 = "defenseStreaks";
            break;
        case "specialist":
            var_1 = "specialistStreaks";
            break;
    }

    if ( isdefined( self.class_num ) )
    {
        var_2 = getCustomClassLoc();

        if ( self getplayerdata( var_2, self.class_num, var_1, 0 ) == var_0 )
            self.firstKillstreakEarned = gettime();
        else if ( self getplayerdata( var_2, self.class_num, var_1, 2 ) == var_0 && isdefined( self.firstKillstreakEarned ) )
        {
            if ( gettime() - self.firstKillstreakEarned < 20000 )
                thread maps\mp\gametypes\_missions::genericChallenge( "wargasm" );
        }
    }
}

earnKillstreak( var_0, var_1 )
{
    level notify( "gave_killstreak",  var_0  );
    self.earnedStreakLevel = var_1;

    if ( !level.gameEnded )
    {
        var_2 = undefined;

        if ( self.streakType == "specialist" )
        {
            var_3 = getsubstr( var_0, 0, var_0.size - 3 );

            if ( maps\mp\gametypes\_class::isPerkUpgraded( var_3 ) )
                var_2 = "pro";
        }

        thread maps\mp\gametypes\_hud_message::killstreakSplashNotify( var_0, var_1, var_2 );
    }

    thread killstreakEarned( var_0 );
    self.pers["lastEarnedStreak"] = var_0;
    setStreakCountToNext();
    giveKillstreak( var_0, 1, 1 );
}

giveKillstreak( var_0, var_1, var_2, var_3, var_4 )
{
    self endon( "givingLoadout" );

    if ( !isdefined( level.killstreakFuncs[var_0] ) || tablelookup( "mp/killstreakTable.csv", 1, var_0, 0 ) == "" )
        return;

    if ( !isdefined( self.pers["killstreaks"] ) )
        return;

    self endon( "disconnect" );

    if ( !isdefined( var_4 ) )
        var_4 = 0;

    var_5 = undefined;

    if ( !isdefined( var_1 ) || var_1 == 0 )
    {
        var_6 = self.pers["killstreaks"].size;

        if ( !isdefined( self.pers["killstreaks"][var_6] ) )
            self.pers["killstreaks"][var_6] = spawnstruct();

        self.pers["killstreaks"][var_6].available = 0;
        self.pers["killstreaks"][var_6].streakName = var_0;
        self.pers["killstreaks"][var_6].earned = 0;
        self.pers["killstreaks"][var_6].awardxp = isdefined( var_2 ) && var_2;
        self.pers["killstreaks"][var_6].owner = var_3;
        self.pers["killstreaks"][var_6].kID = self.pers["kID"];
        self.pers["killstreaks"][var_6].lifeId = -1;
        self.pers["killstreaks"][var_6].isGimme = 1;
        self.pers["killstreaks"][var_6].isSpecialist = 0;
        self.pers["killstreaks"][0].nextSlot = var_6;
        self.pers["killstreaks"][0].streakName = var_0;
        var_5 = 0;
        var_7 = getKillstreakIndex( var_0 );
        self setplayerdata( "killstreaksState", "icons", 0, var_7 );

        if ( !var_4 )
            showSelectedStreakHint( var_0 );
    }
    else
    {
        for ( var_8 = 1; var_8 < 4; var_8++ )
        {
            if ( isdefined( self.pers["killstreaks"][var_8] ) && isdefined( self.pers["killstreaks"][var_8].streakName ) && var_0 == self.pers["killstreaks"][var_8].streakName )
            {
                var_5 = var_8;
                break;
            }
        }

        if ( !isdefined( var_5 ) )
            return;
    }

    self.pers["killstreaks"][var_5].available = 1;
    self.pers["killstreaks"][var_5].earned = isdefined( var_1 ) && var_1;
    self.pers["killstreaks"][var_5].awardxp = isdefined( var_2 ) && var_2;
    self.pers["killstreaks"][var_5].owner = var_3;
    self.pers["killstreaks"][var_5].kID = self.pers["kID"];
    self.pers["kID"]++;

    if ( !self.pers["killstreaks"][var_5].earned )
        self.pers["killstreaks"][var_5].lifeId = -1;
    else
        self.pers["killstreaks"][var_5].lifeId = self.pers["deaths"];

    if ( self.streakType == "specialist" && var_5 != 0 )
    {
        self.pers["killstreaks"][var_5].isSpecialist = 1;

        if ( isdefined( level.killstreakFuncs[var_0] ) )
            self [[ level.killstreakFuncs[var_0] ]]();

        usedKillstreak( var_0, var_2 );
    }
    else if ( level.console )
    {
        var_9 = getKillstreakWeapon( var_0 );
        giveKillstreakWeapon( var_9 );

        if ( isdefined( self.killstreakIndexWeapon ) )
        {
            var_0 = self.pers["killstreaks"][self.killstreakIndexWeapon].streakName;
            var_10 = getKillstreakWeapon( var_0 );

            if ( !iscurrentlyholdingkillstreakweapon( var_10 ) )
                self.killstreakIndexWeapon = var_5;
        }
        else
            self.killstreakIndexWeapon = var_5;
    }
    else
    {
        if ( 0 == var_5 && self.pers["killstreaks"][0].nextSlot > 5 )
        {
            var_11 = self.pers["killstreaks"][0].nextSlot - 1;
            var_12 = getKillstreakWeapon( self.pers["killstreaks"][var_11].streakName );
            self takeweapon( var_12 );
        }

        var_10 = getKillstreakWeapon( var_0 );
        maps\mp\_utility::_giveWeapon( var_10, 0 );
        maps\mp\_utility::_setActionSlot( var_5 + 4, "weapon", var_10 );
    }

    updateStreakSlots();

    if ( isdefined( level.killstreakSetupFuncs[var_0] ) )
        self [[ level.killstreakSetupFuncs[var_0] ]]();

    if ( isdefined( var_1 ) && var_1 && isdefined( var_2 ) && var_2 )
        self notify( "received_earned_killstreak" );
}

iscurrentlyholdingkillstreakweapon( var_0 )
{
    var_1 = self getcurrentweapon();

    switch ( var_0 )
    {
        case "killstreak_uav_mp":
            return var_1 == "killstreak_remote_uav_mp";
    }

    return var_1 == var_0;
}

giveKillstreakWeapon( var_0 )
{
    self endon( "disconnect" );

    if ( !level.console )
        return;

    var_1 = self getweaponslistitems();

    foreach ( var_3 in var_1 )
    {
        if ( !maps\mp\_utility::isStrStart( var_3, "killstreak_" ) && !maps\mp\_utility::isStrStart( var_3, "airdrop_" ) && !maps\mp\_utility::isStrStart( var_3, "deployable_" ) )
            continue;

        if ( self getcurrentweapon() == var_3 || isdefined( self.changingWeapon ) && self.changingWeapon == var_3 )
            continue;

        while ( maps\mp\_utility::isChangingWeapon() )
            wait 0.05;

        self takeweapon( var_3 );
    }

    if ( isdefined( self.killstreakIndexWeapon ) )
    {
        var_5 = self.pers["killstreaks"][self.killstreakIndexWeapon].streakName;
        var_6 = getKillstreakWeapon( var_5 );

        if ( self getcurrentweapon() != var_6 )
        {
            maps\mp\_utility::_giveWeapon( var_0, 0 );
            maps\mp\_utility::_setActionSlot( 4, "weapon", var_0 );
            return;
        }
    }
    else
    {
        maps\mp\_utility::_giveWeapon( var_0, 0 );
        maps\mp\_utility::_setActionSlot( 4, "weapon", var_0 );
    }
}

getStreakCost( var_0 )
{
    var_1 = int( tablelookup( "mp/killstreakTable.csv", 1, var_0, 4 ) );

    if ( isdefined( self ) && isplayer( self ) )
    {
        if ( isSpecialistKillstreak( var_0 ) )
        {
            if ( isdefined( self.pers["gamemodeLoadout"] ) )
            {
                if ( isdefined( self.pers["gamemodeLoadout"]["loadoutKillstreak1"] ) && self.pers["gamemodeLoadout"]["loadoutKillstreak1"] == var_0 )
                    var_1 = 2;
                else if ( isdefined( self.pers["gamemodeLoadout"]["loadoutKillstreak2"] ) && self.pers["gamemodeLoadout"]["loadoutKillstreak2"] == var_0 )
                    var_1 = 4;
                else if ( isdefined( self.pers["gamemodeLoadout"]["loadoutKillstreak3"] ) && self.pers["gamemodeLoadout"]["loadoutKillstreak3"] == var_0 )
                    var_1 = 6;
                else
                {

                }
            }
            else if ( issubstr( self.curClass, "custom" ) )
            {
                var_2 = getCustomClassLoc();

                for ( var_3 = 0; var_3 < 3; var_3++ )
                {
                    var_4 = self getplayerdata( var_2, self.class_num, "specialistStreaks", var_3 );

                    if ( var_4 == var_0 )
                        break;
                }

                var_1 = self getplayerdata( var_2, self.class_num, "specialistStreakKills", var_3 );
            }
            else if ( issubstr( self.curClass, "axis" ) || issubstr( self.curClass, "allies" ) )
            {
                var_3 = 0;
                var_5 = "none";

                if ( issubstr( self.curClass, "axis" ) )
                    var_5 = "axis";
                else if ( issubstr( self.curClass, "allies" ) )
                    var_5 = "allies";

                for ( var_6 = maps\mp\gametypes\_class::getClassIndex( self.curClass ); var_3 < 3; var_3++ )
                {
                    var_4 = getmatchrulesdata( "defaultClasses", var_5, var_6, "class", "specialistStreaks", var_3 );

                    if ( var_4 == var_0 )
                        break;
                }

                var_1 = getmatchrulesdata( "defaultClasses", var_5, var_6, "class", "specialistStreakKills", var_3 );
            }
        }

        if ( maps\mp\_utility::_hasPerk( "specialty_hardline" ) && var_1 > 0 )
            var_1--;
    }

    return var_1;
}

isAssaultKillstreak( var_0 )
{
    switch ( var_0 )
    {
        case "uav":
        case "ac130":
        case "precision_airstrike":
        case "predator_missile":
        case "airdrop_assault":
        case "airdrop_sentry_minigun":
        case "airdrop_juggernaut":
        case "helicopter_flares":
        case "littlebird_flock":
        case "osprey_gunner":
        case "ims":
        case "remote_mortar":
        case "airdrop_remote_tank":
        case "helicopter":
        case "littlebird_support":
            return 1;
        default:
            return 0;
    }
}

isSupportKillstreak( var_0 )
{
    switch ( var_0 )
    {
        case "emp":
        case "triple_uav":
        case "counter_uav":
        case "stealth_airstrike":
        case "airdrop_trap":
        case "escort_airdrop":
        case "deployable_vest":
        case "remote_mg_turret":
        case "airdrop_juggernaut_recon":
        case "uav_support":
        case "remote_uav":
        case "sam_turret":
            return 1;
        default:
            return 0;
    }
}

isSpecialistKillstreak( var_0 )
{
    switch ( var_0 )
    {
        case "specialty_longersprint_ks":
        case "specialty_fastreload_ks":
        case "specialty_scavenger_ks":
        case "specialty_blindeye_ks":
        case "specialty_paint_ks":
        case "specialty_hardline_ks":
        case "specialty_coldblooded_ks":
        case "specialty_quickdraw_ks":
        case "specialty_assists_ks":
        case "_specialty_blastshield_ks":
        case "specialty_detectexplosive_ks":
        case "specialty_autospot_ks":
        case "specialty_bulletaccuracy_ks":
        case "specialty_quieter_ks":
        case "specialty_stalker_ks":
        case "all_perks_bonus":
            return 1;
        default:
            return 0;
    }
}

getKillstreakHint( var_0 )
{
    return tablelookupistring( "mp/killstreakTable.csv", 1, var_0, 6 );
}

getKillstreakInformEnemy( var_0 )
{
    return int( tablelookup( "mp/killstreakTable.csv", 1, var_0, 11 ) );
}

getKillstreakSound( var_0 )
{
    return tablelookup( "mp/killstreakTable.csv", 1, var_0, 7 );
}

getKillstreakDialog( var_0 )
{
    return tablelookup( "mp/killstreakTable.csv", 1, var_0, 8 );
}

getKillstreakWeapon( var_0 )
{
    return tablelookup( "mp/killstreakTable.csv", 1, var_0, 12 );
}

getKillstreakIcon( var_0 )
{
    return tablelookup( "mp/killstreakTable.csv", 1, var_0, 14 );
}

getKillstreakCrateIcon( var_0 )
{
    return tablelookup( "mp/killstreakTable.csv", 1, var_0, 15 );
}

getKillstreakDpadIcon( var_0 )
{
    return tablelookup( "mp/killstreakTable.csv", 1, var_0, 16 );
}

getKillstreakIndex( var_0 )
{
    return tablelookuprownum( "mp/killstreakTable.csv", 1, var_0 ) - 1;
}

streakTypeResetsOnDeath( var_0 )
{
    switch ( var_0 )
    {
        case "specialist":
        case "assault":
            return 1;
        case "support":
            return 0;
    }
}

giveOwnedKillstreakItem( var_0 )
{
    if ( level.console )
    {
        var_1 = -1;
        var_2 = -1;

        for ( var_3 = 0; var_3 < 4; var_3++ )
        {
            if ( isdefined( self.pers["killstreaks"][var_3] ) && isdefined( self.pers["killstreaks"][var_3].streakName ) && self.pers["killstreaks"][var_3].available && getStreakCost( self.pers["killstreaks"][var_3].streakName ) > var_2 )
            {
                var_2 = 0;

                if ( !self.pers["killstreaks"][var_3].isGimme )
                    var_2 = getStreakCost( self.pers["killstreaks"][var_3].streakName );

                var_1 = var_3;
            }
        }

        if ( var_1 != -1 )
        {
            self.killstreakIndexWeapon = var_1;
            var_4 = self.pers["killstreaks"][self.killstreakIndexWeapon].streakName;
            var_5 = getKillstreakWeapon( var_4 );
            giveKillstreakWeapon( var_5 );

            if ( !isdefined( var_0 ) && !level.inGracePeriod )
                showSelectedStreakHint( var_4 );
        }
        else
            self.killstreakIndexWeapon = undefined;
    }
    else
    {
        var_1 = -1;
        var_2 = -1;

        for ( var_3 = 0; var_3 < 4; var_3++ )
        {
            if ( isdefined( self.pers["killstreaks"][var_3] ) && isdefined( self.pers["killstreaks"][var_3].streakName ) && self.pers["killstreaks"][var_3].available )
            {
                var_6 = getKillstreakWeapon( self.pers["killstreaks"][var_3].streakName );
                var_7 = self getweaponslistitems();
                var_8 = 0;

                for ( var_9 = 0; var_9 < var_7.size; var_9++ )
                {
                    if ( var_6 == var_7[var_9] )
                    {
                        var_8 = 1;
                        break;
                    }
                }

                if ( !var_8 )
                    maps\mp\_utility::_giveWeapon( var_6 );
                else if ( issubstr( var_6, "airdrop_" ) )
                    self setweaponammoclip( var_6, 1 );

                maps\mp\_utility::_setActionSlot( var_3 + 4, "weapon", var_6 );

                if ( getStreakCost( self.pers["killstreaks"][var_3].streakName ) > var_2 )
                {
                    var_2 = 0;

                    if ( !self.pers["killstreaks"][var_3].isGimme )
                        var_2 = getStreakCost( self.pers["killstreaks"][var_3].streakName );

                    var_1 = var_3;
                }
            }
        }

        if ( var_1 != -1 )
        {
            var_4 = self.pers["killstreaks"][var_1].streakName;

            if ( !isdefined( var_0 ) && !level.inGracePeriod )
                showSelectedStreakHint( var_4 );
        }

        self.killstreakIndexWeapon = undefined;
    }

    updateStreakSlots();
}

initRideKillstreak( var_0 )
{
    common_scripts\utility::_disableUsability();
    var_1 = initRideKillstreak_internal( var_0 );

    if ( isdefined( self ) )
        common_scripts\utility::_enableUsability();

    return var_1;
}

initRideKillstreak_internal( var_0 )
{
    if ( isdefined( var_0 ) && ( var_0 == "osprey_gunner" || var_0 == "remote_uav" || var_0 == "remote_tank" ) )
        var_1 = "timeout";
    else
        var_1 = common_scripts\utility::waittill_any_timeout( 1.0, "disconnect", "death", "weapon_switch_started" );

    maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();

    if ( var_1 == "weapon_switch_started" )
        return "fail";

    if ( !isalive( self ) )
        return "fail";

    if ( var_1 == "disconnect" || var_1 == "death" )
    {
        if ( var_1 == "disconnect" )
            return "disconnect";

        if ( self.team == "spectator" )
            return "fail";

        return "success";
    }

    if ( maps\mp\_utility::isEMPed() || maps\mp\_utility::isNuked() || maps\mp\_utility::isAirDenied() )
        return "fail";

    self visionsetnakedforplayer( "black_bw", 0.75 );
    var_2 = common_scripts\utility::waittill_any_timeout( 0.8, "disconnect", "death" );
    maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();

    if ( var_2 != "disconnect" )
    {
        thread clearRideIntro( 1.0 );

        if ( self.team == "spectator" )
            return "fail";
    }

    if ( self isonladder() )
        return "fail";

    if ( !isalive( self ) )
        return "fail";

    if ( maps\mp\_utility::isEMPed() || maps\mp\_utility::isNuked() || maps\mp\_utility::isAirDenied() )
        return "fail";

    if ( var_2 == "disconnect" )
        return "disconnect";
    else
        return "success";
}

clearRideIntro( var_0 )
{
    self endon( "disconnect" );

    if ( isdefined( var_0 ) )
        wait(var_0);

    if ( isdefined( level.nukeDetonated ) )
        self visionsetnakedforplayer( level.nukeVisionSet, 0 );
    else
        self visionsetnakedforplayer( "", 0 );
}

giveSelectedKillstreakItem()
{
    var_0 = self.pers["killstreaks"][self.killstreakIndexWeapon].streakName;
    var_1 = getKillstreakWeapon( var_0 );
    giveKillstreakWeapon( var_1 );
    updateStreakSlots();
}

showSelectedStreakHint( var_0 )
{
    var_1 = spawnstruct();
    var_1.name = "selected_" + var_0;
    var_1.type = "killstreak_minisplash";
    var_1.optionalNumber = getStreakCost( var_0 );
    var_1.leaderSound = var_0;
    var_1.leaderSoundGroup = "killstreak_earned";
    var_1.slot = 0;
    self.notifyText.alpha = 0;
    self.notifyText2.alpha = 0;
    self.notifyIcon.alpha = 0;
    thread maps\mp\gametypes\_hud_message::actionNotifyMessage( var_1 );
}

getKillstreakCount()
{
    var_0 = 0;

    for ( var_1 = 0; var_1 < 4; var_1++ )
    {
        if ( isdefined( self.pers["killstreaks"][var_1] ) && isdefined( self.pers["killstreaks"][var_1].streakName ) && self.pers["killstreaks"][var_1].available )
            var_0++;
    }

    return var_0;
}

shuffleKillstreaksUp()
{
    if ( getKillstreakCount() > 1 )
    {
        for (;;)
        {
            self.killstreakIndexWeapon++;

            if ( self.killstreakIndexWeapon > 3 )
                self.killstreakIndexWeapon = 0;

            if ( self.pers["killstreaks"][self.killstreakIndexWeapon].available == 1 )
                break;
        }

        giveSelectedKillstreakItem();
        showSelectedStreakHint( self.pers["killstreaks"][self.killstreakIndexWeapon].streakName );
    }
}

shuffleKillstreaksDown()
{
    if ( getKillstreakCount() > 1 )
    {
        for (;;)
        {
            self.killstreakIndexWeapon--;

            if ( self.killstreakIndexWeapon < 0 )
                self.killstreakIndexWeapon = 3;

            if ( self.pers["killstreaks"][self.killstreakIndexWeapon].available == 1 )
                break;
        }

        giveSelectedKillstreakItem();
        showSelectedStreakHint( self.pers["killstreaks"][self.killstreakIndexWeapon].streakName );
    }
}

streakSelectUpTracker()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "faux_spawn" );
    level endon( "game_ended" );

    for (;;)
    {
        self waittill( "toggled_up" );

        if ( !self ismantling() && ( !isdefined( self.changingWeapon ) || isdefined( self.changingWeapon ) && self.changingWeapon == "none" ) && ( !maps\mp\_utility::isKillstreakWeapon( self getcurrentweapon() ) || maps\mp\_utility::isjuggernautweapon( self getcurrentweapon() ) && maps\mp\_utility::isJuggernaut() ) && self.streakType != "specialist" && ( !isdefined( self.isCarrying ) || isdefined( self.isCarrying ) && self.isCarrying == 0 ) && ( !isdefined( self.laststreakused ) || isdefined( self.laststreakused ) && gettime() - self.laststreakused > 100 ) )
            shuffleKillstreaksUp();

        wait 0.12;
    }
}

streakSelectDownTracker()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "faux_spawn" );
    level endon( "game_ended" );

    for (;;)
    {
        self waittill( "toggled_down" );

        if ( !self ismantling() && ( !isdefined( self.changingWeapon ) || isdefined( self.changingWeapon ) && self.changingWeapon == "none" ) && ( !maps\mp\_utility::isKillstreakWeapon( self getcurrentweapon() ) || maps\mp\_utility::isjuggernautweapon( self getcurrentweapon() ) && maps\mp\_utility::isJuggernaut() ) && self.streakType != "specialist" && ( !isdefined( self.isCarrying ) || isdefined( self.isCarrying ) && self.isCarrying == 0 ) && ( !isdefined( self.laststreakused ) || isdefined( self.laststreakused ) && gettime() - self.laststreakused > 100 ) )
            shuffleKillstreaksDown();

        wait 0.12;
    }
}

streakusetimetracker()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "faux_spawn" );
    level endon( "game_ended" );

    for (;;)
    {
        self waittill( "streakUsed" );
        self.laststreakused = gettime();
    }
}

streakNotifyTracker()
{
    self endon( "death" );
    self endon( "disconnect" );
    level endon( "game_ended" );
    maps\mp\_utility::gameFlagWait( "prematch_done" );

    if ( level.console )
    {
        self notifyonplayercommand( "toggled_up", "+actionslot 1" );
        self notifyonplayercommand( "toggled_down", "+actionslot 2" );
        self notifyonplayercommand( "streakUsed", "+actionslot 4" );
        self notifyonplayercommand( "streakUsed", "+actionslot 5" );
        self notifyonplayercommand( "streakUsed", "+actionslot 6" );
        self notifyonplayercommand( "streakUsed", "+actionslot 7" );
    }
    else
    {
        self notifyonplayercommand( "streakUsed1", "+actionslot 4" );
        self notifyonplayercommand( "streakUsed2", "+actionslot 5" );
        self notifyonplayercommand( "streakUsed3", "+actionslot 6" );
        self notifyonplayercommand( "streakUsed4", "+actionslot 7" );
    }
}

registerAdrenalineInfo( var_0, var_1 )
{
    if ( !isdefined( level.adrenalineInfo ) )
        level.adrenalineInfo = [];

    level.adrenalineInfo[var_0] = var_1;
}

giveAdrenaline( var_0 )
{
    if ( level.adrenalineInfo[var_0] == 0 )
        return;

    var_1 = self.adrenaline + level.adrenalineInfo[var_0];
    var_2 = var_1;
    var_3 = getMaxStreakCost();

    if ( var_2 > var_3 && self.streakType != "specialist" )
        var_2 -= var_3;
    else if ( level.killstreakRewards && var_2 > var_3 && self.streakType == "specialist" )
    {
        var_4 = 8;

        if ( maps\mp\_utility::_hasPerk( "specialty_hardline" ) )
            var_4--;

        if ( var_2 == var_4 )
        {
            giveAllPerks();
            usedKillstreak( "all_perks_bonus", 1 );
            thread maps\mp\gametypes\_hud_message::killstreakSplashNotify( "all_perks_bonus", var_4 );
            self setplayerdata( "killstreaksState", "hasStreak", 4, 1 );
            self.pers["killstreaks"][4].available = 1;
        }

        if ( var_3 > 0 && !( ( var_2 - var_3 ) % 2 ) )
        {
            thread maps\mp\gametypes\_rank::xpEventPopup( &"MP_SPECIALIST_STREAKING_XP" );
            thread maps\mp\gametypes\_rank::giveRankXP( "kill" );
        }
    }

    setAdrenaline( var_2 );
    checkStreakReward();

    if ( var_1 == var_3 && self.streakType != "specialist" )
        setAdrenaline( 0 );
}

giveAllPerks()
{
    var_0 = [];
    var_0[var_0.size] = "specialty_longersprint";
    var_0[var_0.size] = "specialty_fastreload";
    var_0[var_0.size] = "specialty_scavenger";
    var_0[var_0.size] = "specialty_blindeye";
    var_0[var_0.size] = "specialty_paint";
    var_0[var_0.size] = "specialty_hardline";
    var_0[var_0.size] = "specialty_coldblooded";
    var_0[var_0.size] = "specialty_quickdraw";
    var_0[var_0.size] = "_specialty_blastshield";
    var_0[var_0.size] = "specialty_detectexplosive";
    var_0[var_0.size] = "specialty_autospot";
    var_0[var_0.size] = "specialty_bulletaccuracy";
    var_0[var_0.size] = "specialty_quieter";
    var_0[var_0.size] = "specialty_stalker";
    var_0[var_0.size] = "specialty_marksman";
    var_0[var_0.size] = "specialty_sharp_focus";
    var_0[var_0.size] = "specialty_longerrange";
    var_0[var_0.size] = "specialty_fastermelee";
    var_0[var_0.size] = "specialty_reducedsway";
    var_0[var_0.size] = "specialty_lightweight";

    foreach ( var_2 in var_0 )
    {
        if ( !maps\mp\_utility::_hasPerk( var_2 ) )
        {
            maps\mp\_utility::givePerk( var_2, 0 );

            if ( maps\mp\gametypes\_class::isPerkUpgraded( var_2 ) )
            {
                var_3 = tablelookup( "mp/perktable.csv", 1, var_2, 8 );
                maps\mp\_utility::givePerk( var_3, 0 );
            }
        }
    }
}

resetAdrenaline()
{
    self.earnedStreakLevel = 0;
    setAdrenaline( 0 );
    resetStreakCount();

    if ( isdefined( self.pers["lastEarnedStreak"] ) )
        self.pers["lastEarnedStreak"] = undefined;
}

setAdrenaline( var_0 )
{
    if ( var_0 < 0 )
        var_0 = 0;

    if ( isdefined( self.adrenaline ) )
        self.previousAdrenaline = self.adrenaline;
    else
        self.previousAdrenaline = 0;

    self.adrenaline = var_0;
    self setclientdvar( "ui_adrenaline", self.adrenaline );
    updateStreakCount();
}

pc_watchstreakuse()
{
    self endon( "death" );
    self endon( "disconnect" );
    level endon( "game_ended" );
    self.actionslotenabled = [];
    self.actionslotenabled[0] = 1;
    self.actionslotenabled[1] = 1;
    self.actionslotenabled[2] = 1;
    self.actionslotenabled[3] = 1;

    for (;;)
    {
        var_0 = common_scripts\utility::waittill_any_return( "streakUsed1", "streakUsed2", "streakUsed3", "streakUsed4" );

        if ( !isdefined( var_0 ) )
            continue;

        if ( self.streakType == "specialist" && var_0 != "streakUsed1" )
            continue;

        if ( isdefined( self.changingWeapon ) && self.changingWeapon == "none" )
            continue;

        switch ( var_0 )
        {
            case "streakUsed1":
                if ( self.pers["killstreaks"][0].available && self.actionslotenabled[0] )
                    self.killstreakIndexWeapon = 0;

                break;
            case "streakUsed2":
                if ( self.pers["killstreaks"][1].available && self.actionslotenabled[1] )
                    self.killstreakIndexWeapon = 1;

                break;
            case "streakUsed3":
                if ( self.pers["killstreaks"][2].available && self.actionslotenabled[2] )
                    self.killstreakIndexWeapon = 2;

                break;
            case "streakUsed4":
                if ( self.pers["killstreaks"][3].available && self.actionslotenabled[3] )
                    self.killstreakIndexWeapon = 3;

                break;
        }

        if ( isdefined( self.killstreakIndexWeapon ) && !self.pers["killstreaks"][self.killstreakIndexWeapon].available )
            self.killstreakIndexWeapon = undefined;

        if ( isdefined( self.killstreakIndexWeapon ) )
        {
            disablekillstreakactionslots();

            for (;;)
            {
                self waittill( "weapon_change",  var_1  );

                if ( isdefined( self.killstreakIndexWeapon ) )
                {
                    var_2 = getKillstreakWeapon( self.pers["killstreaks"][self.killstreakIndexWeapon].streakName );

                    if ( var_1 == var_2 || var_1 == "none" || var_2 == "killstreak_uav_mp" && var_1 == "killstreak_remote_uav_mp" || var_2 == "killstreak_uav_mp" && var_1 == "uav_remote_mp" )
                        continue;

                    break;
                }

                break;
            }

            enablekillstreakactionslots();
            self.killstreakIndexWeapon = undefined;
        }
    }
}

disablekillstreakactionslots()
{
    for ( var_0 = 0; var_0 < 4; var_0++ )
    {
        if ( !isdefined( self.killstreakIndexWeapon ) )
            break;

        if ( self.killstreakIndexWeapon == var_0 )
            continue;

        maps\mp\_utility::_setActionSlot( var_0 + 4, "" );
        self.actionslotenabled[var_0] = 0;
    }
}

enablekillstreakactionslots()
{
    for ( var_0 = 0; var_0 < 4; var_0++ )
    {
        if ( self.pers["killstreaks"][var_0].available )
        {
            var_1 = getKillstreakWeapon( self.pers["killstreaks"][var_0].streakName );
            maps\mp\_utility::_setActionSlot( var_0 + 4, "weapon", var_1 );
        }
        else
            maps\mp\_utility::_setActionSlot( var_0 + 4, "" );

        self.actionslotenabled[var_0] = 1;
    }
}

killstreakhit( var_0, var_1, var_2 )
{
    if ( isdefined( var_1 ) && isplayer( var_0 ) && isdefined( var_2.owner ) && isdefined( var_2.owner.team ) )
    {
        if ( ( level.teamBased && var_2.owner.team != var_0.team || !level.teamBased ) && var_0 != var_2.owner )
        {
            if ( maps\mp\_utility::isKillstreakWeapon( var_1 ) )
                return;

            if ( !isdefined( var_0.lastHitTime[var_1] ) )
                var_0.lastHitTime[var_1] = 0;

            if ( var_0.lastHitTime[var_1] == gettime() )
                return;

            var_0.lastHitTime[var_1] = gettime();
            var_0 thread maps\mp\gametypes\_gamelogic::threadedSetWeaponStatByName( var_1, 1, "hits" );
            var_3 = var_0 maps\mp\gametypes\_persistence::statGetBuffered( "totalShots" );
            var_4 = var_0 maps\mp\gametypes\_persistence::statGetBuffered( "hits" ) + 1;

            if ( var_4 <= var_3 )
            {
                var_0 maps\mp\gametypes\_persistence::statSetBuffered( "hits", var_4 );
                var_0 maps\mp\gametypes\_persistence::statSetBuffered( "misses", int( var_3 - var_4 ) );
                var_5 = clamp( float( var_4 ) / float( var_3 ), 0.0, 1.0 ) * 10000.0;
                var_0 maps\mp\gametypes\_persistence::statSetBuffered( "accuracy", int( var_5 ) );
            }
        }
    }
}
