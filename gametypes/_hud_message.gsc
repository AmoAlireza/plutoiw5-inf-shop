// IW5 PC GSC
// Decompiled by https://github.com/xensik/gsc-tool

init()
{
    precachestring( &"MP_FIRSTPLACE_NAME" );
    precachestring( &"MP_SECONDPLACE_NAME" );
    precachestring( &"MP_THIRDPLACE_NAME" );
    precachestring( &"MP_MATCH_BONUS_IS" );
    precachemenu( "splash" );
    precachemenu( "challenge" );
    precachemenu( "defcon" );
    precachemenu( "killstreak" );
    precachemenu( "perk_display" );
    precachemenu( "perk_hide" );
    precachemenu( "killedby_card_display" );
    precachemenu( "killedby_card_hide" );
    precachemenu( "youkilled_card_display" );
    game["menu_endgameupdate"] = "endgameupdate";

    if ( level.splitscreen )
        game["menu_endgameupdate"] += "_splitscreen";

    precachemenu( game["menu_endgameupdate"] );
    game["strings"]["draw"] = &"MP_DRAW";
    game["strings"]["round_draw"] = &"MP_ROUND_DRAW";
    game["strings"]["round_win"] = &"MP_ROUND_WIN";
    game["strings"]["round_loss"] = &"MP_ROUND_LOSS";
    game["strings"]["victory"] = &"MP_VICTORY";
    game["strings"]["defeat"] = &"MP_DEFEAT";
    game["strings"]["halftime"] = &"MP_HALFTIME";
    game["strings"]["overtime"] = &"MP_OVERTIME";
    game["strings"]["roundend"] = &"MP_ROUNDEND";
    game["strings"]["intermission"] = &"MP_INTERMISSION";
    game["strings"]["side_switch"] = &"MP_SWITCHING_SIDES";
    game["strings"]["match_bonus"] = &"MP_MATCH_BONUS_IS";
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for (;;)
    {
        level waittill( "connected",  var_0  );
        var_0 thread hintMessageDeathThink();
        var_0 thread lowerMessageThink();
        var_0 thread initNotifyMessage();
    }
}

hintMessage( var_0 )
{
    var_1 = spawnstruct();
    var_1.notifyText = var_0;
    var_1.glowcolor = ( 0.3, 0.6, 0.3 );
    notifyMessage( var_1 );
}

initNotifyMessage()
{
    if ( level.splitscreen || self issplitscreenplayer() )
    {
        var_0 = 1.5;
        var_1 = 1.25;
        var_2 = 24;
        var_3 = "default";
        var_4 = "TOP";
        var_5 = "BOTTOM";
        var_6 = 0;
        var_7 = 0;
    }
    else
    {
        var_0 = 2.5;
        var_1 = 1.75;
        var_2 = 30;
        var_3 = "objective";
        var_4 = "TOP";
        var_5 = "BOTTOM";
        var_6 = 50;
        var_7 = 0;
    }

    self.notifyTitle = maps\mp\gametypes\_hud_util::createFontString( var_3, var_0 );
    self.notifyTitle maps\mp\gametypes\_hud_util::setPoint( var_4, undefined, var_7, var_6 );
    self.notifyTitle.glowcolor = ( 0.2, 0.3, 0.7 );
    self.notifyTitle.glowalpha = 1;
    self.notifyTitle.hidewheninmenu = 1;
    self.notifyTitle.archived = 0;
    self.notifyTitle.alpha = 0;
    self.notifyText = maps\mp\gametypes\_hud_util::createFontString( var_3, var_1 );
    self.notifyText maps\mp\gametypes\_hud_util::setParent( self.notifyTitle );
    self.notifyText maps\mp\gametypes\_hud_util::setPoint( var_4, var_5, 0, 0 );
    self.notifyText.glowcolor = ( 0.2, 0.3, 0.7 );
    self.notifyText.glowalpha = 1;
    self.notifyText.hidewheninmenu = 1;
    self.notifyText.archived = 0;
    self.notifyText.alpha = 0;
    self.notifyText2 = maps\mp\gametypes\_hud_util::createFontString( var_3, var_1 );
    self.notifyText2 maps\mp\gametypes\_hud_util::setParent( self.notifyTitle );
    self.notifyText2 maps\mp\gametypes\_hud_util::setPoint( var_4, var_5, 0, 0 );
    self.notifyText2.glowcolor = ( 0.2, 0.3, 0.7 );
    self.notifyText2.glowalpha = 1;
    self.notifyText2.hidewheninmenu = 1;
    self.notifyText2.archived = 0;
    self.notifyText2.alpha = 0;
    self.notifyIcon = maps\mp\gametypes\_hud_util::createIcon( "white", var_2, var_2 );
    self.notifyIcon maps\mp\gametypes\_hud_util::setParent( self.notifyText2 );
    self.notifyIcon maps\mp\gametypes\_hud_util::setPoint( var_4, var_5, 0, 0 );
    self.notifyIcon.hidewheninmenu = 1;
    self.notifyIcon.archived = 0;
    self.notifyIcon.alpha = 0;
    self.notifyOverlay = maps\mp\gametypes\_hud_util::createIcon( "white", var_2, var_2 );
    self.notifyOverlay maps\mp\gametypes\_hud_util::setParent( self.notifyIcon );
    self.notifyOverlay maps\mp\gametypes\_hud_util::setPoint( "CENTER", "CENTER", 0, 0 );
    self.notifyOverlay.hidewheninmenu = 1;
    self.notifyOverlay.archived = 0;
    self.notifyOverlay.alpha = 0;
    self.doingSplash = [];
    self.doingSplash[0] = undefined;
    self.doingSplash[1] = undefined;
    self.doingSplash[2] = undefined;
    self.doingSplash[3] = undefined;
    self.splashQueue = [];
    self.splashQueue[0] = [];
    self.splashQueue[1] = [];
    self.splashQueue[2] = [];
    self.splashQueue[3] = [];
}

