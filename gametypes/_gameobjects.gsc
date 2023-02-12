// IW5 PC GSC
// Decompiled by https://github.com/xensik/gsc-tool

main( var_0 )
{
    var_0[var_0.size] = "airdrop_pallet";
    var_1 = getentarray();

    for ( var_2 = 0; var_2 < var_1.size; var_2++ )
    {
        if ( isdefined( var_1[var_2].script_gameobjectname ) )
        {
            var_3 = 1;
            var_4 = strtok( var_1[var_2].script_gameobjectname, " " );

            for ( var_5 = 0; var_5 < var_0.size; var_5++ )
            {
                for ( var_6 = 0; var_6 < var_4.size; var_6++ )
                {
                    if ( var_4[var_6] == var_0[var_5] )
                    {
                        var_3 = 0;
                        break;
                    }
                }

                if ( !var_3 )
                    break;
            }

            if ( var_3 )
                var_1[var_2] delete();
        }
    }
}

init()
{
    level.numGametypeReservedObjectives = 0;
    precacheitem( "briefcase_bomb_mp" );
    precacheitem( "briefcase_bomb_defuse_mp" );
    precachemodel( "prop_suitcase_bomb" );
    level.objIDStart = 0;
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    level endon( "game_ended" );

    for (;;)
    {
        level waittill( "connected",  var_0  );
        var_0 thread onPlayerSpawned();
        var_0 thread onPlayerDisconnect();
    }
}

onPlayerSpawned()
{
    self endon( "disconnect" );
    level endon( "game_ended" );

    for (;;)
    {
        self waittill( "spawned_player" );

        if ( isdefined( self.gameobject_fauxspawn ) )
        {
            self.gameobject_fauxspawn = undefined;
            continue;
        }

        thread onDeath();
        self.touchTriggers = [];
        self.carryObject = undefined;
        self.claimTrigger = undefined;
        self.canPickupObject = 1;
        self.killedInUse = undefined;
    }
}

onDeath()
{
    level endon( "game_ended" );
    self waittill( "death" );

    if ( isdefined( self.carryObject ) )
        self.carryObject thread setDropped();
}

onPlayerDisconnect()
{
    level endon( "game_ended" );
    self waittill( "disconnect" );

    if ( isdefined( self.carryObject ) )
        self.carryObject thread setDropped();
}

createCarryObject( var_0, var_1, var_2, var_3 )
{
    var_4 = spawnstruct();
    var_4.type = "carryObject";
    var_4.curOrigin = var_1.origin;
    var_4.ownerTeam = var_0;
    var_4.entNum = var_1 getentitynumber();

    if ( issubstr( var_1.classname, "use" ) )
        var_4.triggerType = "use";
    else
        var_4.triggerType = "proximity";

    var_1.baseOrigin = var_1.origin;
    var_4.trigger = var_1;
    var_4.useWeapon = undefined;

    if ( !isdefined( var_3 ) )
        var_3 = ( 0, 0, 0 );

    var_4.offset3d = var_3;

    for ( var_5 = 0; var_5 < var_2.size; var_5++ )
    {
        var_2[var_5].baseOrigin = var_2[var_5].origin;
        var_2[var_5].baseAngles = var_2[var_5].angles;
    }

    var_4.visuals = var_2;
    var_4.compassIcons = [];
    var_4.objIDAllies = getNextObjID();
    var_4.objIDAxis = getNextObjID();
    var_4.objIDPingFriendly = 0;
    var_4.objIDPingEnemy = 0;
    level.objIDStart = level.objIDStart + 2;
    objective_add( var_4.objIDAllies, "invisible", var_4.curOrigin );
    objective_add( var_4.objIDAxis, "invisible", var_4.curOrigin );
    objective_team( var_4.objIDAllies, "allies" );
    objective_team( var_4.objIDAxis, "axis" );
    var_4.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + var_4.entNum, var_4.curOrigin + var_3, "allies", undefined );
    var_4.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + var_4.entNum, var_4.curOrigin + var_3, "axis", undefined );
    var_4.objPoints["allies"].alpha = 0;
    var_4.objPoints["axis"].alpha = 0;
    var_4.carrier = undefined;
    var_4.isResetting = 0;
    var_4.interactTeam = "none";
    var_4.allowWeapons = 0;
    var_4.worldIcons = [];
    var_4.carrierVisible = 0;
    var_4.visibleTeam = "none";
    var_4.carryIcon = undefined;
    var_4.onDrop = undefined;
    var_4.onPickup = undefined;
    var_4.onReset = undefined;

    if ( var_4.triggerType == "use" )
        var_4 thread carryObjectUseThink();
    else
    {
        var_4.curProgress = 0;
        var_4.useTime = 0;
        var_4.useRate = 0;
        var_4.teamUseTimes = [];
        var_4.teamUseTexts = [];
        var_4.numTouching["neutral"] = 0;
        var_4.numTouching["axis"] = 0;
        var_4.numTouching["allies"] = 0;
        var_4.numTouching["none"] = 0;
        var_4.touchList["neutral"] = [];
        var_4.touchList["axis"] = [];
        var_4.touchList["allies"] = [];
        var_4.touchList["none"] = [];
        var_4.claimTeam = "none";
        var_4.claimPlayer = undefined;
        var_4.lastClaimTeam = "none";
        var_4.lastClaimTime = 0;
        var_4 thread carryObjectProxThink();
    }

    var_4 thread updateCarryObjectOrigin();
    return var_4;
}

carryObjectUseThink()
{
    level endon( "game_ended" );

    for (;;)
    {
        self.trigger waittill( "trigger",  var_0  );

        if ( self.isResetting )
            continue;

        if ( !maps\mp\_utility::isReallyAlive( var_0 ) )
            continue;

        if ( !canInteractWith( var_0.pers["team"] ) )
            continue;

        if ( !var_0.canPickupObject )
            continue;

        if ( isdefined( var_0.throwingGrenade ) )
            continue;

        if ( isdefined( self.carrier ) )
            continue;

        if ( var_0 maps\mp\_utility::isUsingRemote() )
            continue;

        setPickedUp( var_0 );
    }
}

carryObjectProxThink()
{
    thread carryObjectProxThinkDelayed();
}

carryObjectProxThinkInstant()
{
    level endon( "game_ended" );

    for (;;)
    {
        self.trigger waittill( "trigger",  var_0  );

        if ( self.isResetting )
            continue;

        if ( !maps\mp\_utility::isReallyAlive( var_0 ) )
            continue;

        if ( !canInteractWith( var_0.pers["team"] ) )
            continue;

        if ( !var_0.canPickupObject )
            continue;

        if ( isdefined( var_0.throwingGrenade ) )
            continue;

        if ( isdefined( self.carrier ) )
            continue;

        setPickedUp( var_0 );
    }
}

