// IW5 PC GSC
// Decompiled by https://github.com/xensik/gsc-tool

onForfeit( var_0 )
{
    if ( isdefined( level.forfeitInProgress ) )
        return;

    level endon( "abort_forfeit" );
    level thread forfeitWaitforAbort();
    level.forfeitInProgress = 1;

    if ( !level.teamBased && level.players.size > 1 && getdvarint( "party_maxplayers" ) > 2 )
        wait 10;

    level.forfeit_aborted = 0;

    if ( getdvarint( "party_maxplayers" ) > 2 )
    {
        var_1 = 20.0;
        matchForfeitTimer( var_1 );
    }

    var_2 = &"";

    if ( !isdefined( var_0 ) )
    {
        level.finalKillCam_winner = "none";
        var_2 = game["strings"]["players_forfeited"];
        var_3 = level.players[0];
    }
    else if ( var_0 == "allies" )
    {
        level.finalKillCam_winner = "axis";
        var_2 = game["strings"]["allies_forfeited"];
        var_3 = "axis";
    }
    else if ( var_0 == "axis" )
    {
        level.finalKillCam_winner = "allies";
        var_2 = game["strings"]["axis_forfeited"];
        var_3 = "allies";
    }
    else
    {
        level.finalKillCam_winner = "none";
        var_3 = "tie";
    }

    level.forcedEnd = 1;

    if ( isplayer( var_3 ) )
        logstring( "forfeit, win: " + var_3 getxuid() + "(" + var_3.name + ")" );
    else
        logstring( "forfeit, win: " + var_3 + ", allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );

    thread endGame( var_3, var_2 );
}

forfeitWaitforAbort()
{
    level endon( "game_ended" );
    level waittill( "abort_forfeit" );
    level.forfeit_aborted = 1;

    if ( isdefined( level.matchForfeitTimer ) )
        level.matchForfeitTimer maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( level.matchForfeitText ) )
        level.matchForfeitText maps\mp\gametypes\_hud_util::destroyElem();
}

matchForfeitTimer_Internal( var_0, var_1 )
{
    waittillframeend;
    level endon( "match_forfeit_timer_beginning" );

    while ( var_0 > 0 && !level.gameEnded && !level.forfeit_aborted && !level.inGracePeriod )
    {
        var_1 thread maps\mp\gametypes\_hud::fontPulse( level );
        wait(var_1.inFrames * 0.05);
        var_1 setvalue( var_0 );
        var_0--;
        wait(1 - var_1.inFrames * 0.05);
    }
}

matchForfeitTimer( var_0 )
{
    level notify( "match_forfeit_timer_beginning" );
    var_1 = maps\mp\gametypes\_hud_util::createServerFontString( "objective", 1.5 );
    var_1 maps\mp\gametypes\_hud_util::setPoint( "CENTER", "CENTER", 0, -40 );
    var_1.sort = 1001;
    var_1 settext( game["strings"]["opponent_forfeiting_in"] );
    var_1.foreground = 0;
    var_1.hidewheninmenu = 1;
    var_2 = maps\mp\gametypes\_hud_util::createServerFontString( "hudbig", 1 );
    var_2 maps\mp\gametypes\_hud_util::setPoint( "CENTER", "CENTER", 0, 0 );
    var_2.sort = 1001;
    var_2.color = ( 1, 1, 0 );
    var_2.foreground = 0;
    var_2.hidewheninmenu = 1;
    var_2 maps\mp\gametypes\_hud::fontPulseInit();
    var_3 = int( var_0 );
    level.matchForfeitTimer = var_2;
    level.matchForfeitText = var_1;
    matchForfeitTimer_Internal( var_3, var_2 );
    var_2 maps\mp\gametypes\_hud_util::destroyElem();
    var_1 maps\mp\gametypes\_hud_util::destroyElem();
}