oldNotifyMessage( var_0, var_1, var_2, var_3, var_4, var_5 )
{
    var_6 = spawnstruct();
    var_6.titleText = var_0;
    var_6.notifyText = var_1;
    var_6.iconName = var_2;
    var_6.glowcolor = var_3;
    var_6.sound = var_4;
    var_6.duration = var_5;
    notifyMessage( var_6 );
}

notifyMessage( var_0 )
{
    self endon( "death" );
    self endon( "disconnect" );

    if ( !isdefined( var_0.slot ) )
        var_0.slot = 0;

    var_1 = var_0.slot;

    if ( !isdefined( var_0.type ) )
        var_0.type = "";

    if ( !isdefined( self.doingSplash[var_1] ) )
    {
        thread showNotifyMessage( var_0 );
        return;
    }

    self.splashQueue[var_1][self.splashQueue[var_1].size] = var_0;
}

dispatchNotify( var_0 )
{
    var_1 = self.splashQueue[var_0][0];

    for ( var_2 = 1; var_2 < self.splashQueue[var_0].size; var_2++ )
        self.splashQueue[var_0][var_2 - 1] = self.splashQueue[var_0][var_2];

    self.splashQueue[var_0][var_2 - 1] = undefined;

    if ( isdefined( var_1.name ) )
        actionNotify( var_1 );
    else
        showNotifyMessage( var_1 );
}

promotionSplashNotify()
{
    self endon( "disconnect" );
    var_0 = spawnstruct();
    var_0.name = "promotion";
    var_0.type = "rank";
    var_0.sound = "mp_level_up";
    var_0.slot = 0;
    thread actionNotify( var_0 );
}

weaponPromotionSplashNotify()
{
    self endon( "disconnect" );
    var_0 = spawnstruct();
    var_0.name = "promotion_weapon";
    var_0.type = "weaponRank";
    var_0.sound = "mp_level_up";
    var_0.slot = 0;
    thread actionNotify( var_0 );
}

