### <h1 align="center"> [IW5(MW3)](https://en.wikipedia.org/wiki/Call_of_Duty:_Modern_Warfare_3) INFECTED shop for [plutonium](https://plutonium.pw) </h1>

<em><h5 align="center">(Programming Language - GSC)</h5></em>

# ⚙️installation
- Create 2 folder with names `scripts` and `plugins` inside `%LocalAppData%\Plutonium\storage\iw5`.
- download [iw5 gsc utils](https://github.com/fedddddd/iw5-gsc-utils) and put it on `plugins` folder.
- put the `infshop.gsc` script inside `scripts` folder.
- you need this gsc scripts like images inside `gametypes` and `killstreaks` in directoy `%LocalAppData%\Plutonium\storage\iw5\maps\mp`.

![1](https://user-images.githubusercontent.com/79990596/218305933-47321241-d3cd-4401-85f9-eb5c29729ba9.PNG)
![2](https://user-images.githubusercontent.com/79990596/218305934-040f20a1-0a3c-45d3-901b-802a40f77cf8.PNG)

# 📜features

- 🚁heli point.
   - the player who destroys the heli point get 10,000 H and Z point.
   - heli HP is `800`.
   - custom sound and fx.
   - heli point will spawn after `180 second` if player size equal or more than `9` playing in server.

- 💵money(point) system.
   - if you in ***🧑human*** team and kill each zombie you will get `100 H` point.
   - if you in ***🧟zombie*** team and kill each human you will get `2000 Z` point.
   - your point will saved after exit server.
   - maximum point(H and Z) is 700,000.
   - starter point is 10,000 H and Z.
   
- 🛠️custom settings.

   - team names and icons.
   - score board color.
   - bunny hop jump.
   - slow down jump disabled.
   - jump step size.
   - disabled fall damage.
   - jump spread add.
   - special perks(fast reload,fast mele and etc...).
   - fog disabled.
   - draw sun disabled.
   
 - 🔫weapon box.
   - spawn free random weapon.
   - every `40 second` spawn new weapon after someone take last weapon.
   - zombie can't take weapon.

 - ⌨️keys
   - press `N` to show shop and your point.
   - press `6` to kill your self(zombie only) or buy ammo(human only and cost 700 H point).

- 💣M.O.A.B. effects deleted.

- 💫custom FX loads.

- ✨custom shaders.

 - 📄command system.

 - 🗺️own custom map edit.

 - 💥custom damage on weapons.
 
 - 🔧custom perk speed and damage.
 
 - 📡support command when you stuck in somewhere in map(`!tp` cost 500 H point(only human)).


# 👑admin features

- create a file with name your `GUID` in `%LocalAppData%\Plutonium\storage\iw5\scripts\infshop\admins` like image below.

![3](https://user-images.githubusercontent.com/79990596/218310067-720e36a3-9d12-4d60-8ae2-0252c900f1ca.PNG)

- press `G` button to go in spectator mode.
- special command for admins only.
- funny features for admins.
- check players point with command.


 

 
# 📄Commands

### 👑admins
|   command   |                        description                        |         example                       |
| ----------- | --------------------------------------------------------- | ------------------------------------- |
| `!hpset`    | set player H point.                                       | !hpset `<player_name>` `<amount>`     |
| `!zpset`    | set player Z point.                                       | !zpset `<player_name>` `<amount>`     |
| `!ghpall`   | give H point to all player.                               | !ghpall `<amount>`                    |
| `!gzpall`   | give Z point to all player.                               | !gzpall `<amount>`                    |
| `!point`    | find the amount of player points.                         | !point `<player_name>`                |
| `!kick`     | kick player with reason.                                  | !kick `<player_name>` `<reason>`      |
| `!kill`     | kill player.                                              | !kill `<player_name>`                 |
| `!name`     | change your name and clan tag.                            | !name `<new_name>` `<clan_tag>`       |
| `!team`     | change you team to *allies* or *axis*.                    | !team `<team_name>`                   |
| `!speed`    | change you running speed.                                 | !speed `<value>`                      |
| `!100k`     | give your self 100,000 H and Z point.                     | !100k                                 |
| `!tpall`    | teleport all player to your self.                         | !tpall                                |
| `!killall`  | kill player (zombie and human).                           | !killall                              |
| `!mres`     | restart map.                                              | !mres                                 |
| `!drop`     | drop current weapon on your hand.                         | !drop                                 |
| `!ac130`    | give your self all ac130 types(105mm,40mm,25mm).          | !ac130                                |
| `!dg`       | drop 10 random gun.                                       | !dg                                   |
| `!cus`      | default game weapon.                                      | !cus                                  |
| `!god`      | god mode.                                                 | !god                                  |
| `!air`      | custom killstreak.                                        | !air                                  |
| `!nm`       | map rotate.                                               | !nm                                   |
| `!tpg`      | teleport gun(teleport you in where you shot).             | !tpg                                  |


 
### 🧑humans
|   command   |                description & cost H point                 |
| ----------- | --------------------------------------------------------- |
| `!ghp`      | give H point to player. (!ghp `<player_name>` `<amount>`) |
| `!gzp`      | give Z point to player. (!gzp `<player_name>` `<amount>`) |
| `!htz`      | H point to Z point (divide 2). (!htz `<amount>`)          |
| `!zth`      | Z point to H point (divide 2). (!zth `<amount>`)          |
| `!re`       | restart map. (90,000)                                     |
| `!sui`      | suicide. (free)                                           |
| `!1`        | random pistol. (50)                                       |
| `!2`        | random auto pistol. (300)                                 |
| `!3`        | random smg. (500)                                         |
| `!4`        | random AR. (700)                                          |
| `!5`        | random shotgun. (50)                                      |
| `!6`        | random sniper. (800)                                      |
| `!7`        | random LMG. (1000)                                        |
| `!8`        | random luncher. (400)                                     |
| `!dmg`      | more damage. (400)                                        |
| `!mb`       | mega bullet. (4500)                                       |
| `!nr`       | no recoil. (1500)                                         |
| `!ri`       | riot shield. (500)                                        |
| `!sx`       | semtex. (100)                                             |
| `!tr`       | trophy system. (1500)                                     |
| `!aug`      | custom weapon. (1500)                                     |
| `!cw1`      | usp45 customized. (3500)                                  |
| `!cw2`      | deserteagle customized. (3500)                            |
| `!cw3`      | mp412 customized. (3500)                                  |
| `!tp`       | teleport when you stuck. (500)                            |



 
### 🧟zombies
|   command   |                description & cost Z point                 |
| ----------- | --------------------------------------------------------- |
| `!ghp`      | give H point to player. (!ghp `<player_name>` `<amount>`) |
| `!gzp`      | give Z point to player. (!gzp `<player_name>` `<amount>`) |
| `!htz`      | H point to Z point (divide 2). (!htz `<amount>`)          |
| `!zth`      | Z point to H point (divide 2). (!zth `<amount>`)          |
| `!re`       | restart map. (90,000)                                     |
| `!sui`      | suicide. (free)                                           |
| `!sx`       | semtex. (500)                                             |
| `!cm`       | claymore. (150)                                           |
| `!sm`       | smoke. (200)                                              |
| `!fg`       | flash grenade. (400)                                      |
| `!ttk`      | throwing knife. (2500)                                    |
| `!emp`      | emp grenade. (400)                                        |
| `!wh`       | wall hack. (400)                                          |
| `!msp`      | more running speed. (3500)                                |
| `!smgun`    | smoke gun. (1000)                                         |

