// IW5 PC GSC
// Decompiled by https://github.com/xensik/gsc-tool

init()
{
    game["music"]["spawn_allies"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "allies" ) + "spawn_music";
    game["music"]["defeat_allies"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "allies" ) + "defeat_music";
    game["music"]["victory_allies"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "allies" ) + "victory_music";
    game["music"]["winning_allies"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "allies" ) + "winning_music";
    game["music"]["losing_allies"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "allies" ) + "losing_music";
    game["voice"]["allies"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "allies" ) + "1mc_";
    game["music"]["spawn_axis"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "axis" ) + "spawn_music";
    game["music"]["defeat_axis"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "axis" ) + "defeat_music";
    game["music"]["victory_axis"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "axis" ) + "victory_music";
    game["music"]["winning_axis"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "axis" ) + "winning_music";
    game["music"]["losing_axis"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "axis" ) + "losing_music";
    game["voice"]["axis"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "axis" ) + "1mc_";
    game["music"]["losing_time"] = "mp_time_running_out_losing";
    game["music"]["suspense"] = [];
    game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_01";
    game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_02";
    game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_03";
    game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_04";
    game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_05";
    game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_06";
    game["dialog"]["mission_success"] = "mission_success";
    game["dialog"]["mission_failure"] = "mission_fail";
    game["dialog"]["mission_draw"] = "draw";
    game["dialog"]["round_success"] = "encourage_win";
    game["dialog"]["round_failure"] = "encourage_lost";
    game["dialog"]["round_draw"] = "draw";
    game["dialog"]["timesup"] = "timesup";
    game["dialog"]["winning_time"] = "winning";
    game["dialog"]["losing_time"] = "losing";
    game["dialog"]["winning_score"] = "winning_fight";
    game["dialog"]["losing_score"] = "losing_fight";
    game["dialog"]["lead_lost"] = "lead_lost";
    game["dialog"]["lead_tied"] = "tied";
    game["dialog"]["lead_taken"] = "lead_taken";
    game["dialog"]["last_alive"] = "lastalive";
    game["dialog"]["boost"] = "boost";

    if ( !isdefined( game["dialog"]["offense_obj"] ) )
        game["dialog"]["offense_obj"] = "boost";

    if ( !isdefined( game["dialog"]["defense_obj"] ) )
        game["dialog"]["defense_obj"] = "boost";

    game["dialog"]["hardcore"] = "hardcore";
    game["dialog"]["highspeed"] = "highspeed";
    game["dialog"]["tactical"] = "tactical";
    game["dialog"]["challenge"] = "challengecomplete";
    game["dialog"]["promotion"] = "promotion";
    game["dialog"]["bomb_taken"] = "acheive_bomb";
    game["dialog"]["bomb_lost"] = "bomb_taken";
    game["dialog"]["bomb_defused"] = "bomb_defused";
    game["dialog"]["bomb_planted"] = "bomb_planted";
    game["dialog"]["obj_taken"] = "securedobj";
    game["dialog"]["obj_lost"] = "lostobj";
    game["dialog"]["obj_defend"] = "obj_defend";
    game["dialog"]["obj_destroy"] = "obj_destroy";
    game["dialog"]["obj_capture"] = "capture_obj";
    game["dialog"]["objs_capture"] = "capture_objs";
    game["dialog"]["hq_located"] = "hq_located";
    game["dialog"]["hq_enemy_captured"] = "hq_captured";
    game["dialog"]["hq_enemy_destroyed"] = "hq_destroyed";
    game["dialog"]["hq_secured"] = "hq_secured";
    game["dialog"]["hq_offline"] = "hq_offline";
    game["dialog"]["hq_online"] = "hq_online";
    game["dialog"]["move_to_new"] = "new_positions";
    game["dialog"]["push_forward"] = "pushforward";
    game["dialog"]["attack"] = "attack";
    game["dialog"]["defend"] = "defend";
    game["dialog"]["offense"] = "offense";
    game["dialog"]["defense"] = "defense";
    game["dialog"]["halftime"] = "halftime";
    game["dialog"]["overtime"] = "overtime";
    game["dialog"]["side_switch"] = "switching";
    game["dialog"]["flag_taken"] = "ourflag";
    game["dialog"]["flag_dropped"] = "ourflag_drop";
    game["dialog"]["flag_returned"] = "ourflag_return";
    game["dialog"]["flag_captured"] = "ourflag_capt";
    game["dialog"]["flag_getback"] = "getback_ourflag";
    game["dialog"]["enemy_flag_bringhome"] = "enemyflag_tobase";
    game["dialog"]["enemy_flag_taken"] = "enemyflag";
    game["dialog"]["enemy_flag_dropped"] = "enemyflag_drop";
    game["dialog"]["enemy_flag_returned"] = "enemyflag_return";
    game["dialog"]["enemy_flag_captured"] = "enemyflag_capt";
    game["dialog"]["got_flag"] = "achieve_flag";
    game["dialog"]["dropped_flag"] = "lost_flag";
    game["dialog"]["enemy_got_flag"] = "enemy_has_flag";
    game["dialog"]["enemy_dropped_flag"] = "enemy_dropped_flag";
    game["dialog"]["capturing_a"] = "capturing_a";
    game["dialog"]["capturing_b"] = "capturing_b";
    game["dialog"]["capturing_c"] = "capturing_c";
    game["dialog"]["captured_a"] = "capture_a";
    game["dialog"]["captured_b"] = "capture_c";
    game["dialog"]["captured_c"] = "capture_b";
    game["dialog"]["securing_a"] = "securing_a";
    game["dialog"]["securing_b"] = "securing_b";
    game["dialog"]["securing_c"] = "securing_c";
    game["dialog"]["secured_a"] = "secure_a";
    game["dialog"]["secured_b"] = "secure_b";
    game["dialog"]["secured_c"] = "secure_c";
    game["dialog"]["losing_a"] = "losing_a";
    game["dialog"]["losing_b"] = "losing_b";
    game["dialog"]["losing_c"] = "losing_c";
    game["dialog"]["lost_a"] = "lost_a";
    game["dialog"]["lost_b"] = "lost_b";
    game["dialog"]["lost_c"] = "lost_c";
    game["dialog"]["enemy_taking_a"] = "enemy_take_a";
    game["dialog"]["enemy_taking_b"] = "enemy_take_b";
    game["dialog"]["enemy_taking_c"] = "enemy_take_c";
    game["dialog"]["enemy_has_a"] = "enemy_has_a";
    game["dialog"]["enemy_has_b"] = "enemy_has_b";
    game["dialog"]["enemy_has_c"] = "enemy_has_c";
    game["dialog"]["lost_all"] = "take_positions";
    game["dialog"]["secure_all"] = "positions_lock";
    game["dialog"]["destroy_sentry"] = "dest_sentrygun";
    game["music"]["nuke_music"] = "nuke_music";
    game["dialog"]["sentry_gone"] = "sentry_gone";
    game["dialog"]["sentry_destroyed"] = "sentry_destroyed";
    game["dialog"]["ti_gone"] = "ti_cancelled";
    game["dialog"]["ti_destroyed"] = "ti_blocked";
    game["dialog"]["ims_destroyed"] = "ims_destroyed";
    game["dialog"]["lbguard_destroyed"] = "lbguard_destroyed";
    game["dialog"]["ballistic_vest_destroyed"] = "ballistic_vest_destroyed";
    game["dialog"]["remote_sentry_destroyed"] = "remote_sentry_destroyed";
    game["dialog"]["sam_destroyed"] = "sam_destroyed";
    game["dialog"]["sam_gone"] = "sam_gone";
    level thread onPlayerConnect();
    level thread onLastAlive();
    level thread musicController();
    level thread onGameEnded();
    level thread onRoundSwitch();
}