showNotifyMessage( var_0 )
{
    self endon( "disconnect" );
    var_1 = var_0.slot;

    if ( level.gameEnded )
    {
        if ( isdefined( var_0.type ) && var_0.type == "rank" )
        {
            self setclientdvar( "ui_promotion", 1 );
            self.postGamePromotion = 1;
        }

        if ( self.splashQueue[var_1].size )
            thread dispatchNotify( var_1 );

        return;
    }

    self.doingSplash[var_1] = var_0;
    waitRequireVisibility( 0 );

    if ( isdefined( var_0.duration ) )
        var_2 = var_0.duration;
    else if ( level.gameEnded )
        var_2 = 2.0;
    else
        var_2 = 4.0;

    thread resetOnCancel();

    if ( isdefined( var_0.sound ) )
        self playlocalsound( var_0.sound );

    if ( isdefined( var_0.leaderSound ) )
        maps\mp\_utility::leaderDialogOnPlayer( var_0.leaderSound );

    if ( isdefined( var_0.glowcolor ) )
        var_3 = var_0.glowcolor;
    else
        var_3 = ( 0.3, 0.6, 0.3 );

    var_4 = self.notifyTitle;

    if ( isdefined( var_0.titleText ) )
    {
        if ( isdefined( var_0.titleLabel ) )
            self.notifyTitle.label = var_0.titleLabel;
        else
            self.notifyTitle.label = &"";

        if ( isdefined( var_0.titleLabel ) && !isdefined( var_0.titleIsString ) )
            self.notifyTitle setvalue( var_0.titleText );
        else
            self.notifyTitle settext( var_0.titleText );

        self.notifyTitle setpulsefx( int( 25 * var_2 ), int( var_2 * 1000 ), 1000 );
        self.notifyTitle.glowcolor = var_3;
        self.notifyTitle.alpha = 1;
    }

    if ( isdefined( var_0.textGlowColor ) )
        var_3 = var_0.textGlowColor;

    if ( isdefined( var_0.notifyText ) )
    {
        if ( isdefined( var_0.textLabel ) )
            self.notifyText.label = var_0.textLabel;
        else
            self.notifyText.label = &"";

        if ( isdefined( var_0.textLabel ) && !isdefined( var_0._ID4852 ) )
            self.notifyText setvalue( var_0.notifyText );
        else
            self.notifyText settext( var_0.notifyText );

        self.notifyText setpulsefx( 100, int( var_2 * 1000 ), 1000 );
        self.notifyText.glowcolor = var_3;
        self.notifyText.alpha = 1;
        var_4 = self.notifyText;
    }

    if ( isdefined( var_0.notifyText2 ) )
    {
        self.notifyText2 maps\mp\gametypes\_hud_util::setParent( var_4 );

        if ( isdefined( var_0.text2Label ) )
            self.notifyText2.label = var_0.text2Label;
        else
            self.notifyText2.label = &"";

        self.notifyText2 settext( var_0.notifyText2 );
        self.notifyText2 setpulsefx( 100, int( var_2 * 1000 ), 1000 );
        self.notifyText2.glowcolor = var_3;
        self.notifyText2.alpha = 1;
        var_4 = self.notifyText2;
    }

    if ( isdefined( var_0.iconName ) )
    {
        self.notifyIcon maps\mp\gametypes\_hud_util::setParent( var_4 );

        if ( level.splitscreen || self issplitscreenplayer() )
            self.notifyIcon setshader( var_0.iconName, 30, 30 );
        else
            self.notifyIcon setshader( var_0.iconName, 60, 60 );

        self.notifyIcon.alpha = 0;

        if ( isdefined( var_0.iconOverlay ) )
        {
            self.notifyIcon fadeovertime( 0.15 );
            self.notifyIcon.alpha = 1;
            var_0._ID14057 = 0;
            self.notifyOverlay maps\mp\gametypes\_hud_util::setParent( self.notifyIcon );
            self.notifyOverlay maps\mp\gametypes\_hud_util::setPoint( "CENTER", "CENTER", 0, var_0._ID14057 );
            self.notifyOverlay setshader( var_0.iconOverlay, 512, 512 );
            self.notifyOverlay.alpha = 0;
            self.notifyOverlay.color = ( 1, 0, 0 );
            self.notifyOverlay fadeovertime( 0.4 );
            self.notifyOverlay.alpha = 0.85;
            self.notifyOverlay scaleovertime( 0.4, 32, 32 );
            waitRequireVisibility( var_2 );
            self.notifyIcon fadeovertime( 0.75 );
            self.notifyIcon.alpha = 0;
            self.notifyOverlay fadeovertime( 0.75 );
            self.notifyOverlay.alpha = 0;
        }
        else
        {
            self.notifyIcon fadeovertime( 1.0 );
            self.notifyIcon.alpha = 1;
            waitRequireVisibility( var_2 );
            self.notifyIcon fadeovertime( 0.75 );
            self.notifyIcon.alpha = 0;
        }
    }
    else
        waitRequireVisibility( var_2 );

    self notify( "notifyMessageDone" );
    self.doingSplash[var_1] = undefined;

    if ( self.splashQueue[var_1].size )
        thread dispatchNotify( var_1 );
}

killstreakSplashNotify( var_0, var_1, var_2 )
{
    self endon( "disconnect" );
    waittillframeend;

    if ( level.gameEnded )
        return;

    var_3 = spawnstruct();

    if ( isdefined( var_2 ) )
        var_3.name = var_0 + "_" + var_2;
    else
        var_3.name = var_0;

    var_3.type = "killstreak";
    var_3.optionalNumber = var_1;
    var_3.sound = maps\mp\killstreaks\_killstreaks::getKillstreakSound( var_0 );
    var_3.leaderSound = var_0;
    var_3.leaderSoundGroup = "killstreak_earned";
    var_3.slot = 0;
    thread actionNotify( var_3 );
}

defconSplashNotify( var_0, var_1 )
{

}

challengeSplashNotify( var_0 )
{
    self endon( "disconnect" );
    waittillframeend;
    wait 0.05;
    var_1 = maps\mp\gametypes\_hud_util::ch_getState( var_0 ) - 1;
    var_2 = maps\mp\gametypes\_hud_util::ch_getTarget( var_0, var_1 );

    if ( var_2 == 0 )
        var_2 = 1;

    if ( var_0 == "ch_longersprint_pro" || var_0 == "ch_longersprint_pro_daily" || var_0 == "ch_longersprint_pro_weekly" )
        var_2 = int( var_2 / 5280 );

    var_3 = spawnstruct();
    var_3.type = "challenge";
    var_3.optionalNumber = var_2;
    var_3.name = var_0;
    var_3.sound = tablelookup( "mp/splashTable.csv", 0, var_3.name, 9 );
    var_3.slot = 0;
    thread actionNotify( var_3 );
}

splashNotify( var_0, var_1 )
{
    self endon( "disconnect" );
    wait 0.05;
    var_2 = spawnstruct();
    var_2.name = var_0;
    var_2.optionalNumber = var_1;
    var_2.sound = tablelookup( "mp/splashTable.csv", 0, var_2.name, 9 );
    var_2.slot = 0;
    thread actionNotify( var_2 );
}

splashNotifyDelayed( var_0, var_1 )
{
    if ( level.hardcoreMode )
        return;

    self endon( "disconnect" );
    waittillframeend;

    if ( level.gameEnded )
        return;

    var_2 = spawnstruct();
    var_2.name = var_0;
    var_2.optionalNumber = var_1;
    var_2.sound = tablelookup( "mp/splashTable.csv", 0, var_2.name, 9 );
    var_2.slot = 0;
    thread actionNotify( var_2 );
}

