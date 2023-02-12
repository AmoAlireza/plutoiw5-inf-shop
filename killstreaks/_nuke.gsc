// IW5 PC GSC
// Decompiled by https://github.com/xensik/gsc-tool

init()
{
    precacheitem( "nuke_mp" );
    precachelocationselector( "map_nuke_selector" );
    precachestring( &"MP_TACTICAL_NUKE_CALLED" );
    precachestring( &"MP_FRIENDLY_TACTICAL_NUKE" );
    precachestring( &"MP_TACTICAL_NUKE" );
    level.nukeVisionSet = "aftermath";
    level._effect["nuke_player"] = loadfx( "explosions/player_death_nuke" );
    level._effect["nuke_flash"] = loadfx( "explosions/player_death_nuke_flash" );
    level._effect["nuke_aftermath"] = loadfx( "dust/nuke_aftermath_mp" );
    game["strings"]["nuclear_strike"] = &"MP_TACTICAL_NUKE";
    level.killstreakFuncs["nuke"] = ::tryUseNuke;
    setdvarifuninitialized( "scr_nukeTimer", 10 );
    setdvarifuninitialized( "scr_nukeCancelMode", 0 );
    level.nukeTimer = getdvarint( "scr_nukeTimer" );
    level.cancelMode = getdvarint( "scr_nukeCancelMode" );
    level.teamNukeEMPed["allies"] = 0;
    level.teamNukeEMPed["axis"] = 0;
    level.nukeEmpTimeout = 60.0;
    level.nukeEmpTimeRemaining = int( level.nukeEmpTimeout );
    level.nukeInfo = spawnstruct();
    level.nukeInfo._unk_field_ID54 = 2;
    level.nukeDetonated = undefined;
    level thread nuke_EMPTeamTracker();
    level thread onPlayerConnect();
}

tryUseNuke( var_0, var_1 )
{
    if ( isdefined( level.nukeIncoming ) )
    {
        self iprintlnbold( &"MP_NUKE_ALREADY_INBOUND" );
        return 0;
    }

    if ( maps\mp\_utility::isUsingRemote() && ( !isdefined( level.gtnw ) || !level.gtnw ) )
        return 0;

    if ( !isdefined( var_1 ) )
        var_1 = 1;

    thread doNuke( var_1 );
    self notify( "used_nuke" );
    maps\mp\_matchdata::logKillstreakEvent( "nuke", self.origin );
    return 1;
}

delaythread_nuke( var_0, var_1 )
{
    level endon( "nuke_cancelled" );
    maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( var_0 );
    thread [[ var_1 ]]();
}

doNuke( var_0 )
{
    level endon( "nuke_cancelled" );
    level.nukeInfo.player = self;
    level.nukeInfo.team = self.pers["team"];
    level.nukeIncoming = 1;
    setdvar( "ui_bomb_timer", 4 );

    if ( level.teamBased )
        thread maps\mp\_utility::teamPlayerCardSplash( "used_nuke", self, self.team );
    else if ( !level.hardcoreMode )
        self iprintlnbold( &"MP_FRIENDLY_TACTICAL_NUKE" );

    level thread delaythread_nuke( level.nukeTimer - 3.3, ::nukeSoundIncoming );
    level thread delaythread_nuke( level.nukeTimer, ::nukeSoundExplosion );
    level thread delaythread_nuke( level.nukeTimer, ::nukeSlowMo );
    level thread delaythread_nuke( level.nukeTimer, ::nukeEffects );
    level thread delaythread_nuke( level.nukeTimer + 0.25, ::nukeVision );
    level thread delaythread_nuke( level.nukeTimer + 1.5, ::nukeDeath );
    level thread delaythread_nuke( level.nukeTimer + 1.5, ::nukeEarthquake );
    level thread nukeAftermathEffect();
    level thread update_ui_timers();

    if ( level.cancelMode && var_0 )
        level thread cancelNukeOnDeath( self );

    if ( !isdefined( level.nuke_clockobject ) )
    {
        level.nuke_clockobject = spawn( "script_origin", ( 0, 0, 0 ) );
        level.nuke_clockobject hide();
    }

    if ( !isdefined( level.nuke_soundobject ) )
    {
        level.nuke_soundobject = spawn( "script_origin", ( 0, 0, 1 ) );
        level.nuke_soundobject hide();
    }

    for ( var_1 = level.nukeTimer; var_1 > 0; var_1-- )
    {
        level.nuke_clockobject playsound( "ui_mp_nukebomb_timer" );
        wait 1.0;
    }
}