onPlayerConnect()
{
    for (;;)
    {
        level waittill( "connected",  var_0  );
        var_0 thread onPlayerSpawned();
        var_0 thread finalKillcamMusic();
    }
}

onPlayerSpawned()
{
    self endon( "disconnect" );
    self waittill( "spawned_player" );

    if ( !level.splitscreen || level.splitscreen && !isdefined( level.playedStartingMusic ) )
    {
        if ( !self issplitscreenplayer() || self issplitscreenplayerprimary() )
            self playlocalsound( game["music"]["spawn_" + self.team] );

        if ( level.splitscreen )
            level.playedStartingMusic = 1;
    }

    if ( isdefined( game["dialog"]["gametype"] ) && ( !level.splitscreen || self == level.players[0] ) )
    {
        if ( isdefined( game["dialog"]["allies_gametype"] ) && self.team == "allies" )
            maps\mp\_utility::leaderDialogOnPlayer( "allies_gametype" );
        else if ( isdefined( game["dialog"]["axis_gametype"] ) && self.team == "axis" )
            maps\mp\_utility::leaderDialogOnPlayer( "axis_gametype" );
        else if ( !self issplitscreenplayer() || self issplitscreenplayerprimary() )
            maps\mp\_utility::leaderDialogOnPlayer( "gametype" );
    }

    maps\mp\_utility::gameFlagWait( "prematch_done" );

    if ( self.team == game["attackers"] )
    {
        if ( !self issplitscreenplayer() || self issplitscreenplayerprimary() )
            maps\mp\_utility::leaderDialogOnPlayer( "offense_obj", "introboost" );
    }
    else if ( !self issplitscreenplayer() || self issplitscreenplayerprimary() )
        maps\mp\_utility::leaderDialogOnPlayer( "defense_obj", "introboost" );
}