default_onDeadEvent( var_0 )
{
    level.finalKillCam_winner = "none";

    if ( var_0 == "allies" )
    {
        iprintln( game["strings"]["allies_eliminated"] );
        logstring( "team eliminated, win: opfor, allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );
        level.finalKillCam_winner = "axis";
        thread endGame( "axis", game["strings"]["allies_eliminated"] );
    }
    else if ( var_0 == "axis" )
    {
        iprintln( game["strings"]["axis_eliminated"] );
        logstring( "team eliminated, win: allies, allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );
        level.finalKillCam_winner = "allies";
        thread endGame( "allies", game["strings"]["axis_eliminated"] );
    }
    else
    {
        logstring( "tie, allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );
        level.finalKillCam_winner = "none";

        if ( level.teamBased )
            thread endGame( "tie", game["strings"]["tie"] );
        else
            thread endGame( undefined, game["strings"]["tie"] );
    }
}

default_onOneLeftEvent( var_0 )
{
    if ( level.teamBased )
    {
        var_1 = maps\mp\_utility::getLastLivingPlayer( var_0 );
        var_1 thread giveLastOnTeamWarning();
    }
    else
    {
        var_1 = maps\mp\_utility::getLastLivingPlayer();
        logstring( "last one alive, win: " + var_1.name );
        level.finalKillCam_winner = "none";
        thread endGame( var_1, &"MP_ENEMIES_ELIMINATED" );
    }

    return 1;
}

default_onTimeLimit()
{
    var_0 = undefined;
    level.finalKillCam_winner = "none";

    if ( level.teamBased )
    {
        if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
            var_0 = "tie";
        else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
        {
            level.finalKillCam_winner = "axis";
            var_0 = "axis";
        }
        else
        {
            level.finalKillCam_winner = "allies";
            var_0 = "allies";
        }

        logstring( "time limit, win: " + var_0 + ", allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );
    }
    else
    {
        var_0 = maps\mp\gametypes\_gamescore::getHighestScoringPlayer();

        if ( isdefined( var_0 ) )
            logstring( "time limit, win: " + var_0.name );
        else
            logstring( "time limit, tie" );
    }

    thread endGame( var_0, game["strings"]["time_limit_reached"] );
}

default_onHalfTime()
{
    var_0 = undefined;
    level.finalKillCam_winner = "none";
    thread endGame( "halftime", game["strings"]["time_limit_reached"] );
}

forceEnd()
{
    if ( level.hostForcedEnd || level.forcedEnd )
        return;

    var_0 = undefined;
    level.finalKillCam_winner = "none";

    if ( level.teamBased )
    {
        if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
            var_0 = "tie";
        else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
        {
            level.finalKillCam_winner = "axis";
            var_0 = "axis";
        }
        else
        {
            level.finalKillCam_winner = "allies";
            var_0 = "allies";
        }

        logstring( "host ended game, win: " + var_0 + ", allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );
    }
    else
    {
        var_0 = maps\mp\gametypes\_gamescore::getHighestScoringPlayer();

        if ( isdefined( var_0 ) )
            logstring( "host ended game, win: " + var_0.name );
        else
            logstring( "host ended game, tie" );
    }

    level.forcedEnd = 1;
    level.hostForcedEnd = 1;

    if ( level.splitscreen )
        var_1 = &"MP_ENDED_GAME";
    else
        var_1 = &"MP_HOST_ENDED_GAME";

    thread endGame( var_0, var_1 );
}

onScoreLimit()
{
    var_0 = game["strings"]["score_limit_reached"];
    var_1 = undefined;
    level.finalKillCam_winner = "none";

    if ( level.teamBased )
    {
        if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
            var_1 = "tie";
        else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
        {
            var_1 = "axis";
            level.finalKillCam_winner = "axis";
        }
        else
        {
            var_1 = "allies";
            level.finalKillCam_winner = "allies";
        }

        logstring( "scorelimit, win: " + var_1 + ", allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );
    }
    else
    {
        var_1 = maps\mp\gametypes\_gamescore::getHighestScoringPlayer();

        if ( isdefined( var_1 ) )
            logstring( "scorelimit, win: " + var_1.name );
        else
            logstring( "scorelimit, tie" );
    }

    thread endGame( var_1, var_0 );
    return 1;
}

updateGameEvents()
{
    if ( maps\mp\_utility::matchMakingGame() && !level.inGracePeriod )
    {
        if ( level.teamBased )
        {
            if ( level.teamCount["allies"] < 1 && level.teamCount["axis"] > 0 && game["state"] == "playing" )
            {
                thread onForfeit( "allies" );
                return;
            }

            if ( level.teamCount["axis"] < 1 && level.teamCount["allies"] > 0 && game["state"] == "playing" )
            {
                thread onForfeit( "axis" );
                return;
            }

            if ( level.teamCount["axis"] > 0 && level.teamCount["allies"] > 0 )
            {
                level.forfeitInProgress = undefined;
                level notify( "abort_forfeit" );
            }
        }
        else
        {
            if ( level.teamCount["allies"] + level.teamCount["axis"] == 1 && level.maxPlayerCount > 1 )
            {
                thread onForfeit();
                return;
            }

            if ( level.teamCount["axis"] + level.teamCount["allies"] > 1 )
            {
                level.forfeitInProgress = undefined;
                level notify( "abort_forfeit" );
            }
        }
    }

    if ( !maps\mp\_utility::getGametypeNumLives() && ( !isdefined( level.disableSpawning ) || !level.disableSpawning ) )
        return;

    if ( !maps\mp\_utility::gameHasStarted() )
        return;

    if ( level.inGracePeriod )
        return;

    if ( level.teamBased )
    {
        var_0["allies"] = level.livesCount["allies"];
        var_0["axis"] = level.livesCount["axis"];

        if ( isdefined( level.disableSpawning ) && level.disableSpawning )
        {
            var_0["allies"] = 0;
            var_0["axis"] = 0;
        }

        if ( !level.aliveCount["allies"] && !level.aliveCount["axis"] && !var_0["allies"] && !var_0["axis"] )
            return [[ level.onDeadEvent ]]( "all" );

        if ( !level.aliveCount["allies"] && !var_0["allies"] )
            return [[ level.onDeadEvent ]]( "allies" );

        if ( !level.aliveCount["axis"] && !var_0["axis"] )
            return [[ level.onDeadEvent ]]( "axis" );

        if ( level.aliveCount["allies"] == 1 && !var_0["allies"] )
        {
            if ( !isdefined( level.oneLeftTime["allies"] ) )
            {
                level.oneLeftTime["allies"] = gettime();
                return [[ level.onOneLeftEvent ]]( "allies" );
            }
        }

        if ( level.aliveCount["axis"] == 1 && !var_0["axis"] )
        {
            if ( !isdefined( level.oneLeftTime["axis"] ) )
            {
                level.oneLeftTime["axis"] = gettime();
                return [[ level.onOneLeftEvent ]]( "axis" );
                return;
            }

            return;
        }
    }
    else
    {
        if ( !level.aliveCount["allies"] && !level.aliveCount["axis"] && ( !level.livesCount["allies"] && !level.livesCount["axis"] ) )
            return [[ level.onDeadEvent ]]( "all" );

        var_1 = maps\mp\_utility::getPotentialLivingPlayers();

        if ( var_1.size == 1 )
            return [[ level.onOneLeftEvent ]]( "all" );
    }
}

waittillFinalKillcamDone()
{
    if ( !isdefined( level.finalKillCam_winner ) )
        return 0;

    level waittill( "final_killcam_done" );
    return 1;
}

timeLimitClock_Intermission( var_0 )
{
    setgameendtime( gettime() + int( var_0 * 1000 ) );
    var_1 = spawn( "script_origin", ( 0, 0, 0 ) );
    var_1 hide();

    if ( var_0 >= 10.0 )
        wait(var_0 - 10.0);

    for (;;)
    {
        var_1 playsound( "ui_mp_timer_countdown" );
        wait 1.0;
    }
}

waitForPlayers( var_0 )
{
    var_1 = gettime() + var_0 * 1000 - 200;

    if ( level.teamBased )
    {
        while ( ( !level.hasSpawned["axis"] || !level.hasSpawned["allies"] ) && gettime() < var_1 )
            wait 0.05;
    }
    else
    {
        while ( level.maxPlayerCount < 2 && gettime() < var_1 )
            wait 0.05;
    }
}

prematchPeriod()
{
    level endon( "game_ended" );

    if ( level.prematchPeriod > 0 )
    {
        if ( level.console )
        {
            thread matchStartTimer( "match_starting_in", level.prematchPeriod );
            wait(level.prematchPeriod);
        }
        else
            matchStartTimerPC();
    }
    else
        matchStartTimerSkip();

    for ( var_0 = 0; var_0 < level.players.size; var_0++ )
    {
        level.players[var_0] maps\mp\_utility::freezeControlsWrapper( 0 );
        level.players[var_0] enableweapons();
        var_1 = maps\mp\_utility::getObjectiveHintText( level.players[var_0].pers["team"] );

        if ( !isdefined( var_1 ) || !level.players[var_0].hasSpawned )
            continue;

        level.players[var_0] setclientdvar( "scr_objectiveText", var_1 );
        level.players[var_0] thread maps\mp\gametypes\_hud_message::hintMessage( var_1 );
    }

    if ( game["state"] != "playing" )
        return;
}

gracePeriod()
{
    level endon( "game_ended" );

    while ( level.inGracePeriod > 0 )
    {
        wait 1.0;
        level.inGracePeriod--;
    }

    level notify( "grace_period_ending" );
    wait 0.05;
    maps\mp\_utility::gameFlagSet( "graceperiod_done" );
    level.inGracePeriod = 0;

    if ( game["state"] != "playing" )
        return;

    if ( maps\mp\_utility::getGametypeNumLives() )
    {
        var_0 = level.players;

        for ( var_1 = 0; var_1 < var_0.size; var_1++ )
        {
            var_2 = var_0[var_1];

            if ( !var_2.hasSpawned && var_2.sessionteam != "spectator" && !isalive( var_2 ) )
                var_2.statusicon = "hud_status_dead";
        }
    }

    level thread updateGameEvents();
}

sethasdonecombat( var_0, var_1 )
{
    var_0.hasDoneCombat = var_1;
    var_2 = !isdefined( var_0.hasdoneanycombat ) || !var_0.hasdoneanycombat;

    if ( var_2 && var_1 )
    {
        var_0.hasdoneanycombat = 1;
        game[var_0.guid] = 1;
        updateLossStats( var_0 );
    }
}

updateWinStats( var_0 )
{
    if ( !var_0 maps\mp\_utility::rankingEnabled() )
        return;

    if ( !isdefined( var_0.hasdoneanycombat ) || !var_0.hasdoneanycombat )
        return;

    var_0 maps\mp\gametypes\_persistence::statAdd( "losses", -1 );
    var_0 maps\mp\gametypes\_persistence::statAdd( "wins", 1 );
    var_0 maps\mp\_utility::updatePersRatio( "winLossRatio", "wins", "losses" );
    var_0 maps\mp\gametypes\_persistence::statAdd( "currentWinStreak", 1 );
    var_1 = var_0 maps\mp\gametypes\_persistence::statGet( "currentWinStreak" );

    if ( var_1 > var_0 maps\mp\gametypes\_persistence::statGet( "winStreak" ) )
        var_0 maps\mp\gametypes\_persistence::statSet( "winStreak", var_1 );

    var_0 maps\mp\gametypes\_persistence::statSetChild( "round", "win", 1 );
    var_0 maps\mp\gametypes\_persistence::statSetChild( "round", "loss", 0 );
}

updateLossStats( var_0 )
{
    if ( !var_0 maps\mp\_utility::rankingEnabled() )
        return;

    if ( !isdefined( var_0.hasdoneanycombat ) || !var_0.hasdoneanycombat )
        return;

    var_0 maps\mp\gametypes\_persistence::statAdd( "losses", 1 );
    var_0 maps\mp\_utility::updatePersRatio( "winLossRatio", "wins", "losses" );
    var_0 maps\mp\gametypes\_persistence::statSetChild( "round", "loss", 1 );
}

updateTieStats( var_0 )
{
    if ( !var_0 maps\mp\_utility::rankingEnabled() )
        return;

    if ( !isdefined( var_0.hasdoneanycombat ) || !var_0.hasdoneanycombat )
        return;

    var_0 maps\mp\gametypes\_persistence::statAdd( "losses", -1 );
    var_0 maps\mp\gametypes\_persistence::statAdd( "ties", 1 );
    var_0 maps\mp\_utility::updatePersRatio( "winLossRatio", "wins", "losses" );
    var_0 maps\mp\gametypes\_persistence::statSet( "currentWinStreak", 0 );
}

updateWinLossStats( var_0 )
{
    if ( maps\mp\_utility::privateMatch() )
        return;

    if ( !maps\mp\_utility::wasLastRound() )
        return;

    var_1 = level.players;

    if ( !isdefined( var_0 ) || isdefined( var_0 ) && isstring( var_0 ) && var_0 == "tie" )
    {
        foreach ( var_3 in level.players )
        {
            if ( isdefined( var_3.connectedPostGame ) )
                continue;

            if ( level.hostForcedEnd && var_3 ishost() )
            {
                var_3 maps\mp\gametypes\_persistence::statSet( "currentWinStreak", 0 );
                continue;
            }

            updateTieStats( var_3 );
        }
    }
    else if ( isplayer( var_0 ) )
    {
        if ( level.hostForcedEnd && var_0 ishost() )
        {
            var_0 maps\mp\gametypes\_persistence::statSet( "currentWinStreak", 0 );
            return;
        }

        updateWinStats( var_0 );
    }
    else if ( isstring( var_0 ) )
    {
        foreach ( var_3 in level.players )
        {
            if ( isdefined( var_3.connectedPostGame ) )
                continue;

            if ( level.hostForcedEnd && var_3 ishost() )
            {
                var_3 maps\mp\gametypes\_persistence::statSet( "currentWinStreak", 0 );
                continue;
            }

            if ( var_0 == "tie" )
            {
                updateTieStats( var_3 );
                continue;
            }

            if ( var_3.pers["team"] == var_0 )
            {
                updateWinStats( var_3 );
                continue;
            }

            var_3 maps\mp\gametypes\_persistence::statSet( "currentWinStreak", 0 );
        }
    }
}

freezePlayerForRoundEnd( var_0 )
{
    self endon( "disconnect" );
    maps\mp\_utility::clearLowerMessages();

    if ( !isdefined( var_0 ) )
        var_0 = 0.05;

    self closepopupmenu();
    self closeingamemenu();
    wait(var_0);
    maps\mp\_utility::freezeControlsWrapper( 1 );
}

updateMatchBonusScores( var_0 )
{
    if ( !game["timePassed"] )
        return;

    if ( !maps\mp\_utility::matchMakingGame() )
        return;

    if ( !maps\mp\_utility::getTimeLimit() || level.forcedEnd )
    {
        var_1 = maps\mp\_utility::getTimePassed() / 1000;
        var_1 = min( var_1, 1200 );
    }
    else
        var_1 = maps\mp\_utility::getTimeLimit() * 60;

    if ( level.teamBased )
    {
        if ( var_0 == "allies" )
        {
            var_2 = "allies";
            var_3 = "axis";
        }
        else if ( var_0 == "axis" )
        {
            var_2 = "axis";
            var_3 = "allies";
        }
        else
        {
            var_2 = "tie";
            var_3 = "tie";
        }

        if ( var_2 != "tie" )
        {
            var_4 = maps\mp\gametypes\_rank::getScoreInfoValue( "win" );
            var_5 = maps\mp\gametypes\_rank::getScoreInfoValue( "loss" );
            setwinningteam( var_2 );
        }
        else
        {
            var_4 = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
            var_5 = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
        }

        foreach ( var_7 in level.players )
        {
            if ( isdefined( var_7.connectedPostGame ) )
                continue;

            if ( !var_7 maps\mp\_utility::rankingEnabled() )
                continue;

            if ( var_7.timePlayed["total"] < 1 || var_7.pers["participation"] < 1 )
            {
                var_7 thread maps\mp\gametypes\_rank::endGameUpdate();
                continue;
            }

            if ( level.hostForcedEnd && var_7 ishost() )
                continue;

            if ( !isdefined( var_7.hasdoneanycombat ) || !var_7.hasdoneanycombat )
                continue;

            var_8 = var_7 maps\mp\gametypes\_rank::getSPM();

            if ( var_2 == "tie" )
            {
                var_9 = int( var_4 * ( var_1 / 60 * var_8 ) * var_7.timePlayed["total"] / var_1 );
                var_7 thread giveMatchBonus( "tie", var_9 );
                var_7.matchBonus = var_9;
                continue;
            }

            if ( isdefined( var_7.pers["team"] ) && var_7.pers["team"] == var_2 )
            {
                var_9 = int( var_4 * ( var_1 / 60 * var_8 ) * var_7.timePlayed["total"] / var_1 );
                var_7 thread giveMatchBonus( "win", var_9 );
                var_7.matchBonus = var_9;
                continue;
            }

            if ( isdefined( var_7.pers["team"] ) && var_7.pers["team"] == var_3 )
            {
                var_9 = int( var_5 * ( var_1 / 60 * var_8 ) * var_7.timePlayed["total"] / var_1 );
                var_7 thread giveMatchBonus( "loss", var_9 );
                var_7.matchBonus = var_9;
            }
        }
    }
    else
    {
        if ( isdefined( var_0 ) )
        {
            var_4 = maps\mp\gametypes\_rank::getScoreInfoValue( "win" );
            var_5 = maps\mp\gametypes\_rank::getScoreInfoValue( "loss" );
        }
        else
        {
            var_4 = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
            var_5 = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
        }

        foreach ( var_7 in level.players )
        {
            if ( isdefined( var_7.connectedPostGame ) )
                continue;

            if ( var_7.timePlayed["total"] < 1 || var_7.pers["participation"] < 1 )
            {
                var_7 thread maps\mp\gametypes\_rank::endGameUpdate();
                continue;
            }

            if ( !isdefined( var_7.hasdoneanycombat ) || !var_7.hasdoneanycombat )
                continue;

            var_8 = var_7 maps\mp\gametypes\_rank::getSPM();
            var_12 = 0;

            for ( var_13 = 0; var_13 < min( level.placement["all"].size, 3 ); var_13++ )
            {
                if ( level.placement["all"][var_13] != var_7 )
                    continue;

                var_12 = 1;
            }

            if ( var_12 )
            {
                var_9 = int( var_4 * ( var_1 / 60 * var_8 ) * var_7.timePlayed["total"] / var_1 );
                var_7 thread giveMatchBonus( "win", var_9 );
                var_7.matchBonus = var_9;
                continue;
            }

            var_9 = int( var_5 * ( var_1 / 60 * var_8 ) * var_7.timePlayed["total"] / var_1 );
            var_7 thread giveMatchBonus( "loss", var_9 );
            var_7.matchBonus = var_9;
        }
    }
}

giveMatchBonus( var_0, var_1 )
{
    self endon( "disconnect" );
    level waittill( "give_match_bonus" );
    maps\mp\gametypes\_rank::giveRankXP( var_0, var_1 );
    maps\mp\gametypes\_rank::endGameUpdate();
}

setXenonRanks( var_0 )
{
    var_1 = level.players;

    for ( var_2 = 0; var_2 < var_1.size; var_2++ )
    {
        var_3 = var_1[var_2];

        if ( !isdefined( var_3.score ) || !isdefined( var_3.pers["team"] ) )
            continue;
    }

    for ( var_2 = 0; var_2 < var_1.size; var_2++ )
    {
        var_3 = var_1[var_2];

        if ( !isdefined( var_3.score ) || !isdefined( var_3.pers["team"] ) )
            continue;

        setplayerteamrank( var_3, var_3.clientid, var_3.score - 5 * var_3.deaths );
    }
}

checkTimeLimit( var_0 )
{
    if ( isdefined( level.timeLimitOverride ) && level.timeLimitOverride )
        return;

    if ( game["state"] != "playing" )
    {
        setgameendtime( 0 );
        return;
    }

    if ( maps\mp\_utility::getTimeLimit() <= 0 )
    {
        if ( isdefined( level.startTime ) )
            setgameendtime( level.startTime );
        else
            setgameendtime( 0 );

        return;
    }

    if ( !maps\mp\_utility::gameFlag( "prematch_done" ) )
    {
        setgameendtime( 0 );
        return;
    }

    if ( !isdefined( level.startTime ) )
        return;

    var_1 = getTimeRemaining();
    setgameendtime( gettime() + int( var_1 ) );

    if ( var_1 > 0 )
    {
        if ( maps\mp\_utility::getHalfTime() && checkHalfTime( var_0 ) )
            [[ level.onHalfTime ]]();

        return;
    }

    [[ level.onTimeLimit ]]();
}

checkHalfTime( var_0 )
{
    if ( !level.teamBased )
        return 0;

    if ( maps\mp\_utility::getTimeLimit() )
    {
        var_1 = maps\mp\_utility::getTimeLimit() * 60 * 1000 * 0.5;

        if ( maps\mp\_utility::getTimePassed() >= var_1 && var_0 < var_1 && var_0 > 0 )
        {
            game["roundMillisecondsAlreadyPassed"] = maps\mp\_utility::getTimePassed();
            return 1;
        }
    }

    return 0;
}

getTimeRemaining()
{
    return maps\mp\_utility::getTimeLimit() * 60 * 1000 - maps\mp\_utility::getTimePassed();
}

checkTeamScoreLimitSoon( var_0 )
{
    if ( maps\mp\_utility::getWatchedDvar( "scorelimit" ) <= 0 || maps\mp\_utility::isObjectiveBased() )
        return;

    if ( isdefined( level.scoreLimitOverride ) && level.scoreLimitOverride )
        return;

    if ( level.gameType == "conf" || level.gameType == "jugg" )
        return;

    if ( !level.teamBased )
        return;

    if ( maps\mp\_utility::getTimePassed() < 60000 )
        return;

    var_1 = estimatedTimeTillScoreLimit( var_0 );

    if ( var_1 < 2 )
        level notify( "match_ending_soon",  "score"  );
}

checkPlayerScoreLimitSoon()
{
    if ( maps\mp\_utility::getWatchedDvar( "scorelimit" ) <= 0 || maps\mp\_utility::isObjectiveBased() )
        return;

    if ( level.teamBased )
        return;

    if ( maps\mp\_utility::getTimePassed() < 60000 )
        return;

    var_0 = estimatedTimeTillScoreLimit();

    if ( var_0 < 2 )
        level notify( "match_ending_soon",  "score"  );
}

checkScoreLimit()
{
    if ( maps\mp\_utility::isObjectiveBased() )
        return 0;

    if ( isdefined( level.scoreLimitOverride ) && level.scoreLimitOverride )
        return 0;

    if ( game["state"] != "playing" )
        return 0;

    if ( maps\mp\_utility::getWatchedDvar( "scorelimit" ) <= 0 )
        return 0;

    if ( level.teamBased )
    {
        if ( game["teamScores"]["allies"] < maps\mp\_utility::getWatchedDvar( "scorelimit" ) && game["teamScores"]["axis"] < maps\mp\_utility::getWatchedDvar( "scorelimit" ) )
            return 0;
    }
    else
    {
        if ( !isplayer( self ) )
            return 0;

        if ( self.score < maps\mp\_utility::getWatchedDvar( "scorelimit" ) )
            return 0;
    }

    return onScoreLimit();
}

updateGametypeDvars()
{
    level endon( "game_ended" );

    while ( game["state"] == "playing" )
    {
        if ( isdefined( level.startTime ) )
        {
            if ( getTimeRemaining() < 3000 )
            {
                wait 0.1;
                continue;
            }
        }

        wait 1;
    }
}

matchStartTimerPC()
{
    // Plutonium change: allow gametype scripts to cancel the "waiting_for_teams"
    // timer for games where this makes no sense
    if (!isDefined(level.prematchWaitForTeams) || level.prematchWaitForTeams)
    {
        thread matchStartTimer( "waiting_for_teams", level.prematchPeriod + level.prematchPeriodEnd );
        waitForPlayers( level.prematchPeriod );
    }

    if ( level.prematchPeriodEnd > 0 )
        matchStartTimer( "match_starting_in", level.prematchPeriodEnd );
}

matchStartTimer_Internal( var_0, var_1 )
{
    waittillframeend;
    visionsetnaked( "mpIntro", 0 );
    level endon( "match_start_timer_beginning" );

    while ( var_0 > 0 && !level.gameEnded )
    {
        var_1 thread maps\mp\gametypes\_hud::fontPulse( level );
        wait(var_1.inFrames * 0.05);
        var_1 setvalue( var_0 );

        if ( var_0 == 0 )
            visionsetnaked( "", 0 );

        var_0--;
        wait(1 - var_1.inFrames * 0.05);
    }
}

matchStartTimer( var_0, var_1 )
{
    level notify( "match_start_timer_beginning" );
    var_2 = maps\mp\gametypes\_hud_util::createServerFontString( "objective", 1.5 );
    var_2 maps\mp\gametypes\_hud_util::setPoint( "CENTER", "CENTER", 0, -40 );
    var_2.sort = 1001;
    var_2 settext( game["strings"]["waiting_for_teams"] );
    var_2.foreground = 0;
    var_2.hidewheninmenu = 1;
    var_2 settext( game["strings"][var_0] );
    var_3 = maps\mp\gametypes\_hud_util::createServerFontString( "hudbig", 1 );
    var_3 maps\mp\gametypes\_hud_util::setPoint( "CENTER", "CENTER", 0, 0 );
    var_3.sort = 1001;
    var_3.color = ( 1, 1, 0 );
    var_3.foreground = 0;
    var_3.hidewheninmenu = 1;
    var_3 maps\mp\gametypes\_hud::fontPulseInit();
    var_4 = int( var_1 );

    if ( var_4 >= 2 )
    {
        matchStartTimer_Internal( var_4, var_3 );
        visionsetnaked( "", 3.0 );
    }
    else
    {
        visionsetnaked( "mpIntro", 0 );
        visionsetnaked( "", 1.0 );
    }

    var_3 maps\mp\gametypes\_hud_util::destroyElem();
    var_2 maps\mp\gametypes\_hud_util::destroyElem();
}

matchStartTimerSkip()
{
    visionsetnaked( "", 0 );
}

onRoundSwitch()
{
    if ( !isdefined( game["switchedsides"] ) )
        game["switchedsides"] = 0;

    if ( game["roundsWon"]["allies"] == maps\mp\_utility::getWatchedDvar( "winlimit" ) - 1 && game["roundsWon"]["axis"] == maps\mp\_utility::getWatchedDvar( "winlimit" ) - 1 )
    {
        var_0 = getBetterTeam();

        if ( var_0 != game["defenders"] )
            game["switchedsides"] = !game["switchedsides"];
        else
            level.halftimeSubCaption = "";

        level.halftimeType = "overtime";
    }
    else
    {
        level.halftimeType = "halftime";
        game["switchedsides"] = !game["switchedsides"];
    }
}

checkRoundSwitch()
{
    if ( !level.teamBased )
        return 0;

    if ( !isdefined( level.roundSwitch ) || !level.roundSwitch )
        return 0;

    if ( game["roundsPlayed"] % level.roundSwitch == 0 )
    {
        onRoundSwitch();
        return 1;
    }

    return 0;
}

timeUntilRoundEnd()
{
    if ( level.gameEnded )
    {
        var_0 = ( gettime() - level.gameEndTime ) / 1000;
        var_1 = level.postRoundTime - var_0;

        if ( var_1 < 0 )
            return 0;

        return var_1;
    }

    if ( maps\mp\_utility::getTimeLimit() <= 0 )
        return undefined;

    if ( !isdefined( level.startTime ) )
        return undefined;

    var_2 = maps\mp\_utility::getTimeLimit();
    var_0 = ( gettime() - level.startTime ) / 1000;
    var_1 = maps\mp\_utility::getTimeLimit() * 60 - var_0;

    if ( isdefined( level.timePaused ) )
        var_1 += level.timePaused;

    return var_1 + level.postRoundTime;
}

freeGameplayHudElems()
{
    if ( isdefined( self.perkicon ) )
    {
        if ( isdefined( self.perkicon[0] ) )
        {
            self.perkicon[0] maps\mp\gametypes\_hud_util::destroyElem();
            self.perkname[0] maps\mp\gametypes\_hud_util::destroyElem();
        }

        if ( isdefined( self.perkicon[1] ) )
        {
            self.perkicon[1] maps\mp\gametypes\_hud_util::destroyElem();
            self.perkname[1] maps\mp\gametypes\_hud_util::destroyElem();
        }

        if ( isdefined( self.perkicon[2] ) )
        {
            self.perkicon[2] maps\mp\gametypes\_hud_util::destroyElem();
            self.perkname[2] maps\mp\gametypes\_hud_util::destroyElem();
        }
    }

    self notify( "perks_hidden" );
    self.lowerMessage maps\mp\gametypes\_hud_util::destroyElem();
    self.lowerTimer maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( self.proxBar ) )
        self.proxBar maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( self.proxBarText ) )
        self.proxBarText maps\mp\gametypes\_hud_util::destroyElem();
}

getHostPlayer()
{
    var_0 = getentarray( "player", "classname" );

    for ( var_1 = 0; var_1 < var_0.size; var_1++ )
    {
        if ( var_0[var_1] ishost() )
            return var_0[var_1];
    }
}

hostIdledOut()
{
    var_0 = getHostPlayer();

    if ( isdefined( var_0 ) && !var_0.hasSpawned && !isdefined( var_0.selectedClass ) )
        return 1;

    return 0;
}

roundEndWait( var_0, var_1 )
{
    var_2 = 0;

    while ( !var_2 )
    {
        var_3 = level.players;
        var_2 = 1;

        foreach ( var_5 in var_3 )
        {
            if ( !isdefined( var_5.doingSplash ) )
                continue;

            if ( !var_5 maps\mp\gametypes\_hud_message::isDoingSplash() )
                continue;

            var_2 = 0;
        }

        wait 0.5;
    }

    if ( !var_1 )
    {
        wait(var_0);
        level notify( "round_end_finished" );
        return;
    }

    wait(var_0 / 2);
    level notify( "give_match_bonus" );
    wait(var_0 / 2);
    var_2 = 0;

    while ( !var_2 )
    {
        var_3 = level.players;
        var_2 = 1;

        foreach ( var_5 in var_3 )
        {
            if ( !isdefined( var_5.doingSplash ) )
                continue;

            if ( !var_5 maps\mp\gametypes\_hud_message::isDoingSplash() )
                continue;

            var_2 = 0;
        }

        wait 0.5;
    }

    level notify( "round_end_finished" );
}

roundEndDoF( var_0 )
{
    self setdepthoffield( 0, 128, 512, 4000, 6, 1.8 );
}

fixbootlegbrush()
{
    var_0 = spawn( "script_model", ( -297, -1356.3, 159.2 ) );
    var_0.angles = ( 270, 102, 0 );
    var_0 setmodel( "me_chainlink_fence_pole" );
    var_1 = spawn( "script_model", ( -277.8, -1444.8, 70 ) );
    var_1.angles = ( 0, 0, 0 );
    var_1 setmodel( "me_chainlink_fence_pole" );
    var_2 = spawn( "script_model", ( -267.7, -1526.8, 159.5 ) );
    var_2.angles = ( 296, 97, -180 );
    var_2 setmodel( "me_chainlink_fence_pole" );
    var_3 = spawn( "script_model", ( -273.2, -1480.3, 159.1 ) );
    var_3.angles = ( 270, 97, 0 );
    var_3 setmodel( "me_chainlink_fence_pole" );
    var_4 = spawn( "script_model", ( -266.7, -1534.8, 159.1 ) );
    var_4.angles = ( 270, 277, 0 );
    var_4 setmodel( "me_chainlink_fence_pole" );
    var_5 = spawn( "script_model", ( -158.7, -1479.5, 159.2 ) );
    var_5.angles = ( 270, 90, 0 );
    var_5 setmodel( "me_chainlink_fence_pole" );
    var_6 = spawn( "script_model", ( -158.8, -1535.5, 159.2 ) );
    var_6.angles = ( 270, 270, 0 );
    var_6 setmodel( "me_chainlink_fence_pole" );
    var_7 = spawn( "script_model", ( -158.8, -1525.8, 159.5 ) );
    var_7.angles = ( 296, 90, -180 );
    var_7 setmodel( "me_chainlink_fence_pole" );
    var_8 = spawn( "script_model", ( -158.8, -1444.3, 70 ) );
    var_8.angles = ( 0, 0, 0 );
    var_8 setmodel( "me_chainlink_fence_pole" );
    var_9 = spawn( "script_model", ( -249.5, -1444.7, 159.2 ) );
    var_9.angles = ( 270, 180, 0 );
    var_9 setmodel( "me_chainlink_fence_pole" );
    var_10 = spawn( "script_model", ( -185, -1444.8, 159.2 ) );
    var_10.angles = ( 270, 360, 0 );
    var_10 setmodel( "me_chainlink_fence_pole" );
    var_11 = spawn( "script_model", ( -172, -1570.5, 159 ) );
    var_11.angles = ( 270, 361, 0 );
    var_11 setmodel( "me_chainlink_fence_pole" );
    var_12 = spawn( "script_model", ( -248.5, -1572, 159 ) );
    var_12.angles = ( 270, 181, 0 );
    var_12 setmodel( "me_chainlink_fence_pole" );
    var_13 = spawn( "script_model", ( -200, -1511, 161.5 ) );
    var_13.angles = ( 0, 181, -90 );
    var_13 setmodel( "me_corrugated_metal8x8" );
    var_14 = spawn( "script_model", ( -229.5, -1510.5, 161 ) );
    var_14.angles = ( 0, 181, -90 );
    var_14 setmodel( "me_corrugated_metal8x8" );
}

fixranktable()
{
    var_0 = 11;
    var_1 = 0;

    for ( var_0 = 11; var_0 <= level.maxPrestige; var_0++ )
    {
        for ( var_1 = 0; var_1 <= level.maxRank; var_1++ )
            precacheshader( tablelookup( "mp/rankIconTable.csv", 0, var_1, var_0 + 1 ) );
    }
}

Callback_StartGameType()
{
    maps\mp\_load::main();
    maps\mp\_utility::levelFlagInit( "round_over", 0 );
    maps\mp\_utility::levelFlagInit( "game_over", 0 );
    maps\mp\_utility::levelFlagInit( "block_notifies", 0 );
    level.prematchPeriod = 0;
    level.prematchPeriodEnd = 0;
    level.postGameNotifies = 0;
    level.intermission = 0;
    makedvarserverinfo( "cg_thirdPersonAngle", 356 );
    makedvarserverinfo( "scr_gameended", 0 );

    if ( !isdefined( game["gamestarted"] ) )
    {
        game["clientid"] = 0;
        var_0 = getmapcustom( "allieschar" );

        if ( !isdefined( var_0 ) || var_0 == "" )
        {
            if ( !isdefined( game["allies"] ) )
                var_0 = "sas_urban";
            else
                var_0 = game["allies"];
        }

        var_1 = getmapcustom( "axischar" );

        if ( !isdefined( var_1 ) || var_1 == "" )
        {
            if ( !isdefined( game["axis"] ) )
                var_1 = "opforce_henchmen";
            else
                var_1 = game["axis"];
        }

        game["allies"] = var_0;
        game["axis"] = var_1;

        if ( !isdefined( game["attackers"] ) || !isdefined( game["defenders"] ) )
            thread common_scripts\utility::error( "No attackers or defenders team defined in level .gsc." );

        if ( !isdefined( game["attackers"] ) )
            game["attackers"] = "allies";

        if ( !isdefined( game["defenders"] ) )
            game["defenders"] = "axis";

        if ( !isdefined( game["state"] ) )
            game["state"] = "playing";

        precachestatusicon( "hud_status_dead" );
        precachestatusicon( "hud_status_connecting" );
        precachestring( &"MPUI_REVIVING" );
        precachestring( &"MPUI_BEING_REVIVED" );
        precacherumble( "damage_heavy" );
        precacheshader( "white" );
        precacheshader( "black" );
        game["strings"]["press_to_spawn"] = &"PLATFORM_PRESS_TO_SPAWN";

        if ( level.teamBased )
        {
            game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_TEAMS";
            game["strings"]["opponent_forfeiting_in"] = &"MP_OPPONENT_FORFEITING_IN";
        }
        else
        {
            game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_MORE_PLAYERS";
            game["strings"]["opponent_forfeiting_in"] = &"MP_OPPONENT_FORFEITING_IN";
        }

        game["strings"]["match_starting_in"] = &"MP_MATCH_STARTING_IN";
        game["strings"]["match_resuming_in"] = &"MP_MATCH_RESUMING_IN";
        game["strings"]["waiting_for_players"] = &"MP_WAITING_FOR_PLAYERS";
        game["strings"]["spawn_next_round"] = &"MP_SPAWN_NEXT_ROUND";
        game["strings"]["waiting_to_spawn"] = &"MP_WAITING_TO_SPAWN";
        game["strings"]["waiting_to_safespawn"] = &"MP_WAITING_TO_SAFESPAWN";
        game["strings"]["match_starting"] = &"MP_MATCH_STARTING";
        game["strings"]["change_class"] = &"MP_CHANGE_CLASS_NEXT_SPAWN";
        game["strings"]["last_stand"] = &"MPUI_LAST_STAND";
        game["strings"]["final_stand"] = &"MPUI_FINAL_STAND";
        game["strings"]["c4_death"] = &"MPUI_C4_DEATH";
        game["strings"]["cowards_way"] = &"PLATFORM_COWARDS_WAY_OUT";
        game["strings"]["tie"] = &"MP_MATCH_TIE";
        game["strings"]["round_draw"] = &"MP_ROUND_DRAW";
        game["strings"]["grabbed_flag"] = &"MP_GRABBED_FLAG_FIRST";
        game["strings"]["enemies_eliminated"] = &"MP_ENEMIES_ELIMINATED";
        game["strings"]["score_limit_reached"] = &"MP_SCORE_LIMIT_REACHED";
        game["strings"]["round_limit_reached"] = &"MP_ROUND_LIMIT_REACHED";
        game["strings"]["time_limit_reached"] = &"MP_TIME_LIMIT_REACHED";
        game["strings"]["players_forfeited"] = &"MP_PLAYERS_FORFEITED";
        game["strings"]["S.A.S Win"] = &"SAS_WIN";
        game["strings"]["Spetsnaz Win"] = &"SPETSNAZ_WIN";
        game["colors"]["blue"] = ( 0.25, 0.25, 0.75 );
        game["colors"]["red"] = ( 0.75, 0.25, 0.25 );
        game["colors"]["white"] = ( 1, 1, 1 );
        game["colors"]["black"] = ( 0, 0, 0 );
        game["colors"]["green"] = ( 0.25, 0.75, 0.25 );
        game["colors"]["yellow"] = ( 0.65, 0.65, 0 );
        game["colors"]["orange"] = ( 1, 0.45, 0 );
        game["strings"]["allies_eliminated"] = maps\mp\gametypes\_teams::getTeamEliminatedString( "allies" );
        game["strings"]["allies_forfeited"] = maps\mp\gametypes\_teams::getTeamForfeitedString( "allies" );
        game["strings"]["allies_name"] = maps\mp\gametypes\_teams::getTeamName( "allies" );
        game["icons"]["allies"] = maps\mp\gametypes\_teams::getTeamIcon( "allies" );
        game["colors"]["allies"] = maps\mp\gametypes\_teams::getTeamColor( "allies" );
        game["strings"]["axis_eliminated"] = maps\mp\gametypes\_teams::getTeamEliminatedString( "axis" );
        game["strings"]["axis_forfeited"] = maps\mp\gametypes\_teams::getTeamForfeitedString( "axis" );
        game["strings"]["axis_name"] = maps\mp\gametypes\_teams::getTeamName( "axis" );
        game["icons"]["axis"] = maps\mp\gametypes\_teams::getTeamIcon( "axis" );
        game["colors"]["axis"] = maps\mp\gametypes\_teams::getTeamColor( "axis" );

        if ( game["colors"]["allies"] == ( 0, 0, 0 ) )
            game["colors"]["allies"] = ( 0.5, 0.5, 0.5 );

        if ( game["colors"]["axis"] == ( 0, 0, 0 ) )
            game["colors"]["axis"] = ( 0.5, 0.5, 0.5 );

        [[ level.onPrecacheGameType ]]();

        if ( level.console )
        {
            if ( !level.splitscreen )
            {
                if ( getdvarint( "xblive_competitionmatch" ) && ( getdvarint( "systemlink" ) || !level.console && ( getdvar( "dedicated" ) == "dedicated LAN server" || getdvar( "dedicated" ) == "dedicated internet server" ) ) )
                    level.prematchPeriod = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "graceperiod_comp" );
                else
                    level.prematchPeriod = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "graceperiod" );
            }
        }
        else
        {
            if ( getdvarint( "xblive_competitionmatch" ) && ( getdvarint( "systemlink" ) || !level.console && ( getdvar( "dedicated" ) == "dedicated LAN server" || getdvar( "dedicated" ) == "dedicated internet server" ) ) )
                level.prematchPeriod = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "playerwaittime_comp" );
            else
                level.prematchPeriod = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "playerwaittime" );

            level.prematchPeriodEnd = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "matchstarttime" );
        }
    }
    else if ( level.console )
    {
        if ( !level.splitscreen )
            level.prematchPeriod = 5;
    }
    else
    {
        level.prematchPeriod = 5;
        level.prematchPeriodEnd = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "matchstarttime" );
    }

    if ( !isdefined( game["status"] ) )
        game["status"] = "normal";

    makedvarserverinfo( "ui_overtime", game["status"] == "overtime" );

    if ( game["status"] != "overtime" && game["status"] != "halftime" )
    {
        game["teamScores"]["allies"] = 0;
        game["teamScores"]["axis"] = 0;
    }

    if ( !isdefined( game["timePassed"] ) )
        game["timePassed"] = 0;

    if ( !isdefined( game["roundsPlayed"] ) )
        game["roundsPlayed"] = 0;

    if ( !isdefined( game["roundsWon"] ) )
        game["roundsWon"] = [];

    if ( level.teamBased )
    {
        if ( !isdefined( game["roundsWon"]["axis"] ) )
            game["roundsWon"]["axis"] = 0;

        if ( !isdefined( game["roundsWon"]["allies"] ) )
            game["roundsWon"]["allies"] = 0;
    }

    level.gameEnded = 0;
    level.forcedEnd = 0;
    level.hostForcedEnd = 0;
    level.hardcoreMode = getdvarint( "g_hardcore" );

    if ( level.hardcoreMode )
        logstring( "game mode: hardcore" );

    level.dieHardMode = getdvarint( "scr_diehard" );

    if ( !level.teamBased )
        level.dieHardMode = 0;

    if ( level.dieHardMode )
        logstring( "game mode: diehard" );

    level.killstreakRewards = getdvarint( "scr_game_hardpoints" );
    level.useStartSpawn = 1;
    level.objectivePointsMod = 1;

    if ( maps\mp\_utility::matchMakingGame() )
        level.maxAllowedTeamKills = 2;
    else
        level.maxAllowedTeamKills = -1;

    thread maps\mp\gametypes\_persistence::init();
    thread maps\mp\gametypes\_menus::init();
    thread maps\mp\gametypes\_hud::init();
    thread maps\mp\gametypes\_serversettings::init();
    thread maps\mp\gametypes\_teams::init();
    thread maps\mp\gametypes\_weapons::init();
    thread maps\mp\gametypes\_killcam::init();
    thread maps\mp\gametypes\_shellshock::init();
    thread maps\mp\gametypes\_deathicons::init();
    thread maps\mp\gametypes\_damagefeedback::init();
    thread maps\mp\gametypes\_healthoverlay::init();
    thread maps\mp\gametypes\_spectating::init();
    thread maps\mp\gametypes\_objpoints::init();
    thread maps\mp\gametypes\_gameobjects::init();
    thread maps\mp\gametypes\_spawnlogic::init();
    thread maps\mp\gametypes\_battlechatter_mp::init();
    thread maps\mp\gametypes\_music_and_dialog::init();
    thread maps\mp\_matchdata::init();
    thread maps\mp\_awards::init();
    thread maps\mp\_skill::init();
    thread maps\mp\_areas::init();
    thread maps\mp\killstreaks\_killstreaks::init();
    thread maps\mp\perks\_perks::init();
    thread maps\mp\_events::init();
    thread maps\mp\_defcon::init();
    thread maps\mp\_matchevents::init();
    thread maps\mp\gametypes\_damage::initFinalKillCam();

    if ( level.teamBased )
        thread maps\mp\gametypes\_friendicons::init();

    thread maps\mp\gametypes\_hud_message::init();

    if ( !level.console )
        thread maps\mp\gametypes\_quickmessages::init();

    foreach ( var_3 in game["strings"] )
        precachestring( var_3 );

    foreach ( var_6 in game["icons"] )
        precacheshader( var_6 );

    game["gamestarted"] = 1;
    level.maxPlayerCount = 0;
    level.waveDelay["allies"] = 0;
    level.waveDelay["axis"] = 0;
    level.lastWave["allies"] = 0;
    level.lastWave["axis"] = 0;
    level.wavePlayerSpawnIndex["allies"] = 0;
    level.wavePlayerSpawnIndex["axis"] = 0;
    level.alivePlayers["allies"] = [];
    level.alivePlayers["axis"] = [];
    level.activePlayers = [];
    makedvarserverinfo( "ui_scorelimit", 0 );
    makedvarserverinfo( "ui_allow_classchange", getdvar( "ui_allow_classchange" ) );
    makedvarserverinfo( "ui_allow_teamchange", 1 );
    setdvar( "ui_allow_teamchange", 1 );

    if ( maps\mp\_utility::getGametypeNumLives() )
        setdvar( "g_deadChat", 0 );
    else
        setdvar( "g_deadChat", 1 );

    var_8 = getdvarint( "scr_" + level.gameType + "_waverespawndelay" );

    if ( var_8 )
    {
        level.waveDelay["allies"] = var_8;
        level.waveDelay["axis"] = var_8;
        level.lastWave["allies"] = 0;
        level.lastWave["axis"] = 0;
        level thread waveSpawnTimer();
    }

    maps\mp\_utility::gameFlagInit( "prematch_done", 0 );
    level.gracePeriod = 15;
    level.inGracePeriod = level.gracePeriod;
    maps\mp\_utility::gameFlagInit( "graceperiod_done", 0 );
    level.roundEndDelay = 4;
    level.halftimeRoundEndDelay = 4;
    level.noRagdollEnts = getentarray( "noragdoll", "targetname" );

    if ( level.teamBased )
    {
        maps\mp\gametypes\_gamescore::updateTeamScore( "axis" );
        maps\mp\gametypes\_gamescore::updateTeamScore( "allies" );
    }
    else
        thread maps\mp\gametypes\_gamescore::initialDMScoreUpdate();

    thread updateUIScoreLimit();
    level notify( "update_scorelimit" );
    [[ level.onStartGameType ]]();

    if ( !level.console && ( getdvar( "dedicated" ) == "dedicated LAN server" || getdvar( "dedicated" ) == "dedicated internet server" ) )
        thread verifydedicatedconfiguration();

    if ( level.script == "mp_bootleg" )
        fixbootlegbrush();

    fixranktable();
    thread startGame();
    level thread maps\mp\_utility::updateWatchedDvars();
    level thread timeLimitThread();
    level thread maps\mp\gametypes\_damage::doFinalKillcam();
}