carryObjectProxThinkDelayed()
{
    level endon( "game_ended" );
    thread proxTriggerThink();

    for (;;)
    {
        if ( self.useTime && self.curProgress >= self.useTime )
        {
            self.curProgress = 0;
            var_0 = getEarliestClaimPlayer();

            if ( isdefined( self.onEndUse ) )
                self [[ self.onEndUse ]]( getClaimTeam(), var_0, isdefined( var_0 ) );

            if ( isdefined( var_0 ) )
                setPickedUp( var_0 );

            setClaimTeam( "none" );
            self.claimPlayer = undefined;
        }

        if ( self.claimTeam != "none" )
        {
            if ( self.useTime )
            {
                if ( !self.numTouching[self.claimTeam] )
                {
                    if ( isdefined( self.onEndUse ) )
                        self [[ self.onEndUse ]]( getClaimTeam(), self.claimPlayer, 0 );

                    setClaimTeam( "none" );
                    self.claimPlayer = undefined;
                }
                else
                {
                    self.curProgress = self.curProgress + 50 * self.useRate;

                    if ( isdefined( self.onUseUpdate ) )
                        self [[ self.onUseUpdate ]]( getClaimTeam(), self.curProgress / self.useTime, 50 * self.useRate / self.useTime );
                }
            }
            else
            {
                if ( maps\mp\_utility::isReallyAlive( self.claimPlayer ) )
                    setPickedUp( self.claimPlayer );

                setClaimTeam( "none" );
                self.claimPlayer = undefined;
            }
        }

        wait 0.05;
        maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
    }
}

pickupObjectDelay( var_0 )
{
    level endon( "game_ended" );
    self endon( "death" );
    self endon( "disconnect" );
    self.canPickupObject = 0;

    for (;;)
    {
        if ( distancesquared( self.origin, var_0 ) > 4096 )
            break;

        wait 0.2;
    }

    self.canPickupObject = 1;
}

setPickedUp( var_0 )
{
    if ( isdefined( var_0.carryObject ) )
    {
        if ( isdefined( self.onPickupFailed ) )
            self [[ self.onPickupFailed ]]( var_0 );

        return;
    }

    var_0 giveObject( self );
    setCarrier( var_0 );

    for ( var_1 = 0; var_1 < self.visuals.size; var_1++ )
        self.visuals[var_1] hide();

    self.trigger.origin = self.trigger.origin + ( 0, 0, 10000 );
    self notify( "pickup_object" );

    if ( isdefined( self.onPickup ) )
        self [[ self.onPickup ]]( var_0 );

    updateCompassIcons();
    updateWorldIcons();
}

updateCarryObjectOrigin()
{
    level endon( "game_ended" );
    var_0 = 5.0;

    for (;;)
    {
        if ( isdefined( self.carrier ) )
        {
            self.curOrigin = self.carrier.origin + ( 0, 0, 75 );
            self.objPoints["allies"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin );
            self.objPoints["axis"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin );

            if ( ( self.visibleTeam == "friendly" || self.visibleTeam == "any" ) && isFriendlyTeam( "allies" ) && self.objIDPingFriendly )
            {
                if ( self.objPoints["allies"].isShown )
                {
                    self.objPoints["allies"].alpha = self.objPoints["allies"].baseAlpha;
                    self.objPoints["allies"] fadeovertime( var_0 + 1.0 );
                    self.objPoints["allies"].alpha = 0;
                }

                objective_position( self.objIDAllies, self.curOrigin );
            }
            else if ( ( self.visibleTeam == "friendly" || self.visibleTeam == "any" ) && isFriendlyTeam( "axis" ) && self.objIDPingFriendly )
            {
                if ( self.objPoints["axis"].isShown )
                {
                    self.objPoints["axis"].alpha = self.objPoints["axis"].baseAlpha;
                    self.objPoints["axis"] fadeovertime( var_0 + 1.0 );
                    self.objPoints["axis"].alpha = 0;
                }

                objective_position( self.objIDAxis, self.curOrigin );
            }

            if ( ( self.visibleTeam == "enemy" || self.visibleTeam == "any" ) && !isFriendlyTeam( "allies" ) && self.objIDPingEnemy )
            {
                if ( self.objPoints["allies"].isShown )
                {
                    self.objPoints["allies"].alpha = self.objPoints["allies"].baseAlpha;
                    self.objPoints["allies"] fadeovertime( var_0 + 1.0 );
                    self.objPoints["allies"].alpha = 0;
                }

                objective_position( self.objIDAllies, self.curOrigin );
            }
            else if ( ( self.visibleTeam == "enemy" || self.visibleTeam == "any" ) && !isFriendlyTeam( "axis" ) && self.objIDPingEnemy )
            {
                if ( self.objPoints["axis"].isShown )
                {
                    self.objPoints["axis"].alpha = self.objPoints["axis"].baseAlpha;
                    self.objPoints["axis"] fadeovertime( var_0 + 1.0 );
                    self.objPoints["axis"].alpha = 0;
                }

                objective_position( self.objIDAxis, self.curOrigin );
            }

            maps\mp\_utility::wait_endon( var_0, "dropped", "reset" );
            continue;
        }

        self.objPoints["allies"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin + self.offset3d );
        self.objPoints["axis"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin + self.offset3d );
        wait 0.05;
    }
}

hideCarryIconOnGameEnd()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "drop_object" );
    level waittill( "game_ended" );

    if ( isdefined( self.carryIcon ) )
        self.carryIcon.alpha = 0;
}

giveObject( var_0 )
{
    self.carryObject = var_0;
    thread trackCarrier();

    if ( !var_0.allowWeapons )
    {
        common_scripts\utility::_disableWeapon();
        thread manualDropThink();
    }

    if ( isdefined( var_0.carryIcon ) )
    {
        if ( level.splitscreen )
        {
            self.carryIcon = maps\mp\gametypes\_hud_util::createIcon( var_0.carryIcon, 33, 33 );
            self.carryIcon maps\mp\gametypes\_hud_util::setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", -50, -78 );
        }
        else
        {
            self.carryIcon = maps\mp\gametypes\_hud_util::createIcon( var_0.carryIcon, 50, 50 );
            self.carryIcon maps\mp\gametypes\_hud_util::setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", -50, -65 );
        }

        self.carryIcon.hidewheninmenu = 1;
        thread hideCarryIconOnGameEnd();
    }
}

returnHome()
{
    self.isResetting = 1;
    self notify( "reset" );

    for ( var_0 = 0; var_0 < self.visuals.size; var_0++ )
    {
        self.visuals[var_0].origin = self.visuals[var_0].baseOrigin;
        self.visuals[var_0].angles = self.visuals[var_0].baseAngles;
        self.visuals[var_0] show();
    }

    self.trigger.origin = self.trigger.baseOrigin;
    self.curOrigin = self.trigger.origin;

    if ( isdefined( self.onReset ) )
        self [[ self.onReset ]]();

    clearCarrier();
    updateWorldIcons();
    updateCompassIcons();
    self.isResetting = 0;
}