onLastAlive()
{
    level endon( "game_ended" );
    level waittill( "last_alive",  var_0  );

    if ( !isalive( var_0 ) )
        return;

    var_0 maps\mp\_utility::leaderDialogOnPlayer( "last_alive" );
}

onRoundSwitch()
{
    level waittill( "round_switch",  var_0  );

    switch ( var_0 )
    {
        case "halftime":
            foreach ( var_2 in level.players )
            {
                if ( var_2 issplitscreenplayer() && !var_2 issplitscreenplayerprimary() )
                    continue;

                var_2 maps\mp\_utility::leaderDialogOnPlayer( "halftime" );
            }

            break;
        case "overtime":
            foreach ( var_2 in level.players )
            {
                if ( var_2 issplitscreenplayer() && !var_2 issplitscreenplayerprimary() )
                    continue;

                var_2 maps\mp\_utility::leaderDialogOnPlayer( "overtime" );
            }

            break;
        default:
            foreach ( var_2 in level.players )
            {
                if ( var_2 issplitscreenplayer() && !var_2 issplitscreenplayerprimary() )
                    continue;

                var_2 maps\mp\_utility::leaderDialogOnPlayer( "side_switch" );
            }

            break;
    }
}

onGameEnded()
{
    level thread roundWinnerDialog();
    level thread gameWinnerDialog();
    level waittill( "game_win",  var_0  );

    if ( level.teamBased )
    {
        if ( level.splitscreen )
        {
            if ( var_0 == "allies" )
                maps\mp\_utility::playSoundOnPlayers( game["music"]["victory_allies"], "allies" );
            else if ( var_0 == "axis" )
                maps\mp\_utility::playSoundOnPlayers( game["music"]["victory_axis"], "axis" );
            else
                maps\mp\_utility::playSoundOnPlayers( game["music"]["nuke_music"] );
        }
        else if ( var_0 == "allies" )
        {
            maps\mp\_utility::playSoundOnPlayers( game["music"]["victory_allies"], "allies" );
            maps\mp\_utility::playSoundOnPlayers( game["music"]["defeat_axis"], "axis" );
        }
        else if ( var_0 == "axis" )
        {
            maps\mp\_utility::playSoundOnPlayers( game["music"]["victory_axis"], "axis" );
            maps\mp\_utility::playSoundOnPlayers( game["music"]["defeat_allies"], "allies" );
        }
        else
            maps\mp\_utility::playSoundOnPlayers( game["music"]["nuke_music"] );
    }
    else
    {
        foreach ( var_2 in level.players )
        {
            if ( var_2 issplitscreenplayer() && !var_2 issplitscreenplayerprimary() )
                continue;

            if ( var_2.pers["team"] != "allies" && var_2.pers["team"] != "axis" )
            {
                var_2 playlocalsound( game["music"]["nuke_music"] );
                continue;
            }

            if ( isdefined( var_0 ) && isplayer( var_0 ) && var_2 == var_0 )
            {
                var_2 playlocalsound( game["music"]["victory_" + var_2.pers["team"]] );
                continue;
            }

            if ( !level.splitscreen )
                var_2 playlocalsound( game["music"]["defeat_" + var_2.pers["team"]] );
        }
    }
}

roundWinnerDialog()
{
    level waittill( "round_win",  var_0  );
    var_1 = level.roundEndDelay / 4;

    if ( var_1 > 0 )
        wait(var_1);

    if ( !isdefined( var_0 ) || isplayer( var_0 ) )
        return;

    if ( var_0 == "allies" )
    {
        maps\mp\_utility::leaderDialog( "round_success", "allies" );
        maps\mp\_utility::leaderDialog( "round_failure", "axis" );
    }
    else if ( var_0 == "axis" )
    {
        maps\mp\_utility::leaderDialog( "round_success", "axis" );
        maps\mp\_utility::leaderDialog( "round_failure", "allies" );
    }
}