cancelNukeOnDeath( var_0 )
{
    var_0 common_scripts\utility::waittill_any( "death", "disconnect" );

    if ( isdefined( var_0 ) && level.cancelMode == 2 )
        var_0 thread maps\mp\killstreaks\_emp::EMP_Use( 0, 0 );

    setdvar( "ui_bomb_timer", 0 );
    level.nukeIncoming = undefined;
    level notify( "nuke_cancelled" );
}

nukeSoundIncoming()
{
    level endon( "nuke_cancelled" );

    if ( isdefined( level.nuke_soundobject ) )
        level.nuke_soundobject playsound( "nuke_incoming" );
}

nukeSoundExplosion()
{
    level endon( "nuke_cancelled" );

    if ( isdefined( level.nuke_soundobject ) )
    {
        level.nuke_soundobject playsound( "nuke_explosion" );
        level.nuke_soundobject playsound( "nuke_wave" );
    }
}

nukeEffects()
{
    level endon( "nuke_cancelled" );
    setdvar( "ui_bomb_timer", 0 );
    level.nukeDetonated = 1;

    foreach ( var_1 in level.players )
    {
        var_2 = anglestoforward( var_1.angles );
        var_2 = ( var_2[0], var_2[1], 0 );
        var_2 = vectornormalize( var_2 );
        var_3 = 5000;
        var_4 = spawn( "script_model", var_1.origin + var_2 * var_3 );
        var_4 setmodel( "tag_origin" );
        var_4.angles = ( 0, var_1.angles[1] + 180, 90 );
        var_4 thread nukeEffect( var_1 );
    }
}

nukeEffect( var_0 )
{
    level endon( "nuke_cancelled" );
    var_0 endon( "disconnect" );
    common_scripts\utility::waitframe();
    playfxontagforclients( level._effect["nuke_flash"], self, "tag_origin", var_0 );
}

nukeAftermathEffect()
{
    level endon( "nuke_cancelled" );
    level waittill( "spawning_intermission" );
    var_0 = getentarray( "mp_global_intermission", "classname" );
    var_0 = var_0[0];
    var_1 = anglestoup( var_0.angles );
    var_2 = anglestoright( var_0.angles );
    playfx( level._effect["nuke_aftermath"], var_0.origin, var_1, var_2 );
}

nukeSlowMo()
{
    level endon( "nuke_cancelled" );
    setslowmotion( 1.0, 0.25, 0.5 );
    level waittill( "nuke_death" );
    setslowmotion( 0.25, 1, 2.0 );
}

nukeVision()
{
    level endon( "nuke_cancelled" );
    level.nukeVisionInProgress = 1;
    visionsetnaked( "mpnuke", 3 );
    level waittill( "nuke_death" );
    visionsetnaked( level.nukeVisionSet, 5 );
    visionsetpain( level.nukeVisionSet );
}

nukeDeath()
{
    level endon( "nuke_cancelled" );
    level notify( "nuke_death" );
    maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
    ambientstop( 1 );

    foreach ( var_1 in level.players )
    {
        if ( level.teamBased )
        {
            if ( isdefined( level.nukeInfo.team ) && var_1.team == level.nukeInfo.team )
                continue;
        }
        else if ( isdefined( level.nukeInfo.player ) && var_1 == level.nukeInfo.player )
            continue;

        var_1.nuked = 1;

        if ( isalive( var_1 ) )
            var_1 thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( level.nukeInfo.player, level.nukeInfo.player, 999999, 0, "MOD_EXPLOSIVE", "nuke_mp", var_1.origin, var_1.origin, "none", 0, 0 );
    }

    level thread nuke_EMPJam();
    level.nukeIncoming = undefined;
}