playerCardSplashNotify( var_0, var_1, var_2 )
{
    self endon( "disconnect" );
    waittillframeend;

    if ( level.gameEnded )
        return;

    var_3 = spawnstruct();
    var_3.name = var_0;
    var_3.optionalNumber = var_2;
    var_3.sound = tablelookup( "mp/splashTable.csv", 0, var_3.name, 9 );
    var_3.playerCardPlayer = var_1;
    var_3.slot = 1;
    thread actionNotify( var_3 );
}

actionNotify( var_0 )
{
    self endon( "death" );
    self endon( "disconnect" );
    var_1 = var_0.slot;

    if ( !isdefined( var_0.type ) )
        var_0.type = "";

    if ( !isdefined( self.doingSplash[var_1] ) )
    {
        thread actionNotifyMessage( var_0 );
        return;
    }
    else if ( var_0.type == "killstreak" && self.doingSplash[var_1].type != "challenge" && self.doingSplash[var_1].type != "rank" )
    {
        self.notifyText.alpha = 0;
        self.notifyText2.alpha = 0;
        self.notifyIcon.alpha = 0;
        thread actionNotifyMessage( var_0 );
        return;
    }
    else if ( var_0.type == "challenge" && self.doingSplash[var_1].type != "killstreak" && self.doingSplash[var_1].type != "challenge" && self.doingSplash[var_1].type != "rank" )
    {
        self.notifyText.alpha = 0;
        self.notifyText2.alpha = 0;
        self.notifyIcon.alpha = 0;
        thread actionNotifyMessage( var_0 );
        return;
    }

    if ( var_0.type == "challenge" || var_0.type == "killstreak" )
    {
        if ( var_0.type == "killstreak" )
            removeTypeFromQueue( "killstreak", var_1 );

        for ( var_2 = self.splashQueue[var_1].size; var_2 > 0; var_2-- )
            self.splashQueue[var_1][var_2] = self.splashQueue[var_1][var_2 - 1];

        self.splashQueue[var_1][0] = var_0;
    }
    else
        self.splashQueue[var_1][self.splashQueue[var_1].size] = var_0;
}

removeTypeFromQueue( var_0, var_1 )
{
    var_2 = [];

    for ( var_3 = 0; var_3 < self.splashQueue[var_1].size; var_3++ )
    {
        if ( self.splashQueue[var_1][var_3].type != "killstreak" )
            var_2[var_2.size] = self.splashQueue[var_1][var_3];
    }

    self.splashQueue[var_1] = var_2;
}

actionNotifyMessage( var_0 )
{
    self endon( "disconnect" );
    var_1 = var_0.slot;

    if ( level.gameEnded )
    {
        wait 0;

        if ( isdefined( var_0.type ) && ( var_0.type == "rank" || var_0.type == "weaponRank" ) )
        {
            self setclientdvar( "ui_promotion", 1 );
            self.postGamePromotion = 1;
        }
        else if ( isdefined( var_0.type ) && var_0.type == "challenge" )
        {
            self.pers["postGameChallenges"]++;
            self setclientdvar( "ui_challenge_" + self.pers["postGameChallenges"] + "_ref", var_0.name );
        }

        if ( self.splashQueue[var_1].size )
            thread dispatchNotify( var_1 );

        return;
    }

    if ( tablelookup( "mp/splashTable.csv", 0, var_0.name, 0 ) != "" )
    {
        if ( isdefined( var_0.playerCardPlayer ) )
            self setcarddisplayslot( var_0.playerCardPlayer, 5 );

        if ( isdefined( var_0.optionalNumber ) )
            self showhudsplash( var_0.name, var_0.slot, var_0.optionalNumber );
        else
            self showhudsplash( var_0.name, var_0.slot );

        self.doingSplash[var_1] = var_0;
        var_2 = maps\mp\_utility::stringToFloat( tablelookup( "mp/splashTable.csv", 0, var_0.name, 4 ) );

        if ( isdefined( var_0.sound ) )
            self playlocalsound( var_0.sound );

        if ( isdefined( var_0.leaderSound ) )
        {
            if ( isdefined( var_0.leaderSoundGroup ) )
                maps\mp\_utility::leaderDialogOnPlayer( var_0.leaderSound, var_0.leaderSoundGroup, 1 );
            else
                maps\mp\_utility::leaderDialogOnPlayer( var_0.leaderSound );
        }

        self notify( "actionNotifyMessage" + var_1 );
        self endon( "actionNotifyMessage" + var_1 );
        wait(var_2 - 0.05);
        self.doingSplash[var_1] = undefined;
    }

    if ( self.splashQueue[var_1].size )
        thread dispatchNotify( var_1 );
}

waitRequireVisibility( var_0 )
{
    var_1 = 0.05;

    while ( !canReadText() )
        wait(var_1);

    while ( var_0 > 0 )
    {
        wait(var_1);

        if ( canReadText() )
            var_0 -= var_1;
    }
}

canReadText()
{
    if ( maps\mp\_flashgrenades::isFlashbanged() )
        return 0;

    return 1;
}

resetOnDeath()
{
    self endon( "notifyMessageDone" );
    self endon( "disconnect" );
    level endon( "game_ended" );
    self waittill( "death" );
    resetNotify();
}

resetOnCancel()
{
    self notify( "resetOnCancel" );
    self endon( "resetOnCancel" );
    self endon( "notifyMessageDone" );
    self endon( "disconnect" );
    level waittill( "cancel_notify" );
    resetNotify();
}