Callback_CodeEndGame()
{
    endparty();

    if ( !level.gameEnded )
        level thread forceEnd();
}

verifydedicatedconfiguration()
{
    for (;;)
    {
        if ( level.rankedmatch )
            exitlevel( 0 );

        if ( !getdvarint( "xblive_privatematch" ) )
            exitlevel( 0 );

        if ( getdvar( "dedicated" ) != "dedicated LAN server" && getdvar( "dedicated" ) != "dedicated internet server" )
            exitlevel( 0 );

        wait 5;
    }
}

timeLimitThread()
{
    level endon( "game_ended" );
    var_0 = maps\mp\_utility::getTimePassed();

    while ( game["state"] == "playing" )
    {
        thread checkTimeLimit( var_0 );
        var_0 = maps\mp\_utility::getTimePassed();

        if ( isdefined( level.startTime ) )
        {
            if ( getTimeRemaining() < 3000 )
            {
                wait 0.1;
                continue;
            }
        }

        wait 1;
    }
}

updateUIScoreLimit()
{
    for (;;)
    {
        level common_scripts\utility::waittill_either( "update_scorelimit", "update_winlimit" );

        if ( !maps\mp\_utility::isRoundBased() || !maps\mp\_utility::isObjectiveBased() )
        {
            setdvar( "ui_scorelimit", maps\mp\_utility::getWatchedDvar( "scorelimit" ) );
            thread checkScoreLimit();
            continue;
        }

        setdvar( "ui_scorelimit", maps\mp\_utility::getWatchedDvar( "winlimit" ) );
    }
}

