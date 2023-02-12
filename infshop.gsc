#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\_gameobjects;
#include maps\mp\killstreaks\_autoshotgun;

init()
{
    replacefunc(maps\mp\killstreaks\_nuke::nukeVision, ::disableNukeVision); 
	replacefunc(maps\mp\killstreaks\_nuke::nuke_EMPJam, ::disableNukeEmp);
	replacefunc(maps\mp\killstreaks\_nuke::nukeEffects, ::disableNukeEffects);

    level.HeliPointSpawned = false;
    level.BoxWeaponSpawned = false;

    level thread onPlayerConnect();
    level thread HeliPoint();
    level thread BoxWeapon();
    thread Settings();
    thread RandomGun();
    thread OnPlayerSay();
    thread MapEdits();
    
    level.callbackPlayerKilled = ::Callback_PlayerKilled;
    level.callbackPlayerDamage = ::Callback_PlayerDamage;
    
    level.fx["megabullet"] = loadfx( "fire/fire_smoke_trail_l" );
    level.fx["flare"] = loadfx( "misc/aircraft_light_wingtip_red" );
    level.fx["smoke"] = loadfx( "smoke/smoke_grenade_11sec_mp" );
    level.fx["weaponfx"] = loadFx("misc/ui_flagbase_black");

    PreCacheShader("specialty_marksman");
    PreCacheShader("specialty_bulletpenetration");
    PreCacheShader("specialty_moredamage");
    PreCacheShader("specialty_longersprint");
    precacheshader("white");

    upangles = vectorToAngles((0, 0, 1000));
	level.forward_fx = anglesToForward(upangles);
	level.right_fx = anglesToRight(upangles);
}


onPlayerConnect() 
{
    for(;;)
    {
        level waittill("connected", player);
        
		player thread TitleBar();
		player thread ShowPoint();
        player thread ShowShop();
		player thread onPlayerSpawned();
		player thread ShowCreator();
        player thread WelcomeMessage();
        player thread StarterPoint();
        player thread MaxPoint();
        player thread ButtonSuicideAmmo();
        player thread TeamsSpeed();
        player thread AdminOptions();
        player.MegaBulletBuyed = false;
        player.NoRecoilBuyed = false;
        player.MoreDamageBuyed = false;
        player.MoreSpeedBuyed = false;
        player.SpeedBuyed = false;
    }
}

Callback_PlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
    if (sMeansofDeath != "MOD_FALLING" && sMeansofDeath != "MOD_TRIGGER_HURT" && sMeansofDeath != "MOD_SUICIDE" && sMeansofDeath != "MOD_UNKNOWN")
    {
        if (attacker.pers["team"] == "axis" && attacker != self)
        {
            attacker PointAddZ(2000);
        }
        if (attacker.pers["team"] == "allies" && attacker != self)
        {
            attacker PointAdd(100);
        }
    }
    
	//attacker notify("kill");
	self maps\mp\gametypes\_damage::Callback_PlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
}

Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
    if (sMeansofDeath != "MOD_FALLING" && sMeansofDeath != "MOD_TRIGGER_HURT" && sMeansofDeath != "MOD_SUICIDE" && sMeansofDeath != "MOD_EXPLOSIVE")
    {
        if(sWeapon == "iw5_striker_mp_silencer03_camo11" && sMeansofDeath != "MOD_MELEE")
        {
            eAttacker iPrintLnBold("^3this weapon does not deal any damage");
            return;
        }
    }

	self maps\mp\gametypes\_damage::Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
}

AdminOptions()
{
	createDirectory("scripts//infshop//admins");
    if(fileExists("scripts//infshop//admins//" + self.GUID))
    {
        self endon("disconnect");
	    level endon("game_ended");

	    self notifyOnPlayerCommand("flyy", "+frag");
	    while(1)
	    {
		    self waittill("flyy");

		    if(self.sessionstate == "playing")
            {
                self.sessionstate = "spectator";
	        }
	        else
            {
                self.sessionstate = "playing";
            }
	    }
    }
}

HeliPoint()
{
    for(;;)
    {
        wait(0.05);
        level waittill("connected", player);
        if(level.players.size >= 9 && level.HeliPointSpawned == false)
        {
            wait(180);
            switch(GetDvar("mapname"))
            {
		        case "mp_dome":
		        thread Heli((2017.11, 11783.3, 2308.92), (-6127.99, -12960, 1331.66), (0,-110,0), 37);
		        break;
                case "mp_seatown":
                thread Heli((309.352, 10958.7, 1920.24), (369.671, -11634.8, 1917.25), (0,-90,0), 34);
                break;
                case "mp_plaza2":
                thread Heli((-3122.76, 9822.14, 3328.13), (-1646.84, -6307.17, 2853.16), (0,-90,0), 26);
                break;
                case "mp_mogadishu":
                thread Heli((5799.62, -21994.3, 1899.71), (-512.794, 19661.3, 2165.66), (0,100,0), 50);
                break;
                case "mp_paris":
                thread Heli((-15160.1, 470.569, 6113.39), (10469.7, 1059.4, 2741.38), (0,0,0), 34);
                break;
                case "mp_exchange":
                thread Heli((9215.51, 201.59, 3397.61), (-4581.5, 2194.32, 3565.58), (0,-190,0), 32);
                break;
                case "mp_bootleg":
                thread Heli((-1258.6, 14162.5, 2852.95), (479.166, -16296.9, 2593.84), (0,-88,0), 42);
                break;
                case "mp_carbon":
                thread Heli((-6616, -3772.6, 5296.73), (6264.29, -2752.62, 6087.11), (0,5,0), 33);
                break;
                case "mp_hardhat":
                thread Heli((5199.27, 1093.85, 2560.13), (-7048.14, 1229.98, 2852.25), (0,180,0), 31);
                break;
                case "mp_alpha":
                thread Heli((-869.694, -8791.12, 3417.2), (-140.68, 9047.81, 4147.39), (0,88,0), 40);
                break;
                case "mp_village":
                thread Heli((7443.5, 3769.85, 3664.51), (-7045.29, -2643.63, 4511.07), (0,-158,0), 36);
                break;
                case "mp_lambeth":
                thread Heli((-5929.95, -5379.14, 2666.12), (8500.4, 7293.88, 3283.23), (0,40,0), 42);
                break;
                case "mp_radar":
                thread Heli((-14135.5, 14836.4, 5522.13), (8657.34, -16392.2, 6454.95), (0,303,0), 63);
                break;
                case "mp_interchange":
                thread Heli((9790.84, -6465.32, 2489.25), (-17416.8, 14620.5, 2361.16), (0,145,0), 63);
                break;
                case "mp_underground":
                thread Heli((3033.22, -11176.2, 3572.95), (-2864.52, 8429.74, 1935.42), (0,105,0), 43);
                break;
                case "mp_bravo":
                thread Heli((9859.55, 543.33, 4159.98), (-5747.41, 337.784, 3675.34), (0,180,0), 38);
                break;
            }
        }
    }
}

Heli(startorg, endorg, angle, htime)
{
    level.HeliPointSpawned = true;
    say("^1****^3 Heli Point is coming^1****^7(the person destroy Heli Point get 10K H&Z point");
    helicopter = spawn("script_model", startorg);
    helicopter setModel("vehicle_av8b_harrier_jet_mp");
    helicopter.angles = angle;
    playSoundAtPos(helicopter.origin,"missile_incoming");
    playSoundAtPos(helicopter.origin,"veh_mig29_sonic_boom");
	helicopter setCanDamage( true );
	helicopter.health = 800;
    helicopter moveTo((endorg), htime);
	for ( ;; )
	{
		helicopter waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags, weapon );

		if (!isdefined( helicopter ))
		{
		    return;
		}

		if ( helicopter.health <= 0 )
		{
			if ( isDefined( helicopter ) && helicopter.origin != endorg)
			{
				fxhandle = int(loadfx("explosions/aerial_explosion_ac130_coop"));
                effect = spawnfx(fxhandle, helicopter.origin);
                triggerfx(effect);
                playSoundAtPos(helicopter.origin,"cobra_helicopter_crash");
				helicopter delete();
                say("^0=>^1"+attacker.name+"^0<= ^3was destroy Heli Point and win 10k point(H & Z point)");
                attacker iPrintLnBold("^3you win ^110k^3 H & Z point");
                attacker PointAdd(10000);
                attacker PointAddZ(10000);
				wait(3);
				effect delete();
			}
            else
            {
                attacker iPrintLnBold("^1you destroy Heli Point too late");
                helicopter delete();
            }
		}
	}
}

BoxWeapon()
{
    for(;;)
    {
        level endon("game_ended");
        wait(0.05);
        if(level.BoxWeaponSpawned == false)
        {
            wait(40);
            switch(GetDvar("mapname"))
            {
		        case "mp_dome":
		        thread SpawnWeapon(undefined,"weapon", (-209.14, 1646.25, 89.9118), 1);
		        break;
                case "mp_seatown":
                thread SpawnWeapon(undefined,"weapon", (2667.72, 443.153, 388.613), 1);
                break;
                case "mp_plaza2":
                thread SpawnWeapon(undefined,"weapon", (3906.33, 612.205, 2302.39), 1);
                break;
                case "mp_mogadishu":
                thread SpawnWeapon(undefined,"weapon", (10129.3, -635.636, 183.192), 1);
                break;
                case "mp_paris":
                thread SpawnWeapon(undefined,"weapon", (2243.55, -602.521, 416.811), 1);
                break;
                case "mp_exchange":
                thread SpawnWeapon(undefined,"weapon", (1453.07, 1268.54, 459.215), 1);
                break;
                case "mp_bootleg":
                thread SpawnWeapon(undefined,"weapon", (-3022.83, -271.204, 153.908), 1);
                break;
                case "mp_carbon":
                thread SpawnWeapon(undefined,"weapon", (-3597.64, -4494.47, 3742.74), 1);
                break;
                case "mp_hardhat":
                thread SpawnWeapon(undefined,"weapon", (-119.306, 1429.83, 675.036), 1);
                break;
                case "mp_alpha":
                thread SpawnWeapon(undefined,"weapon", (-19.9993, 213.079, 660.9), 1);
                break;
                case "mp_village":
                thread SpawnWeapon(undefined,"weapon", (-734.336, -1819.85, 765.565), 1);
                break;
                case "mp_lambeth":
                thread SpawnWeapon(undefined,"weapon", (1028.16, 179.778, 39.5788), 1);
                break;
                case "mp_radar":
                thread SpawnWeapon(undefined,"weapon", (-5749.81, 2167.68, 2049.63), 1);
                break;
                case "mp_interchange":
                thread SpawnWeapon(undefined,"weapon", (-4756.33, 14247.9, 979.369), 1);
                break;
                case "mp_underground":
                thread SpawnWeapon(undefined,"weapon", (-1967.97, -442.418, 253.199), 1);
                break;
                case "mp_bravo":
                thread SpawnWeapon(undefined,"weapon", (108.391, -650.242, 1425.17), 1);
                break;
            }
        }
    } 
}

SpawnWeapon( wfunc, weaponname, location, takeonce)
{
	level endon("game_ended");

    level.BoxWeaponSpawned = true;
    weapon = level.rnddrop[randomIntRange(0,level.rnddrop.size)];
    weapon_model = getweaponmodel(weapon);
    wep=spawn("script_model",location);
    wep setModel(weapon_model);
    
    //boxwep = int(loadfx("misc/ui_flagbase_gold"));
    effect = spawnfx(level.fx["weaponfx"], wep.origin - (0, 0, 30), level.forward_fx, level.right_fx);
    triggerfx(effect);
    while(1)
    {
        wep rotateyaw(360, 5);
        foreach(player in level.players)
        {
            radius=distance(wep.origin,player.origin);
            if(player.pers["team"] == "allies")
            {
                if(radius<55)
                {
                    player setLowerMessage(weaponname,"Press ^3[{+activate}]^7 to take "+weaponname);
                    wait 0.05;
                    if(player UseButtonPressed())
                    {
                        if(!isDefined(wfunc))
                        {
                            level.BoxWeaponSpawned = false;
                            player takeWeapon(player getCurrentWeapon());
                            player _giveWeapon(weapon);
                            player switchToWeapon(weapon);
                            
                            wait 0.05;
                            if(takeonce)
                            {
                                wep delete();
                                effect delete();
                                foreach(player in level.players)
                                {
                                    player clearLowerMessage(weaponname);
                                }
                                return;
                            }
                        }
                        else
                        {
                            player clearLowerMessage(weaponname);
                            player [[wfunc]]();
                            wait 0.05;
                        }
                    }
                }
                else
                {
                    player clearLowerMessage(weaponname);
                }
            }
            else
            {
                if(radius<55 && player UseButtonPressed())
                {
                    player iPrintLnBold("^1infecteds can't take weapon");
                }
            }
            wait 0.05;
        }
        wait 0.05;
    }
}

TPBack()
{
    switch(GetDvar("mapname"))
    {
        case "mp_dome":
        self setorigin((-884.789, -467.071, -412.332));
        break;

        case "mp_seatown":
        self setorigin((-966.699, -1879.05, 508.125));
        break;

        case "mp_plaza2":
        self setorigin((940.817, 575.267, 1718.13));
        break;

        case "mp_mogadishu":
        self setorigin((-1514.35, -818.056, 2.125));
        break;

        case "mp_paris":
        self setorigin((686.833, 765.474, 112.125));
        break;

        case "mp_exchange":
        self setorigin((1357.63, -726.559, 1722.13));
        break;

        case "mp_bootleg":
        self setorigin((1329.87, -1422.36, -65.875));
        break;

        case "mp_carbon":
        self setorigin((-1453.92, -3586.31, 3918.63));
        break;

        case "mp_hardhat":
        self setorigin((3231.17, -1168.01, 384.125));
        break;

        case "mp_alpha":
        self setorigin((-791.016, 3235.25, 292.125));
        break;

        case "mp_village":
        self setorigin((-95.9129, 332.947, 174.931));
        break;

        case "mp_lambeth":
        self setorigin((596.393, 1722.13, -50.875));
        break;

        case "mp_radar":
        self setorigin((-4785.5, -733.729, 2236));
        break;

        case "mp_interchange":
        self setorigin((-10162.8, 4953.83, 708.125));
        break;

        case "mp_underground":
        self setorigin((1818.83, 1589.64, 0.125001));
        break;

        case "mp_bravo":
        self setorigin((-2032.9, 829.916, 988.526));
        break;

        default:
        break;
    }
}

ButtonSuicideAmmo()
{
	level endon("game_ended");

	self notifyOnPlayerCommand("thisismainbutt", "+actionslot 6");
	for(;;)
	{
        self waittill("thisismainbutt");
        hpointcostammo = fopen("scripts//infshop//players//GUID"+self.GUID+"//h."+self.GUID+".point", "r");
        readhpointcostammo = fread(hpointcostammo);
        fclose(hpointcostammo);
        inthpointammo = int(readhpointcostammo);
		if(self.pers["team"] == "allies")
        {
            if (700 <= inthpointammo)
            {
                self PointCost(700);
                self iPrintLnBold("^3max ^1ammo ^3purchased");
                self giveMaxAmmo(self getCurrentWeapon());
                self ShopFX();
            }
            else
            {
                self iprintlnbold("^1you don't have enough points!");
            }
            
        }
        if(self.pers["team"] == "axis")
        {
            self Suicide();
        }
	}
}

StarterPoint()
{
    if (!fileExists("scripts//infshop//players//GUID"+self.GUID+"//h."+self.GUID+".point") && !fileExists("scripts//infshop//players//GUID"+self.GUID+"//z."+self.GUID+".point"))
    {
        writeFile("scripts//infshop//players//GUID"+self.GUID+"//h."+self.GUID+".point", "10000", false);
        writeFile("scripts//infshop//players//GUID"+self.GUID+"//z."+self.GUID+".point", "10000", false);
        writeFile("scripts//infshop//players//GUID"+self.GUID+"//"+self.name, "", false);
    }
}

MaxPoint()
{
	level endon("game_ended");

    filehp = fopen("scripts//infshop//players//GUID"+self.GUID+"//h."+self.GUID+".point", "r");
    readhp = fread(filehp);
    fclose(filehp);
    inthp = int(readhp);

    filezp = fopen("scripts//infshop//players//GUID"+self.GUID+"//z."+self.GUID+".point", "r");
    readzp = fread(filezp);
    fclose(filezp);
    intzp = int(readzp);

    if (700001 <= inthp)
    {
        writeFile("scripts//infshop//players//GUID"+self.GUID+"//h."+self.GUID+".point", "700000", false);
        self iprintlnbold("^3maximum H point is ^1=> 700,000 <=");
        wait(2);
        self iprintlnbold("^3your point changed to ^1=> 700,000 <=");
    }

    if (700001 <= intzp)
    {
        writeFile("scripts//infshop//players//GUID"+self.GUID+"//z."+self.GUID+".point", "700000", false);
        self iprintlnbold("^3maximum Z point is ^1=> 700,000 <=");
        wait(2);
        self iprintlnbold("^3your point changed to ^1=> 700,000 <=");
    }
}

TitleBar()
{
	self endon("disconnect");
	level endon("game_ended");

	self.Motd = self createfontstring("Default", 1.2);
    self.Motd.Foreground = true;
    self.Motd.HideWhenInMenu = true;
    self.Motd.GlowAlpha = 1;
    self.Motd.glowcolor = (0.255 , 0 , 0.847);
	for(;;)
	{
		self.Motd SetText("^5 Press ^3(^1[{+actionslot 6}]^3) ^5Button To Kill Your Self ^1(infected only) ^5or Buy Ammo ^1(Human only + cost 700 H)");
        self.Motd SetPoint("CENTER", "BOTTOM", 1100, -8);
        self.Motd moveovertime(30);
        self.Motd.X = -700;
        wait 35;
	}
}