resetNotify()
{
    self.notifyTitle.alpha = 0;
    self.notifyText.alpha = 0;
    self.notifyIcon.alpha = 0;
    self.notifyOverlay.alpha = 0;
    self.doingSplash[0] = undefined;
    self.doingSplash[1] = undefined;
    self.doingSplash[2] = undefined;
    self.doingSplash[3] = undefined;
}

hintMessageDeathThink()
{
    self endon( "disconnect" );

    for (;;)
    {
        self waittill( "death" );

        if ( isdefined( self.hintMessage ) )
            self.hintMessage maps\mp\gametypes\_hud_util::destroyElem();
    }
}

lowerMessageThink()
{
    self endon( "disconnect" );
    self.lowerMessages = [];
    self.lowerMessage = maps\mp\gametypes\_hud_util::createFontString( "default", level.lowerTextFontSize );
    self.lowerMessage settext( "" );
    self.lowerMessage.archived = 0;
    self.lowerMessage.sort = 10;

    if ( level.splitscreen || self issplitscreenplayer() )
    {
        self.lowerMessage maps\mp\gametypes\_hud_util::setPoint( "CENTER", level.lowerTextYAlign, 0, level.lowerTextY );
        var_0 = 0.5;
    }
    else
    {
        self.lowerMessage maps\mp\gametypes\_hud_util::setPoint( "CENTER", level.lowerTextYAlign, 0, level.lowerTextY - 40 );
        var_0 = 0.75;
    }

    self.lowerTimer = maps\mp\gametypes\_hud_util::createFontString( "hudbig", var_0 );
    self.lowerTimer maps\mp\gametypes\_hud_util::setParent( self.lowerMessage );
    self.lowerTimer maps\mp\gametypes\_hud_util::setPoint( "TOP", "BOTTOM", 0, 0 );
    self.lowerTimer settext( "" );
    self.lowerTimer.archived = 0;
    self.lowerTimer.sort = 10;
}

outcomeOverlay( var_0 )
{
    if ( level.teamBased )
    {
        if ( var_0 == "tie" )
            matchOutcomeNotify( "draw" );
        else if ( var_0 == self.team )
            matchOutcomeNotify( "victory" );
        else
            matchOutcomeNotify( "defeat" );
    }
    else if ( var_0 == self )
        matchOutcomeNotify( "victory" );
    else
        matchOutcomeNotify( "defeat" );
}

matchOutcomeNotify( var_0 )
{
    var_1 = self.team;
    var_2 = maps\mp\gametypes\_hud_util::createFontString( "bigfixed", 1.0 );
    var_2 maps\mp\gametypes\_hud_util::setPoint( "TOP", undefined, 0, 50 );
    var_2.foreground = 1;
    var_2.glowalpha = 1;
    var_2.hidewheninmenu = 0;
    var_2.archived = 0;
    var_2 settext( game["strings"][var_0] );
    var_2.alpha = 0;
    var_2 fadeovertime( 0.5 );
    var_2.alpha = 1;

    switch ( var_0 )
    {
        case "victory":
            var_2.glowcolor = ( 0.6, 0.9, 0.6 );
            break;
        default:
            var_2.glowcolor = ( 0.9, 0.6, 0.6 );
            break;
    }

    var_3 = maps\mp\gametypes\_hud_util::createIcon( game["icons"][var_1], 64, 64 );
    var_3 maps\mp\gametypes\_hud_util::setParent( var_2 );
    var_3 maps\mp\gametypes\_hud_util::setPoint( "TOP", "BOTTOM", 0, 30 );
    var_3.foreground = 1;
    var_3.hidewheninmenu = 0;
    var_3.archived = 0;
    var_3.alpha = 0;
    var_3 fadeovertime( 0.5 );
    var_3.alpha = 1;
    wait 3.0;
    var_2 maps\mp\gametypes\_hud_util::destroyElem();
    var_3 maps\mp\gametypes\_hud_util::destroyElem();
}

isDoingSplash()
{
    if ( isdefined( self.doingSplash[0] ) )
        return 1;

    if ( isdefined( self.doingSplash[1] ) )
        return 1;

    if ( isdefined( self.doingSplash[2] ) )
        return 1;

    if ( isdefined( self.doingSplash[3] ) )
        return 1;

    return 0;
}