playTickingSound()
{
    self endon( "death" );
    self endon( "stop_ticking" );
    level endon( "game_ended" );
    var_0 = level.bombTimer;

    for (;;)
    {
        self playsound( "ui_mp_suitcasebomb_timer" );

        if ( var_0 > 10 )
        {
            var_0 -= 1;
            wait 1;
        }
        else if ( var_0 > 4 )
        {
            var_0 -= 0.5;
            wait 0.5;
        }
        else if ( var_0 > 1 )
        {
            var_0 -= 0.4;
            wait 0.4;
        }
        else
        {
            var_0 -= 0.3;
            wait 0.3;
        }

        maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
    }
}

stopTickingSound()
{
    self notify( "stop_ticking" );
}

timeLimitClock()
{
    level endon( "game_ended" );
    wait 0.05;
    var_0 = spawn( "script_origin", ( 0, 0, 0 ) );
    var_0 hide();

    while ( game["state"] == "playing" )
    {
        if ( !level.timerStopped && maps\mp\_utility::getTimeLimit() )
        {
            var_1 = getTimeRemaining() / 1000;
            var_2 = int( var_1 + 0.5 );

            if ( maps\mp\_utility::getHalfTime() && var_2 > maps\mp\_utility::getTimeLimit() * 60 * 0.5 )
                var_2 -= int( maps\mp\_utility::getTimeLimit() * 60 * 0.5 );

            if ( var_2 >= 30 && var_2 <= 60 )
                level notify( "match_ending_soon",  "time"  );

            if ( var_2 <= 10 || var_2 <= 30 && var_2 % 2 == 0 )
            {
                level notify( "match_ending_very_soon" );

                if ( var_2 == 0 )
                    break;

                var_0 playsound( "ui_mp_timer_countdown" );
            }

            if ( var_1 - floor( var_1 ) >= 0.05 )
                wait(var_1 - floor( var_1 ));
        }

        wait 1.0;
    }
}