isHome()
{
    if ( isdefined( self.carrier ) )
        return 0;

    if ( self.curOrigin != self.trigger.baseOrigin )
        return 0;

    return 1;
}

setPosition( var_0, var_1 )
{
    self.isResetting = 1;

    for ( var_2 = 0; var_2 < self.visuals.size; var_2++ )
    {
        self.visuals[var_2].origin = self.origin;
        self.visuals[var_2].angles = self.angles;
        self.visuals[var_2] show();
    }

    self.trigger.origin = var_0;
    self.curOrigin = self.trigger.origin;
    clearCarrier();
    updateWorldIcons();
    updateCompassIcons();
    self.isResetting = 0;
}

onPlayerLastStand()
{
    if ( isdefined( self.carryObject ) )
        self.carryObject thread setDropped();
}

setDropped()
{
    self.isResetting = 1;
    self notify( "dropped" );

    if ( isdefined( self.carrier ) && self.carrier.team != "spectator" )
    {
        var_0 = playerphysicstrace( self.carrier.origin + ( 0, 0, 20 ), self.carrier.origin - ( 0, 0, 2000 ), 0, self.carrier.body );
        var_1 = bullettrace( self.carrier.origin + ( 0, 0, 20 ), self.carrier.origin - ( 0, 0, 2000 ), 0, self.carrier.body );
    }
    else
    {
        var_0 = playerphysicstrace( self.safeOrigin + ( 0, 0, 20 ), self.safeOrigin - ( 0, 0, 20 ), 0, undefined );
        var_1 = bullettrace( self.safeOrigin + ( 0, 0, 20 ), self.safeOrigin - ( 0, 0, 20 ), 0, undefined );
    }

    var_2 = self.carrier;
    var_3 = 0;

    if ( isdefined( var_0 ) )
    {
        var_4 = randomfloat( 360 );
        var_5 = var_0;

        if ( var_1["fraction"] < 1 && distance( var_1["position"], var_0 ) < 10.0 )
        {
            var_6 = ( cos( var_4 ), sin( var_4 ), 0 );
            var_6 = vectornormalize( var_6 - var_1["normal"] * vectordot( var_6, var_1["normal"] ) );
            var_7 = vectortoangles( var_6 );
        }
        else
            var_7 = ( 0, var_4, 0 );

        for ( var_8 = 0; var_8 < self.visuals.size; var_8++ )
        {
            self.visuals[var_8].origin = var_5;
            self.visuals[var_8].angles = var_7;
            self.visuals[var_8] show();
        }

        self.trigger.origin = var_5;
        self.curOrigin = self.trigger.origin;
        thread pickupTimeout();
    }

    if ( !isdefined( var_0 ) )
    {
        for ( var_8 = 0; var_8 < self.visuals.size; var_8++ )
        {
            self.visuals[var_8].origin = self.visuals[var_8].baseOrigin;
            self.visuals[var_8].angles = self.visuals[var_8].baseAngles;
            self.visuals[var_8] show();
        }

        self.trigger.origin = self.trigger.baseOrigin;
        self.curOrigin = self.trigger.baseOrigin;
    }

    if ( isdefined( self.onDrop ) )
        self [[ self.onDrop ]]( var_2 );

    clearCarrier();
    updateCompassIcons();
    updateWorldIcons();
    self.isResetting = 0;
}

setCarrier( var_0 )
{
    self.carrier = var_0;
    thread updateVisibilityAccordingToRadar();
}

clearCarrier()
{
    if ( !isdefined( self.carrier ) )
        return;

    self.carrier takeObject( self );
    self.carrier = undefined;
    self notify( "carrier_cleared" );
}

pickupTimeout()
{
    self endon( "pickup_object" );
    self endon( "stop_pickup_timeout" );
    wait 0.05;
    var_0 = getentarray( "minefield", "targetname" );
    var_1 = getentarray( "trigger_hurt", "classname" );
    var_2 = getentarray( "radiation", "targetname" );

    for ( var_3 = 0; var_3 < var_2.size; var_3++ )
    {
        if ( !self.visuals[0] istouching( var_2[var_3] ) )
            continue;

        returnHome();
        return;
    }

    for ( var_3 = 0; var_3 < var_0.size; var_3++ )
    {
        if ( !self.visuals[0] istouching( var_0[var_3] ) )
            continue;

        returnHome();
        return;
    }

    for ( var_3 = 0; var_3 < var_1.size; var_3++ )
    {
        if ( !self.visuals[0] istouching( var_1[var_3] ) )
            continue;

        returnHome();
        return;
    }

    if ( isdefined( self.autoResetTime ) )
    {
        wait(self.autoResetTime);

        if ( !isdefined( self.carrier ) )
            returnHome();
    }
}

takeObject( var_0 )
{
    if ( isdefined( self.carryIcon ) )
        self.carryIcon maps\mp\gametypes\_hud_util::destroyElem();

    if ( isdefined( self ) )
        self.carryObject = undefined;

    self notify( "drop_object" );

    if ( var_0.triggerType == "proximity" )
        thread pickupObjectDelay( var_0.trigger.origin );

    if ( maps\mp\_utility::isReallyAlive( self ) && !var_0.allowWeapons )
        common_scripts\utility::_enableWeapon();
}

trackCarrier()
{
    level endon( "game_ended" );
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "drop_object" );

    while ( isdefined( self.carryObject ) && maps\mp\_utility::isReallyAlive( self ) )
    {
        if ( self isonground() )
        {
            var_0 = bullettrace( self.origin + ( 0, 0, 20 ), self.origin - ( 0, 0, 20 ), 0, undefined );

            if ( var_0["fraction"] < 1 )
                self.carryObject.safeOrigin = var_0["position"];
        }

        wait 0.05;
    }
}

manualDropThink()
{
    level endon( "game_ended" );
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "drop_object" );

    for (;;)
    {
        while ( self attackbuttonpressed() || self fragbuttonpressed() || self secondaryoffhandbuttonpressed() || self meleebuttonpressed() )
            wait 0.05;

        while ( !self attackbuttonpressed() && !self fragbuttonpressed() && !self secondaryoffhandbuttonpressed() && !self meleebuttonpressed() )
            wait 0.05;

        if ( isdefined( self.carryObject ) && !self usebuttonpressed() )
            self.carryObject thread setDropped();
    }
}