teamOutcomeNotify( var_0, var_1, var_2 )
{
    self endon( "disconnect" );
    self notify( "reset_outcome" );
    wait 0.5;
    var_3 = self.pers["team"];

    if ( !isdefined( var_3 ) || var_3 != "allies" && var_3 != "axis" )
        var_3 = "allies";

    while ( isDoingSplash() )
        wait 0.05;

    self endon( "reset_outcome" );

    if ( level.splitscreen || self issplitscreenplayer() )
    {
        var_4 = 1;
        var_5 = -76;
        var_6 = 0.667;
        var_7 = 12;
        var_8 = 0.833;
        var_9 = 46;
        var_10 = 40;
        var_11 = 30;
        var_12 = 0;
        var_13 = 60;
        var_14 = "hudbig";
    }
    else
    {
        var_4 = 1.5;
        var_5 = -134;
        var_6 = 1.0;
        var_7 = 18;
        var_8 = 1.25;
        var_9 = 70;
        var_10 = 60;
        var_11 = 45;
        var_12 = 0;
        var_13 = 90;
        var_14 = "hudbig";
    }

    var_15 = 60000;
    var_16 = maps\mp\gametypes\_hud_util::createFontString( var_14, var_4 );
    var_16 maps\mp\gametypes\_hud_util::setPoint( "CENTER", undefined, 0, var_5 );
    var_16.foreground = 1;
    var_16.glowalpha = 1;
    var_16.hidewheninmenu = 0;
    var_16.archived = 0;
    var_17 = maps\mp\gametypes\_hud_util::createFontString( var_14, var_6 );
    var_17 maps\mp\gametypes\_hud_util::setParent( var_16 );
    var_17.foreground = 1;
    var_17 maps\mp\gametypes\_hud_util::setPoint( "TOP", "BOTTOM", 0, var_7 );
    var_17.glowalpha = 1;
    var_17.hidewheninmenu = 0;
    var_17.archived = 0;

    if ( var_0 == "halftime" )
    {
        var_16.glowcolor = ( 0.2, 0.3, 0.7 );
        var_16 settext( game["strings"]["halftime"] );
        var_16.color = ( 1, 1, 1 );
        var_0 = "allies";
    }
    else if ( var_0 == "intermission" )
    {
        var_16.glowcolor = ( 0.2, 0.3, 0.7 );
        var_16 settext( game["strings"]["intermission"] );
        var_16.color = ( 1, 1, 1 );
        var_0 = "allies";
    }
    else if ( var_0 == "roundend" )
    {
        var_16.glowcolor = ( 0.2, 0.3, 0.7 );
        var_16 settext( game["strings"]["roundend"] );
        var_16.color = ( 1, 1, 1 );
        var_0 = "allies";
    }
    else if ( var_0 == "overtime" )
    {
        var_16.glowcolor = ( 0.2, 0.3, 0.7 );
        var_16 settext( game["strings"]["overtime"] );
        var_16.color = ( 1, 1, 1 );
        var_0 = "allies";
    }
    else if ( var_0 == "tie" )
    {
        var_16.glowcolor = ( 0.2, 0.3, 0.7 );

        if ( var_1 )
            var_16 settext( game["strings"]["round_draw"] );
        else
            var_16 settext( game["strings"]["draw"] );

        var_16.color = ( 1, 1, 1 );
        var_0 = "allies";
    }
    else if ( isdefined( self.pers["team"] ) && var_0 == var_3 )
    {
        var_16.glowcolor = ( 0, 0, 0 );

        if ( var_1 )
            var_16 settext( game["strings"]["round_win"] );
        else
            var_16 settext( game["strings"]["victory"] );

        var_16.color = ( 0.6, 0.9, 0.6 );
    }
    else
    {
        var_16.glowcolor = ( 0, 0, 0 );

        if ( var_1 )
            var_16 settext( game["strings"]["round_loss"] );
        else
            var_16 settext( game["strings"]["defeat"] );

        var_16.color = ( 0.7, 0.3, 0.2 );
    }

    var_17.glowcolor = ( 0.2, 0.3, 0.7 );
    var_17 settext( var_2 );
    var_16 setpulsefx( 100, var_15, 1000 );
    var_17 setpulsefx( 100, var_15, 1000 );

    if ( maps\mp\_utility::getIntProperty( "useRelativeTeamColors", 0 ) )
        var_18 = maps\mp\gametypes\_hud_util::createIcon( game["icons"][var_3] + "_blue", var_9, var_9 );
    else
        var_18 = maps\mp\gametypes\_hud_util::createIcon( game["icons"][var_3], var_9, var_9 );

    var_18 maps\mp\gametypes\_hud_util::setParent( var_17 );
    var_18 maps\mp\gametypes\_hud_util::setPoint( "TOP", "BOTTOM", var_10 * -1, var_11 );
    var_18.foreground = 1;
    var_18.hidewheninmenu = 0;
    var_18.archived = 0;
    var_18.alpha = 0;
    var_18 fadeovertime( 0.5 );
    var_18.alpha = 1;

    if ( maps\mp\_utility::getIntProperty( "useRelativeTeamColors", 0 ) )
        var_19 = maps\mp\gametypes\_hud_util::createIcon( game["icons"][level.otherTeam[var_3]] + "_red", var_9, var_9 );
    else
        var_19 = maps\mp\gametypes\_hud_util::createIcon( game["icons"][level.otherTeam[var_3]], var_9, var_9 );

    var_19 maps\mp\gametypes\_hud_util::setParent( var_17 );
    var_19 maps\mp\gametypes\_hud_util::setPoint( "TOP", "BOTTOM", var_10, var_11 );
    var_19.foreground = 1;
    var_19.hidewheninmenu = 0;
    var_19.archived = 0;
    var_19.alpha = 0;
    var_19 fadeovertime( 0.5 );
    var_19.alpha = 1;
    var_20 = maps\mp\gametypes\_hud_util::createFontString( var_14, var_8 );
    var_20 maps\mp\gametypes\_hud_util::setParent( var_18 );
    var_20 maps\mp\gametypes\_hud_util::setPoint( "TOP", "BOTTOM", 0, var_12 );

    if ( maps\mp\_utility::getIntProperty( "useRelativeTeamColors", 0 ) )
        var_20.glowcolor = game["colors"]["blue"];
    else
        var_20.glowcolor = game["colors"][var_3];

    var_20.glowalpha = 1;

    if ( !maps\mp\_utility::isRoundBased() || !maps\mp\_utility::isObjectiveBased() )
        var_20 setvalue( maps\mp\gametypes\_gamescore::_getTeamScore( var_3 ) );
    else
        var_20 setvalue( game["roundsWon"][var_3] );

    var_20.foreground = 1;
    var_20.hidewheninmenu = 0;
    var_20.archived = 0;
    var_20 setpulsefx( 100, var_15, 1000 );
    var_21 = maps\mp\gametypes\_hud_util::createFontString( var_14, var_8 );
    var_21 maps\mp\gametypes\_hud_util::setParent( var_19 );
    var_21 maps\mp\gametypes\_hud_util::setPoint( "TOP", "BOTTOM", 0, var_12 );

    if ( maps\mp\_utility::getIntProperty( "useRelativeTeamColors", 0 ) )
        var_21.glowcolor = game["colors"]["red"];
    else
        var_21.glowcolor = game["colors"][level.otherTeam[var_3]];

    var_21.glowalpha = 1;

    if ( !maps\mp\_utility::isRoundBased() || !maps\mp\_utility::isObjectiveBased() )
        var_21 setvalue( maps\mp\gametypes\_gamescore::_getTeamScore( level.otherTeam[var_3] ) );
    else
        var_21 setvalue( game["roundsWon"][level.otherTeam[var_3]] );

    var_21.foreground = 1;
    var_21.hidewheninmenu = 0;
    var_21.archived = 0;
    var_21 setpulsefx( 100, var_15, 1000 );
    var_22 = undefined;

    if ( isdefined( self.matchBonus ) )
    {
        var_22 = maps\mp\gametypes\_hud_util::createFontString( var_14, var_6 );
        var_22 maps\mp\gametypes\_hud_util::setParent( var_17 );
        var_22 maps\mp\gametypes\_hud_util::setPoint( "TOP", "BOTTOM", 0, var_9 + var_13 + var_20.height );
        var_22.glowalpha = 1;
        var_22.foreground = 1;
        var_22.hidewheninmenu = 0;
        var_22.color = ( 1, 1, 0.5 );
        var_22.archived = 0;
        var_22.label = game["strings"]["match_bonus"];
        var_22 setvalue( self.matchBonus );
    }

    thread resetTeamOutcomeNotify( var_16, var_17, var_18, var_19, var_20, var_21, var_22 );
}