gameTimer()
{
    level endon( "game_ended" );
    level waittill( "prematch_over" );
    level.startTime = gettime();
    level.discardTime = 0;

    if ( isdefined( game["roundMillisecondsAlreadyPassed"] ) )
    {
        level.startTime = level.startTime - game["roundMillisecondsAlreadyPassed"];
        game["roundMillisecondsAlreadyPassed"] = undefined;
    }

    var_0 = gettime();

    while ( game["state"] == "playing" )
    {
        if ( !level.timerStopped )
            game["timePassed"] += gettime() - var_0;

        var_0 = gettime();
        wait 1.0;
    }
}

UpdateTimerPausedness()
{
    var_0 = level.timerStoppedForGameMode || isdefined( level.hostMigrationTimer );

    if ( !maps\mp\_utility::gameFlag( "prematch_done" ) )
        var_0 = 0;

    if ( !level.timerStopped && var_0 )
    {
        level.timerStopped = 1;
        level.timerPauseTime = gettime();
    }
    else if ( level.timerStopped && !var_0 )
    {
        level.timerStopped = 0;
        level.discardTime = level.discardTime + gettime() - level.timerPauseTime;
    }
}

pauseTimer()
{
    level.timerStoppedForGameMode = 1;
    UpdateTimerPausedness();
}