deleteUseObject()
{
    maps\mp\_utility::_objective_delete( self.objIDAllies );
    maps\mp\_utility::_objective_delete( self.objIDAxis );
    maps\mp\gametypes\_objpoints::deleteObjPoint( self.objPoints["allies"] );
    maps\mp\gametypes\_objpoints::deleteObjPoint( self.objPoints["axis"] );
    self.trigger = undefined;
    self notify( "deleted" );
}

createUseObject( var_0, var_1, var_2, var_3 )
{
    var_4 = spawnstruct();
    var_4.type = "useObject";
    var_4.curOrigin = var_1.origin;
    var_4.ownerTeam = var_0;
    var_4.entNum = var_1 getentitynumber();
    var_4.keyObject = undefined;

    if ( issubstr( var_1.classname, "use" ) )
        var_4.triggerType = "use";
    else
        var_4.triggerType = "proximity";

    var_4.trigger = var_1;

    for ( var_5 = 0; var_5 < var_2.size; var_5++ )
    {
        var_2[var_5].baseOrigin = var_2[var_5].origin;
        var_2[var_5].baseAngles = var_2[var_5].angles;
    }

    var_4.visuals = var_2;

    if ( !isdefined( var_3 ) )
        var_3 = ( 0, 0, 0 );

    var_4.offset3d = var_3;
    var_4.compassIcons = [];
    var_4.objIDAllies = getNextObjID();
    var_4.objIDAxis = getNextObjID();
    objective_add( var_4.objIDAllies, "invisible", var_4.curOrigin );
    objective_add( var_4.objIDAxis, "invisible", var_4.curOrigin );
    objective_team( var_4.objIDAllies, "allies" );
    objective_team( var_4.objIDAxis, "axis" );
    var_4.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + var_4.entNum, var_4.curOrigin + var_3, "allies", undefined );
    var_4.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + var_4.entNum, var_4.curOrigin + var_3, "axis", undefined );
    var_4.objPoints["allies"].alpha = 0;
    var_4.objPoints["axis"].alpha = 0;
    var_4.interactTeam = "none";
    var_4.worldIcons = [];
    var_4.visibleTeam = "none";
    var_4.onUse = undefined;
    var_4.onCantUse = undefined;
    var_4.useText = "default";
    var_4.useTime = 10000;
    var_4.curProgress = 0;

    if ( var_4.triggerType == "proximity" )
    {
        var_4.teamUseTimes = [];
        var_4.teamUseTexts = [];
        var_4.numTouching["neutral"] = 0;
        var_4.numTouching["axis"] = 0;
        var_4.numTouching["allies"] = 0;
        var_4.numTouching["none"] = 0;
        var_4.touchList["neutral"] = [];
        var_4.touchList["axis"] = [];
        var_4.touchList["allies"] = [];
        var_4.touchList["none"] = [];
        var_4.useRate = 0;
        var_4.claimTeam = "none";
        var_4.claimPlayer = undefined;
        var_4.lastClaimTeam = "none";
        var_4.lastClaimTime = 0;
        var_4 thread useObjectProxThink();
    }
    else
    {
        var_4.useRate = 1;
        var_4 thread useObjectUseThink();
    }

    return var_4;
}

setKeyObject( var_0 )
{
    self.keyObject = var_0;
}

useObjectUseThink()
{
    level endon( "game_ended" );
    self endon( "deleted" );

    for (;;)
    {
        self.trigger waittill( "trigger",  var_0  );

        if ( !maps\mp\_utility::isReallyAlive( var_0 ) )
            continue;

        if ( !canInteractWith( var_0.pers["team"] ) )
            continue;

        if ( !var_0 isonground() )
            continue;

        if ( !var_0 maps\mp\_utility::isJuggernaut() && maps\mp\_utility::isKillstreakWeapon( var_0 getcurrentweapon() ) )
            continue;

        if ( isdefined( self.keyObject ) && ( !isdefined( var_0.carryObject ) || var_0.carryObject != self.keyObject ) )
        {
            if ( isdefined( self.onCantUse ) )
                self [[ self.onCantUse ]]( var_0 );

            continue;
        }

        if ( !var_0 common_scripts\utility::isWeaponEnabled() )
            continue;

        var_1 = 1;

        if ( self.useTime > 0 )
        {
            if ( isdefined( self.onBeginUse ) )
                self [[ self.onBeginUse ]]( var_0 );

            if ( !isdefined( self.keyObject ) )
                thread cantUseHintThink();

            var_2 = var_0.pers["team"];
            var_1 = useHoldThink( var_0 );
            self notify( "finished_use" );

            if ( isdefined( self.onEndUse ) )
                self [[ self.onEndUse ]]( var_2, var_0, var_1 );
        }

        if ( !var_1 )
            continue;

        if ( isdefined( self.onUse ) )
            self [[ self.onUse ]]( var_0 );
    }
}

cantUseHintThink()
{
    level endon( "game_ended" );
    self endon( "deleted" );
    self endon( "finished_use" );

    for (;;)
    {
        self.trigger waittill( "trigger",  var_0  );

        if ( !maps\mp\_utility::isReallyAlive( var_0 ) )
            continue;

        if ( !canInteractWith( var_0.pers["team"] ) )
            continue;

        if ( isdefined( self.onCantUse ) )
            self [[ self.onCantUse ]]( var_0 );
    }
}

getEarliestClaimPlayer()
{
    var_0 = self.claimTeam;

    if ( maps\mp\_utility::isReallyAlive( self.claimPlayer ) )
        var_1 = self.claimPlayer;
    else
        var_1 = undefined;

    if ( self.touchList[var_0].size > 0 )
    {
        var_2 = undefined;
        var_3 = getarraykeys( self.touchList[var_0] );

        for ( var_4 = 0; var_4 < var_3.size; var_4++ )
        {
            var_5 = self.touchList[var_0][var_3[var_4]];

            if ( maps\mp\_utility::isReallyAlive( var_5.player ) && ( !isdefined( var_2 ) || var_5.startTime < var_2 ) )
            {
                var_1 = var_5.player;
                var_2 = var_5.startTime;
            }
        }
    }

    return var_1;
}

useObjectProxThink()
{
    level endon( "game_ended" );
    self endon( "deleted" );
    thread proxTriggerThink();

    for (;;)
    {
        if ( self.useTime && self.curProgress >= self.useTime )
        {
            self.curProgress = 0;
            var_0 = getEarliestClaimPlayer();

            if ( isdefined( self.onEndUse ) )
                self [[ self.onEndUse ]]( getClaimTeam(), var_0, isdefined( var_0 ) );

            if ( isdefined( var_0 ) && isdefined( self.onUse ) )
                self [[ self.onUse ]]( var_0 );

            setClaimTeam( "none" );
            self.claimPlayer = undefined;
        }

        if ( self.claimTeam != "none" )
        {
            if ( self.useTime )
            {
                if ( !self.numTouching[self.claimTeam] )
                {
                    if ( isdefined( self.onEndUse ) )
                        self [[ self.onEndUse ]]( getClaimTeam(), self.claimPlayer, 0 );

                    setClaimTeam( "none" );
                    self.claimPlayer = undefined;
                }
                else
                {
                    self.curProgress = self.curProgress + 50 * self.useRate;

                    if ( isdefined( self.onUseUpdate ) )
                        self [[ self.onUseUpdate ]]( getClaimTeam(), self.curProgress / self.useTime, 50 * self.useRate / self.useTime );
                }
            }
            else
            {
                if ( isdefined( self.onUse ) )
                    self [[ self.onUse ]]( self.claimPlayer );

                setClaimTeam( "none" );
                self.claimPlayer = undefined;
            }
        }

        wait 0.05;
        maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
    }
}

