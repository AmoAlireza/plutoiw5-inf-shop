// IW5 PC GSC
// Decompiled by https://github.com/xensik/gsc-tool

CodeCallback_StartGameType()
{
    if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
        level waittill( "eternity" );

    if ( !isdefined( level.gametypestarted ) || !level.gametypestarted )
    {
        [[ level.callbackStartGameType ]]();
        level.gametypestarted = 1;
    }
}

CodeCallback_PlayerConnect()
{
    if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
        level waittill( "eternity" );

    self endon( "disconnect" );
    [[ level.callbackPlayerConnect ]]();
}

CodeCallback_PlayerDisconnect()
{
    self notify( "disconnect" );
    [[ level.callbackPlayerDisconnect ]]();
}

CodeCallback_PlayerDamage( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9 )
{
    self endon( "disconnect" );
    [[ level.callbackPlayerDamage ]]( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9 );
}

CodeCallback_PlayerKilled( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8 )
{
    self endon( "disconnect" );
    [[ level.callbackPlayerKilled ]]( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8 );
}

CodeCallback_VehicleDamage( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9, var_10, var_11 )
{
    if ( isdefined( self.damageCallback ) )
        self [[ self.damageCallback ]]( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9, var_10, var_11 );
    else
        self vehicle_finishdamage( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9, var_10, var_11 );
}

CodeCallback_CodeEndGame()
{
    self endon( "disconnect" );
    [[ level.callbackCodeEndGame ]]();
}

CodeCallback_PlayerLastStand( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8 )
{
    self endon( "disconnect" );
    [[ level.callbackPlayerLastStand ]]( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8 );
}

CodeCallback_PlayerMigrated()
{
    self endon( "disconnect" );
    [[ level.callbackPlayerMigrated ]]();
}

CodeCallback_HostMigration()
{
    [[ level.callbackHostMigration ]]();
}

SetupDamageFlags()
{
    level.iDFLAGS_RADIUS = 1;
    level.iDFLAGS_NO_ARMOR = 2;
    level.iDFLAGS_NO_KNOCKBACK = 4;
    level.iDFLAGS_PENETRATION = 8;
    level.iDFLAGS_STUN = 16;
    level.iDFLAGS_SHIELD_EXPLOSIVE_IMPACT = 32;
    level.iDFLAGS_SHIELD_EXPLOSIVE_IMPACT_HUGE = 64;
    level.iDFLAGS_SHIELD_EXPLOSIVE_SPLASH = 128;
    level.iDFLAGS_NO_TEAM_PROTECTION = 256;
    level.iDFLAGS_NO_PROTECTION = 512;
    level.iDFLAGS_PASSTHRU = 1024;
}

SetupCallbacks()
{
    SetDefaultCallbacks();
    SetupDamageFlags();
}

StartGameTypeWithDev()
{
    maps\mp\gametypes\_gamelogic::Callback_StartGameType();

    /#
    maps\mp\gametypes\_dev::init();
    #/
}

SetDefaultCallbacks()
{
    level.callbackStartGameType = ::StartGameTypeWithDev;
    level.callbackPlayerConnect = maps\mp\gametypes\_playerlogic::Callback_PlayerConnect;
    level.callbackPlayerDisconnect = maps\mp\gametypes\_playerlogic::Callback_PlayerDisconnect;
    level.callbackPlayerDamage = maps\mp\gametypes\_damage::Callback_PlayerDamage;
    level.callbackPlayerKilled = maps\mp\gametypes\_damage::Callback_PlayerKilled;
    level.callbackCodeEndGame = maps\mp\gametypes\_gamelogic::Callback_CodeEndGame;
    level.callbackPlayerLastStand = maps\mp\gametypes\_damage::Callback_PlayerLastStand;
    level.callbackPlayerMigrated = maps\mp\gametypes\_playerlogic::Callback_PlayerMigrated;
    level.callbackHostMigration = maps\mp\gametypes\_hostmigration::Callback_HostMigration;
}

AbortLevel()
{
    level.callbackStartGameType = ::callbackVoid;
    level.callbackPlayerConnect = ::callbackVoid;
    level.callbackPlayerDisconnect = ::callbackVoid;
    level.callbackPlayerDamage = ::callbackVoid;
    level.callbackPlayerKilled = ::callbackVoid;
    level.callbackCodeEndGame = ::callbackVoid;
    level.callbackPlayerLastStand = ::callbackVoid;
    level.callbackPlayerMigrated = ::callbackVoid;
    level.callbackHostMigration = ::callbackVoid;
    setdvar( "g_gametype", "dm" );
    exitlevel( 0 );
}

callbackVoid()
{

}