resumeTimer()
{
    level.timerStoppedForGameMode = 0;
    UpdateTimerPausedness();
}

startGame()
{
    thread gameTimer();
    level.timerStopped = 0;
    level.timerStoppedForGameMode = 0;
    thread maps\mp\gametypes\_spawnlogic::spawnPerFrameUpdate();
    prematchPeriod();
    maps\mp\_utility::gameFlagSet( "prematch_done" );
    level notify( "prematch_over" );
    UpdateTimerPausedness();
    thread timeLimitClock();
    thread gracePeriod();
    thread maps\mp\gametypes\_missions::roundBegin();
}

waveSpawnTimer()
{
    level endon( "game_ended" );

    while ( game["state"] == "playing" )
    {
        var_0 = gettime();

        if ( var_0 - level.lastWave["allies"] > level.waveDelay["allies"] * 1000 )
        {
            level notify( "wave_respawn_allies" );
            level.lastWave["allies"] = var_0;
            level.wavePlayerSpawnIndex["allies"] = 0;
        }

        if ( var_0 - level.lastWave["axis"] > level.waveDelay["axis"] * 1000 )
        {
            level notify( "wave_respawn_axis" );
            level.lastWave["axis"] = var_0;
            level.wavePlayerSpawnIndex["axis"] = 0;
        }

        wait 0.05;
    }
}

getBetterTeam()
{
    var_0["allies"] = 0;
    var_0["axis"] = 0;
    var_1["allies"] = 0;
    var_1["axis"] = 0;

    foreach ( var_3 in level.players )
    {
        var_4 = var_3.pers["team"];

        if ( isdefined( var_4 ) && ( var_4 == "allies" || var_4 == "axis" ) )
        {
            var_0[var_4] += var_3.kills;
            var_1[var_4] += var_3.deaths;
        }
    }

    if ( var_0["allies"] > var_0["axis"] )
        return "allies";
    else if ( var_0["axis"] > var_0["allies"] )
        return "axis";

    if ( var_1["allies"] < var_1["axis"] )
        return "allies";
    else if ( var_1["axis"] < var_1["allies"] )
        return "axis";

    if ( randomint( 2 ) == 0 )
        return "allies";

    return "axis";
}

rankedMatchUpdates( var_0 )
{
    if ( maps\mp\_utility::matchMakingGame() )
    {
        setXenonRanks();

        if ( hostIdledOut() )
        {
            level.hostForcedEnd = 1;
            logstring( "host idled out" );
            endlobby();
        }

        updateMatchBonusScores( var_0 );
    }

    updateWinLossStats( var_0 );
}

displayRoundEnd( var_0, var_1 )
{
    foreach ( var_3 in level.players )
    {
        if ( isdefined( var_3.connectedPostGame ) || var_3.pers["team"] == "spectator" )
            continue;

        if ( level.teamBased )
        {
            var_3 thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( var_0, 1, var_1 );
            continue;
        }

        var_3 thread maps\mp\gametypes\_hud_message::outcomeNotify( var_0, var_1 );
    }

    if ( !maps\mp\_utility::wasLastRound() )
        level notify( "round_win",  var_0  );

    if ( maps\mp\_utility::wasLastRound() )
        roundEndWait( level.roundEndDelay, 0 );
    else
        roundEndWait( level.roundEndDelay, 1 );
}

displayGameEnd( var_0, var_1 )
{
    foreach ( var_3 in level.players )
    {
        if ( isdefined( var_3.connectedPostGame ) || var_3.pers["team"] == "spectator" )
            continue;

        if ( level.teamBased )
        {
            var_3 thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( var_0, 0, var_1 );
            continue;
        }

        var_3 thread maps\mp\gametypes\_hud_message::outcomeNotify( var_0, var_1 );
    }

    level notify( "game_win",  var_0  );
    roundEndWait( level.postRoundTime, 1 );
}

displayRoundSwitch()
{
    var_0 = level.halftimeType;

    if ( var_0 == "halftime" )
    {
        if ( maps\mp\_utility::getWatchedDvar( "roundlimit" ) )
        {
            if ( game["roundsPlayed"] * 2 == maps\mp\_utility::getWatchedDvar( "roundlimit" ) )
                var_0 = "halftime";
            else
                var_0 = "intermission";
        }
        else if ( maps\mp\_utility::getWatchedDvar( "winlimit" ) )
        {
            if ( game["roundsPlayed"] == maps\mp\_utility::getWatchedDvar( "winlimit" ) - 1 )
                var_0 = "halftime";
            else
                var_0 = "intermission";
        }
        else
            var_0 = "intermission";
    }

    level notify( "round_switch",  var_0  );

    foreach ( var_2 in level.players )
    {
        if ( isdefined( var_2.connectedPostGame ) || var_2.pers["team"] == "spectator" )
            continue;

        var_2 thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( var_0, 1, level.halftimeSubCaption );
    }

    roundEndWait( level.halftimeRoundEndDelay, 0 );
}

endGameOvertime( var_0, var_1 )
{
    visionsetnaked( "mpOutro", 0.5 );
    setdvar( "scr_gameended", 3 );

    foreach ( var_3 in level.players )
    {
        var_3 thread freezePlayerForRoundEnd( 0 );
        var_3 thread roundEndDoF( 4.0 );
        var_3 freeGameplayHudElems();
        var_3 setclientdvars( "cg_everyoneHearsEveryone", 1 );
        var_3 setclientdvars( "cg_drawSpectatorMessages", 0, "g_compassShowEnemies", 0 );

        if ( var_3.pers["team"] == "spectator" )
            var_3 thread maps\mp\gametypes\_playerlogic::spawnIntermission();
    }

    level notify( "round_switch",  "overtime"  );

    foreach ( var_3 in level.players )
    {
        if ( isdefined( var_3.connectedPostGame ) || var_3.pers["team"] == "spectator" )
            continue;

        if ( level.teamBased )
        {
            var_3 thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( var_0, 0, var_1 );
            continue;
        }

        var_3 thread maps\mp\gametypes\_hud_message::outcomeNotify( var_0, var_1 );
    }

    roundEndWait( level.roundEndDelay, 0 );

    if ( isdefined( level.finalKillCam_winner ) )
    {
        level.finalKillCam_timeGameEnded[level.finalKillCam_winner] = maps\mp\_utility::getSecondsPassed();

        foreach ( var_3 in level.players )
            var_3 notify( "reset_outcome" );

        level notify( "game_cleanup" );
        waittillFinalKillcamDone();
    }

    game["status"] = "overtime";
    level notify( "restarting" );
    game["state"] = "playing";
    map_restart( 1 );
}