proxTriggerThink()
{
    level endon( "game_ended" );
    self endon( "deleted" );
    var_0 = self.entNum;

    for (;;)
    {
        self.trigger waittill( "trigger",  var_1  );

        if ( !maps\mp\_utility::isReallyAlive( var_1 ) )
            continue;

        if ( isdefined( self.carrier ) )
            continue;

        if ( var_1 maps\mp\_utility::isUsingRemote() || isdefined( var_1.spawningAfterRemoteDeath ) )
            continue;

        if ( isdefined( var_1.classname ) && var_1.classname == "script_vehicle" )
            continue;

        if ( level.gameType == "ctfpro" )
        {
            if ( isdefined( self.type ) && self.type == "carryObject" && isdefined( var_1.carryFlag ) )
                continue;
        }

        if ( canInteractWith( var_1.pers["team"], var_1 ) && self.claimTeam == "none" )
        {
            if ( !isdefined( self.keyObject ) || isdefined( var_1.carryObject ) && var_1.carryObject == self.keyObject )
            {
                if ( !proxTriggerLOS( var_1 ) )
                    continue;

                setClaimTeam( var_1.pers["team"] );
                self.claimPlayer = var_1;
                var_2 = getRelativeTeam( var_1.pers["team"] );

                if ( isdefined( self.teamUseTimes[var_2] ) )
                    self.useTime = self.teamUseTimes[var_2];

                if ( self.useTime && isdefined( self.onBeginUse ) )
                    self [[ self.onBeginUse ]]( self.claimPlayer );
            }
            else if ( isdefined( self.onCantUse ) )
                self [[ self.onCantUse ]]( var_1 );
        }

        if ( self.useTime && maps\mp\_utility::isReallyAlive( var_1 ) && !isdefined( var_1.touchTriggers[var_0] ) )
            var_1 thread triggerTouchThink( self );
    }
}

proxTriggerLOS( var_0 )
{
    if ( !isdefined( self.requiresLOS ) )
        return 1;

    var_1 = var_0 geteye();
    var_2 = self.trigger.origin + ( 0, 0, 32 );
    var_3 = bullettrace( var_1, var_2, 0, undefined );

    if ( var_3["fraction"] != 1 )
    {
        var_2 = self.trigger.origin + ( 0, 0, 16 );
        var_3 = bullettrace( var_1, var_2, 0, undefined );
    }

    if ( var_3["fraction"] != 1 )
    {
        var_2 = self.trigger.origin + ( 0, 0, 0 );
        var_3 = bullettrace( var_1, var_2, 0, undefined );
    }

    return var_3["fraction"] == 1;
}

setClaimTeam( var_0 )
{
    if ( self.claimTeam == "none" && gettime() - self.lastClaimTime > 1000 )
        self.curProgress = 0;
    else if ( var_0 != "none" && var_0 != self.lastClaimTeam )
        self.curProgress = 0;

    self.lastClaimTeam = self.claimTeam;
    self.lastClaimTime = gettime();
    self.claimTeam = var_0;
    updateUseRate();
}

getClaimTeam()
{
    return self.claimTeam;
}

triggerTouchThink( var_0 )
{
    var_1 = self.pers["team"];
    var_0.numTouching[var_1]++;
    var_2 = self.guid;
    var_3 = spawnstruct();
    var_3.player = self;
    var_3.startTime = gettime();
    var_0.touchList[var_1][var_2] = var_3;

    if ( !isdefined( var_0.noUseBar ) )
        var_0.noUseBar = 0;

    self.touchTriggers[var_0.entNum] = var_0.trigger;
    var_0 updateUseRate();

    while ( maps\mp\_utility::isReallyAlive( self ) && isdefined( var_0.trigger ) && self istouching( var_0.trigger ) && !level.gameEnded && var_0.useTime )
    {
        updateProxBar( var_0, 0 );
        wait 0.05;
    }

    if ( isdefined( self ) )
    {
        updateProxBar( var_0, 1 );
        self.touchTriggers[var_0.entNum] = undefined;
    }

    if ( level.gameEnded )
        return;

    var_0.touchList[var_1][var_2] = undefined;
    var_0.numTouching[var_1]--;
    var_0 updateUseRate();
}

updateProxBar( var_0, var_1 )
{
    if ( var_1 || !var_0 canInteractWith( self.pers["team"] ) || self.pers["team"] != var_0.claimTeam || var_0.noUseBar )
    {
        if ( isdefined( self.proxBar ) )
            self.proxBar maps\mp\gametypes\_hud_util::hideElem();

        if ( isdefined( self.proxBarText ) )
            self.proxBarText maps\mp\gametypes\_hud_util::hideElem();

        return;
    }

    if ( !isdefined( self.proxBar ) )
    {
        self.proxBar = maps\mp\gametypes\_hud_util::createPrimaryProgressBar();
        self.proxBar.lastUseRate = -1;
        self.proxBar.lastHostMigrationState = 0;
    }

    if ( self.proxBar.hidden )
    {
        self.proxBar maps\mp\gametypes\_hud_util::showElem();
        self.proxBar.lastUseRate = -1;
        self.proxBar.lastHostMigrationState = 0;
    }

    if ( !isdefined( self.proxBarText ) )
    {
        self.proxBarText = maps\mp\gametypes\_hud_util::createPrimaryProgressBarText();
        var_2 = var_0 getRelativeTeam( self.pers["team"] );

        if ( isdefined( var_0.teamUseTexts[var_2] ) )
            self.proxBarText settext( var_0.teamUseTexts[var_2] );
        else
            self.proxBarText settext( var_0.useText );
    }

    if ( self.proxBarText.hidden )
    {
        self.proxBarText maps\mp\gametypes\_hud_util::showElem();
        var_2 = var_0 getRelativeTeam( self.pers["team"] );

        if ( isdefined( var_0.teamUseTexts[var_2] ) )
            self.proxBarText settext( var_0.teamUseTexts[var_2] );
        else
            self.proxBarText settext( var_0.useText );
    }

    if ( self.proxBar.lastUseRate != var_0.useRate || self.proxBar.lastHostMigrationState != isdefined( level.hostMigrationTimer ) )
    {
        if ( var_0.curProgress > var_0.useTime )
            var_0.curProgress = var_0.useTime;

        var_3 = var_0.curProgress / var_0.useTime;
        var_4 = 1000 / var_0.useTime * var_0.useRate;

        if ( isdefined( level.hostMigrationTimer ) )
            var_4 = 0;

        self.proxBar maps\mp\gametypes\_hud_util::updateBar( var_3, var_4 );
        self.proxBar.lastUseRate = var_0.useRate;
        self.proxBar.lastHostMigrationState = isdefined( level.hostMigrationTimer );
    }
}