outcomeNotify( var_0, var_1 )
{
    self endon( "disconnect" );
    self notify( "reset_outcome" );

    while ( isDoingSplash() )
        wait 0.05;

    self endon( "reset_outcome" );

    if ( level.splitscreen || self issplitscreenplayer() )
    {
        var_2 = 2.0;
        var_3 = 1.5;
        var_4 = 1.5;
        var_5 = 30;
        var_6 = 2;
        var_7 = "default";
    }
    else
    {
        var_2 = 3.0;
        var_3 = 2.0;
        var_4 = 1.5;
        var_5 = 30;
        var_6 = 20;
        var_7 = "objective";
    }

    var_8 = 60000;
    var_9 = level.placement["all"];
    var_10 = var_9[0];
    var_11 = var_9[1];
    var_12 = var_9[2];
    var_13 = maps\mp\gametypes\_hud_util::createFontString( var_7, var_2 );
    var_13 maps\mp\gametypes\_hud_util::setPoint( "TOP", undefined, 0, var_6 );
    var_14 = 0;

    if ( isdefined( var_10 ) && self.score == var_10.score && self.deaths == var_10.deaths )
    {
        if ( self != var_10 )
            var_14 = 1;
        else if ( isdefined( var_11 ) && var_11.score == var_10.score && var_11.deaths == var_10.deaths )
            var_14 = 1;
    }

    if ( var_14 )
    {
        var_13 settext( game["strings"]["tie"] );
        var_13.glowcolor = ( 0.2, 0.3, 0.7 );
    }
    else if ( isdefined( var_10 ) && self == var_10 )
    {
        var_13 settext( game["strings"]["victory"] );
        var_13.glowcolor = ( 0.2, 0.3, 0.7 );
    }
    else
    {
        var_13 settext( game["strings"]["defeat"] );
        var_13.glowcolor = ( 0.7, 0.3, 0.2 );
    }

    var_13.glowalpha = 1;
    var_13.foreground = 1;
    var_13.hidewheninmenu = 0;
    var_13.archived = 0;
    var_13 setpulsefx( 100, var_8, 1000 );
    var_15 = maps\mp\gametypes\_hud_util::createFontString( var_7, 2.0 );
    var_15 maps\mp\gametypes\_hud_util::setParent( var_13 );
    var_15 maps\mp\gametypes\_hud_util::setPoint( "TOP", "BOTTOM", 0, 0 );
    var_15.glowalpha = 1;
    var_15.foreground = 1;
    var_15.hidewheninmenu = 0;
    var_15.archived = 0;
    var_15.glowcolor = ( 0.2, 0.3, 0.7 );
    var_15 settext( var_1 );
    var_16 = maps\mp\gametypes\_hud_util::createFontString( var_7, var_3 );
    var_16 maps\mp\gametypes\_hud_util::setParent( var_15 );
    var_16 maps\mp\gametypes\_hud_util::setPoint( "TOP", "BOTTOM", 0, var_6 );
    var_16.glowcolor = ( 0.3, 0.7, 0.2 );
    var_16.glowalpha = 1;
    var_16.foreground = 1;
    var_16.hidewheninmenu = 0;
    var_16.archived = 0;

    if ( isdefined( var_10 ) )
    {
        var_16.label = &"MP_FIRSTPLACE_NAME";
        var_16 setplayernamestring( var_10 );
        var_16 setpulsefx( 100, var_8, 1000 );
    }

    var_17 = maps\mp\gametypes\_hud_util::createFontString( var_7, var_4 );
    var_17 maps\mp\gametypes\_hud_util::setParent( var_16 );
    var_17 maps\mp\gametypes\_hud_util::setPoint( "TOP", "BOTTOM", 0, var_6 );
    var_17.glowcolor = ( 0.2, 0.3, 0.7 );
    var_17.glowalpha = 1;
    var_17.foreground = 1;
    var_17.hidewheninmenu = 0;
    var_17.archived = 0;

    if ( isdefined( var_11 ) )
    {
        var_17.label = &"MP_SECONDPLACE_NAME";
        var_17 setplayernamestring( var_11 );
        var_17 setpulsefx( 100, var_8, 1000 );
    }

    var_18 = maps\mp\gametypes\_hud_util::createFontString( var_7, var_4 );
    var_18 maps\mp\gametypes\_hud_util::setParent( var_17 );
    var_18 maps\mp\gametypes\_hud_util::setPoint( "TOP", "BOTTOM", 0, var_6 );
    var_18 maps\mp\gametypes\_hud_util::setParent( var_17 );
    var_18.glowcolor = ( 0.2, 0.3, 0.7 );
    var_18.glowalpha = 1;
    var_18.foreground = 1;
    var_18.hidewheninmenu = 0;
    var_18.archived = 0;

    if ( isdefined( var_12 ) )
    {
        var_18.label = &"MP_THIRDPLACE_NAME";
        var_18 setplayernamestring( var_12 );
        var_18 setpulsefx( 100, var_8, 1000 );
    }

    var_19 = maps\mp\gametypes\_hud_util::createFontString( var_7, 2.0 );
    var_19 maps\mp\gametypes\_hud_util::setParent( var_18 );
    var_19 maps\mp\gametypes\_hud_util::setPoint( "TOP", "BOTTOM", 0, var_6 );
    var_19.glowalpha = 1;
    var_19.foreground = 1;
    var_19.hidewheninmenu = 0;
    var_19.archived = 0;

    if ( isdefined( self.matchBonus ) )
    {
        var_19.label = game["strings"]["match_bonus"];
        var_19 setvalue( self.matchBonus );
    }

    thread updateOutcome( var_16, var_17, var_18 );
    thread resetOutcomeNotify( var_13, var_15, var_16, var_17, var_18, var_19 );
}