WelcomeMessage()
{
    hud = self createfontstring("objective", 1.5);
    hud SetPulseFX(200, 11500, 1000);
    hud.HideWhenInMenu = false;
    hud.Foreground = true;
    hud.alpha = 1;
    hud.GlowAlpha = 5;
    hud.glowcolor = (0.6, 0.2, 1);
    hud SetPoint("LEFT", "LEFT", 130, 160);
    hud SetText("^3Welcome To ^1Infected Shop ^3Server By ^1RAVEN\n ^6BETA 0.1");
    wait 0.05;
    return hud;
}

OnPlayerSay()
{
    self endon("disconnect");

    for(;;)
    {
        level waittill( "say", message, player);
        level.args = [];
        
        str1 = strTok( message, "" );
        
        i = 0;
        foreach ( s in str1 )
        {
            if ( i > 2 )
            {
                break;
            }
            level.args[i] = s;
            i++;
        }

        str2 = strTok( level.args[0], " " );

        i = 0; 

        foreach( s in str2 )
        {
            if ( i > 2 )
            {
                break;
            }
            level.args[i] = s;
            i++;
        }

        hpointcost = fopen("scripts//infshop//players//GUID"+player.GUID+"//h."+player.GUID+".point", "r");
        readhpointcost = fread(hpointcost);
        fclose(hpointcost);
        inthpoint = int(readhpointcost);

        zpointcost = fopen("scripts//infshop//players//GUID"+player.GUID+"//z."+player.GUID+".point", "r");
        readzpointcost = fread(zpointcost);
        fclose(zpointcost);
        intzpoint = int(readzpointcost);

        nopoint = "^1you don't have enough points!";

        // This Is human cmd's //
        if(player.pers["team"] == "allies")
        {
            switch ( toLower(level.args[0]) )
            {
                case "!1":
                if (50 <= inthpoint)
                {
                    player PointCost(50);
                    player iprintlnbold("^3random ^1pistol ^3was purchased");

                    gun = level.rndpistol[randomIntRange(0,level.rndpistol.size)];
                    if(player getcurrentWeapon() != "iw5_usp45_mp_silencer02" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02" && player getcurrentWeapon() != "iw5_mp412_mp" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02")
                    {
                        player DropItem(player getcurrentWeapon());
                    }
                    player giveWeapon(gun);
                    player giveStartAmmo(gun);
                    player SwitchToWeaponImmediate(gun);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!2":
                if (300 <= inthpoint)
                {
                    player PointCost(300);
                    player iprintlnbold("^3random ^1auto pistol ^3was purchased");

                    gun = level.rndautopistol[randomIntRange(0,level.rndautopistol.size)];
                    if(player getcurrentWeapon() != "iw5_usp45_mp_silencer02" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02" && player getcurrentWeapon() != "iw5_mp412_mp" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02")
                    {
                        player DropItem(player getcurrentWeapon());
                    }
                    player giveWeapon(gun);
                    player giveStartAmmo(gun);
                    player SwitchToWeaponImmediate(gun);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!3":
                if (500 <= inthpoint)
                {
                    player PointCost(500);
                    player iprintlnbold("^3random ^1smg ^3was purchased");

                    gun = level.rndsmg[randomIntRange(0,level.rndsmg.size)];
                    if(player getcurrentWeapon() != "iw5_usp45_mp_silencer02" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02" && player getcurrentWeapon() != "iw5_mp412_mp" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02")
                    {
                        player DropItem(player getcurrentWeapon());
                    }
                    player giveWeapon(gun);
                    player giveStartAmmo(gun);
                    player SwitchToWeaponImmediate(gun);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!4":
                if (700 <= inthpoint)
                {
                    player PointCost(700);
                    player iprintlnbold("^3random ^1AR ^3was purchased");

                    gun = level.rndar[randomIntRange(0,level.rndar.size)];
                    if(player getcurrentWeapon() != "iw5_usp45_mp_silencer02" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02" && player getcurrentWeapon() != "iw5_mp412_mp" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02")
                    {
                        player DropItem(player getcurrentWeapon());
                    }
                    player giveWeapon(gun);
                    player giveStartAmmo(gun);
                    player SwitchToWeaponImmediate(gun);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!5":
                if (50 <= inthpoint)
                {
                    player PointCost(50);
                    player iprintlnbold("^3random ^1shotgun ^3was purchased");

                    gun = level.rndsg[randomIntRange(0,level.rndsg.size)];
                    if(player getcurrentWeapon() != "iw5_usp45_mp_silencer02" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02" && player getcurrentWeapon() != "iw5_mp412_mp" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02")
                    {
                        player DropItem(player getcurrentWeapon());
                    }
                    player giveWeapon(gun);
                    player giveStartAmmo(gun);
                    player SwitchToWeaponImmediate(gun);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!6":
                if (800 <= inthpoint)
                {
                    player PointCost(800);
                    player iprintlnbold("^3random ^1sniper ^3was purchased");

                    gun = level.rndsnip[randomIntRange(0,level.rndsnip.size)];
                    if(player getcurrentWeapon() != "iw5_usp45_mp_silencer02" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02" && player getcurrentWeapon() != "iw5_mp412_mp" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02")
                    {
                        player DropItem(player getcurrentWeapon());
                    }
                    player giveWeapon(gun);
                    player giveStartAmmo(gun);
                    player SwitchToWeaponImmediate(gun);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!7":
                if (1000 <= inthpoint)
                {
                    player PointCost(1000);
                    player iprintlnbold("^3random ^1LMG ^3was purchased");

                    gun = level.rndlmg[randomIntRange(0,level.rndlmg.size)];
                    if(player getcurrentWeapon() != "iw5_usp45_mp_silencer02" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02" && player getcurrentWeapon() != "iw5_mp412_mp" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02")
                    {
                        player DropItem(player getcurrentWeapon());
                    }
                    player giveWeapon(gun);
                    player giveStartAmmo(gun);
                    player SwitchToWeaponImmediate(gun);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!8":
                if (400 <= inthpoint)
                {
                    player PointCost(400);
                    player iprintlnbold("^3random ^1luncher ^3was purchased");

                    gun = level.rndln[randomIntRange(0,level.rndln.size)];
                    if(player getcurrentWeapon() != "iw5_usp45_mp_silencer02" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02" && player getcurrentWeapon() != "iw5_mp412_mp" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02")
                    {
                        player DropItem(player getcurrentWeapon());
                    }
                    player giveWeapon(gun);
                    player giveStartAmmo(gun);
                    player SwitchToWeaponImmediate(gun);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!dmg":
                if(player.MoreDamageBuyed == false)
                {
                    if (400 <= inthpoint)
                    {
                        player PointCost(400);
                        player iprintlnbold("^1more damage ^3was purchased");

                        player SetPerk("specialty_bulletpenetration", true, true);
                        player SetPerk("specialty_longerrange", true, true);
                        player thread SetIcon("specialty_bulletpenetration", 165,10, true);
                        player.MoreDamageBuyed = true;
                        player ShopFX();
                    }
                    else
                    {
                        player iprintlnbold(nopoint);
                    }
                }
                else
                {
                    player iPrintLnBold("^3you already have this option");
                }
                break;

                case "!mb":
                if(player.MegaBulletBuyed == false)
                {
                    if (4500 <= inthpoint)
                    {
                        player PointCost(4500);
                        player iprintlnbold("^1mega bullet ^3was purchased");

                        player thread doFlame(70, 3, 3, level.fx["megabullet"]);
                        player thread SetIcon("specialty_moredamage", 180,10,true);
                        player.MegaBulletBuyed = true;
                        player ShopFX();
                    }
                    else
                    {
                        player iprintlnbold(nopoint);
                    }
                }
                else
                {
                    player iPrintLnBold("^3you already have this option");
                }
                break;

                case "!nr":
                if(player.NoRecoilBuyed == false)
                {
                    if (1500 <= inthpoint)
                    {
                        player PointCost(1500);
                        player iprintlnbold("^1no recoil ^3was purchased");

                        player setRecoilScale(45);
                        player thread SetIcon("specialty_marksman", 150,10,true);
                        player.NoRecoilBuyed = true;
                        player ShopFX();
                    }
                    else
                    {
                        player iprintlnbold(nopoint);
                    }
                }
                else
                {
                    player iPrintLnBold("^3you already have this option");
                }
                break;

                case "!re":
                if (90000 <= inthpoint)
                {
                    player PointCost(90000);
                    player iprintlnbold("^1map restart ^3was purchased");
                    say("^1"+player.name+" ^3was purchased map restart =D");

                    wait 3;
                    cmdexec("map_restart");
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!ri":
                if (500 <= inthpoint)
                {
                    player PointCost(500);
                    player iprintlnbold("^1riot shield ^3was purchased");

                    riot = "riotshield_mp";
                    player giveWeapon(riot);
                    player SwitchToWeaponImmediate(riot);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!sx":
                if (100 <= inthpoint)
                {
                    player PointCost(100);
                    player iprintlnbold("^1semtex ^3was purchased");

                    player SetOffhandPrimaryClass("other");
                    player giveWeapon("semtex_mp");
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!tr":
                if (1500 <= inthpoint)
                {
                    player PointCost(1500);
                    player iprintlnbold("^1trophy ^3was purchased");

                    player setoffhandsecondaryclass("flash");
                    player giveWeapon("trophy_mp");
                    //player setweaponammoclip("trophy_mp", 1);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!aug":
                if (1500 <= inthpoint)
                {
                    player PointCost(1500);
                    player iprintlnbold("^1special gun ^3was purchased");

                    gun = "iw5_m60jugg_mp_silencer_thermal_camo05";
                    if(player getcurrentWeapon() != "iw5_usp45_mp_silencer02" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02" && player getcurrentWeapon() != "iw5_mp412_mp" && player getcurrentWeapon() != "iw5_deserteagle_mp_silencer02")
                    {
                        player DropItem(player getcurrentWeapon());
                    }
                    player giveWeapon(gun);
                    player giveStartAmmo(gun);
                    player SwitchToWeaponImmediate(gun);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!sui":
                player suicide();
                break;

                case "!ghp":
                entityghp = FindPlayerByName(level.args[1]);

                if (isDefined(entityghp))
                {
                    gp = int(level.args[2]);
                    if (gp >= 0)
                    {
                        if (gp <= inthpoint)
                        {

                            player iprintlnbold(gp + "^1 H Points sent to ^2" + entityghp.Name);
                            entityghp iprintlnbold("^2" + gp + " H ^1Points recieved from ^2" + player.Name);
                            player PointCost(gp);
                            entityghp PointAdd(gp);
                            writeFile("scripts//infshop//PointTransfers//Transfers.txt", gp + " H points from =>" + player.Name + "<= to =>" + entityghp.Name + "<=\n", true);
                        }
                        else
                        {
                            player iprintlnbold("^1You dont have enough points.");
                        }
                    }
                }
                else
                {
                    player iPrintLnBold("^1player not found");
                }
                break;

                case "!gzp":
                entitygzp = FindPlayerByName(level.args[1]);
                
                if (isDefined(entitygzp))
                {
                    gp = int(level.args[2]);
                    if (gp >= 0)
                    {
                        if (gp <= intzpoint)
                        {
                            player iprintlnbold(gp + "^1 Z Points sent to ^2" + entitygzp.Name);
                            entitygzp iprintlnbold("^2" + gp + "^1 Z Points recieved from ^2" + player.Name);
                            player PointCostZ(gp);
                            entitygzp PointAddZ(gp);
                            writeFile("scripts//infshop//PointTransfers//Transfers.txt", gp + " Z points from =>" + player.Name + "<= to =>" + entitygzp.Name + "<=\n", true);
                        }
                        else
                        {
                            player iprintlnbold("^1You dont have enough points.");
                        }
                    }
                }
                else
                {
                    player iPrintLnBold("^1player not found");
                }
                break;

                case "!htz":
                PointToChange = int(level.args[1]);
                if (PointToChange >= 0)
                {
                    if (PointToChange <= inthpoint)
                    {
                        ChangedPoint = int(PointToChange / 2);
                        player iprintlnbold("^1" + PointToChange + "^2 H POINT to^1 " + ChangedPoint + "^2 Z POINT");
                        player PointCost(PointToChange);
                        player PointAddZ(ChangedPoint);
                    }
                    else
                    {
                        player iprintlnbold("^1You dont have enough points");
                    }
                }
                break;

                case "!zth":
                PointToChange = int(level.args[1]);
                if (PointToChange >= 0)
                {
                    if (PointToChange <= intzpoint)
                    {
                        ChangedPoint = int(PointToChange / 2);
                        player iprintlnbold("^1" + PointToChange + "^2 H POINT to^1 " + ChangedPoint + "^2 Z POINT");
                        player PointCostZ(PointToChange);
                        player PointAdd(ChangedPoint);
                    }
                    else
                    {
                        player iprintlnbold("^1You dont have enough points");
                    }
                }
                break;

                case "!cw1":
                if(player HasWeapon("iw5_usp45_mp_silencer02"))
                {
                    player iPrintLnBold("^1you have this weapon");
                }
                else
                {
                    if (3500 <= inthpoint)
                    {
                        player PointCost(3500);
                        player iPrintLnBold("^3custom ^1weapon(usp45+dragunov) ^3was purchased");
                        player giveWeapon("iw5_usp45_mp_silencer02");
                        player SwitchToWeaponImmediate("iw5_usp45_mp_silencer02");
                        player thread CustomWeapon("iw5_usp45_mp_silencer02", "iw5_dragunov_mp");
                        player thread FXOnGun("iw5_usp45_mp_silencer02", level.fx["flare"]);
                        player ShopFX();
                    }
                    else
                    {
                        player iprintlnbold(nopoint);
                    }
                }
                break;
                
                case "!cw2":
                if(player HasWeapon("iw5_deserteagle_mp_silencer02"))
                {
                    player iPrintLnBold("^1you have this weapon");
                }
                else
                {
                    if (3500 <= inthpoint)
                    {
                        player PointCost(3500);
                        player iPrintLnBold("^3custom ^1weapon(desert+msr) ^3was purchased");
                        player giveWeapon("iw5_deserteagle_mp_silencer02");
                        player SwitchToWeaponImmediate("iw5_deserteagle_mp_silencer02");
                        player thread CustomWeapon("iw5_deserteagle_mp_silencer02", "iw5_msr_mp");
                        player thread FXOnGun("iw5_deserteagle_mp_silencer02", level.fx["flare"]);
                        player ShopFX();
                    }
                    else
                    {
                        player iprintlnbold(nopoint);
                    }
                }
                break;
                case "!cw3":
                if(player HasWeapon("iw5_mp412_mp"))
                {
                    player iPrintLnBold("^1you have this weapon");
                }
                else
                {
                    if (3500 <= inthpoint)
                    {
                        player PointCost(3500);
                        player iPrintLnBold("^3custom ^1weapon(mp412+cheytac) ^3was purchased");
                        player giveWeapon("iw5_mp412_mp");
                        player SwitchToWeaponImmediate("iw5_mp412_mp");
                        player thread CustomWeapon("iw5_mp412_mp", "iw5_cheytac_mp");
                        player thread FXOnGun("iw5_mp412_mp", level.fx["flare"]);
                        player ShopFX();
                    }
                    else
                    {
                        player iprintlnbold(nopoint);
                    }
                }
                break;

                case "!tp":

                if (500 <= inthpoint)
                {
                    player PointCost(500);
                    player iPrintLnBold("^3your not stuck anymore ^1:)");
                    player thread TPBack();
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                default:
                break;
            }
        }



        

        // This Is infected cmd's //
        if(player.pers["team"] == "axis")
        {
            switch ( toLower(level.args[0]) )
            {
                case "!ghp":
                entityghp = FindPlayerByName(level.args[1]);

                if (isDefined(entityghp))
                {
                    gp = int(level.args[2]);
                    if (gp >= 0)
                    {
                        if (gp <= inthpoint)
                        {

                            player iprintlnbold(gp + "^1 H Points sent to ^2" + entityghp.Name);
                            entityghp iprintlnbold("^2" + gp + " H ^1Points recieved from ^2" + player.Name);
                            player PointCost(gp);
                            entityghp PointAdd(gp);
                            writeFile("scripts//infshop//PointTransfers//Transfers.txt", gp + " H points from =>" + player.Name + "<= to =>" + entityghp.Name + "<=\n", true);
                        }
                        else
                        {
                            player iprintlnbold("^1You dont have enough points.");
                        }
                    }
                }
                else
                {
                    player iPrintLnBold("^1player not found");
                }
                break;

                case "!gzp":
                entitygzp = FindPlayerByName(level.args[1]);
                
                if (isDefined(entitygzp))
                {
                    gp = int(level.args[2]);
                    if (gp >= 0)
                    {
                        if (gp <= intzpoint)
                        {
                            player iprintlnbold(gp + "^1 Z Points sent to ^2" + entitygzp.Name);
                            entitygzp iprintlnbold("^2" + gp + "^1 Z Points recieved from ^2" + player.Name);
                            player PointCostZ(gp);
                            entitygzp PointAddZ(gp);
                            writeFile("scripts//infshop//PointTransfers//Transfers.txt", gp + " Z points from =>" + player.Name + "<= to =>" + entitygzp.Name + "<=\n", true);
                        }
                        else
                        {
                            player iprintlnbold("^1You dont have enough points.");
                        }
                    }
                }
                else
                {
                    player iPrintLnBold("^1player not found");
                }
                break;
                
                case "!htz":
                PointToChange = int(level.args[1]);
                if (PointToChange >= 0)
                {
                    if (PointToChange <= inthpoint)
                    {
                        ChangedPoint = int(PointToChange / 2);
                        player iprintlnbold("^1" + PointToChange + "^2 H POINT to^1 " + ChangedPoint + "^2 Z POINT");
                        player PointCost(PointToChange);
                        player PointAddZ(ChangedPoint);
                    }
                    else
                    {
                        player iprintlnbold("^1You dont have enough points");
                    }
                }
                break;

                case "!zth":
                PointToChange = int(level.args[1]);
                if (PointToChange >= 0)
                {
                    if (PointToChange <= intzpoint)
                    {
                        ChangedPoint = int(PointToChange / 2);
                        player iprintlnbold("^1" + PointToChange + "^2 H POINT to^1 " + ChangedPoint + "^2 Z POINT");
                        player PointCostZ(PointToChange);
                        player PointAdd(ChangedPoint);
                    }
                    else
                    {
                        player iprintlnbold("^1You dont have enough points");
                    }
                }
                break;

                case "!sui":
                player suicide();
                break;

                case "!sx":
                if (5000 <= intzpoint)
                {
                    player PointCostZ(5000);
                    player iprintlnbold("^1semtex ^3was purchased");

                    player SetOffhandPrimaryClass("other");
                    player giveWeapon("semtex_mp");
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!cm":
                if (150 <= intzpoint)
                {
                    player PointCostZ(150);
                    player iprintlnbold("^1claymore ^3was purchased");

                    player SetOffhandPrimaryClass("other");
                    player giveWeapon("claymore_mp");
                    player setweaponammoclip("claymore_mp", 1);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!sm":
                if (200 <= intzpoint)
                {
                    player PointCostZ(200);
                    player iprintlnbold("^1smoke ^3was purchased");

                    player SetOffhandsecondaryClass("smoke");
                    player giveWeapon("smoke_grenade_mp");
                    player setweaponammoclip("smoke_grenade_mp", 1);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!fg":
                if (400 <= intzpoint)
                {
                    player PointCostZ(400);
                    player iprintlnbold("^1flash ^3was purchased");

                    player setoffhandsecondaryclass("flash");
                    player giveWeapon("flash_grenade_mp");
                    player setweaponammoclip("flash_grenade_mp", 2);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!ttk":
                if (2500 <= intzpoint)
                {
                    player PointCostZ(2500);
                    player iprintlnbold("^1throwing knife ^3was purchased");

                    player SetOffhandPrimaryClass("throwingknife");
                    player giveWeapon("throwingknife_mp");
                    player setweaponammoclip("throwingknife_mp", 1);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!emp":
                if (400 <= intzpoint)
                {
                    player PointCostZ(400);
                    player iprintlnbold("^1emp ^3was purchased");

                    player setoffhandsecondaryclass("flash");
                    player giveWeapon("emp_grenade_mp");
                    player setweaponammoclip("emp_grenade_mp", 2);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!wh":
                if (400 <= intzpoint)
                {
                    player PointCostZ(400);
                    player iprintlnbold("^1wall hack ^3was purchased");

                    player thermalvisionfofoverlayon();
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!msp":
                if(player.MoreSpeedBuyed == false)
                {
                    if (3500 <= intzpoint)
                    {
                        player PointCostZ(3500);
                        player iprintlnbold("^1more speed for ever ^3was purchased");

                        player thread SetIcon("specialty_longersprint", 150,7,false);
                        player.SpeedBuyed = true;
                        player.MoreSpeedBuyed = true;
                        player ShopFX();
                    }
                    else
                    {
                        player iprintlnbold(nopoint);
                    }
                }
                else
                {
                    player iPrintLnBold("^3you already have this option");
                }
                break;

                case "!smgun":
                if (1000 <= intzpoint)
                {
                    player PointCostZ(1000);
                    player iprintlnbold("^1smoke gun ^3was purchased");
                    
                    gun = "iw5_striker_mp_silencer03_camo11";
                    player giveWeapon(gun);
                    player setweaponammostock(gun, 0);
                    player setweaponammoclip(gun, 5);
                    player SwitchToWeaponImmediate(gun);
                    player thread removeWeaponOnOutOfAmmo(gun);
                    player thread FXOnGun(gun, level.fx["smoke"]);
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;

                case "!re":
                if (90000 <= intzpoint)
                {
                    player PointCostZ(90000);
                    player iprintlnbold("^1map restart ^3was purchased");
                    say("^1"+player.name+" ^3was purchased map restart =D");

                    wait 3;
                    cmdexec("map_restart");
                    player ShopFX();
                }
                else
                {
                    player iprintlnbold(nopoint);
                }
                break;
                default:
                break;
            }
        }



        // This Is Only Admins //
        if(fileExists("scripts//infshop//admins//" + player.GUID))
        {
            switch ( toLower(level.args[0]) )
            {
                case "!hpset":
                entityhpset = FindPlayerByName(level.args[1]);

                if (isDefined(entityhpset))
                {
                    hgp = level.args[2];
                    writefile("scripts//infshop//players//GUID"+entityhpset.GUID+"//h."+entityhpset.GUID+".point", hgp);

                    player iPrintLnBold("^1" + entityhpset.Name + "^7 H Point set to = ^1" + hgp);
                    entityhpset iprintlnbold("^3Admin ^1" + player.Name + "^3 set your H Point  to = ^2" + hgp);
                }
                else
                {
                    player iPrintLnBold("^1player not found");
                }

                
                break;

                case "!zpset":
                entityzpset = FindPlayerByName(level.args[1]);
                
                if (isDefined(entityzpset))
                {
                    zgp = level.args[2];
                    writefile("scripts//infshop//players//GUID"+entityzpset.GUID+"//z."+entityzpset.GUID+".point", zgp);

                    player iPrintLnBold("^1" + entityzpset.Name + "^7 H Point set to = ^1" + zgp);
                    entityzpset iprintlnbold("^3Admin ^1" + player.Name + "^3 set your H Point  to = ^2" + zgp);
                }
                else
                {
                    player iPrintLnBold("^1player not found");
                }
                break;

                case "!ghpall":
                ghpall = int(level.args[1]);
                foreach (entityghpall in level.Players)
                {
                    wait 0.05;
                    entityghpall iprintlnbold("^1" + ghpall + " ^3H point from admin^1 " + player.Name + " ^3to all players");
                    entityghpall PointAdd(ghpall);
                }
                break;

                case "!gzpall":
                gzpall = int(level.args[1]);
                foreach (entitygzpall in level.Players)
                {
                    wait 0.05;
                    entitygzpall iprintlnbold("^1" + gzpall + " ^3Z point from admin^1 " + player.Name + " ^3to all players");
                    entitygzpall PointAddZ(gzpall);
                }
                break;

                case "!point":
                entitypoint = FindPlayerByName(level.args[1]);

                if (isDefined(entitypoint))
                {
                    hpointread = fopen("scripts//infshop//players//GUID"+entitypoint.GUID+"//h."+entitypoint.GUID+".point", "r");
                    readhpointsure = fread(hpointread);
                    fclose(hpointread);
                    readinth = int(readhpointsure);

                    zpointread = fopen("scripts//infshop//players//GUID"+entitypoint.GUID+"//z."+entitypoint.GUID+".point", "r");
                    readzpointsure = fread(zpointread);
                    fclose(zpointread);
                    readintz = int(readzpointsure);

                    player iPrintLnBold(entitypoint.Name + " ^3 H point = ^1" + readinth + "^7- ^3 Z point = ^1" + readintz);
                }
                else
                {
                    player iPrintLnBold("^1player not found");
                }
                break;

                case "!kick":
                entitykick = FindPlayerByName(level.args[1]);
                playerr = entitykick getEntityNumber();
                
                if (isDefined(playerr))
                {
                    executeCommand("clientkick "+playerr+" "+level.args[2]);
                }
                else
                {
                    player iPrintLnBold("^1player not found");
                }
                break;

                case "!kill":
                entitykill = FindPlayerByName(level.args[1]);
                
                if (isDefined(entitykill))
                {
                    entitykill suicide();
                }
                else
                {
                    player iPrintLnBold("^1player not found");
                }
                break;

                case "!100k":
                {
                    player iprintlnbold("^1======100k point======");
                    player PointAdd(100000);
                    player PointAddZ(100000);
                }
                break;

                case "!tpall":
                {
                    foreach (entitytp in level.players)
                    {
                        wait 0.05;
                        entitytp setorigin(player.origin);
                    }         
                }
                break;

                case "!killall":
                {
                    foreach (entitysui in level.players)
                    {
                        wait 0.05;
                        entitysui suicide();
                    }
                }
                break;

                case "!mres":
                wait(0.05);
                cmdexec("map_restart");
                break;

                case "!drop":
                {
                    player DropItem(player getCurrentWeapon());
                }
                break;

                case "!ac130":
                {
                    player iprintlnbold("^5AC-130 25|40|105 ^3MM");
                    player TakeAllWeapons();
                    player GiveWeapon("ac130_105mm_mp");
                    player GiveWeapon("ac130_40mm_mp");
                    player GiveWeapon("ac130_25mm_mp");
                    player SwitchToWeaponImmediate("ac130_25mm_mp");
                }
                break;

                case "!dg":
                {
                    for (i = 0; i < 10; i++)
                    {
                        gun = level.rnddrop[randomIntRange(0,level.rnddrop.size)];
                        player giveWeapon(gun);
                        player SwitchToWeaponImmediate(gun);

                        wait 0.2;
                        player DropItem(player getCurrentWeapon());
                    }
                    
                }
                break;

                case "!cus":
                player giveWeapon("defaultweapon_mp");
                player SwitchToWeaponImmediate("defaultweapon_mp");
                player thread CustomWeapon("defaultweapon_mp", level.args[1]);
                break;

                case "!name":
                player setName(level.args[1]);
                player setClantag(level.args[2]);
                break;

                case "!team":
                if(player.pers["team"] == "allies")
                {
                    player maps\mp\gametypes\_menus::addToTeam( "axis" );
                }
                else
                {
                    player maps\mp\gametypes\_menus::addToTeam( "allies" );
                }
                break;

                case "!speed":
                speedme = float(level.args[1]);
                wait(1);
                player setMoveSpeedScale(speedme);
                break;

                case "!god":
                if ( player.maxhealth < 9999999 )
                {
                    player.maxhealth = 9999999;
                    player.health = player.maxhealth;
                }
                else
                {
                    player.maxhealth = 100;
                    player.health = player.maxhealth;
                }
                break;

                case "!air":
                player beginLocationselection("map_artillery_selector",true,(level.mapSize/5.625));
                player.selectingLocation = true;
                player waittill("confirm_location",location,directionYaw);
                player endLocationSelection();
                player.selectingLocation = undefined;
                trace = bullettrace(location+(0,0,100),location-(0,0,100000),true,player);
                MagicBullet("ac130_105mm_mp",location,trace["position"],player);
                break;

                case "!nm":
                wait(0.1);
                executeCommand("map_rotate");
                break;

                case "!tpg":
                player thread TPGun();
                break;

                default:
                break;
            }
        }
    }
}

SetIcon(perk, x, y,DestroyIcon)
{
    level endon("game_ended");
    self endon("disconnect");

    iconshow = newClientHudElem(self);
    iconshow.alignx = "right";
    iconshow.aligny = "bottom";
    iconshow.horzalign = "right";
    iconshow.vertalign = "bottom";
    iconshow.x -= x;
    iconshow.Y = y;
    iconshow.alpha = 1;
    iconshow.Foreground = true;
    iconshow.hidewheninmenu = 1;
    iconshow setShader(perk, 20, 20);
    if(DestroyIcon)
    {
        thread DestroyIcon(iconshow);
    }
}

DestroyIcon(icon)
{
    for (;;)
    {
        wait(0.1);
        if(!isAlive(self))
        {
            icon.alpha = 0;
        }
    }
}

TPGun()
{
    self endon ("death");
    for(;;)
    {
        self waittill ("weapon_fired");
        self setorigin(BulletTrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,0,self)["position"]);
    }
}

doFlame(range, maxdmg, mindmg, fxmodel)
{
    self endon ("death");
    self endon( "disconnect" );
    level endon("game_ended");
    while (true)
    {
        self waittill("weapon_fired");
        forward=self getEye();
        end=self getEye()+anglestoforward(self getplayerangles())*1000000;
        Crosshair=BulletTrace(forward,end,0,self)["position"];
        //fxhandle = int(loadfx(fxmodel));
        effect = spawnfx(fxmodel, Crosshair);
        triggerfx(effect);
        RadiusDamage(Crosshair,range,maxdmg,mindmg,self);
        thread MakeSureDeleted(effect, 1);
    }
}

FXOnGun(weapfire, fxmodel)
{
    self endon ("death");
    self endon( "disconnect" );
    level endon("game_ended");
    while (true)
    {
        self waittill("weapon_fired", weapfire2);
        if ( weapfire != weapfire2) continue;
        forward=self getEye();
        end=self getEye()+anglestoforward(self getplayerangles())*1000000;
        Crosshair=BulletTrace(forward,end,0,self)["position"];
        //fxhandle = int(loadfx(fxmodel));
        effect = spawnfx(fxmodel, Crosshair);
        triggerfx(effect);
        thread MakeSureDeleted(effect, 0.3);
    }
}

MakeSureDeleted(shitde,time)
{
    wait(time);
    shitde delete(); 
}

CustomWeapon(orgweap, shity)
{
    self endon( "death" );
    self endon( "disconnect" );
    level endon("game_ended");
    for ( ;; )
    {
        self waittill( "weapon_fired", weaponName );
        if (weaponName != orgweap) continue;
        magicBullet( shity, self GetTagOrigin( "tag_weapon_left" ), AnglesToForward(self GetPlayerAngles()) *1000000, self );
    }
}
/*
randomNum(size, min, max)
{
	uniqueArray = [size];
	random = 0;

	for (i = 0; i < size; i++)
	{
		random = randomIntRange(min, max);
		for (j = i; j >= 0; j--)
			if (isDefined(uniqueArray[j]) && uniqueArray[j] == random)
			{
				random = randomIntRange(min, max);
				j = i;
			}
		uniqueArray[i] = random;
	}
	return uniqueArray;
}
*/
RandomGun()
{
    level.rndpistol= [];
	level.rndpistol[0]="iw5_44magnum_mp";
	level.rndpistol[1]="iw5_p99_mp_silencer02";
	level.rndpistol[2]="iw5_fnfiveseven_mp_silencer02";

    level.rndautopistol= [];
	level.rndautopistol[0]="iw5_fmg9_mp_akimbo_reflexsmg_silencer02";
	level.rndautopistol[1]="iw5_skorpion_mp_akimbo_reflexsmg_silencer02";
	level.rndautopistol[2]="iw5_mp9_mp_akimbo_reflexsmg_silencer02";
    level.rndautopistol[3]="iw5_g18_mp_akimbo_reflexsmg_silencer02";

    level.rndsmg= [];
	level.rndsmg[0]="iw5_mp5_mp_reflexsmg_camo02";
	level.rndsmg[1]="iw5_m9_mp_reflexsmg_camo03";
	level.rndsmg[2]="iw5_p90_mp_reflexsmg_camo04";
    level.rndsmg[3]="iw5_pp90m1_mp_reflexsmg_camo05";
    level.rndsmg[4]="iw5_ump45_mp_reflexsmg_camo06";
    level.rndsmg[5]="iw5_mp7_mp_reflexsmg_camo07";

    level.rndar= [];
	level.rndar[0]="iw5_ak47_mp_reflex_shotgun_camo07";
	level.rndar[1]="iw5_m16_mp_reflex_shotgun_camo05";
	level.rndar[2]="iw5_m4_mp_reflex_shotgun_camo04";
    level.rndar[3]="iw5_fad_mp_reflex_shotgun_camo02";
    level.rndar[4]="iw5_acr_mp_reflex_shotgun_camo03";
    level.rndar[5]="iw5_type95_mp_reflex_shotgun_camo01";
    level.rndar[6]="iw5_mk14_mp_reflex_shotgun_camo09";
    level.rndar[7]="iw5_scar_mp_reflex_shotgun_camo08";
    level.rndar[8]="iw5_g36c_mp_reflex_shotgun_camo11";
    level.rndar[9]="iw5_cm901_mp_reflex_shotgun_camo10";

    level.rndsg= [];
	level.rndsg[0]="iw5_1887_mp_camo09";
	level.rndsg[1]="iw5_aa12_mp_reflex_camo08";
    level.rndsg[2]="iw5_usas12_mp_reflex_camo07";
    level.rndsg[3]="iw5_spas12_mp_reflex_camo04";
    level.rndsg[4]="iw5_ksg_mp_reflex_camo05";

    level.rndsnip= [];
	level.rndsnip[0]="iw5_dragunov_mp_xmags_camo05";
	level.rndsnip[1]="iw5_msr_mp_xmags_camo06";
    level.rndsnip[2]="iw5_barrett_mp_xmags_camo07";
    level.rndsnip[3]="iw5_rsass_mp_xmags_camo08";
    level.rndsnip[4]="iw5_as50_mp_xmags_camo09";
    level.rndsnip[5]="iw5_l96a1_mp_xmags_camo10";
    level.rndsnip[6]="iw5_cheytac_mp_xmags_camo11";

    level.rndlmg= [];
	level.rndlmg[0]="iw5_m60_mp_acog_camo06";
	level.rndlmg[1]="iw5_mk46_mp_acog_camo07";
    level.rndlmg[2]="iw5_pecheneg_mp_acog_camo08";
    level.rndlmg[3]="iw5_sa80_mp_acog_camo09";
    level.rndlmg[4]="iw5_mg36_mp_acog_camo10";

    level.rndln= [];
	level.rndln[0]="rpg_mp";
	level.rndln[1]="iw5_smaw_mp";
    level.rndln[2]="xm25_mp";

    level.rnddrop= [];
	level.rnddrop[0]="iw5_m16_mp_camo11";
	level.rnddrop[1]="iw5_mg36_mp_camo11";
    level.rnddrop[2]="iw5_pecheneg_mp_camo11";
    level.rnddrop[3]="iw5_sa80_mp_camo11";
    level.rnddrop[4]="iw5_spas12_mp_camo11";
    level.rnddrop[5]="iw5_mk14_mp_camo11";
    level.rnddrop[6]="iw5_scar_mp_camo11";
    level.rnddrop[7]="iw5_mp7_mp_camo11";
    level.rnddrop[8]="iw5_m9_mp_camo11";
    level.rnddrop[9]="iw5_fnfiveseven_mp_silencer02";
    level.rnddrop[10]="iw5_fmg9_mp_reflexsmg_silencer02";
    level.rnddrop[11]="iw5_mp9_mp_reflexsmg_silencer02";
    level.rnddrop[12]="iw5_usas12_mp_camo11";
    level.rnddrop[13]="iw5_ksg_mp_camo11";
    level.rnddrop[14]="iw5_m4_mp_camo11";
    level.rnddrop[15]="iw5_fad_mp_camo11";
    level.rnddrop[16]="iw5_acr_mp_camo11";
    level.rnddrop[17]="iw5_g36c_mp_camo11";
    level.rnddrop[18]="iw5_mk46_mp_camo11";
    level.rnddrop[19]="rpg_mp";
}

ShowCreator()
{
	self endon("disconnect");

	self notifyOnPlayerCommand("butt", "+scores");
	self notifyOnPlayerCommand("butt2", "-scores");
	self.me = self createFontString( "hudbig", 0.8 );
	self.me setPoint( "top", "center", 0, -160 );
	self.me.glowalpha = 1;
	self.me.glowcolor = (0.6, 0.2, 1);
	for(;;)
	{
        wait(0.01);
		self waittill("butt");
		wait (0.04);
	    self.me setText("^7Infected  Shop  By  ^1RAVEN");
		self.me.alpha = 1;

		self waittill("butt2");
	    wait (0.04);
		self.me.alpha = 0;
	}
}

ShopFX()
{
    playfx(loadfx("props/cash_player_drop"), self gettagorigin("j_spine4"));
    self playsound("mp_killconfirm_tags_pickup");
}

PointCost(newpointPointcost)
{
    self endon("disconnect");

    mainfPointcost = fopen("scripts//infshop//players//GUID"+self.GUID+"//h."+self.GUID+".point", "r");
    linesPointcost = fread(mainfPointcost);
    fclose(mainfPointcost);
    tointPointcost = int(linesPointcost);
    mathxPointcost = (tointPointcost - newpointPointcost);
    testPointcost = mathxPointcost;
    trypPointcost = testPointcost + "";
    writeFile("scripts//infshop//players//GUID"+self.GUID+"//h."+self.GUID+".point", trypPointcost);
}

PointAdd(newpointPointadd)
{
    self endon("disconnect");

    mainfPointadd = fopen("scripts//infshop//players//GUID"+self.GUID+"//h."+self.GUID+".point", "r");
    linesPointadd = fread(mainfPointadd);
    fclose(mainfPointadd);
    tointPointadd = int(linesPointadd);
    mathxPointadd = (tointPointadd + newpointPointadd);
    testPointadd = mathxPointadd;
    trypPointadd = testPointadd + "";
    writeFile("scripts//infshop//players//GUID"+self.GUID+"//h."+self.GUID+".point", trypPointadd);
}

PointCostZ(newpointPointcostz)
{
    self endon("disconnect");

    mainfPointcostz = fopen("scripts//infshop//players//GUID"+self.GUID+"//z."+self.GUID+".point", "r");
    linesPointcostz = fread(mainfPointcostz);
    fclose(mainfPointcostz);
    tointPointcostz = int(linesPointcostz);
    mathxPointcostz = (tointPointcostz - newpointPointcostz);
    testPointcostz = mathxPointcostz;
    trypPointcostz = testPointcostz + "";
    writeFile("scripts//infshop//players//GUID"+self.GUID+"//z."+self.GUID+".point", trypPointcostz);
}

PointAddZ(newpointPointaddz)
{
    self endon("disconnect");

    mainfPointaddz = fopen("scripts//infshop//players//GUID"+self.GUID+"//z."+self.GUID+".point", "r");
    linesPointaddz = fread(mainfPointaddz);
    fclose(mainfPointaddz);
    tointPointaddz = int(linesPointaddz);
    mathxPointaddz = (tointPointaddz + newpointPointaddz);
    testPointaddz = mathxPointaddz;
    trypPointaddz = testPointaddz + "";
    writeFile("scripts//infshop//players//GUID"+self.GUID+"//z."+self.GUID+".point", trypPointaddz);
}

onPlayerSpawned()
{
    self endon("disconnect");

    for(;;)
    {
        self waittill("spawned_player");
		wait 0.05;
        self freezecontrols (false);
        ModelChanger();
        self ThermalVisionFOFOverlayOff();
        self SetPerk("specialty_quieter", true, false);
        self SetPerk("specialty_fastreload", true, false);
        self SetPerk("specialty_quickdraw", true, false);
        self SetPerk("specialty_longersprint", true, false);
        self SetPerk("specialty_fastermelee", true, false);
        self SetPerk("specialty_lightweight", true, false);
        self SetPerk("specialty_quickswap", true, false);
        self setClientDvar("r_fog", 0);
        self setClientDvar("r_drawsun", 0);
        self setClientDvar("lowAmmoWarningColor1", "0 0 0 0");
        self setClientDvar("lowAmmoWarningColor2", "0 0 0 0");
        self setClientDvar("lowAmmoWarningNoAmmoColor1", "0 0 0 0");
        self setClientDvar("lowAmmoWarningNoAmmoColor2", "0 0 0 0");
        self setClientDvar("lowAmmoWarningNoReloadColor1", "0 0 0 0");
        self setClientDvar("lowAmmoWarningNoReloadColor2", "0 0 0 0");

        if ( self.pers["team"] == "allies" )
        {
            self enableweaponpickup();
            self TakeAllWeapons();
            numm = int(9);
            WeaponNum = randomint(numm);
            if (WeaponNum == 0 || WeaponNum == 1)
            {
                self giveweapon("iw5_striker_mp_silencer03_camo13");
                self SwitchToWeaponImmediate("iw5_striker_mp_silencer03_camo13");
                self giveweapon("iw5_p99_mp_silencer02");
            }
            if (WeaponNum == 2 || WeaponNum == 3)
            {
                self giveweapon("iw5_ksg_mp_silencer03_camo13");
                self SwitchToWeaponImmediate("iw5_ksg_mp_silencer03_camo13");
                self giveweapon("iw5_p99_mp_silencer02");
            }
            if (WeaponNum == 4 || WeaponNum == 5)
            {
                self giveweapon("iw5_mp412_mp_akimbo");
                self SwitchToWeaponImmediate("iw5_mp412_mp_akimbo");
                self giveweapon("iw5_p99_mp_silencer02");
            }
            if (WeaponNum == 6 || WeaponNum == 7)
            {
                self giveweapon("iw5_spas12_mp_silencer03_camo13");
                self SwitchToWeaponImmediate("iw5_spas12_mp_silencer03_camo13");
                self giveweapon("iw5_p99_mp_silencer02");
            }
            if (WeaponNum == 8 || WeaponNum == 9)
            {
                self giveweapon("iw5_1887_mp_camo13");
                self SwitchToWeaponImmediate("iw5_1887_mp_camo13");
                self giveweapon("iw5_p99_mp_silencer02");
            }
        }
        if(self.pers["team"] == "axis")
        {
            self disableweaponpickup();
            self setMoveSpeedScale(1.24);
        }
	}
}

TeamsSpeed()
{
    self endon("disconnect");
    level endon("game_ended");
    
    for(;;)
    {
        self waittill("spawned_player");
        while(self.pers["team"] == "allies")
        {
            self setMoveSpeedScale(1.18);
            wait(0.09);
        }
        wait(0.09);
        while(self.pers["team"] == "axis" && self.SpeedBuyed == false)
        {
            self setMoveSpeedScale(1.24);
            wait(0.09);
        }
        wait(0.09);
        while(self.pers["team"] == "axis" && self.SpeedBuyed == true)
        {
            self setMoveSpeedScale(1.85);
            wait(0.09);
        }
    }
}

Settings()
{
    self endon("disconnect");

    SetDvar("g_TeamName_Axis", "^1i^:nfected^1s");
    SetDvar("g_TeamName_Allies", "^5h^:uman^5s");
    setdvar("g_TeamIcon_Allies", "iw5_cardicon_juggernaut_c");
    setdvar("g_teamIcon_Axis", "cardicon_redhand");
    setDvar("g_scorescolor_allies", "0 1.28 0 .8");
    setDvar("g_scorescolor_axis", "1 0 0 1");
    setdvar("ui_allow_teamchange", "0");
    setDvar("jump_autobunnyhop", 1);
    setDvar("jump_slowdownEnable", 0);
    setDvar("jump_stepSize", 256);
    setDvar("jump_spreadadd", 512);
    setDvar("jump_disableFallDamage", 1);

    env = getMapEnv(getdvar("mapname"));
    setdvar("env1", env);
    if (getdvar("mapname") == "mp_radar")
    {
        env = "arctic";
    }
    setdvar("env2", env);
    precachemodel("viewhands_iw5_ghillie_" + env);
}

ModelChanger()
{
    self endon("disconnect");

    wait 0.01;
    foreach( player in level.players )
    {
        if ( player.pers["team"] == "axis" )
        {
            player setmodel("mp_body_ally_ghillie_" + getdvar("env1") + "_sniper");
            player setviewmodel("viewhands_iw5_ghillie_" + getdvar("env2"));
        }
    } 
}

getMapEnv(mapname)
{
    switch (mapname)
    {
        case "mp_alpha":
        case "mp_bootleg":
        case "mp_exchange":
        case "mp_hardhat":
        case "mp_interchange":
        case "mp_mogadishu":
        case "mp_paris":
        case "mp_plaza2":
        case "mp_underground":
        case "mp_cement":
        case "mp_hillside_ss":
        case "mp_overwatch":
        case "mp_terminal_cls":
        case "mp_aground_ss":
        case "mp_courtyard_ss":
        case "mp_meteora":
        case "mp_morningwood":
        case "mp_qadeem":
        case "mp_crosswalk_ss":
        case "mp_italy":
        case "mp_boardwalk":
        case "mp_roughneck":
        case "mp_nola":
            return "urban";
        case "mp_dome":
        case "mp_radar":
        case "mp_restrepo_ss":
        case "mp_burn_ss":
        case "mp_seatown":
        case "mp_shipbreaker":
        case "mp_moab":
            return "desert";
        case "mp_bravo":
        case "mp_carbon":
        case "mp_park":
        case "mp_six_ss":
        case "mp_village":
        case "mp_lambeth":
            return "woodland";
        }
    return "";
}

ShowPoint()
{
	self endon("disconnect");

	self notifyOnPlayerCommand("buttpoint", "+actionslot 1");
	for(;;)
	{
        wait (0.1);
        mainfileh = fopen("scripts//infshop//players//GUID"+self.GUID+"//h."+self.GUID+".point", "r");
        inth = int(mainfileh);
        showh = fread(inth);
        fclose(mainfileh);

		mainfilez = fopen("scripts//infshop//players//GUID"+self.GUID+"//z."+self.GUID+".point", "r");
        intz = int(mainfilez);
        showz = fread(intz);
        fclose(mainfilez);

		self waittill("buttpoint");
		wait (0.04);
        self iprintlnbold("^8H POINT ^7: ^1(^5" + showh + "^1)^7-------^9Z POINT ^7: ^1(^5" + showz + "^1)^7");
	} 
}

ShaderSpawner(shader, align, relative, x, y, width, height, color)
{
    element = spawnstruct();
    element = newclienthudelem(self);
    
    element.elemtype = "icon";
    element.hidewheninmenu = true;
    element.shader = shader;
    element.width = width;
    element.height = height;
    element.align = align;
    element.relative = relative;
    element.xoffset = 0;
    element.yoffset = 0;
    element.children = [];
    element.sort = 1;
    element.color = color;
    element.alpha = 1;
    element setparent(level.uiparent);
    element setshader(shader, width, height);
    element setpoint(align, relative, x, y);
    return element;
}

ShowShop()
{
	self endon("disconnect");

	self notifyOnPlayerCommand("buttshop", "+actionslot 1");
    self notifyOnPlayerCommand("buttshophide", "+actionslot 1");
    wait 0.05;
    
    backghuman = ShaderSpawner("white", "TOP TOP", "TOP TOP", 28, 5.5, 698, 117, (0.310,0.349,0.275));
    backghuman.alpha = 0;

    backginfect = ShaderSpawner("white", "TOP TOP", "TOP TOP", -54, 5.5, 535, 75, (0.310,0.349,0.275));
    backginfect.alpha = 0;

    self.pressto = self createfontstring("default", 1.1);
    self.pressto setpoint("TOP LEFT", "TOP LEFT", 2, 110);
    self.pressto.hidewheninmenu = true;
    self.pressto.glowalpha = 1;
	self.pressto.glowcolor = (0.392, 0, 0);
    //Human Huds
    self.humanhud1 = self createfontstring("default", 1.2);
    self.humanhud1 setpoint("TOP LEFT", "TOP LEFT", 110, 05);
    self.humanhud1.hidewheninmenu = true;
    self.humanhud1.glowalpha = 1;
	self.humanhud1.glowcolor = (0,0,0.298);

    self.humanhud2 = self createfontstring("default", 1.2);
    self.humanhud2 setpoint("TOP LEFT", "TOP LEFT", 280, 05);
    self.humanhud2.hidewheninmenu = true;
    self.humanhud2.glowalpha = 1;
	self.humanhud2.glowcolor = (0,0,0.298);

    self.humanhud3 = self createfontstring("default", 1.2);
    self.humanhud3 setpoint("TOP LEFT", "TOP LEFT", 450, 05);
    self.humanhud3.hidewheninmenu = true;
    self.humanhud3.glowalpha = 1;
	self.humanhud3.glowcolor = (0,0,0.298);

    self.humanhud4 = self createfontstring("default", 1.2);
    self.humanhud4 setpoint("TOP LEFT", "TOP LEFT", 620, 05);
    self.humanhud4.hidewheninmenu = true;
    self.humanhud4.glowalpha = 1;
	self.humanhud4.glowcolor = (0,0,0.298);

    //inf Huds
    self.infhud1 = self createfontstring("default", 1.2);
    self.infhud1 setpoint("TOP LEFT", "TOP LEFT", 110, 05);
    self.infhud1.hidewheninmenu = true;
    self.infhud1.glowalpha = 1;
	self.infhud1.glowcolor = (0,0,0.298);

    self.infhud2 = self createfontstring("default", 1.2);
    self.infhud2 setpoint("TOP LEFT", "TOP LEFT", 280, 05);
    self.infhud2.hidewheninmenu = true;
    self.infhud2.glowalpha = 1;
	self.infhud2.glowcolor = (0,0,0.298);
    
    self.infhud3 = self createfontstring("default", 1.2);
    self.infhud3 setpoint("TOP LEFT", "TOP LEFT", 450, 05);
    self.infhud3.hidewheninmenu = true;
    self.infhud3.glowalpha = 1;
	self.infhud3.glowcolor = (0,0,0.298);

	for(;;)
	{
        self.pressto SetText("^1Press ^3[{+actionslot 1}] ^1To Show/Hide Shop");

        self waittill("buttshop");
        wait 0.05;

        self.pressto.alpha = 0;
        if ( self.pers["team"] == "allies")
        {
            self.humanhud1 SetText("^5!1^1=>^3random pistol^;(50)\n^5!2^1=>^3random auto pistol^;(300)\n^5!3^1=>^3random SMG^;(500)\n^5!4^1=>^3random AR^;(700)\n^5!5^1=>^3random shotgun^;(150)\n^5!6^1=>^3random snipe^;(800)\n^5!7^1=>^3random LMG^;(1k)\n^5!8^1=>^3random launcher^;(400)");
            self.humanhud2 SetText("^5!mb^1=>^3mega bullet^;(4.5k)\n^5!dmg^1=>^3more damage^;(1k)\n^5!nr^1=>^3no recoil^;(1.5k)\n^5!cw1^1=>^3(usp45+dragunov)^;(3.5k)\n^5!cw2^1=>^3(desert+msr)^;(3.5k)\n^5!cw3^1=>^3(mp412+cheytac)^;(3.5k)");
            self.humanhud3 SetText("^5!ri^1=>^3riot shield^;(500)\n^5!sx^1=>^3Semtex^;(100)\n^5!aug^1=>^3special gun^;(1.5k)\n^5!tr^1=>^3trophy system^;(1.5k)\n^5!sui^1=>^3Suicide^;(free)\n^5!re^1=>^3restart map^;(25k)");
            self.humanhud4 SetText("^5!ghp^1=>^3give H point^;!ghp [name] [value]\n^5!gzp^1=>^3give Z point^;!gzp [name] [value]\n^5!zth^1=>^3Z point to H divided 2^;!zth [value]\n^5!htz^1=>^3H point to Z divided 2^;!htz [value]\n^5!tp^1 =>^3teleport when you stuck^;(500)");
            self.humanhud1.alpha = 1;
            self.humanhud2.alpha = 1;
            self.humanhud3.alpha = 1;
            self.humanhud4.alpha = 1;
            self.infhud1.alpha = 0;
            self.infhud2.alpha = 0;
            self.infhud3.alpha = 0;
            backghuman.alpha = 0.69;
            backginfect.alpha = 0;
        
        }
        if ( self.pers["team"] == "axis")
        {
            self.infhud1 SetText("^5!sui^1=>^3suicide^;(free)\n^5!msp^1=>^3more speed for ever^;(3.5k)\n^5!sm^1=>^3smoke^;(200)\n^5!sx^1=>^3semtex^;(5k)\n^5!smgun^1=>^3smoke gun^;(1k)");
            self.infhud2 SetText("^5!wh^1=>^3wallhack^;(400)\n^5!fg^1=>^3flashbang x2^;(400)\n^5!cm^1=>^3claymore^;(150)\n^5!emp^1=>^3emp x2^;(400)\n^5!re^1=>^3restart Map^;(25k)");
            self.infhud3 SetText("^5!ghp^1=>^3give H point^;!ghp [name] [value]\n^5!gzp^1=>^3give Z point^;!gzp [name] [value]\n^5!zth^1=>^3Z point to H divided 2^;!zth [value]\n^5!htz^1=>^3H point to Z divided 2^;!htz [value]\n^5!ttk^1=>^3throwing knife^;(2.5k)");
            self.infhud1.alpha = 1;
            self.infhud2.alpha = 1;
            self.infhud3.alpha = 1;
            self.humanhud1.alpha = 0;
            self.humanhud2.alpha = 0;
            self.humanhud3.alpha = 0;
            self.humanhud4.alpha = 0;
            backghuman.alpha = 0;
            backginfect.alpha = 0.69;
        }
        self waittill("buttshophide");
        wait 0.05;

        self.pressto.alpha = 1;

        if ( self.pers["team"] == "allies" )
        {
            self.humanhud1.alpha = 0;
            self.humanhud2.alpha = 0;
            self.humanhud3.alpha = 0;
            self.humanhud4.alpha = 0;
            backghuman.alpha = 0;
            backginfect.alpha = 0;
        }
        if( self.pers["team"] == "axis" )
        {
            self.infhud1.alpha = 0;
            self.infhud2.alpha = 0;
            self.infhud3.alpha = 0;
            backghuman.alpha = 0;
            backginfect.alpha = 0;
        }
    }
}

FindPlayerByName( name )
{
    foreach ( playername in level.players )
    {
        if ( playername.name == ToUpper(name) || playername.name == toLower(name) )
        {
            if(isDefined(playername))
            {
                return playername;
            }
        }
    }
    return undefined;
}

disableNukeVision()
{

}

disableNukeEmp()
{

}

disableNukeEffects()
{
	level endon( "nuke_cancelled" );
	setdvar( "ui_bomb_timer", 0 );
}







////////////////////////////////////////////////////////
///////////////////             ///////////////////////
//////////////////  Map Edits  ///////////////////////
/////////////////             ///////////////////////
////////////////////////////////////////////////////





MapEdits()
{
	switch(GetDvar("mapname"))
    {
		case "mp_dome":
		thread TPFlag((-621.1235, 90.50472, -414.5001), (-884.789, -467.071, -412.332));
		thread TPFlag((-266.2838, 1499.117, -279.383), (-884.789, -467.071, -412.332));
		thread TPFlag((972.5123, 2034.576, -254.875), (-884.789, -467.071, -412.332));
		thread TPFlag((841.7935, -327.3016, -396.9384), (-884.789, -467.071, -412.332));
		thread Model((-884.789, -467.071, -840.332), (0, 0, 0), "com_water_tower");
		thread BackTPHide145((-161.24, -360.365, -320.189), (-884.789, -467.071, -412.332));
		thread TPFlagC((-411.459, -393.417, -307.875), (-362.061, -171.827, -194.375));
		thread TPFlagC((451.966, 158.823, -194.375), (2008.26, 1477.97, -185.173));
		thread Model((2008.26, 1477.97, -635.173), (0, 0, 0), "com_water_tower");
		thread JumpZone((869.544, -1102.24, -352.41) , (0,0,500));
		thread Model((636.129, -1004.84, -229.375), (0, 52, -90), "vehicle_hummer_destructible");
		thread Model((736.586, -872.191, -229.375), (180, 52, -90), "vehicle_hummer_destructible");
		thread Wall2((-936.588, 1485.78, -213.66), (-1289.12, 1508.25, -19.8851), 90,"com_wooden_pallet", 60, 75);
		thread TPFlagC((202.994, -378.364, -292.328), (324.689, 2665.61, -251.427));
		thread Model((324.689, 2665.61, -635.427), (0, 0, 0), "com_water_tower");
		thread TPFlagC((-228.792, 1459.38, 49.1472), (871.935, -45.3093, -394.175));
		thread Ramp((-523.951, 1615.36, -132.694), (-307.951, 1637.7, -132.694), false, 33);
		thread Ramp((-229.997, 1459.66, 34.0222), (-258.47, 1842.75, 34.0222), false, 33);
		thread JumpZone((-314.096, 1636.85, -117.569) , (0,0,600));
		thread HideTP((-579.249, 1618.51, -116.132) , (-496.559, 1618.58, -117.569));
		thread OneBox((-378.861, -107.729, -198.113) , (0,25,-90), "com_wooden_pallet");
		thread OneBox((463.134, 119.196, -205.051) , (0,25,90), "com_wooden_pallet");
        thread Icon((-209.14, 1646.25, 89.9118));
		break;
        case "mp_seatown":
		thread TPFlag((-987.4134, -1360.005, 145.0411),(-966.699, -1879.05, 508.125));
		thread TPFlag((1229.51, 918.1544, 164.25),(-966.699, -1879.05, 508.125));
		thread TPFlag((1142.332, -1131.101, 205.125),(-966.699, -1879.05, 508.125));
		thread TPFlag((-1405.013, 1019.07, 15.2217),(-966.699, -1879.05, 508.125));
		thread BackTPHide145((-802.493, -2585.08, 160.125), (-1019.97, -2579.95, 160.125));
		thread BackTPHide145((-1019.97, -2579.95, 160.125), (-1186.48, -2575.91, 160.125));
		thread BackTPHide145((-1186.48, -2575.91, 160.125), (-1305.3, -2573.5, 160.125));
		thread BackTPHide145((-1305.3, -2573.5, 160.125), (-1438.78, -2570.85, 160.125));
		thread BackTPHide145((-1438.78, -2570.85, 160.125), (-1540.87, -2568.96, 160.125));
		thread BackTPHide145((-1540.87, -2568.96, 160.125), (-424.801, -1841.98, 432.125));
		thread BackTPHide145((145.534, -2252.51, 408.125), (260.237, -2254.32, 408.125));
		thread BackTPHide145((260.237, -2254.32, 408.125), (442.533, -2249.51, 408.125));
		thread BackTPHide145((442.533, -2249.51, 408.125), (-465.36, -1845.8, 436.582));
		thread Model((-967.503, -1833.25, 470), (0,90,0), "vehicle_moving_truck_destructible");
		thread Model((-865, -1833.25, 470), (0,90,0), "vehicle_moving_truck_destructible");
		thread Model((-1067, -1833.25, 470), (0,90,0), "vehicle_moving_truck_destructible");
		thread TPFlagC((-40.6301, -2135.13, 406.125),(-627.931, -2138.96, 561.125));
		thread Model((-627.931, -2138.96, 522), (0,180,0), "vehicle_moving_truck_destructible");
		thread BackTPHide350((-1557.9, -3408.13, 192.125), (-1566.39, -3808.02, 192.125));
		thread BackTPHide350((-1566.39, -3808.02, 192.125), (-1550.6, -4292.12, 192.125));
		thread BackTPHide350((-1550.6, -4292.12, 192.125), (-1553.99, -4822.3, 192.125));
		thread BackTPHide350((-1553.99, -4822.3, 192.125), (-1558.88, -5304.22, 192.125));
		thread BackTPHide350((-1558.88, -5304.22, 192.125), (-1562.1, -5743.34, 192.125));
		thread BackTPHide350((-1562.1, -5743.34, 192.125), (-1565.35, -6184.27, 192.125));
		thread BackTPHide350((-1565.35, -6184.27, 192.125), (-1593.51, -6499.97, 192.125));
		thread BackTPHide350((-1593.51, -6499.97, 192.125), (-2174.03, -2105.56, 448.125));
		thread BackTPHide145((-2754.68, 735.863, 150.313), (-2174.03, -2105.56, 448.125));
		thread JumpZone((-2943.54, -4067.74, 384.125),(0,0,500));
		thread JumpZone((-2982.39, -5923.74, 384.125),(0,0,500));
		thread JumpZone((-2175.2, -2098.51, 448.125),(0,0,350));
		thread Wall((2704.59, 271.875, 308.133),(2707.34, 29.8322, 465.8), true);
		thread Wall((2356.22, -13.4894, 165.103),(2609.13, -2.26312, 308.143), true);
		thread Wall((2337.09, -5.93121, 300.125),(2337.1, 552.538, 483.778), true);
		thread Wall((2310.61, 540.563, 300.134),(1700.31, 538.006, 461.324), true);
		thread Wall((3110.94, 1583.87, 200.129),(3114.09, 1123.13, 331.101), true);
		thread Wall((2693.88, 1136.39, 136.134),(2636.13, 1126.82, 155.667), true);
		thread TPFlagC((2667.14, 446.251, 195.125),(2669.1, 1049.42, 350.125));
		thread TPFlagC((-2092.98, -7028.17, 384.125),(1576.81, 1119.45, 175.887));
		thread TPFlagC((1963.15, 717.207, 165.872),(-952.859, 771.125, 298.125));
        thread Icon((2667.72, 443.153, 388.613));
		break;
        case "mp_plaza2":
		thread Wall((1706.83, 803.213, 1726.13),(720.746, 795.225, 1880.17), true);
		thread Wall((755.564, 775.137, 1726.13),(746.987, -182.09, 1880.56), true);
		thread Wall((1312.93, -788.191, 1726.13),(1748.35, -791.241, 1880.98), true);
		thread Wall((1732.49, -152.255, 1718.13),(1729.79, -806.792, 1880.88), true);
		thread Ramp((1752.57, 128.679, 1703.14),(3255.87, 141.864, 2252.06), false, 33);
		thread Ramp((1752.57, 706.847, 1703.14),(3255.87, 693.257, 2252.06), false, 33);
		thread Ramp((1752.57, 423.968, 1703.14),(3255.87, 424.125, 2252.06), false, 33);
		thread Wall((3288.96, 64.3508, 2272.13),(4050.96, 63.4997, 2423.43), true);
		thread Wall((4031.43, 107.882, 2272.13),(4032.59, 1333.38, 2423.43), true);
		thread Wall((3992.38, 1307.84, 2272.13),(3318.28, 1236.62, 2423.43), true);
		thread Wall((3318.28, 1236.62, 2280.13),(3326.89, 1070.12, 2423.43), true);
		thread Wall((3297.27, 1082.69, 2280.13),(3252.48, 1084.06, 2423.43), true);
		thread Wall((3266.77, 1056.72, 2280.13),(3266.94, 860.619, 2423.43), true);
		thread BackTPHide350((1391.17, 2216.4, 648.125),(1925.25, 2314.15, 640.125));
		thread BackTPHide350((1925.25, 2314.15, 640.125),(2594.93, 2401.84, 644.125));
		thread BackTPHide350((2594.93, 2401.84, 644.125),(2992.87, 2398.07, 640.125));
		thread BackTPHide350((2992.87, 2398.07, 640.125),(1304.9, 425.846, 1718.13));
		thread BackTPHide350((1863.05, -1029.49, 800.125),(2339, -1030.12, 640.125));
		thread BackTPHide350((2339, -1030.12, 640.125),(3026.27, -1002.85, 640.125));
		thread BackTPHide350((3026.27, -1002.85, 640.125),(3423.87, -803.759, 640.125));
		thread BackTPHide350((3423.87, -803.759, 640.125),(3917.77, -294.724, 640.125));
		thread BackTPHide350((3917.77, -294.724, 640.125),(4047.13, 114.6, 640.125));
		thread BackTPHide350((4047.13, 114.6, 640.125),(1304.9, 425.846, 1718.13));
		thread TPFlag((-745.837, -40.5463, 800.125),(940.817, 575.267, 1718.13));
		thread TPFlag((-386.444, 1155.36, 616.125),(975.13, 257.604, 1718.13));
		thread TPFlag((341.235, -895.383, 640.125),(940.817, 575.267, 1718.13));
		thread TPFlag((-1091.13, -785.763, 801.125),(975.13, 257.604, 1718.13));
		thread Model((940.817, 575.267, 1770.13),(0,90,90), "vehicle_bm21_cover_castle_destructible");
		thread Model((940.817, 257.604, 1770.13),(180,90,90), "vehicle_bm21_cover_castle_destructible");
		thread Model((2405.37, 699.713, 1905.58),(-18.5,0,0), "vehicle_bm21_cover_castle_destructible");
		thread Model((2405.37, 426.057, 1905.58),(-18.5,0,0), "vehicle_bm21_cover_castle_destructible");
		thread Model((2405.37, 134.834, 1905.58),(-18.5,0,0), "vehicle_bm21_cover_castle_destructible");
		thread TPFlagC((3958.19, 1233.03, 2272.13),(-779.835, -1901.25, 608.125));
		thread JumpZone((-2026.96, -1904.17, 608.125), (0, 0, 650));
		thread BackTPHide145((-118.677, -2255.91, 640.125), (-1335.5, -1888.54, 608.125));
		thread BackTPHide350((-2159.21, -3514.88, 736.125), (-1335.5, -1888.54, 608.125));
		thread BackTPHide350((-2523.14, -3515.09, 736.125), (-1335.5, -1888.54, 608.125));
		thread BackTPHide350((-2881.58, -3323.35, 736.125), (-1335.5, -1888.54, 608.125));
		thread BackTPHide350((-3349.37, -1174.64, 736.125), (-1335.5, -1888.54, 608.125));
		thread BackTPHide350((-3341.83, -782.689, 736.125), (-1335.5, -1888.54, 608.125));
		thread TPFlagC((-2121.16, -786.542, 894.98),(407.313, -668.856, 863.402));
		thread JumpZone((1412.98, 421.188, 1718.13),(1400,0,600));
        thread Icon((3906.33, 612.205, 2302.39));
		break;
        case "mp_mogadishu":
		thread BackTPHide350((-2077.2, -319.962, -39.875),(-1503.11, -753.567, 2.12499));
		thread Ramp((-1508.69, -2546.32, -58.0126),(-1509.74, -3066.45, 169.999), false, 33);
		thread Ramp((-1522.7, -3096.32, 173.748),(-657.775, -3096.32, 173.748), false, 33);
		thread Ramp((-674.513, -3064.26, 169.999),(-683.517, -2446.77, 317.217), false, 33);
		thread JumpZone((2292.61, -1952.12, 230.425),(0,600,50));
		thread JumpZone((10121.5, -385.947, 142.651),(0,0,565));
		thread JumpZone((10123.7, -889.417, 142.651),(0,0,565));
		thread Ramp((10063.7, -370.917, 293.887),(10063.7, -903.06, 293.887), false, 33);
		thread BackTPHide350((6409.43, 262.879, -31.875),(6685.64, 262.504, -31.875));
		thread BackTPHide350((6685.64, 262.504, -31.875),(7063, 262.835, -31.875));
		thread BackTPHide350((7063, 262.835, -31.875),(7433.69, 263.213, -31.875));
		thread BackTPHide350((7433.69, 263.213, -31.875),(7764.08, 263.546, -31.875));
		thread BackTPHide350((7764.08, 263.546, -31.875),(8092.57, 263.883, -31.875));
		thread BackTPHide350((8092.57, 263.883, -31.875),(8379.28, 264.177, -31.875));
		thread BackTPHide350((8379.28, 264.177, -31.875),(8735.35, 264.537, -31.875));
		thread BackTPHide350((8735.35, 264.537, -31.875),(9140.68, 264.948, -31.875));
		thread BackTPHide350((9140.68, 264.948, -31.875),(9434.12, 265.248, -31.875));
		thread BackTPHide350((9434.12, 265.248, -31.875),(9748.36, 265.567, -31.875));
		thread BackTPHide350((9748.36, 265.567, -31.875),(10068.9, 265.896, -31.875));
		thread BackTPHide350((10068.9, 265.896, -31.875),(10370.4, 266.201, -31.875));
		thread BackTPHide350((10370.4, 266.201, -31.875),(10652.2, 266.492, -31.875));
		thread BackTPHide350((10652.2, 266.492, -31.875),(11005.7, 21.1253, -31.875));
		thread BackTPHide350((11005.7, 21.1253, -31.875),(6690.54, -556.482, -7.875));
		thread Ramp((10398.7, -888.405, -13.87499),(10154, -880.168, 123), false, 33);
		thread Ramp((10398.7, -376.152, -13.87499),(10154, -385.335, 123), false, 33);
		thread Ramp((10127.4, -894.339, 127.526),(10127.4, -373.935, 127.526), false, 33);
		thread Ramp((10127.4, -632.096, 127.526),(10451.4, -638.883, 127.526), false, 33);
		thread TPFlagC((3679.67, -1216.56, -45.875),(6314.45, -867.888, -7.875));
		thread TPFlagC((3719.16, -416.788, -45.875),(6320.19, -557.112, -7.875));
		thread TPFlagC((10455.5, -641.489, 142.651),(79.8461, 257.057, 96.0375));
		thread TPFlag((151.123, 783.927, -65.6038),(-1514.35, -818.056, 2.125));
		thread TPFlag((18.3364, 2117.72, 58.9098),(-1514.35, -818.056, 2.125));
		thread TPFlag((1571.02, 409.209, -70.1502),(-1514.35, -818.056, 2.125));
		thread TPFlag((845.229, -1029.77, -43.743),(-1514.35, -818.056, 2.125));
		thread Model((-1450, -818.056, 0),(0,90,0), "cargocontainer_20ft_red");
		thread Model((-1390.77, -1537.34, -42),(0,0,0), "cargocontainer_20ft_red");
		thread Model((-1390.77, -1537.34, 65),(0,0,0), "cargocontainer_20ft_red");
		thread Model((-1390.77, -2206.46, -42),(0,0,0), "cargocontainer_20ft_red");
		thread Model((-1390.77, -2206.46, 65),(0,0,0), "cargocontainer_20ft_red");
		thread Model((-1511.6, -1902.55, -50.9983),(0,90,0), "cargocontainer_20ft_red");
		thread Model((-1125.48, -3098.25, 188.191),(0,90,0), "cargocontainer_20ft_red");
		thread Model((6314.45, -867.888, -7.875),(0,0,0), "cargocontainer_20ft_red");
		thread Model((6320.19, -557.112, -7.875),(0,0,0), "cargocontainer_20ft_red");
		thread Model((7322.68, -769.226, -7.87499),(0,0,90), "cargocontainer_20ft_red");
		thread Model((8032.29, -355.184, -7.87499),(0,0,90), "cargocontainer_20ft_red");
		thread Model((8907.42, -692.732, -7.87499),(0,0,90), "cargocontainer_20ft_red");
		thread Model((9469.89, -308.451, -7.87499),(0,0,90), "cargocontainer_20ft_red");
        thread Icon((10129.3, -635.636, 183.192));
		break;
        case "mp_paris":
		thread TPFlag((1124.39, -57.3603, -14.1873), (686.833, 765.474, 112.125));
		thread TPFlag((422.952, 1626.28, -38.2367), (686.833, 765.474, 112.125));
		thread TPFlag((-1257.56, -165.172, 59.2366), (686.833, 765.474, 112.125));
		thread TPFlag((-798.98, 1703.58, 221.751), (686.833, 765.474, 112.125));
		thread JumpZone((683.156, 571.924, 112.125), (0, 0, 710));
		thread JumpZone((724.714, -26.5035, 368.125), (0, 0, 450));
		thread TPFlagC((517.125, -243.924, 466.125), (-118.252, 963.944, 893.125));
		thread BackTPHide350((-1297.38, 1844.31, 824.387), (-830.396, 1938.69, 783.876));
		thread BackTPHide350((-830.396, 1938.69, 783.876), (-379.504, 2134.91, 780.825));
		thread BackTPHide350((-379.504, 2134.91, 780.825), (1.87351, 2293.95, 724.651));
		thread BackTPHide350((1.87351, 2293.95, 724.651), (-118.252, 963.944, 893.125));
		thread BackTPHide350((-64.2575, 320.151, 668.993), (-118.252, 963.944, 893.125));
		thread BackTPHide145((-792.134, 543.608, 1299), (-575.871, 549.174, 1295.2));
		thread BackTPHide145((-575.871, 549.174, 1295.2), (-365.351, 562.998, 1296.77));
		thread BackTPHide145((-365.351, 562.998, 1296.77), (-118.252, 963.944, 893.125));
		thread JumpZone((-292.985, 1206.74, 893.125), (0, 0, 550));
		thread JumpZone((-351.031, 1376.09, 1052.24), (0, 0, 680));
		thread TPFlagC((-548.017, 807.449, 1300.99), (2144.64, 1825.11, -26.5681));
		thread Ramp((3294.51, 1684.16, 120.624), (3294.51, 1455.15, 120.624), false, 33);
		thread JumpZone((3729.72, 1535.05, -49.8368), (-400, 0, 600));
		thread Ramp((3744.79, 1659.61, 302.271), (3744.79, 1295.72, 302.271), false, 33);
		thread JumpZone((3300.2, 1455, 135.749), (400, 0, 600));
		thread BackTPHide145((3758.87, 854.226, 128.125), (2144.64, 1825.11, -26.5681));
		thread BackTPHide350((2435.78, -1265.01, 0.124999), (2427.55, 983.934, -25.3143));
		thread BackTPHide145((3502.32, 199.987, 0.124999), (2144.64, 1825.11, -26.5681));
		thread JumpZone((2299.17, 628.275, -17.7168), (400, -400, 700));
		thread JumpZone((2609.72, -79.7384, 278.125), (-400, -400, 580));
		thread JumpZone((1751.49, -405.06, 384.125), (0, 0, 350));
		thread BackTPHide145((1365.69, -255.696, 409.125), (2433.89, 1035.19, -23.6539));
		thread TPFlagC((1777.87, -145.89, 424.125), (-1194.3, 422.865, 184.768));
		thread Model((2185.48, 1791.12, 0), (0,90,90), "vehicle_van_sas_dark_destructable");
		thread Model((2185.48, 1791.12, 80), (0,90,90), "vehicle_van_sas_dark_destructable");
		thread Model((-118.428, 951.386, 888.125), (0,0,0), "vehicle_van_sas_dark_destructable");
		thread BackTPHide350((527.802, 985.293, 856.733), (-143.747, 951.477, 893.125));
		thread BackTPHide350((554.9, 1468.08, 880.311), (-143.747, 951.477, 893.125));
		thread BackTPHide350((365.91, 415.238, 915.882), (-143.747, 951.477, 893.125));
        thread Icon((2243.55, -602.521, 416.811));
		break;
        case "mp_exchange":
		thread BackTPHide350((2922.73, 568.867, 1553.4),(1344.46, -789.723, 1722.13));
		thread BackTPHide350((2874.62, 96.9015, 1546.93),(1344.46, -789.723, 1722.13));
		thread BackTPHide350((2865.48, -253.658, 1551.7),(1344.46, -789.723, 1722.13));
		thread BackTPHide350((2866.1, -594.853, 1581.62),(1344.46, -789.723, 1722.13));
		thread BackTPHide350((2592.11, -640.479, 1600.97),(1344.46, -789.723, 1722.13));
		thread BackTPHide350((2211.62, -558.392, 1582.73),(1344.46, -789.723, 1722.13));
		thread BackTPHide350((1747.61, -551.616, 1584.3),(1344.46, -789.723, 1722.13));
		thread BackTPHide350((1417.8, -263.536, 1060.13),(1344.46, -789.723, 1722.13));
		thread BackTPHide350((1492.86, -934.28, 438.361),(1344.46, -789.723, 1722.13));
		thread BackTPHide350((1780.8, 352.942, 507.747),(1344.46, -789.723, 1722.13));
		thread BackTPHide350((1512.77, -1151.81, 526.275),(1344.46, -789.723, 1722.13));
		thread Wall2((4621.29, 3576.63, 1006.13),(4617.13, 3766.18, 1107.19), 90,"com_plasticcase_friendly", 94, 55);
		thread BackTPHide350((4117.87, 1948.13, 620.355),(4327.83, 2896.98, 922.125));
		thread BackTPHide350((4146.26, 1277.62, 216.157),(4327.83, 2896.98, 922.125));
		thread BackTPHide350((3499.38, 2172.15, 408.309),(4327.83, 2896.98, 922.125));
		thread BackTPHide350((4197.13, 4243.69, 882.625),(4327.83, 2896.98, 922.125));
		thread BackTPHide350((4255.21, 4260.15, 546.625),(4327.83, 2896.98, 922.125));
		thread BackTPHide350((4253.09, 4240.75, 42.625),(4327.83, 2896.98, 922.125));
		thread BackTPHide350((3754.8, 1086.18, 141.413),(4327.83, 2896.98, 922.125));
		thread Wall2((4748.44, 1664.63, 1006.13),(4747.75, 1812.37, 1100.88), 90,"com_plasticcase_friendly", 94, 55);
		thread TPFlag((142.858, -868.782, 25.2022),(1357.63, -726.559, 1722.13));
		thread TPFlag((-129.629, 1174.68, 83.0845),(1357.63, -726.559, 1722.13));
		thread TPFlag((2377.34, 611.089, 73.9606),(1357.63, -726.559, 1722.13));
		thread TPFlag((394.047, -1073.72, -160.65),(1357.63, -726.559, 1722.13));
		thread Model((1545.35, -661.544, 1760),(0,90,90), "vehicle_bus_destructible_mp");
		thread Model((2203.05, -1043.28, 1690.13),(0,90,0), "vehicle_moving_truck_destructible");
		thread Model((2743.71, -938.896, 1760),(0,0,-90), "vehicle_bus_destructible_mp");
		thread TPFlagC((3332.81, 729.186, 1722.13),(4325.67, 3269.73, 922.125));
		thread Model((4325.67, 3269.73, 960.125),(0,90,90), "vehicle_moving_truck_destructible");
		thread Model((4325.67, 3269.73, 900),(0,90,0), "vehicle_moving_truck_destructible");
		thread Model((4325.67, 3269.73, 960.125),(0,90,-90), "vehicle_moving_truck_destructible");
		thread JumpZone((1699.45, -1105.58, 1722.13),(2000,0,200));
		thread JumpZone((4317.6, 2107.63, 922.125),(0,0,450));
		thread HideTP((1706.79, 1012.03, 229.125),(2025.58, 1492, 139.265));
		thread HideTP((2063.8, 1017.34, 228.625),(2025.58, 1492, 139.265));
		thread HideTP((2064.45, 893.914, 228.625),(2025.58, 1492, 139.265));
		thread HideTP((1705.94, 886.104, 229.125),(2025.58, 1492, 139.265));
		thread Ramp((1927.95, 866.262, 235.451),(1927.95, 1157.18, 300.492), false, 33);
		thread Ramp((2048.12, 1189.47, 412.976),(1788.09, 1189.47, 412.976), false, 33);
		thread Ramp((1451.28, 1096.9, 412.976),(1451.28, 1273.71, 412.976), false, 33);
		thread JumpZone((1927.15, 1135.57, 311.53),(0,0,490));
		thread JumpZone((1786.47, 1188.43, 428.101),(-500,0,300));
		thread TPFlagC((4548.91, 3735, 998.125),(2707.22, 824.797, 246.125));
		thread Model((2707.22, 824.797, 220.125),(0,0,0), "vehicle_moving_truck_destructible");
		thread Model((2129.84, 881.285, 220.125),(0,0,0), "vehicle_moving_truck_destructible");
        thread Icon((1453.07, 1268.54, 459.215));
		break;
        case "mp_bootleg":
		thread BackTPHide145((2784.52, -845.539, -67.875),(2340.48, -1000.52, -80.0099));
		thread Ramp((2676.17, 296.27, -92.9345),(2665.08, -759.099, -92.9345), true, 33);
		thread BackTPHide145((2851.87, -597.81, -115.875),(2534.17, -270.41, -79.875));
		thread BackTPHide145((2845.58, -273.648, -115.875),(2534.17, -270.41, -79.875));
		thread BackTPHide350((2893.28, 169.763, -115.875),(2534.17, -270.41, -79.875));
		thread JumpZone((1655.78, -960.24, -80.1895),(0,0,700));
		thread Ramp((1427.6, -880.131, 156.623),(1427.6, -1044.92, 156.623), false, 33);
		thread Ramp((1442.6, -1083.85, 156.623),(1132.03, -1082.16, 156.623), false, 33);
		thread HideTP((1315.13, -1083.64, 171.748),(1261.24, -1083.6, 171.748));
		thread Ramp((1089.47, -1221.48, 155.855),(1089.47, -919.103, 155.855), false, 33);
		thread Ramp((1016.86, -1230.81, 313.432),(1016.86, -912.861, 313.432), false, 33);
		thread JumpZone((1079.76, -1074.09, 170.98),(0,0,600));
		thread TPFlagC((1016.35, -1224.68, 328.557),(2020.04, -243.663, -115.875));
		thread OneBox((1685.67, -634.175, 270.479),(0,90,90), "");
		thread JumpZone((2127.92, 282.076, -115.875),(-700,-600,830));
		thread BackTPHide350((1893.5, 481.075, 197.369),(2291.67, 37.9374, -115.875));
		thread BackTPHide350((1888.76, 754.188, 197.383),(2291.67, 37.9374, -115.875));
		thread BackTPHide350((1880.83, 1113.07, 196.34),(2291.67, 37.9374, -115.875));
		thread BackTPHide350((1734.5, 1446.42, 99.1009),(2291.67, 37.9374, -115.875));
		thread JumpZone((1464.99, 136.305, 256.125),(0,0,400));
		thread BackTPHide145((900.865, 141.117, 177.996),(2291.67, 37.9374, -115.875));
		thread BackTPHide145((914.477, 888.149, 234.125),(2291.67, 37.9374, -115.875));
		thread Wall2((-2528.13, 83.0894, -96.375),(-3511.87, 72.3842, -32.1321), 90,"", 80, 60);
		thread TPFlag((-1777.66, 23.4976, -46.2537),(1329.87, -1422.36, -65.875));
		thread TPFlag((-607.29, 1474.33, -102.012),(1329.87, -1422.36, -65.875));
		thread TPFlag((421.569, -85.7653, -79.8729),(1329.87, -1422.36, -65.875));
		thread TPFlag((-732.269, -1697.89, 0.124999),(1329.87, -1422.36, -65.875));
		thread TPFlagC((946.539, 339.366, 411.7),(-3007.4, -2081.21, -104.375));
		thread Ramp((-2555.85, -171.279, -14.3571),(-2555.85, -339.276, -14.3571), false, 37);
		thread BackTPHide350((-2544.42, 368.875, 0.125001),(-3035.39, -1712.54, -104.375));
		thread BackTPHide350((-2423.48, -1149.07, 288.962),(-3035.39, -1712.54, -104.375));
		thread BackTPHide350((-3887.14, 294.272, -115.875),(-3035.39, -1712.54, -104.375));
		thread BackTPHide350((-4031.62, -1766.33, -115.875),(-3035.39, -1712.54, -104.375));
		thread BackTPHide350((-3822.05, -2197.36, 32.125),(-3035.39, -1712.54, -104.375));
		thread Wall2((-2528.13, -2381.86, -104.367),(-3511.87, -2388.27, 27.839), 90,"", 80, 60);
		thread Ramp((-2604.8, -257.136, -14.3571),(-2917.46, -257.136, -14.3571), false, 33);
		thread Ramp((-2877.39, -323.435, 99.4508),(-3079.5, -323.435, 99.4508), false, 40);
		thread JumpZone((-2919.52, -263.325, 0.767903),(0,0,500));
		thread JumpZone((-2553.99, -375.609, -104.375),(0,0,500));
		thread Model((-3007.4, -2081.21, -140.375),(0,0,0), "vehicle_moving_truck_destructible");
		thread Model((-3326.87, -980.802, -140.375),(0,0,0), "vehicle_moving_truck_destructible");
		thread Model((-2954.26, -1.25902, -140.375),(0,0,0), "vehicle_moving_truck_destructible");
		thread TPFlagC((-3104.85, -327.459, 114.576),(-1752.37, 273.476, 69.125));
		thread BackTPHide350((-3373.02, 383.592, 89.8129),(-3035.39, -1712.54, -104.375));
        thread Icon((-3022.83, -271.204, 153.908));
		break;
        case "mp_carbon":
		thread Wall2((-2562.22, -3187.13, 3771.12),(-2565.16, -3277.15, 3870.36), 90,"", 80, 60);
		thread Wall2((-2570.98, -3278.05, 3796.57),(-2444.58, -3278.99, 3883.8), 90,"", 80, 60);
		thread OneBox((-2562.78, -3200.61, 3756), (0,0,0), "com_barrel_benzin");
		thread OneBox((-2562.78, -3255.29, 3756), (0,0,0), "com_barrel_benzin");
		thread Wall2((-1926.94, -4332.54, 3769.61),(-1845.88, -4290.81, 3975.29), 90,"", 80, 60);
		thread Wall2((-1852.97, -4261.06, 3762.48),(-1901.65, -4123.99, 3988.58), 90,"", 80, 60);
		thread Wall2((-1394.34, -3280.3, 3760.07),(-1485.63, -3282.59, 3936.28), 90,"", 80, 60);
		thread Wall2((-1485.67, -3476.74, 3744.94),(-1487.89, -3281.73, 3974.21), 90,"", 80, 60);
		thread Wall2((-1369.87, -3615.88, 3930.12),(-1369.87, -3549.84, 4024.83), 90,"", 80, 60);
		thread OneBox((-1384.74, -3587.3, 3920.14), (0,0,0), "com_barrel_benzin");
		thread OneBox((-1913.77, -4327.41, 3757.13), (0,0,0), "com_barrel_benzin");
		thread OneBox((-1863.03, -4310.68, 3757.13), (0,0,0), "com_barrel_benzin");
		thread OneBox((-1413.56, -3295, 3756), (0,0,0), "com_barrel_benzin");
		thread OneBox((-1463.85, -3295, 3756), (0,0,0), "com_barrel_benzin");
		thread Ramp((-1365.8, -4129, 3955.16), (-1050.3, -4129, 3955.16), false, 33);
		thread Ramp((-1206.14, -4180.44, 3955.16), (-1206.14, -4231.75, 3955.16), false, 50);
		thread Ramp((-1365.8, -4293.34, 4127.09), (-1050.3, -4265.52, 4127.09), false, 33);
		thread JumpZone((-1206.98, -4223.1, 3969.78), (0,0,600));
		thread TPFlagC((-1067.13, -4264.02, 4141.71), (-2871.9, -4715.95, 3711.13));
		thread Wall2((-2824.24, -4673.13, 3724.13),(-2822.67, -4756.87, 3823.86), 90,"com_plasticcase_friendly", 80, 60);
		thread Ramp((-3212.02, -4650.21, 3697.73), (-3212.02, -4477.41,3697.73), false, 33);
		thread Ramp((-3269.58, -4495.81, 3697.73), (-3609.03, -4495.81, 3697.73), false, 33);
		thread Ramp((-3595.59, -4553.8,  3697.73), (-3595.59, -4711.47,  3697.73), false, 33);
		thread TPFlagC((-3768.92, -4722.34, 3576.13), (-3722.82, -3993.6, 3822.38));
		thread Wall2((-3575.88, -4451.16, 3584.12),(-3528.13, -4451.8, 3667.86), 90,"com_plasticcase_friendly", 80, 60);
		thread Wall2((-3172.44, -4559.87, 3584.13),(-3171.96, -4512.13, 3667.87), 90,"com_plasticcase_friendly", 80, 60);
		thread Model((-3003.28, -4718.78, 3711.13), (0,90,0), "cargocontainer_20ft_red");
		thread TPFlag((-219.252, -3576.07, 3898.13), (-1453.92, -3586.31, 3918.63));
		thread TPFlag((-893.335, -4887.67, 3884.3), (-1453.92, -3586.31, 3918.63));
		thread TPFlag((-2632.54, -4999.14, 3633.31), (-1453.92, -3586.31, 3918.63));
		thread TPFlag((-2868.71, -2907.23, 3758.13), (-1453.92, -3586.31, 3918.63));
		thread TPFlagC((-2361.62, -3594.03, 3918.63), (-1203.18, -4110.26, 3969.78));
        thread Icon((-3597.64, -4494.47, 3742.74));
		break;
        case "mp_hardhat":
		thread BackTPHide350((2673.11, 1528.24, 384.125),(2685.64, -143.727, 384.125));
		thread BackTPHide145((2252.17, 1520.85, 384.125),(2685.64, -143.727, 384.125));
		thread Wall2((2956.01, 1103.87, 392.125), (2956.01, 1040.13, 498.935), 90,"", 80, 60);
		thread Wall2((3304.13, 361.614, 392.125), (3383.85, 361.614, 547.734), 90,"", 80, 60);
		thread BackTPHide350((3223.39, -1789.06, 384.125),(3243.87, -1173.72, 384.125));
		thread BackTPHide350((2905.19, -1820.98, 384.125),(3243.87, -1173.72, 384.125));
		thread Wall2((2475.2, -478.4, 476.125), (2553.72, -821.938, 541.397), 90,"", 80, 60);
		thread JumpZone((2697.13, 329.893, 384.125),(0,0,550));
		thread Ramp((2317.95, 341.178, 480.928),(2570.82, 341.178, 480.928), false, 35);
		thread Ramp((2332.3, 388.125, 604.559),(2332.3, 827.197, 604.559), false, 35);
		thread Ramp((2332.3, 355.868, 604.559),(2329.83, 132.712, 604.559), false, 35);
		thread JumpZone((2330.17, 873.684, 456.125),(0,0,570));
		thread TPFlagC((2329.63, 127.125, 619.684),(-1216.56, -1645.85, 400.125));
		thread Wall2((-1526.68, -1344.47, 623.719), (-1309.38, -1777.74, 424.14), 90,"", 80, 60);
		thread Wall2((-1099.54, -1775.39, 424.144), (-1314.5, -1777.86, 606.584), 90,"", 80, 60);
		thread BackTPHide350((-1352.29, 353.134, 548.286),(-1311.84, -248.805, 545.092));
		thread Model((-1216.56, -1645.85, 432.125),(0,0,-90), "vehicle_van_dark_gray");
		thread TPFlagC((-1203.99, -273.63, 544.967),(696.873, 3590.15, 224.125));
		thread Wall2((1037.36, 3592.15, 308.193), (1043.35, 4055.87, 437.042), 90,"", 73, 63);
		thread Wall2((-386.386, 1338.88, 648.125), (-571.647, 1341.22, 751.689), 90,"", 73, 63);
		thread Wall2((-575.584, 1345.11, 648.134), (-578.262, 1754.81, 751.689), 90,"", 73, 63);
		thread JumpZone((90.1497, 2330.22, 32.125),(0,-455,1020));
		thread JumpZone((-110.674, 2330.22, 32.125),(0,-455,1020));
		thread JumpZone((-320.951, 2330.22, 32.125),(0,-455,1020));
		thread Model((90.1497, 2330.22, 32.125),(0,0,0), "prop_flag_seal");
		thread Model((-110.674, 2330.22, 32.125),(0,0,0), "prop_flag_seal");
		thread Model((-320.951, 2330.22, 32.125),(0,0,0), "prop_flag_seal");
		thread JumpZone((-2016.87, 1743.13, 224.125),(2500,0,500));
		thread Model((-2016.87, 1743.13, 224.125),(0,0,0), "prop_flag_seal");
		thread JumpZone((208.875, 1743.13, 320.125),(0,0,750));
		thread TPFlagC((212.401, 1456.88, 640.125),(67.9441, 793.078, 436.125));
		thread TPFlag((711.765, 1191.13, 368.125),(3231.17, -1168.01, 384.125));
		thread TPFlag((1538.08, 659.609, 186.682),(3231.17, -1168.01, 384.125));
		thread TPFlag((1899.76, -1050.82, 293.486),(3231.17, -1168.01, 384.125));
		thread TPFlag((637.547, -449.918, 288.125),(3231.17, -1168.01, 384.125));
        thread Icon((-119.306, 1429.83, 659.036));
		break;
        case "mp_alpha":
		thread Wall2((-773.05, -601.374, 144.128),(-773.05, -504.606, 220.501), 90,"", 60, 65);
		thread Wall2((-952.835, -105.372, 144.125),(-952.835, -16.2453, 221.64), 90,"", 60, 65);
		thread Ramp((-757.377, -263.482, 158.024), (-457.897, -263.105, 167.278), false, 35);
		thread Ramp((-757.377, -99.5135, 158.024), (-457.897, -99.5135, 167.278), false, 35);
		thread Ramp((-418.038, -350.049, 355.797), (-418.038, -96.125, 355.797), false, 35);
		thread JumpZone((-422.182, -351.016, 370.922), (0,400,560));
		thread OneBox((-955.266, -259.578, 190.135), (0,90,90), "com_pallet");
		thread Ramp((-801.005, 3354.6, 402.52), (-871.341, 3354.6, 402.52), false, 60);
		thread Ramp((-1106.16, 3364.44, 477.64), (-1106.16, 3242.48, 477.64), false, 45);
		thread JumpZone((-748.486, 3361.42, 292.125),(0,0,550));
		thread Ramp((-1099.79, 2946.06, 528.244), (-881.13, 2946.06, 528.244), false, 40);
		thread JumpZone((-1107.09, 3235.71, 492.765),(0,-500,400));
		thread JumpZone((-877.359, 3354.24, 417.645),(-400,0,400));
		thread OneBox((-949.761, -81.8951, 165.134), (0,90,-90), "com_pallet");
		thread OneBox((-949.761, -25.3131, 165.134), (0,90,-90), "com_pallet");
		thread OneBox((-761.627, -527.391, 165.134), (0,90,90), "com_pallet");
		thread OneBox((-761.627, -591.506, 165.135), (0,90,90), "com_pallet");
		thread Wall2((-840.127, 508.277, 144.133),(-887.875, 508.277, 227.871), 90,"", 60, 65);
		thread Wall2((-452.667, 1917.12, 144.134),(-579.875, 1913.86, 247.873), 90,"", 60, 65);
		thread Wall2((-1019.89, 1800.13, 144.132),(-1020.26, 1847.87, 227.875), 90,"", 60, 65);
		thread OneBox((-1017.1, 1826.68, 164), (0,90,-90), "com_pallet");
		thread OneBox((-533.211, 1917.52, 164), (0,0,-90), "com_pallet");
		thread OneBox((-471.695, 1916.24, 164), (0,0,-90), "com_pallet");
		thread OneBox((-864.483, 510.076, 164), (0,0,90), "com_pallet");
		thread Ramp((-726.006, 1232.13, 156.641), (-726.006, 553.112, 156.641), false, 35);
		thread TPFlag((-507.788, 2410.72, 136.125), (-791.016, 3235.25, 292.125));
		thread TPFlag((193.443, 1180.65, -7.875), (-791.016, 3235.25, 292.125));
		thread TPFlag((186.551, 215.523, 0.124998), (-791.016, 3235.25, 292.125));
		thread TPFlag((-1744.58, 702.405, -5.69623), (-791.016, 3235.25, 292.125));
		thread TPFlagC((-864.606, 2946.78, 543.369), (-972.688, 1709.58, 136.125));
		thread TPFlagC((-723.847, 544.468, 171.766), (-837.2, -421.924, 136.125));
		thread JumpZone((-462.698, -263.245, 182.269),(0,0,620));
		thread JumpZone((-462.384, -111.562, 182.279),(0,0,620));
		thread HideTP((-406.668, -109.129, 538.112),(-410.243, -39.8337, 586.556));
		thread HideTP((-376.725, -102.133, 524.334),(-410.243, -39.8337, 586.556));
		thread HideTP((-449.828, -102.132, 539.981),(-410.243, -39.8337, 586.556));
		thread TPFlagC((128.492, 705.246, 648.125), (-767.41, 1969.3, -1.07262));
        thread Icon((-19.9993, 213.079, 660.9));
		break;
        case "mp_village":
		thread Wall2((-1789.57, 997.25, 285.933),(-2068.13, 841.254, 370.771), 0, "afr_woodfence01", 65, 65);
		thread Wall2((-412.906, 2007.34, 270.949),(-370.818, 1826.97, 378.533), 0, "afr_woodfence01", 70, 65);
		thread Wall2((25.4833, 16.8714, 194.067),(192.203, 311.91, 328.281), 0, "afr_woodfence01", 60, 65);
		thread Ramp((-1050.42, -1406.76, 748.617), (-1441.58, -1633.11, 748.617), false, 35);
		thread JumpZone((-1256.68, -871.355, 621.625) , (110,-400,670));
		thread Ramp((-571.788, -2031.26, 506.118), (-559.823, -2122.23, 506.118), false, 45);
		thread Ramp((-1045.49, -2286.17, 689.06), (-1048.19, -2114.85, 689.06), false, 40);
		thread Ramp((-738.379, -1901.33, 717.22), (-868.358, -1769.49, 717.22), false, 40);
		thread Ramp((-705.832, -1850.83, 717.22), (-787.407, -1769.64, 717.22), false, 40);
		thread JumpZone((-581.526, -2079.41, 521.243) , (-600,-100,550));
		thread JumpZone((-1041.73, -2287.09, 704.185) , (300,700,300));
		thread TPFlag((-1718.34, -735.974, 300.231) , (-95.9129, 332.947, 174.931));
		thread TPFlag((377.37, -701.888, 187.342) , (-95.9129, 332.947, 174.931));
		thread TPFlag((66.6458, 1415.05, 262.665) , (-95.9129, 332.947, 174.931));
		thread TPFlag((1564.97, 840.342, 240.125) , (-95.9129, 332.947, 174.931));
		thread TPFlagC((-1064.98, 1627.04, 129.958) , (-1258.31, -680.825, 623.588));
		thread TPFlagC((-1432.39, -1627.06, 763.742) , (-530.758, -2073.59, 521.243));
        thread Icon((-734.336, -1819.85, 758.565));
		break;
        case "mp_lambeth":
		thread Wall2((1270.5, 1555.7, -286.215),(1270.96, 1914.42, -46.4977), 90, "", 65, 65);
		thread Wall2((1272.66, 1557.36, -285.135),(1197.73, 1562.5, -172.703), 90, "", 65, 65);
		thread Wall2((333.565, 2060.63, -220.978),(413.466, 2058.05, -120.433), 90, "", 65, 65);
		thread Wall2((344.222, 2071.05, -227.921),(341.588, 1824.85, -6.18077), 90, "", 65, 65);
		thread OneBox((1240.36, 1580.82, -275.527) , (0,0,42), "vehicle_small_hatch_blue_destructible_mp");
		thread OneBox((383.81, 2047.05, -225.036) , (0,0,-45), "vehicle_small_hatch_blue_destructible_mp");
		thread Ramp((1278.5, 1989.41, -69.9801), (1499.93, 1989.41, -69.9801), false, 35);
		thread Ramp((1548.74, 1862.12, 81.227), (1548.74, 2139.03, 81.227), false, 35);
		thread Ramp((1557, 2184.64, 82.624), (1200.08, 2184.64, 82.624), false, 35);
		thread JumpZone((1493.62, 1987.96, -54.8551) , (0,0,600));
		thread TPFlagC((1199.1, 2185.86, 97.749) , (2033.86, 1409.9, -303.875));
		thread Wall2((1959.59, 1200.76, -295.875),(2071.12, 1193.94, -192.125), 90, "com_plasticcase_friendly", 65, 65);
		thread Wall2((2273.45, 1674.74, -159.875),(2274.77, 1722.49, -80.125), 90, "com_plasticcase_friendly", 65, 65);
		thread Ramp((2196.87, 1146.18, -152.357), (2182.16, 962.446, -152.357), false, 45);
		thread Ramp((2035.64, 919.774, -19.2739), (2311.29, 914.774, -19.2739), false, 35);
		thread JumpZone((2185.57, 974.521, -137.232) , (0,0,550));
		thread TPFlagC((2032.28, 921.857, -4.1489) , (1337.92, 853.321, -121.422));
		thread Wall2((898.08, 977.078, -278.213),(890.29, 1052.01, -94.3636), 90, "", 65, 65);
		thread Wall2((895.078, 1049.14, -282.905),(1116.99, 1050.83, -79.388), 90, "", 65, 65);
		thread Wall2((1544.48, 961.431, -309.697),(1615.93, 945.578, -153.93), 90, "", 65, 65);
		thread Wall2((1615.12, 935.956, -302.372),(1615.35, 678.953, -44.2472), 90, "", 65, 65);
		thread Ramp((1087.15, 607.633, -137.366), (877.487, 607.633, -137.366), false, 40);
		thread OneBox((912.716, 997.678, -272.619) , (0,90,-45), "vehicle_small_hatch_blue_destructible_mp");
		thread OneBox((1576.5, 932.664, -300.232) , (0,0,-45), "vehicle_small_hatch_blue_destructible_mp");
		thread Ramp((893.126, 561.979, -137.366), (880.126, 264.202, -137.366), false, 40);
		thread Ramp((1012.11, 177.595, -6.44282), (764.969, 193.865, -6.44282), false, 40);
		thread JumpZone((882.065, 265.118, -122.241) , (0,0,550));
		thread TPFlag((1286.72, -23.0049, -235.875) , (596.393, 1722.13, -50.875));
		thread TPFlag((2554.41, 1401.95, -306.786) , (596.393, 1722.13, -50.875));
		thread TPFlag((57.5392, 1582.03, -244.37) , (596.393, 1722.13, -50.875));
		thread TPFlag((-199.609, -1114.33, -242.906) , (596.393, 1722.13, -50.875));
        thread Icon((1028.16, 179.778, 39.5788));
		break;
        case "mp_radar":
		thread BackTPHide350((-4593.78, -2487.17, 1925.3), (-4549.61, -1493.47, 2032.95));
		thread BackTPHide350((-3968.13, -2432.64, 2015.12), (-4549.61, -1493.47, 2032.95));
		thread BackTPHide350((-3788.54, -2215.54, 2038.12), (-4549.61, -1493.47, 2032.95));
		thread BackTPHide350((-3782.88, -1937.64, 2074.65), (-4549.61, -1493.47, 2032.95));
		thread BackTPHide350((-3838.93, -1441.99, 2090.29), (-4549.61, -1493.47, 2032.95));
		thread BackTPHide350((-3982.43, -951.377, 2093.4), (-4549.61, -1493.47, 2032.95));
		thread BackTPHide350((-4143.51, -446.593, 2147.19), (-4549.61, -1493.47, 2032.95));
		thread BackTPHide350((-4617, -67.2378, 2044.43), (-4549.61, -1493.47, 2032.95));
		thread BackTPHide350((-5270.1, 298.85, 2030.56), (-4549.61, -1493.47, 2032.95));
		thread Ramp((-5351.58, -861.722, 2388.38), (-5447.63, -1100.85, 2388.38), false, 35);
		thread JumpZone((-5271.18, -906.446, 2072.64),(0,0,800));
		thread JumpZone((-5378.36, -1111.17, 2071.26),(0,0,800));
		thread Model((-5271.18, -906.446, 2072.64),(0,0,0), "prop_flag_neutral");
		thread Model((-5378.36, -1111.17, 2071.26),(0,0,0), "prop_flag_neutral");
		thread Ramp((-5783.54, -676.768, 2641.19), (-5893.65, -1051.65, 2641.19), false, 35);
		thread JumpZone((-5353.42, -873.405, 2403.5),(-600,100,680));
		thread JumpZone((-5447.8, -1097.87, 2403.5),(-600,100,680));
		thread Wall2((-3832.52, 1213.36, 1170.87), (-3735.36, 1074.37, 1314.48), 0,"com_plasticcase_green_big_snow", 80, 60);
		thread JumpZone((-3839, 1304.9, 1162.13),(0,350,480));
		thread Wall2((-4239.12, 1784.38, 1168.13), (-4239.12, 1903.27, 1263.87), 0,"com_plasticcase_green_big_snow", 80, 60);
		thread TPFlagC((-5773.76, -657.35, 2656.31),(-3831.8, 1788.19, 1164.13));
		thread TPFlagC((-3835.56, 1763.43, 1266.73),(-5820.58, 1839.32, 1454.22));
		thread TPFlagC((-5752.65, 1794.33, 2019.22),(-4842.62, 4494.29, 1330.36));
		thread TPFlag((-4576.64, 732.681, 1149.28),(-4785.5, -733.729, 2236));
		thread TPFlag((-6337.41, 1500.12, 1244.84),(-4785.5, -733.729, 2236));
		thread TPFlag((-6327.98, 3658.52, 1335.13),(-4785.5, -733.729, 2236));
		thread TPFlag((-4742.91, 3623.98, 1170.78),(-4785.5, -733.729, 2236));
		thread Model((-4785.5, -733.729, 2250),(0,0,90), "vehicle_bm21_mobile_bed_destructible");
		thread Model((-4785.5, -733.729, 2250),(0,0,0), "vehicle_bm21_mobile_bed_destructible");
		thread Model((-4785.5, -733.729, 2250),(0,0,-90), "vehicle_bm21_mobile_bed_destructible");
        thread Icon((-5749.81, 2167.68, 2049.63));
		break;
        case "mp_interchange":
		thread TPFlag((1186.9, -2790.74, 123.844), (-10162.8, 4953.83, 708.125));
		thread TPFlag((-469.057, -615.748, 75.602), (-10162.8, 4953.83, 708.125));
		thread TPFlag((845.307, 1674.88, 55.1497), (-10162.8, 4953.83, 708.125));
		thread TPFlag((2665.22, -486.2, 81.6217), (-10162.8, 4953.83, 708.125));
		thread Ramp((-9173.82, 3513.57, 830.46),(-9447.61, 3358.1, 830.46), false, 36);
		thread JumpZone((-9493.04, 3329.37, 708.125), (0,0,550));
		thread JumpZone((-9320.32, 3446.87, 845.585), (-700,1600,550));
		thread Ramp((-10026.7, 5057.54, 964.492),(-10259.8, 4921.45, 964.492), false, 39);
		thread JumpZone((-10258.5, 4921.48, 979.617), (0,0,730));
		thread Model((-10162.8, 4953.83, 690.125),(0,30,0), "vehicle_bus_destructible_mp");
		thread Model((-9381.84, 3557.91, 690.125),(0,30,0), "vehicle_bus_destructible_mp");
		thread TPFlagC((-9312.74, 3456.69, 1260.13), (-11630.4, 2346.78, 708.125));
		thread JumpZone((-12186.9, 3867.62, 708.125), (0,0,1000));
		thread Model((-12186.9, 3867.62, 708.125),(0,0,0), "prop_flag_neutral");
		thread TPFlagC((-11636.8, 2346.74, 1260.08), (-6917.69, 11800.4, 1099.13));
		thread BackTPHide350((-5444.82, 9674.44, 512.125), (-6917.69, 11800.4, 1099.13));
		thread BackTPHide350((-5444.82, 9674.44, 512.125), (-6917.69, 11800.4, 1099.13));
		thread BackTPHide350((-4173.94, 11855.5, 512.125), (-6917.69, 11800.4, 1099.13));
		thread BackTPHide350((-4010.62, 12243.3, 512.125), (-6917.69, 11800.4, 1099.13));
		thread BackTPHide350((-3219.62, 14319.5, 512.125), (-6917.69, 11800.4, 1099.13));
		thread BackTPHide350((-3410.6, 13894.1, 512.125), (-6917.69, 11800.4, 1099.13));
		thread BackTPHide350((-2942.09, 17301.2, 512.125), (-6917.69, 11800.4, 1099.13));
		thread BackTPHide350((-2982.43, 17817.4, 512.125), (-6917.69, 11800.4, 1099.13));
		thread BackTPHide350((-3269.25, 19643.5, 512.125), (-6917.69, 11800.4, 1099.13));
		thread JumpZone((-6010.7, 13234.2, 1111.13), (0,1500,500));
		thread Model((-6010.7, 13234.2, 1111.13),(0,0,0), "prop_flag_neutral");
		thread TPFlagC((-4449.54, 14840.4, 1109.86), (640.541, 290.309, 71.5906));
        thread Icon((-4756.33, 14247.9, 979.369));
		break;
        case "mp_underground":
		thread BackTPHide350((1500.99, -539.096, 69.4142), (1807.59, 2310.81, -9.03667));
		thread BackTPHide350((1859.72, -435.14, 70.4548), (1807.59, 2310.81, -9.03667));
		thread BackTPHide350((2238.15, -405.367, 38.8162), (1807.59, 2310.81, -9.03667));
		thread BackTPHide350((1168.41, 3011.13, 403.869), (1807.59, 2310.81, -9.03667));
		thread BackTPHide350((1485.8, 2991.59, -15.875), (1807.59, 2310.81, -9.03667));
		thread BackTPHide350((1807.13, 2978.66, -12.4331), (1807.59, 2310.81, -9.03667));
		thread BackTPHide350((2219.45, 2980.13, -12.4344), (1807.59, 2310.81, -9.03667));
		thread BackTPHide145((943.469, 2822.75, 173.72), (1807.59, 2310.81, -9.03667));
		thread BackTPHide145((843.485, 3227.42, 152.125), (1807.59, 2310.81, -9.03667));
		thread TPFlag((-1534.98, 1366.39, -255.875), (1818.83, 1589.64, 0.125001));
		thread TPFlag((-441.244, 2945.58, -130.521), (1818.83, 1589.64, 0.125001));
		thread TPFlag((1263.8, 1725.9, -119.875), (1818.83, 1589.64, 0.125001));
		thread TPFlag((150.99, -651.369, 0.125001), (1818.83, 1589.64, 0.125001));
		thread JumpZone((1807.13, 2236.44, -7.97649), (0,0,550));
		thread Model((1807.13, 2236.44, -7.97649),(0,0,0), "prop_flag_neutral");
		thread JumpZone((1129.12, 1109.88, 144.125), (0,0,600));
		thread TPFlagC((1310.19, 2303.96, 312.125), (-2704.3, 1594.19, -215.875));
		thread BackTPHide350((-2512.46, 83.3034, 8.12499), (-864.963, -776.734, 0.124997));
		thread BackTPHide350((-2248.94, 93.9922, 5.19923), (-864.963, -776.734, 0.124997));
		thread BackTPHide350((-1405.21, -1661.59, -22.4174), (-864.963, -776.734, 0.124997));
		thread BackTPHide350((-1681.25, -1607.24, -19.8129), (-864.963, -776.734, 0.124997));
		thread BackTPHide350((-2499.72, -985.94, 8.125), (-864.963, -776.734, 0.124997));
		thread BackTPHide350((-2576.95, -640.875, 0.124999), (-864.963, -776.734, 0.124997));
		thread BackTPHide350((-2747.6, -436.042, 8.125), (-864.963, -776.734, 0.124997));
		thread JumpZone((-1636.35, -659.176, 0.125001), (0,0,650));
		thread Model((-1636.35, -659.176, 0.125001),(0,0,0), "prop_flag_neutral");
		thread Wall2((-2281.55, 1666.26, -207.866), (-2532.94, 1656.44, -76.2264), 90,"", 80, 60);
		thread Wall2((-2300, 1975.87, -207.875), (-2291.35, 1909.92, -88.2286), 90,"", 80, 60);
		thread Wall2((-2545.36, 1969.86, -207.873), (-2549.52, 1893.43, -87.4564), 90,"", 80, 60);
		thread Wall2((-2603.86, 1223.87, -207.873), (-2462.16, 1223.87, -93.0505), 90,"", 80, 60);
		thread TPFlagC((-1972.12, 941.874, -87.875), (-900.528, -775.873, 0.124998));
		thread Ramp((-1592.28, -436.78, 203.719), (-1970.4, -439.896, 204.323), false, 35);
		thread TPFlagC((-1498.85, -413.641, 231.137), (896.794, 1618.59, -48.875));
		thread Wall2((-2095.85, 2471.5, -215.875), (-1906.12, 2466.36, -99.1984), 90,"", 80, 60);
		thread Wall2((-2125.29, 1888.57, -53.875), (-2122.61, 2189.87, 67.017), 90,"", 80, 60);
        thread Icon((-1967.97, -442.418, 241.199));
		break;
        case "mp_bravo":
		thread Wall2((399.607, 66.8628, 1217.71),(403.875, -65.0473, 1353.51), 90,"", 70, 55);
		thread Wall2((-708.131, 337.074, 1219.25),(-705.276, 489.153, 1320.16), 90,"", 70, 55);
		thread Wall2((400.073, 291.21, 1228.79),(399.026, 495.857, 1320.36), 90,"", 70, 55);
		thread Ramp((-57.1, -349.915, 1208.85), (-57.1, -609.842, 1208.85), false, 35);
		thread Ramp((-203.834, -651.65, 1379.47), (113.092, -651.65, 1379.47), false, 35);
		thread JumpZone((-56.8077, -604.87, 1223.97), (0,0,600));
		thread Wall2((-702.098, 908.227, 1236.55),(-699.687, 535.862, 1332.31), 90,"", 70, 55);
		thread Wall2((-726.125, 312.142, 1218.75),(-893.932, 284.875, 1339.58), 90,"", 70, 55);
		thread Wall2((-416.774, 1251.23, 1217.35),(-408.719, 1383.88, 1309.87), 90,"", 70, 55);
		thread Wall2((-2107.29, 801.789, 991.336),(-1984.75, 797.599, 1166.55), 90,"", 70, 55);
		thread Model((-706.312, 823.005, 1260.5), (0,90,90), "vehicle_aa_truck");
		thread Model((-704.664, 407.283, 1253.66), (0,90,90), "vehicle_aa_truck");
		thread Model((-812.549, 298.338, 1260.77), (0,0,90), "vehicle_aa_truck");
		thread Model((-2044.59, 801.188, 1023.66), (0,0,90), "vehicle_aa_truck");
		thread Model((-417.685, 1320.94, 1242.43), (0,90,90), "vehicle_aa_truck");
		thread Model((407.926, 15.1664, 1240.47), (0,90,90), "vehicle_aa_truck");
		thread Model((404.329, 413.469, 1246.42), (0,90,90), "vehicle_aa_truck");
		thread TPFlag((-1496.83, -306.877, 957.964), (-2032.9, 829.916, 988.526));
		thread TPFlag((348.433, -1035.2, 966.533), (-2032.9, 829.916, 988.526));
		thread TPFlag((837.531, -27.2415, 1144.95), (-2032.9, 829.916, 988.526));
		thread TPFlag((523.294, 784.889, 1091.57), (-2032.9, 829.916, 988.526));
		thread TPFlagC((-805.566, 391.003, 1211.88), (1.25596, 345.461, 1206.87));
        thread Icon((108.391, -650.242, 1425.17));
		break;
    }
}

Icon(pos)
{
	level endon("game_ended");
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add(curObjID, "active");
	objective_position(curObjID, pos);
	objective_icon(curObjID, "iw5_cardicon_gunstar");
}

Model(position, angle, modelname)
{
    level endon("game_ended");
	modelspawn = spawn("script_model", position);
    modelspawn setModel(modelname);
	modelspawn.angles = angle;
}

OneBox(position, angle, Model)
{
    level endon("game_ended");
	OneBox = spawn("script_model", position);
    OneBox setModel(Model);
    OneBox CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
	OneBox.angles = angle;
}

BackTPHide145(position, where)
{
	level endon("game_ended");

	for (;;)
	{
		wait (.02);
		foreach (player in level.players)
		{
			dist = distance(player.origin, position);
			if (dist < 145)
			{
				player setOrigin(where);
			}
		}
	}
}

BackTPHide350(position, where)
{
	level endon("game_ended");

	for (;;)
	{
		wait (.02);
		foreach (player in level.players)
		{
			dist = distance(player.origin, position);
			if (dist < 350)
			{
				player setOrigin(where);
			}
		}
	}
}

Ramp(top, bottom, isInvisible, blo)
{
	level endon("game_ended");
    distance = distance(top, bottom);
    blocks = ceil(distance / blo) + 1;
    
    A = ((top[0] - bottom[0]) / blocks, (top[1] - bottom[1]) / blocks, (top[2] - bottom[2]) / blocks);
    temp = vectorToAngles((top[0] - bottom[0], top[1] - bottom[1], top[2] - bottom[2]));
    BA = (temp[2], temp[1] + 90, temp[0]);
 
    
    for (b = 0; b <= blocks; ++b) {
        crate = spawn("script_model", (bottom[0] + A[0] * b, bottom[1] + A[1] * b, bottom[2] + A[2] * b));
        crate setModel("com_plasticcase_enemy");
        crate CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
        crate.angles = BA;
        if(isInvisible)
        {
            crate hide();
        }
    }
}

Wall2(start, end, myangle, Model, blo, hei)
{
    level endon("game_ended");
    D = Distance((start[0], start[1], 0), (end[0], end[1], 0));
    H = Distance((0, 0, start[2]), (0, 0, end[2]));
    blocks = Ceil(D/blo);
    height = Ceil(H/hei);
    CX = end[0] - start[0];
    CY = end[1] - start[1];
    CZ = end[2] - start[2];
    XA = (CX/blocks);
    YA = (CY/blocks);
    ZA = (CZ/height);
    TXA = (XA/4);
    TYA = (YA/4);
    Temp = VectorToAngles(end - start);
    Angle = (0, Temp[1], myangle);
    for(h = 0; h < height; h++){
        block = spawn("script_model", (start + (TXA, TYA, 10) + ((0, 0, ZA) * h)), 1);
        block setModel( Model );  
		block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);   
        block.angles = Angle;
        for(i = 1; i < blocks; i++){
            block = spawn("script_model", (start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h)), 1);
            block setModel( Model );   
			block CloneBrushmodelToScriptmodel(level.airDropCrateCollision); 
            block.angles = Angle;
        }
        block = spawn("script_model", ((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h)), 1);
        block setModel( Model );  
		block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);  
        block.angles = Angle;
    }
}

Wall(start, end, isInvisible)
{
    level endon("game_ended");
    D = Distance2D(start, end);
    H = Distance((0, 0, start[2]), (0, 0, end[2]));
    blocks = Ceil(D / 60);
    height = Ceil(H / 30);
 
    C = (end[0] - start[0], end[1] - start[1], end[2] - start[2]);
    A = (C[0] / blocks, C[1] / blocks, C[2] / height);
    TXA = A[0] / 4;
    TYA = A[1] / 4;
    angle = vectorToAngles(C);
    angle = (0, angle[1], 90);
 
    for (h = 0; h < height; ++h)
    {
        crate = spawn("script_model", (start[0] + TXA, start[1] + TYA, start[2] + 15 + A[2] * h));
        crate setModel("com_plasticcase_friendly");
        crate CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
		crate.angles = angle;
        
        if(isInvisible)
        {
            crate Hide();
        }
 
        for (i = 0; i < blocks; ++i)
        {
            crate = spawn("script_model", (start[0] + A[0] * i, start[1] + A[1] * i, start[2] + 15 + A[2] * h));
            crate setModel("com_plasticcase_friendly");
			crate CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
			crate.angles = angle;
            
            if(isInvisible)
            {
                crate Hide();
            }
        }
 
        crate = spawn("script_model", (start[0] + TXA * -1, start[1] + TYA * -1, start[2] + 15 + A[2] * h));
        crate setModel("com_plasticcase_friendly");
        crate CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
		crate.angles = angle;
        
        if(isInvisible)
        {
            crate Hide();
        }
    }
}

JumpZone(position, impulse)
{
	level endon("game_ended");
	zone = spawn("script_model", position);
	zone setModel("weapon_c4_bombsquad");
	zone setCursorHint("HINT_NOICON");
	zone setHintString("Press and hold ^1[{+activate}] ^7for jump");
	zone makeUsable();
	
	for (;;)
	{
		wait (.25);
		
		foreach (player in level.players)
		{
			dist = distance(player.origin, position);
			if (dist < 75 && player isOnGround() && player useButtonPressed())
			{
				player setVelocity(impulse);
			}
		}
	}
}

TPFlagC(startOrigin, endOrigin)
{
	level endon("game_ended");
    wait(1);
	fxhandle = int(loadfx("fire/jet_afterburner"));
    effect = spawnfx(fxhandle, startOrigin);
    triggerfx(effect);

	fxhandle1 = int(loadfx("fire/jet_afterburner"));
    effect1 = spawnfx(fxhandle1, startOrigin);
    triggerfx(effect1);

	for (;;)
	{
		wait (.25);
		foreach (player in level.players)
		{
			dist = distance(player.origin, startOrigin);
			if (dist < 75)
			{
				player setOrigin(endOrigin);
			}
		}
	}
}

HideTP(startOrigin, endOrigin)
{
	level endon("game_ended");
	for (;;)
	{
		wait (.25);
		foreach (player in level.players)
		{
			dist = distance(player.origin, startOrigin);
			if (dist < 25)
			{
				player setOrigin(endOrigin);
			}
		}
	}
}

TPFlag(startOrigin, endOrigin)
{
	level endon("game_ended");
    wait(1);
	fxhandle = int(loadfx("fire/jet_afterburner"));
    effect = spawnfx(fxhandle, startOrigin);
    triggerfx(effect);

	fxhandle1 = int(loadfx("fire/jet_afterburner"));
    effect1 = spawnfx(fxhandle1, startOrigin);
    triggerfx(effect1);
	
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add(curObjID, "active");
	objective_position(curObjID, startOrigin);
	objective_icon(curObjID, "compass_waypoint_bomb");

	for (;;)
	{
		wait (.25);
		foreach (player in level.players)
		{
			dist = distance(player.origin, startOrigin);
			if (dist < 75)
			{
				player setOrigin(endOrigin);
			}
		}
	}
}