updateUseRate()
{
    var_0 = self.numTouching[self.claimTeam];
    var_1 = 0;
    var_2 = 0;

    if ( self.claimTeam != "axis" )
        var_1 += self.numTouching["axis"];

    if ( self.claimTeam != "allies" )
        var_1 += self.numTouching["allies"];

    foreach ( var_4 in self.touchList[self.claimTeam] )
    {
        if ( var_4.player.pers["team"] != self.claimTeam )
            continue;

        if ( var_4.player.objectiveScaler == 1 )
            continue;

        var_0 *= var_4.player.objectiveScaler;
        var_2 = var_4.player.objectiveScaler;
    }

    self.useRate = 0;

    if ( var_0 && !var_1 )
        self.useRate = min( var_0, 4 );

    if ( isdefined( self.isArena ) && self.isArena && var_2 != 0 )
        self.useRate = 1 * var_2;
    else if ( isdefined( self.isArena ) && self.isArena )
        self.useRate = 1;
}

attachUseModel()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "done_using" );
    wait 1.3;
    self attach( "prop_suitcase_bomb", "tag_inhand", 1 );
    self.attachedUseModel = "prop_suitcase_bomb";
}

useHoldThink( var_0 )
{
    var_0 notify( "use_hold" );
    var_0 playerlinkto( self.trigger );
    var_0 playerlinkedoffsetenable();
    var_0 clientclaimtrigger( self.trigger );
    var_0.claimTrigger = self.trigger;
    var_1 = self.useWeapon;
    var_2 = var_0 getcurrentweapon();

    if ( isdefined( var_1 ) )
    {
        if ( var_2 == var_1 )
            var_2 = var_0.lastNonUseWeapon;

        var_0.lastNonUseWeapon = var_2;
        var_0 maps\mp\_utility::_giveWeapon( var_1 );
        var_0 setweaponammostock( var_1, 0 );
        var_0 setweaponammoclip( var_1, 0 );
        var_0 switchtoweapon( var_1 );
        var_0 thread attachUseModel();
    }
    else
        var_0 common_scripts\utility::_disableWeapon();

    self.curProgress = 0;
    self.inUse = 1;
    self.useRate = 0;
    var_0 thread personalUseBar( self );
    var_3 = useHoldThinkLoop( var_0, var_2 );

    if ( isdefined( var_0 ) )
    {
        var_0 detachUseModels();
        var_0 notify( "done_using" );
    }

    if ( isdefined( var_1 ) && isdefined( var_0 ) )
        var_0 thread takeUseWeapon( var_1 );

    if ( isdefined( var_3 ) && var_3 )
        return 1;

    if ( isdefined( var_0 ) )
    {
        var_0.claimTrigger = undefined;

        if ( isdefined( var_1 ) )
        {
            if ( var_2 != "none" )
                var_0 switchtoweapon( var_2 );
            else
                var_0 takeweapon( var_1 );
        }
        else
            var_0 common_scripts\utility::_enableWeapon();

        var_0 unlink();

        if ( !maps\mp\_utility::isReallyAlive( var_0 ) )
            var_0.killedInUse = 1;
    }

    self.inUse = 0;
    self.trigger releaseclaimedtrigger();
    return 0;
}

detachUseModels()
{
    if ( isdefined( self.attachedUseModel ) )
    {
        self detach( self.attachedUseModel, "tag_inhand" );
        self.attachedUseModel = undefined;
    }
}

takeUseWeapon( var_0 )
{
    self endon( "use_hold" );
    self endon( "death" );
    self endon( "disconnect" );
    level endon( "game_ended" );

    while ( self getcurrentweapon() == var_0 && !isdefined( self.throwingGrenade ) )
        wait 0.05;

    self takeweapon( var_0 );
}

useHoldThinkLoop( var_0, var_1 )
{
    level endon( "game_ended" );
    self endon( "disabled" );
    var_2 = self.useWeapon;
    var_3 = 1;
    var_4 = 0;
    var_5 = 1.5;

    while ( maps\mp\_utility::isReallyAlive( var_0 ) && var_0 istouching( self.trigger ) && var_0 usebuttonpressed() && !isdefined( var_0.throwingGrenade ) && !var_0 meleebuttonpressed() && self.curProgress < self.useTime && ( self.useRate || var_3 ) && !( var_3 && var_4 > var_5 ) )
    {
        var_4 += 0.05;

        if ( !isdefined( var_2 ) || var_0 getcurrentweapon() == var_2 )
        {
            self.curProgress = self.curProgress + 50 * self.useRate;
            self.useRate = 1 * var_0.objectiveScaler;
            var_3 = 0;
        }
        else
            self.useRate = 0;

        if ( self.curProgress >= self.useTime )
        {
            self.inUse = 0;
            var_0 clientreleasetrigger( self.trigger );
            var_0.claimTrigger = undefined;

            if ( isdefined( var_2 ) )
            {
                var_0 setweaponammostock( var_2, 1 );
                var_0 setweaponammoclip( var_2, 1 );

                if ( var_1 != "none" )
                    var_0 switchtoweapon( var_1 );
                else
                    var_0 takeweapon( var_2 );
            }
            else
                var_0 common_scripts\utility::_enableWeapon();

            var_0 unlink();
            return maps\mp\_utility::isReallyAlive( var_0 );
        }

        wait 0.05;
        maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
    }

    return 0;
}