resetOutcomeNotify( var_0, var_1, var_2, var_3, var_4, var_5 )
{
    self endon( "disconnect" );
    self waittill( "reset_outcome" );

    if ( isdefined( var_0 ) )
        var_0 maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( var_1 ) )
        var_1 maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( var_2 ) )
        var_2 maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( var_3 ) )
        var_3 maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( var_4 ) )
        var_4 maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( var_5 ) )
        var_5 maps\mp\gametypes\_hud_util::destroyElem();
}

resetTeamOutcomeNotify( var_0, var_1, var_2, var_3, var_4, var_5, var_6 )
{
    self endon( "disconnect" );
    self waittill( "reset_outcome" );

    if ( isdefined( var_0 ) )
        var_0 maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( var_1 ) )
        var_1 maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( var_2 ) )
        var_2 maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( var_3 ) )
        var_3 maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( var_4 ) )
        var_4 maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( var_5 ) )
        var_5 maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( var_6 ) )
        var_6 maps\mp\gametypes\_hud_util::destroyElem();
}

updateOutcome( var_0, var_1, var_2 )
{
    self endon( "disconnect" );
    self endon( "reset_outcome" );

    for (;;)
    {
        self waittill( "update_outcome" );
        var_3 = level.placement["all"];
        var_4 = var_3[0];
        var_5 = var_3[1];
        var_6 = var_3[2];

        if ( isdefined( var_0 ) && isdefined( var_4 ) )
            var_0 setplayernamestring( var_4 );
        else if ( isdefined( var_0 ) )
            var_0.alpha = 0;

        if ( isdefined( var_1 ) && isdefined( var_5 ) )
            var_1 setplayernamestring( var_5 );
        else if ( isdefined( var_1 ) )
            var_1.alpha = 0;

        if ( isdefined( var_2 ) && isdefined( var_6 ) )
        {
            var_2 setplayernamestring( var_6 );
            continue;
        }

        if ( isdefined( var_2 ) )
            var_2.alpha = 0;
    }
}

canShowSplash( var_0 )
{

}