gameWinnerDialog()
{
    level waittill( "game_win",  var_0  );
    var_1 = level.postRoundTime / 2;

    if ( var_1 > 0 )
        wait(var_1);

    if ( !isdefined( var_0 ) || isplayer( var_0 ) )
        return;

    if ( var_0 == "allies" )
    {
        maps\mp\_utility::leaderDialog( "mission_success", "allies" );
        maps\mp\_utility::leaderDialog( "mission_failure", "axis" );
    }
    else if ( var_0 == "axis" )
    {
        maps\mp\_utility::leaderDialog( "mission_success", "axis" );
        maps\mp\_utility::leaderDialog( "mission_failure", "allies" );
    }
    else
        maps\mp\_utility::leaderDialog( "mission_draw" );
}

// Plutonium change: allow gametype scripts to define custom logic to determine
// which team is winning
playTeamBasedScoreNotification()
{
    winningTeam = "";
    if (isDefined(level.determineWinningTeam))
    {
        winningTeam = [[ level.determineWinningTeam ]]();
        assert(winningTeam == "allies" || winningTeam == "axis" || winningTeam == "tie", "Bad level.determineWinningTeam! " + winningTeam);
    }
    else
    {
        if ( game["teamScores"]["allies"] > game["teamScores"]["axis"] )
        {
            winningTeam = "allies";
        }
        else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
        {
            winningTeam = "axis";
        }
    }

    if ( winningTeam == "allies" )
    {
        if ( !level.hardcoreMode )
        {
            maps\mp\_utility::playSoundOnPlayers( game["music"]["winning_allies"], "allies" );
            maps\mp\_utility::playSoundOnPlayers( game["music"]["losing_axis"], "axis" );
        }

        maps\mp\_utility::leaderDialog( "winning_time", "allies" );
        maps\mp\_utility::leaderDialog( "losing_time", "axis" );
    }
    else if ( winningTeam == "axis" )
    {
        if ( !level.hardcoreMode )
        {
            maps\mp\_utility::playSoundOnPlayers( game["music"]["winning_axis"], "axis" );
            maps\mp\_utility::playSoundOnPlayers( game["music"]["losing_allies"], "allies" );
        }

        maps\mp\_utility::leaderDialog( "winning_time", "axis" );
        maps\mp\_utility::leaderDialog( "losing_time", "allies" );
    }
}

musicController()
{
    level endon( "game_ended" );

    if ( !level.hardcoreMode )
        thread suspenseMusic();

    level waittill( "match_ending_soon",  var_0  );

    if ( maps\mp\_utility::getWatchedDvar( "roundlimit" ) == 1 || game["roundsPlayed"] == maps\mp\_utility::getWatchedDvar( "roundlimit" ) - 1 )
    {
        if ( !level.splitscreen )
        {
            if ( var_0 == "time" )
            {
                if ( level.teamBased )
                {
                    playTeamBasedScoreNotification();
                }
                else
                {
                    if ( !level.hardcoreMode )
                        maps\mp\_utility::playSoundOnPlayers( game["music"]["losing_time"] );

                    maps\mp\_utility::leaderDialog( "timesup" );
                }
            }
            else if ( var_0 == "score" )
            {
                if ( level.teamBased )
                {
                    playTeamBasedScoreNotification();
                }
                else
                {
                    var_1 = maps\mp\gametypes\_gamescore::getHighestScoringPlayer();
                    var_2 = maps\mp\gametypes\_gamescore::getLosingPlayers();
                    var_3[0] = var_1;

                    if ( !level.hardcoreMode )
                    {
                        var_1 playlocalsound( game["music"]["winning_" + var_1.pers["team"]] );

                        foreach ( var_5 in level.players )
                        {
                            if ( var_5 == var_1 )
                                continue;

                            var_5 playlocalsound( game["music"]["losing_" + var_5.pers["team"]] );
                        }
                    }

                    var_1 maps\mp\_utility::leaderDialogOnPlayer( "winning_score" );
                    maps\mp\_utility::leaderDialogOnPlayers( "losing_score", var_2 );
                }
            }

            level waittill( "match_ending_very_soon" );
            maps\mp\_utility::leaderDialog( "timesup" );
        }
    }
    else
    {
        if ( !level.hardcoreMode )
            maps\mp\_utility::playSoundOnPlayers( game["music"]["losing_allies"] );

        maps\mp\_utility::leaderDialog( "timesup" );
    }
}

suspenseMusic()
{
    level endon( "game_ended" );
    level endon( "match_ending_soon" );
    var_0 = game["music"]["suspense"].size;
    wait 120;

    for (;;)
    {
        wait(randomfloatrange( 60, 120 ));
        maps\mp\_utility::playSoundOnPlayers( game["music"]["suspense"][randomint( var_0 )] );
    }
}

finalKillcamMusic()
{
    self waittill( "showing_final_killcam" );
}