personalUseBar( var_0 )
{
    self endon( "disconnect" );
    var_1 = maps\mp\gametypes\_hud_util::createPrimaryProgressBar();
    var_2 = maps\mp\gametypes\_hud_util::createPrimaryProgressBarText();
    var_2 settext( var_0.useText );
    var_3 = -1;
    var_4 = isdefined( level.hostMigrationTimer );

    while ( maps\mp\_utility::isReallyAlive( self ) && var_0.inUse && !level.gameEnded )
    {
        if ( var_3 != var_0.useRate || var_4 != isdefined( level.hostMigrationTimer ) )
        {
            if ( var_0.curProgress > var_0.useTime )
                var_0.curProgress = var_0.useTime;

            var_5 = var_0.curProgress / var_0.useTime;
            var_6 = 1000 / var_0.useTime * var_0.useRate;

            if ( isdefined( level.hostMigrationTimer ) )
                var_6 = 0;

            var_1 maps\mp\gametypes\_hud_util::updateBar( var_5, var_6 );

            if ( !var_0.useRate )
            {
                var_1 maps\mp\gametypes\_hud_util::hideElem();
                var_2 maps\mp\gametypes\_hud_util::hideElem();
            }
            else
            {
                var_1 maps\mp\gametypes\_hud_util::showElem();
                var_2 maps\mp\gametypes\_hud_util::showElem();
            }
        }

        var_3 = var_0.useRate;
        var_4 = isdefined( level.hostMigrationTimer );
        wait 0.05;
    }

    var_1 maps\mp\gametypes\_hud_util::destroyElem();
    var_2 maps\mp\gametypes\_hud_util::destroyElem();
}

updateTrigger()
{
    if ( self.triggerType != "use" )
        return;

    if ( self.interactTeam == "none" )
        self.trigger.origin = self.trigger.origin - ( 0, 0, 50000 );
    else if ( self.interactTeam == "any" )
    {
        self.trigger.origin = self.curOrigin;
        self.trigger setteamfortrigger( "none" );
    }
    else if ( self.interactTeam == "friendly" )
    {
        self.trigger.origin = self.curOrigin;

        if ( self.ownerTeam == "allies" )
            self.trigger setteamfortrigger( "allies" );
        else if ( self.ownerTeam == "axis" )
            self.trigger setteamfortrigger( "axis" );
        else
            self.trigger.origin = self.trigger.origin - ( 0, 0, 50000 );
    }
    else if ( self.interactTeam == "enemy" )
    {
        self.trigger.origin = self.curOrigin;

        if ( self.ownerTeam == "allies" )
            self.trigger setteamfortrigger( "axis" );
        else if ( self.ownerTeam == "axis" )
            self.trigger setteamfortrigger( "allies" );
        else
            self.trigger setteamfortrigger( "none" );
    }
}

updateWorldIcons()
{
    if ( self.visibleTeam == "any" )
    {
        updateWorldIcon( "friendly", 1 );
        updateWorldIcon( "enemy", 1 );
    }
    else if ( self.visibleTeam == "friendly" )
    {
        updateWorldIcon( "friendly", 1 );
        updateWorldIcon( "enemy", 0 );
    }
    else if ( self.visibleTeam == "enemy" )
    {
        updateWorldIcon( "friendly", 0 );
        updateWorldIcon( "enemy", 1 );
    }
    else
    {
        updateWorldIcon( "friendly", 0 );
        updateWorldIcon( "enemy", 0 );
    }
}

updateWorldIcon( var_0, var_1 )
{
    if ( !isdefined( self.worldIcons[var_0] ) )
        var_1 = 0;

    var_2 = getUpdateTeams( var_0 );

    for ( var_3 = 0; var_3 < var_2.size; var_3++ )
    {
        var_4 = "objpoint_" + var_2[var_3] + "_" + self.entNum;
        var_5 = maps\mp\gametypes\_objpoints::getObjPointByName( var_4 );
        var_5 notify( "stop_flashing_thread" );
        var_5 thread maps\mp\gametypes\_objpoints::stopFlashing();

        if ( var_1 )
        {
            var_5 setshader( self.worldIcons[var_0], level.objPointSize, level.objPointSize );
            var_5 fadeovertime( 0.05 );
            var_5.alpha = var_5.baseAlpha;
            var_5.isShown = 1;

            if ( isdefined( self.compassIcons[var_0] ) )
                var_5 setwaypoint( 1, 1 );
            else
                var_5 setwaypoint( 1, 0 );

            if ( self.type == "carryObject" )
            {
                if ( isdefined( self.carrier ) && !shouldPingObject( var_0 ) )
                    var_5 settargetent( self.carrier );
                else
                    var_5 cleartargetent();
            }
        }
        else
        {
            var_5 fadeovertime( 0.05 );
            var_5.alpha = 0;
            var_5.isShown = 0;
            var_5 cleartargetent();
        }

        var_5 thread hideWorldIconOnGameEnd();
    }
}

hideWorldIconOnGameEnd()
{
    self notify( "hideWorldIconOnGameEnd" );
    self endon( "hideWorldIconOnGameEnd" );
    self endon( "death" );
    level waittill( "game_ended" );

    if ( isdefined( self ) )
        self.alpha = 0;
}

updateTimer( var_0, var_1 )
{

}

updateCompassIcons()
{
    if ( self.visibleTeam == "any" )
    {
        updateCompassIcon( "friendly", 1 );
        updateCompassIcon( "enemy", 1 );
    }
    else if ( self.visibleTeam == "friendly" )
    {
        updateCompassIcon( "friendly", 1 );
        updateCompassIcon( "enemy", 0 );
    }
    else if ( self.visibleTeam == "enemy" )
    {
        updateCompassIcon( "friendly", 0 );
        updateCompassIcon( "enemy", 1 );
    }
    else
    {
        updateCompassIcon( "friendly", 0 );
        updateCompassIcon( "enemy", 0 );
    }
}

updateCompassIcon( var_0, var_1 )
{
    var_2 = getUpdateTeams( var_0 );

    for ( var_3 = 0; var_3 < var_2.size; var_3++ )
    {
        var_4 = var_1;

        if ( !var_4 && shouldShowCompassDueToRadar( var_2[var_3] ) )
            var_4 = 1;

        var_5 = self.objIDAllies;

        if ( var_2[var_3] == "axis" )
            var_5 = self.objIDAxis;

        if ( !isdefined( self.compassIcons[var_0] ) || !var_4 )
        {
            objective_state( var_5, "invisible" );
            continue;
        }

        objective_icon( var_5, self.compassIcons[var_0] );
        objective_state( var_5, "active" );

        if ( self.type == "carryObject" )
        {
            if ( maps\mp\_utility::isReallyAlive( self.carrier ) && !shouldPingObject( var_0 ) )
            {
                objective_onentity( var_5, self.carrier );
                continue;
            }

            objective_position( var_5, self.curOrigin );
        }
    }
}

shouldPingObject( var_0 )
{
    if ( var_0 == "friendly" && self.objIDPingFriendly )
        return 1;
    else if ( var_0 == "enemy" && self.objIDPingEnemy )
        return 1;

    return 0;
}

getUpdateTeams( var_0 )
{
    var_1 = [];

    if ( var_0 == "friendly" )
    {
        if ( isFriendlyTeam( "allies" ) )
            var_1[0] = "allies";
        else if ( isFriendlyTeam( "axis" ) )
            var_1[0] = "axis";
    }
    else if ( var_0 == "enemy" )
    {
        if ( !isFriendlyTeam( "allies" ) )
            var_1[var_1.size] = "allies";

        if ( !isFriendlyTeam( "axis" ) )
            var_1[var_1.size] = "axis";
    }

    return var_1;
}