endGameHalfTime()
{
    visionsetnaked( "mpOutro", 0.5 );
    setdvar( "scr_gameended", 2 );
    game["switchedsides"] = !game["switchedsides"];

    foreach ( var_1 in level.players )
    {
        var_1 thread freezePlayerForRoundEnd( 0 );
        var_1 thread roundEndDoF( 4.0 );
        var_1 freeGameplayHudElems();
        var_1 setclientdvars( "cg_everyoneHearsEveryone", 1 );
        var_1 setclientdvars( "cg_drawSpectatorMessages", 0, "g_compassShowEnemies", 0 );

        if ( var_1.pers["team"] == "spectator" )
            var_1 thread maps\mp\gametypes\_playerlogic::spawnIntermission();
    }

    foreach ( var_1 in level.players )
        var_1.pers["stats"] = var_1.stats;

    level notify( "round_switch",  "halftime"  );

    foreach ( var_1 in level.players )
    {
        if ( isdefined( var_1.connectedPostGame ) || var_1.pers["team"] == "spectator" )
            continue;

        var_1 thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( "halftime", 1, level.halftimeSubCaption );
    }

    roundEndWait( level.roundEndDelay, 0 );

    if ( isdefined( level.finalKillCam_winner ) )
    {
        level.finalKillCam_timeGameEnded[level.finalKillCam_winner] = maps\mp\_utility::getSecondsPassed();

        foreach ( var_1 in level.players )
            var_1 notify( "reset_outcome" );

        level notify( "game_cleanup" );
        waittillFinalKillcamDone();
    }

    game["status"] = "halftime";
    level notify( "restarting" );
    game["state"] = "playing";
    map_restart( 1 );
}

endGame( var_0, var_1, var_2 )
{
    if ( !isdefined( var_2 ) )
        var_2 = 0;

    if ( game["state"] == "postgame" || level.gameEnded && ( !isdefined( level.gtnw ) || !level.gtnw ) )
        return;

    game["state"] = "postgame";
    level.gameEndTime = gettime();
    level.gameEnded = 1;
    level.inGracePeriod = 0;
    level notify( "game_ended",  var_0  );
    maps\mp\_utility::levelFlagSet( "game_over" );
    maps\mp\_utility::levelFlagSet( "block_notifies" );
    common_scripts\utility::waitframe();
    setgameendtime( 0 );
    var_3 = getmatchdata( "gameLength" );
    var_3 += int( maps\mp\_utility::getSecondsPassed() );
    setmatchdata( "gameLength", var_3 );
    maps\mp\gametypes\_playerlogic::printPredictedSpawnpointCorrectness();

    if ( isdefined( var_0 ) && isstring( var_0 ) && var_0 == "overtime" )
    {
        level.finalKillCam_winner = "none";
        endGameOvertime( var_0, var_1 );
        return;
    }

    if ( isdefined( var_0 ) && isstring( var_0 ) && var_0 == "halftime" )
    {
        level.finalKillCam_winner = "none";
        endGameHalfTime();
        return;
    }

    if ( isdefined( level.finalKillCam_winner ) )
        level.finalKillCam_timeGameEnded[level.finalKillCam_winner] = maps\mp\_utility::getSecondsPassed();

    game["roundsPlayed"]++;

    if ( level.teamBased )
    {
        if ( var_0 == "axis" || var_0 == "allies" )
            game["roundsWon"][var_0]++;

        maps\mp\gametypes\_gamescore::updateTeamScore( "axis" );
        maps\mp\gametypes\_gamescore::updateTeamScore( "allies" );
    }
    else if ( isdefined( var_0 ) && isplayer( var_0 ) )
        game["roundsWon"][var_0.guid]++;

    maps\mp\gametypes\_gamescore::updatePlacement();
    rankedMatchUpdates( var_0 );

    foreach ( var_5 in level.players )
    {
        var_5 setclientdvar( "ui_opensummary", 1 );

        if ( maps\mp\_utility::wasOnlyRound() || maps\mp\_utility::wasLastRound() )
            var_5 maps\mp\killstreaks\_killstreaks::clearKillstreaks();
    }

    setdvar( "g_deadChat", 1 );
    setdvar( "ui_allow_teamchange", 0 );

    foreach ( var_5 in level.players )
    {
        var_5 thread freezePlayerForRoundEnd( 1.0 );
        var_5 thread roundEndDoF( 4.0 );
        var_5 freeGameplayHudElems();
        var_5 setclientdvars( "cg_everyoneHearsEveryone", 1 );
        var_5 setclientdvars( "cg_drawSpectatorMessages", 0, "g_compassShowEnemies", 0, "cg_fovScale", 1 );

        if ( var_5.pers["team"] == "spectator" )
            var_5 thread maps\mp\gametypes\_playerlogic::spawnIntermission();
    }

    if ( !var_2 )
        visionsetnaked( "mpOutro", 0.5 );

    if ( !maps\mp\_utility::wasOnlyRound() && !var_2 )
    {
        setdvar( "scr_gameended", 2 );
        displayRoundEnd( var_0, var_1 );

        if ( isdefined( level.finalKillCam_winner ) )
        {
            foreach ( var_5 in level.players )
                var_5 notify( "reset_outcome" );

            level notify( "game_cleanup" );
            waittillFinalKillcamDone();
        }

        if ( !maps\mp\_utility::wasLastRound() )
        {
            maps\mp\_utility::levelFlagClear( "block_notifies" );

            if ( checkRoundSwitch() )
                displayRoundSwitch();

            foreach ( var_5 in level.players )
                var_5.pers["stats"] = var_5.stats;

            level notify( "restarting" );
            game["state"] = "playing";
            map_restart( 1 );
            return;
        }

        if ( !level.forcedEnd )
            var_1 = updateEndReasonText( var_0 );
    }

    if ( var_1 == game["strings"]["time_limit_reached"] )
        setdvar( "scr_gameended", 3 );
    else
    {
        switch ( level.gameType )
        {
            case "koth":
            case "sab":
            case "sd":
            case "dom":
            case "ctf":
            case "conf":
                setdvar( "scr_gameended", 4 );
                break;
            default:
                setdvar( "scr_gameended", 1 );
                break;
        }
    }

    if ( !isdefined( game["clientMatchDataDef"] ) )
    {
        game["clientMatchDataDef"] = "mp/clientmatchdata.def";
        setclientmatchdatadef( game["clientMatchDataDef"] );
    }

    maps\mp\gametypes\_missions::roundEnd( var_0 );
    displayGameEnd( var_0, var_1 );

    if ( isdefined( level.finalKillCam_winner ) && maps\mp\_utility::wasOnlyRound() )
    {
        foreach ( var_5 in level.players )
            var_5 notify( "reset_outcome" );

        level notify( "game_cleanup" );
        waittillFinalKillcamDone();
    }

    maps\mp\_utility::levelFlagClear( "block_notifies" );
    level.intermission = 1;
    level notify( "spawning_intermission" );

    foreach ( var_5 in level.players )
    {
        var_5 closepopupmenu();
        var_5 closeingamemenu();
        var_5 notify( "reset_outcome" );
        var_5 thread maps\mp\gametypes\_playerlogic::spawnIntermission();
    }

    processLobbyData();
    wait 1.0;
    checkForPersonalBests();

    if ( level.teamBased )
    {
        if ( var_0 == "axis" || var_0 == "allies" )
            setmatchdata( "victor", var_0 );
        else
            setmatchdata( "victor", "none" );

        setmatchdata( "alliesScore", getteamscore( "allies" ) );
        setmatchdata( "axisScore", getteamscore( "axis" ) );
    }
    else
        setmatchdata( "victor", "none" );

    setmatchdata( "host", level.sendMatchData );
    sendmatchdata();

    foreach ( var_5 in level.players )
        var_5.pers["stats"] = var_5.stats;

    if ( !var_2 && !level.postGameNotifies )
    {
        if ( !maps\mp\_utility::wasOnlyRound() )
            wait 6.0;
        else
            wait 3.0;
    }
    else
        wait(min( 10.0, 4.0 + level.postGameNotifies ));

    level notify( "exitLevel_called" );
    exitlevel( 0 );
}

updateEndReasonText( var_0 )
{
    if ( !level.teamBased )
        return 1;

    if ( maps\mp\_utility::hitRoundLimit() )
        return &"MP_ROUND_LIMIT_REACHED";

    if ( maps\mp\_utility::hitWinLimit() )
        return &"MP_SCORE_LIMIT_REACHED";

    if ( var_0 == "axis" )
        return &"SPETSNAZ_WIN";
    else
        return &"SAS_WIN";
}

estimatedTimeTillScoreLimit( var_0 )
{
    var_1 = getScorePerMinute( var_0 );
    var_2 = getScorePerRemaining( var_0 );
    var_3 = 999999;

    if ( var_1 )
        var_3 = var_2 / var_1;

    return var_3;
}

getScorePerMinute( var_0 )
{
    var_1 = maps\mp\_utility::getWatchedDvar( "scorelimit" );
    var_2 = maps\mp\_utility::getTimeLimit();
    var_3 = maps\mp\_utility::getTimePassed() / 60000 + 0.0001;

    if ( isplayer( self ) )
        var_4 = self.score / var_3;
    else
        var_4 = getteamscore( var_0 ) / var_3;

    return var_4;
}

getScorePerRemaining( var_0 )
{
    var_1 = maps\mp\_utility::getWatchedDvar( "scorelimit" );

    if ( isplayer( self ) )
        var_2 = var_1 - self.score;
    else
        var_2 = var_1 - getteamscore( var_0 );

    return var_2;
}

giveLastOnTeamWarning()
{
    self endon( "death" );
    self endon( "disconnect" );
    level endon( "game_ended" );
    maps\mp\_utility::waitTillRecoveredHealth( 3 );
    var_0 = maps\mp\_utility::getOtherTeam( self.pers["team"] );
    thread maps\mp\_utility::teamPlayerCardSplash( "callout_lastteammemberalive", self, self.pers["team"] );
    thread maps\mp\_utility::teamPlayerCardSplash( "callout_lastenemyalive", self, var_0 );
    level notify( "last_alive",  self  );
}

processLobbyData()
{
    var_0 = 0;

    foreach ( var_2 in level.players )
    {
        if ( !isdefined( var_2 ) )
            continue;

        var_2.clientMatchDataId = var_0;
        var_0++;

        if ( level.ps3 && var_2.name.size > level.MaxNameLength )
        {
            var_3 = "";

            for ( var_4 = 0; var_4 < level.MaxNameLength - 3; var_4++ )
                var_3 += var_2.name[var_4];

            var_3 += "...";
        }
        else
            var_3 = var_2.name;

        setclientmatchdata( "players", var_2.clientMatchDataId, "xuid", var_3 );
    }

    maps\mp\_awards::assignAwards();
    maps\mp\gametypes\_scoreboard::processLobbyScoreboards();
    sendclientmatchdata();
}

trackLeaderBoardDeathStats( var_0, var_1 )
{
    thread threadedSetWeaponStatByName( var_0, 1, "deaths" );
}