nukeEarthquake()
{
    level endon( "nuke_cancelled" );
    level waittill( "nuke_death" );
}

nuke_EMPJam()
{
    level endon( "game_ended" );
    level maps\mp\killstreaks\_emp::destroyActiveVehicles( level.nukeInfo.player, maps\mp\_utility::getOtherTeam( level.nukeInfo.team ) );
    level notify( "nuke_EMPJam" );
    level endon( "nuke_EMPJam" );

    if ( level.teamBased )
        level.teamNukeEMPed[maps\mp\_utility::getOtherTeam( level.nukeInfo.team )] = 1;
    else
    {
        level.teamNukeEMPed[level.nukeInfo.team] = 1;
        level.teamNukeEMPed[maps\mp\_utility::getOtherTeam( level.nukeInfo.team )] = 1;
    }

    level notify( "nuke_emp_update" );
    level thread keepNukeEMPTimeRemaining();
    maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( level.nukeEmpTimeout );

    if ( level.teamBased )
        level.teamNukeEMPed[maps\mp\_utility::getOtherTeam( level.nukeInfo.team )] = 0;
    else
    {
        level.teamNukeEMPed[level.nukeInfo.team] = 0;
        level.teamNukeEMPed[maps\mp\_utility::getOtherTeam( level.nukeInfo.team )] = 0;
    }

    foreach ( var_1 in level.players )
    {
        if ( level.teamBased && var_1.team == level.nukeInfo.team )
            continue;

        var_1.nuked = undefined;
    }

    level notify( "nuke_emp_update" );
    level notify( "nuke_emp_ended" );
}

keepNukeEMPTimeRemaining()
{
    level notify( "keepNukeEMPTimeRemaining" );
    level endon( "keepNukeEMPTimeRemaining" );
    level endon( "nuke_emp_ended" );

    for ( level.nukeEmpTimeRemaining = int( level.nukeEmpTimeout ); level.nukeEmpTimeRemaining; level.nukeEmpTimeRemaining-- )
        wait 1.0;
}

nuke_EMPTeamTracker()
{
    level endon( "game_ended" );

    for (;;)
    {
        level common_scripts\utility::waittill_either( "joined_team", "nuke_emp_update" );

        foreach ( player in level.players )
        {
            if ( player.team == "spectator" )
                continue;

            if ( level.teamBased )
            {
                if ( isdefined( level.nukeInfo.team ) && player.team == level.nukeInfo.team )
                    continue;
            }
            else if ( isdefined( level.nukeInfo.player ) && player == level.nukeInfo.player )
                continue;

            shouldJam = level.teamNukeEMPed[player.team] || player maps\mp\_utility::isEMPed();
            player setEmpJammed(shouldJam);
        }
    }
}

onPlayerConnect()
{
    for (;;)
    {
        level waittill( "connected",  var_0  );
        var_0 thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon( "disconnect" );

    for (;;)
    {
        self waittill( "spawned_player" );

        if ( level.teamNukeEMPed[self.team] )
        {
            // Plutonium change: set nuked to 1 here, so that it is also set for players who join after nukeDeath
            // it will be reset in nuke_EMPJam at the end of the nuke period
            if ( level.teamBased )
            {
                self setempjammed( 1 );
                self.nuked = 1;
            }
            else if ( !isdefined( level.nukeInfo.player ) || isdefined( level.nukeInfo.player ) && self != level.nukeInfo.player )
            {
                self setempjammed( 1 );
                self.nuked = 1;
            }
        }

        if ( isdefined( level.nukeDetonated ) )
            self visionsetnakedforplayer( level.nukeVisionSet, 0 );
    }
}

update_ui_timers()
{
    level endon( "game_ended" );
    level endon( "disconnect" );
    level endon( "nuke_cancelled" );
    level endon( "nuke_death" );
    var_0 = level.nukeTimer * 1000 + gettime();
    setdvar( "ui_nuke_end_milliseconds", var_0 );
    level waittill( "host_migration_begin" );
    var_1 = maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();

    if ( var_1 > 0 )
        setdvar( "ui_nuke_end_milliseconds", var_0 + var_1 );
}