shouldShowCompassDueToRadar( var_0 )
{
    if ( !isdefined( self.carrier ) )
        return 0;

    if ( self.carrier maps\mp\_utility::_hasPerk( "specialty_gpsjammer" ) )
        return 0;

    return getteamradar( var_0 );
}

updateVisibilityAccordingToRadar()
{
    self endon( "death" );
    self endon( "carrier_cleared" );

    for (;;)
    {
        level waittill( "radar_status_change" );
        updateCompassIcons();
    }
}

setOwnerTeam( var_0 )
{
    self.ownerTeam = var_0;
    updateTrigger();
    updateCompassIcons();
    updateWorldIcons();
}

getOwnerTeam()
{
    return self.ownerTeam;
}

setUseTime( var_0 )
{
    self.useTime = int( var_0 * 1000 );
}

setUseText( var_0 )
{
    self.useText = var_0;
}

setTeamUseTime( var_0, var_1 )
{
    self.teamUseTimes[var_0] = int( var_1 * 1000 );
}

setTeamUseText( var_0, var_1 )
{
    self.teamUseTexts[var_0] = var_1;
}

setUseHintText( var_0 )
{
    self.trigger sethintstring( var_0 );
}

allowCarry( var_0 )
{
    self.interactTeam = var_0;
}

allowUse( var_0 )
{
    self.interactTeam = var_0;
    updateTrigger();
}

setVisibleTeam( var_0 )
{
    self.visibleTeam = var_0;
    updateCompassIcons();
    updateWorldIcons();
}

setModelVisibility( var_0 )
{
    if ( var_0 )
    {
        for ( var_1 = 0; var_1 < self.visuals.size; var_1++ )
        {
            self.visuals[var_1] show();

            if ( self.visuals[var_1].classname == "script_brushmodel" || self.visuals[var_1].classname == "script_model" )
            {
                foreach ( var_3 in level.players )
                {
                    if ( var_3 istouching( self.visuals[var_1] ) )
                        var_3 maps\mp\_utility::_suicide();
                }

                self.visuals[var_1] thread makeSolid();
            }
        }
    }
    else
    {
        for ( var_1 = 0; var_1 < self.visuals.size; var_1++ )
        {
            self.visuals[var_1] hide();

            if ( self.visuals[var_1].classname == "script_brushmodel" || self.visuals[var_1].classname == "script_model" )
            {
                self.visuals[var_1] notify( "changing_solidness" );
                self.visuals[var_1] notsolid();
            }
        }
    }
}

makeSolid()
{
    self endon( "death" );
    self notify( "changing_solidness" );
    self endon( "changing_solidness" );

    for (;;)
    {
        for ( var_0 = 0; var_0 < level.players.size; var_0++ )
        {
            if ( level.players[var_0] istouching( self ) )
                break;
        }

        if ( var_0 == level.players.size )
        {
            self solid();
            break;
        }

        wait 0.05;
    }
}

setCarrierVisible( var_0 )
{
    self.carrierVisible = var_0;
}

setCanUse( var_0 )
{
    self.useTeam = var_0;
}

set2DIcon( var_0, var_1 )
{
    self.compassIcons[var_0] = var_1;
    updateCompassIcons();
}

set3DIcon( var_0, var_1 )
{
    self.worldIcons[var_0] = var_1;
    updateWorldIcons();
}

set3DUseIcon( var_0, var_1 )
{
    self.worldUseIcons[var_0] = var_1;
}

setCarryIcon( var_0 )
{
    self.carryIcon = var_0;
}

disableObject()
{
    self notify( "disabled" );

    if ( self.type == "carryObject" )
    {
        if ( isdefined( self.carrier ) )
            self.carrier takeObject( self );

        for ( var_0 = 0; var_0 < self.visuals.size; var_0++ )
            self.visuals[var_0] hide();
    }

    self.trigger common_scripts\utility::trigger_off();
    setVisibleTeam( "none" );
}

enableObject()
{
    if ( self.type == "carryObject" )
    {
        for ( var_0 = 0; var_0 < self.visuals.size; var_0++ )
            self.visuals[var_0] show();
    }

    self.trigger common_scripts\utility::trigger_on();
    setVisibleTeam( "any" );
}

getRelativeTeam( var_0 )
{
    if ( var_0 == self.ownerTeam )
        return "friendly";
    else
        return "enemy";
}

isFriendlyTeam( var_0 )
{
    if ( self.ownerTeam == "any" )
        return 1;

    if ( self.ownerTeam == var_0 )
        return 1;

    return 0;
}

canInteractWith( var_0, var_1 )
{
    switch ( self.interactTeam )
    {
        case "none":
            return 0;
        case "any":
            return 1;
        case "friendly":
            if ( var_0 == self.ownerTeam )
                return 1;
            else
                return 0;
        case "enemy":
            if ( var_0 != self.ownerTeam )
                return 1;
            else
                return 0;
        default:
            return 0;
    }
}

isTeam( var_0 )
{
    if ( var_0 == "neutral" )
        return 1;

    if ( var_0 == "allies" )
        return 1;

    if ( var_0 == "axis" )
        return 1;

    if ( var_0 == "any" )
        return 1;

    if ( var_0 == "none" )
        return 1;

    return 0;
}

isRelativeTeam( var_0 )
{
    if ( var_0 == "friendly" )
        return 1;

    if ( var_0 == "enemy" )
        return 1;

    if ( var_0 == "any" )
        return 1;

    if ( var_0 == "none" )
        return 1;

    return 0;
}

getEnemyTeam( var_0 )
{
    if ( var_0 == "neutral" )
        return "none";
    else if ( var_0 == "allies" )
        return "axis";
    else
        return "allies";
}

getNextObjID()
{
    if ( !isdefined( level.reclaimedReservedObjectives ) || level.reclaimedReservedObjectives.size < 1 )
    {
        var_0 = level.numGametypeReservedObjectives;
        level.numGametypeReservedObjectives++;
    }
    else
    {
        var_0 = level.reclaimedReservedObjectives[level.reclaimedReservedObjectives.size - 1];
        level.reclaimedReservedObjectives[level.reclaimedReservedObjectives.size - 1] = undefined;
    }

    if ( var_0 > 31 )
        var_0 = 31;

    return var_0;
}

getLabel()
{
    var_0 = self.trigger.script_label;

    if ( !isdefined( var_0 ) )
    {
        var_0 = "";
        return var_0;
    }

    if ( var_0[0] != "_" )
        return "_" + var_0;

    return var_0;
}