trackAttackerLeaderBoardDeathStats( var_0, var_1 )
{
    if ( isdefined( self ) && isplayer( self ) )
    {
        if ( var_1 != "MOD_FALLING" )
        {
            if ( var_1 == "MOD_MELEE" && issubstr( var_0, "tactical" ) )
            {
                maps\mp\_matchdata::logAttachmentStat( "tactical", "kills", 1 );
                maps\mp\_matchdata::logAttachmentStat( "tactical", "hits", 1 );
                maps\mp\gametypes\_persistence::incrementAttachmentStat( "tactical", "kills", 1 );
                maps\mp\gametypes\_persistence::incrementAttachmentStat( "tactical", "hits", 1 );
                return;
            }

            if ( var_1 == "MOD_MELEE" && !issubstr( var_0, "riotshield" ) )
            {
                maps\mp\_matchdata::logAttachmentStat( "none", "kills", 1 );
                maps\mp\_matchdata::logAttachmentStat( "none", "hits", 1 );
                maps\mp\gametypes\_persistence::incrementAttachmentStat( "none", "kills", 1 );
                maps\mp\gametypes\_persistence::incrementAttachmentStat( "none", "hits", 1 );
                return;
            }

            thread threadedSetWeaponStatByName( var_0, 1, "kills" );
        }

        if ( var_1 == "MOD_HEAD_SHOT" )
            thread threadedSetWeaponStatByName( var_0, 1, "headShots" );
    }
}

setWeaponStat( var_0, var_1, var_2 )
{
    if ( !var_1 )
        return;

    var_3 = maps\mp\_utility::getWeaponClass( var_0 );

    if ( maps\mp\_utility::isKillstreakWeapon( var_0 ) || var_3 == "killstreak" || var_3 == "deathstreak" || var_3 == "other" )
        return;

    if ( maps\mp\_utility::isEnvironmentWeapon( var_0 ) )
        return;

    if ( var_3 == "weapon_grenade" || var_3 == "weapon_riot" || var_3 == "weapon_explosive" )
    {
        var_4 = maps\mp\_utility::strip_suffix( var_0, "_mp" );
        maps\mp\gametypes\_persistence::incrementWeaponStat( var_4, var_2, var_1 );
        maps\mp\_matchdata::logWeaponStat( var_4, var_2, var_1 );
        return;
    }

    if ( var_2 != "deaths" && var_3 != "weapon_projectile" )
        var_0 = self getcurrentweapon();

    if ( maps\mp\_utility::isKillstreakWeapon( var_0 ) || var_3 == "killstreak" || var_3 == "deathstreak" || var_3 == "other" )
        return;

    if ( !isdefined( self.trackingWeaponName ) )
        self.trackingWeaponName = var_0;

    if ( var_0 != self.trackingWeaponName )
    {
        maps\mp\gametypes\_persistence::updateWeaponBufferedStats();
        self.trackingWeaponName = var_0;
    }

    switch ( var_2 )
    {
        case "shots":
            self.trackingWeaponShots++;
            break;
        case "hits":
            self.trackingWeaponHits++;
            break;
        case "headShots":
            self.trackingWeaponHeadShots++;
            self.trackingWeaponHits++;
            break;
        case "kills":
            self.trackingWeaponKills++;
            break;
    }

    if ( var_2 == "deaths" )
    {
        var_5 = var_0;
        var_6 = strtok( var_0, "_" );
        var_7 = undefined;

        if ( var_6[0] == "iw5" )
            var_4 = var_6[0] + "_" + var_6[1];
        else if ( var_6[0] == "alt" )
            var_4 = var_6[1] + "_" + var_6[2];
        else
            var_4 = var_6[0];

        if ( !maps\mp\_utility::isCACPrimaryWeapon( var_4 ) && !maps\mp\_utility::isCACSecondaryWeapon( var_4 ) )
            return;

        if ( var_6[0] == "alt" )
        {
            var_4 = var_6[1] + "_" + var_6[2];

            foreach ( var_9 in var_6 )
            {
                if ( var_9 == "gl" || var_9 == "gp25" || var_9 == "m320" )
                {
                    var_7 = "gl";
                    break;
                }

                if ( var_9 == "shotgun" )
                {
                    var_7 = "shotgun";
                    break;
                }
            }
        }

        if ( isdefined( var_7 ) && ( var_7 == "gl" || var_7 == "shotgun" ) )
        {
            maps\mp\gametypes\_persistence::incrementAttachmentStat( var_7, var_2, var_1 );
            maps\mp\_matchdata::logAttachmentStat( var_7, var_2, var_1 );
            return;
        }

        maps\mp\gametypes\_persistence::incrementWeaponStat( var_4, var_2, var_1 );
        maps\mp\_matchdata::logWeaponStat( var_4, "deaths", var_1 );

        if ( var_6[0] != "none" )
        {
            for ( var_11 = 0; var_11 < var_6.size; var_11++ )
            {
                if ( var_6[var_11] == "alt" )
                {
                    var_11 += 2;
                    continue;
                }

                if ( var_6[var_11] == "iw5" )
                {
                    var_11 += 1;
                    continue;
                }

                if ( var_6[var_11] == "mp" )
                    continue;

                if ( issubstr( var_6[var_11], "camo" ) )
                    continue;

                if ( issubstr( var_6[var_11], "scope" ) && !issubstr( var_6[var_11], "vz" ) )
                    continue;

                if ( issubstr( var_6[var_11], "scope" ) && issubstr( var_6[var_11], "vz" ) )
                    var_6[var_11] = "vzscope";

                var_6[var_11] = maps\mp\_utility::validateAttachment( var_6[var_11] );

                if ( var_11 == 0 && ( var_6[var_11] != "iw5" && var_6[var_11] != "alt" ) )
                    continue;

                maps\mp\gametypes\_persistence::incrementAttachmentStat( var_6[var_11], var_2, var_1 );
                maps\mp\_matchdata::logAttachmentStat( var_6[var_11], var_2, var_1 );
            }
        }
    }
}

setInflictorStat( var_0, var_1, var_2 )
{
    if ( !isdefined( var_1 ) )
        return;

    if ( !isdefined( var_0 ) )
    {
        var_1 setWeaponStat( var_2, 1, "hits" );
        return;
    }

    if ( !isdefined( var_0.playerAffectedArray ) )
        var_0.playerAffectedArray = [];

    var_3 = 1;

    for ( var_4 = 0; var_4 < var_0.playerAffectedArray.size; var_4++ )
    {
        if ( var_0.playerAffectedArray[var_4] == self )
        {
            var_3 = 0;
            break;
        }
    }

    if ( var_3 )
    {
        var_0.playerAffectedArray[var_0.playerAffectedArray.size] = self;
        var_1 setWeaponStat( var_2, 1, "hits" );
    }
}

threadedSetWeaponStatByName( var_0, var_1, var_2 )
{
    self endon( "disconnect" );
    waittillframeend;
    setWeaponStat( var_0, var_1, var_2 );
}

checkForPersonalBests()
{
    foreach ( var_1 in level.players )
    {
        if ( !isdefined( var_1 ) )
            continue;

        if ( var_1 maps\mp\_utility::rankingEnabled() )
        {
            var_2 = var_1 getplayerdata( "round", "kills" );
            var_3 = var_1 getplayerdata( "round", "deaths" );
            var_4 = var_1.pers["summary"]["xp"];
            var_5 = var_1 getplayerdata( "bestKills" );
            var_6 = var_1 getplayerdata( "mostDeaths" );
            var_7 = var_1 getplayerdata( "mostXp" );

            if ( var_2 > var_5 )
                var_1 setplayerdata( "bestKills", var_2 );

            if ( var_4 > var_7 )
                var_1 setplayerdata( "mostXp", var_4 );

            if ( var_3 > var_6 )
                var_1 setplayerdata( "mostDeaths", var_3 );

            var_1 checkForBestWeapon();
            var_1 maps\mp\_matchdata::logPlayerXP( var_4, "totalXp" );
            var_1 maps\mp\_matchdata::logPlayerXP( var_1.pers["summary"]["score"], "scoreXp" );
            var_1 maps\mp\_matchdata::logPlayerXP( var_1.pers["summary"]["challenge"], "challengeXp" );
            var_1 maps\mp\_matchdata::logPlayerXP( var_1.pers["summary"]["match"], "matchXp" );
            var_1 maps\mp\_matchdata::logPlayerXP( var_1.pers["summary"]["misc"], "miscXp" );
        }

        if ( isdefined( var_1.pers["confirmed"] ) )
            var_1 maps\mp\_matchdata::logKillsConfirmed();

        if ( isdefined( var_1.pers["denied"] ) )
            var_1 maps\mp\_matchdata::logKillsDenied();
    }
}

checkForBestWeapon()
{
    var_0 = maps\mp\_matchdata::buildBaseWeaponList();

    for ( var_1 = 0; var_1 < var_0.size; var_1++ )
    {
        var_2 = var_0[var_1];
        var_3 = strtok( var_2, "_" );

        if ( var_3[0] == "iw5" )
            var_2 = var_3[0] + "_" + var_3[1];

        if ( var_3[0] == "alt" )
            var_2 = var_3[1] + "_" + var_3[2];

        var_4 = maps\mp\_utility::getWeaponClass( var_2 );

        if ( !maps\mp\_utility::isKillstreakWeapon( var_2 ) && var_4 != "killstreak" && var_4 != "deathstreak" && var_4 != "other" )
        {
            var_5 = self getplayerdata( "bestWeapon", "kills" );
            var_6 = getmatchdata( "players", self.clientid, "weaponStats", var_2, "kills" );

            if ( var_6 > var_5 )
            {
                self setplayerdata( "bestWeapon", "kills", var_6 );
                var_7 = getmatchdata( "players", self.clientid, "weaponStats", var_2, "shots" );
                var_8 = getmatchdata( "players", self.clientid, "weaponStats", var_2, "headShots" );
                var_9 = getmatchdata( "players", self.clientid, "weaponStats", var_2, "hits" );
                var_10 = getmatchdata( "players", self.clientid, "weaponStats", var_2, "deaths" );
                var_11 = getmatchdata( "players", self.clientid, "weaponStats", var_2, "XP" );
                self setplayerdata( "bestWeapon", "shots", var_7 );
                self setplayerdata( "bestWeapon", "headShots", var_8 );
                self setplayerdata( "bestWeapon", "hits", var_9 );
                self setplayerdata( "bestWeapon", "deaths", var_10 );
                self setplayerdata( "bestWeaponXP", var_11 );
                self setplayerdata( "bestWeaponIndex", var_1 );
            }
        }
    }
}
