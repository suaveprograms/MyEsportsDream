# File: AIDatabase.gd
# Autoload this script in Project > Autoload to make it global

extends Node



var names = [
  "Kira", "Zane", "Nova", "Frost", "Echo", "Sora", "Reign", "Jet", "Blitz",
  "Aether", "Flame", "Knox", "Lynx", "Vex", "Hex", "Zero", "Shade", "Yuto",
  "Kaze", "Orbit", "Onyx", "Zed", "Ash", "Kai", "Drift", "Nash", "Axe", "Jinx",
  "Byte", "Zen", "Crux", "Phaze", "Scythe", "Surge", "Snare", "Lex", "Jolt",
  "Tempest", "Hunter", "xcent11!", "Iyan00", "Inuyasha", "Wanna", "Tanos", "Wang", "Miranard",
  "wraith4!", "Lunar#7", "Shadow*", "Feral$", "Vortex%", "Nebula&", "Pyro^", "Venom(", "Specter)", "Blaze_", 
  "Cypher+", "Phantom=", "Rogue{", "Spectre}", "Dusk<", "Dawn>", "Rift/", "Specter|", "Fury~",
  "Nova!", "Apex@", "Viper#", "Ghost$", "Storm%", "Ranger&", "Knight^", "Wander(", "Havoc)", "Rogue_",
  "Chaos+", "Phaze=", "Pulse{", "Surge}", "Frost<", "Fang>", "Vortex/", "Rift|", "Claw~",
  "Stryke!", "Specter@", "Shade#", "Blitz$", "Feral%", "Nova&", "Viper^", "Ghost(", "Storm)", "Ranger_",
  "Knight+", "Wander=", "Havoc{", "Chaos}", "Phaze<", "Pulse>", "Frost/", "Fang|", "Vortex~",
  "Rift!", "Claw@", "Stryke#", "Specter$", "Shade%", "Blitz&", "Feral^", "Nova(", "Viper)", "Ghost_",
  "Storm+", "Ranger=", "Knight{", "Wander}", "Havoc<", "Chaos>", "Phaze/", "Pulse|", "Frost~",
  "Fang!", "Vortex@", "Rift#", "Claw$", "Stryke%", "Specter&", "Shade^", "Blitz(", "Feral)", "Nova_",
  "Viper+", "Ghost=", "Storm{", "Ranger}", "Knight<", "Wander>", "Havoc/", "Chaos|", "Phaze~",
  "Pulse!", "Frost@", "Fang#", "Vortex$", "Rift%", "Claw&", "Stryke^", "Specter(", "Shade)", "Blitz_",
  "Feral+", "Nova=", "Viper{", "Ghost}", "Storm<", "Ranger>", "Knight/", "Wander|", "Havoc~",
  "Chaos!", "Phaze@", "Pulse#", "Frost$", "Fang%", "Vortex&", "Rift^", "Claw(", "Stryke)", "Specter_",
  "Shade+", "Blitz=", "Feral{", "Nova}", "Viper<", "Ghost>", "Storm/", "Ranger|", "Havoc~",
  "Chaos!", "Phaze@", "Pulse#", "Frost$", "Fang%", "Vortex&", "Rift^", "Claw(", "Stryke)", "Specter_",
  "Shade+", "Blitz=", "Feral{", "Nova}", "Viper<", "Ghost>", "Storm/", "Ranger|", "Havoc~",
  "Chaos!", "Phaze@", "Pulse#", "Frost$", "Fang%", "Vortex&", "Rift^", "Claw(", "Stryke)", "Specter_",
  "Shade+", "Blitz=", "Feral{", "Nova}", "Viper<", "Ghost>", "Storm/", "Ranger|", "Havoc~",
  "Chaos!", "Phaze@", "Pulse#", "Frost$", "Fang%", "Vortex&", "Rift^", "Claw(", "Stryke)", "Specter_",
  "Eclipse_", "VenomX", "Darkmatter*", "PhantomX", "ShadowFang", "IronClad", "SkyRipper", "BlazeX", "NightWolf",
  "Spectra#", "CyberVortex", "Frostbyte", "Venomous$", "PyroBlade", "Lightning^", "GhostWalker", "DarkSpecter", "VortexRider",
  "ShadowRage", "FrostFang", "Nightshade*", "Blitzkrieg", "EclipseX", "PhantomFury", "DarkVortex", "VenomStrike", "SkyFang",
  "CyberGhost", "FrostNova", "VenomX!", "PyroFang", "LightningBolt", "GhostReaper", "DarkPulse", "VortexFury", "ShadowStrike",
  "FrostBurn", "NightRider", "BlazeFury", "EclipseFang", "PhantomScythe", "DarkStar", "VenomClaw", "SkyShadow", "CyberKnight",
  "FrostPhantom", "VenomVortex", "PyroHawk", "LightningFang", "Ghostly", "DarkSky", "VortexRage", "ShadowVenom", "FrostFire",
  "NightProwler", "BlitzFury", "EclipseDark", "PhantomSpecter", "DarkFang", "VenomStrikeX", "SkyFury", "CyberFang", "FrostBlade",
  "VenomClaw", "PyroStorm", "LightningStrike", "GhostlyFury", "DarkVortexX", "VortexShadow", "ShadowFury", "FrostGale", "NightShade",
  "BlazeStorm", "EclipseFlame", "PhantomRider", "DarkFury", "VenomBlitz", "SkyVortex", "CyberSpecter", "FrostWraith", "VenomFang",
  "PyroClaw", "LightningVortex", "GhostFang", "DarkLightning", "VortexBlitz", "ShadowPyro", "FrostShroud", "NightFang", "BlitzVortex",
  "EclipseVortex", "PhantomFrost", "DarkReaper", "VenomFrost", "SkyReaper", "CyberFrost", "FrostRider", "VenomRush", "PyroVortex",
  "LightningFang", "GhostVortex", "DarkSpecterX", "VortexFang", "ShadowRider", "FrostWraithX", "NightVortex", "BlazeFang", "EclipseRage",
  "PhantomClaw", "DarkStorm", "VenomStorm", "SkyFangX", "CyberVortexX", "FrostPyro", "VenomPyro", "PyroVortexX", "LightningClaw",
  "GhostFrost", "DarkFrost", "VortexShadowX", "ShadowFangX", "FrostBlitz", "NightVortexX", "BlazeVortex", "EclipseFang", "PhantomStorm",
  "DarkVortexZ", "VenomReaper", "SkyPyro", "CyberFangX", "FrostVortexX", "VenomFangX", "PyroShadow", "LightningReaper", "GhostStorm",
  "Aegis", "Arcanum", "Ashen", "Aurora", "Blight", "Cinder", "Draven", "Eclipse", "Fangor", "Gale",
  "Havencraft", "Icefire", "Jade", "Kronos", "Lucid", "Maelstrom", "NovaX", "ObsidianX", "Pyron", "Quasar",
  "Razor", "SpecterX", "Tornado", "Umbra", "VortexX", "Wraith", "Xenon", "Yonder", "ZephyrX", "Abyssal",
  "Beacon", "Celestial", "Darklight", "EmberX", "Frostfire", "Gloom", "HorizonX", "Ignite", "Jinxer", "Khaos",
  "Lumin", "Mistral", "NebulaX", "Omen", "PulseX", "Quantum", "RiftX", "ShadeX", "TempestX", "Uprising",
  "VortexX", "Windsong", "Xerxes", "Yuki", "Zeus", "AetherX", "Blizzard", "ChaosX", "DuskX", "Eon",
  "FrostX", "Glacier", "Helios", "InfernoX", "Jadefire", "Kismet", "LunarX", "Mystic", "NexusX", "OnyxX",
  "PhantomX", "Quickshot", "RogueX", "SpectraX", "Tsunami", "Ultraviolet", "VortexX", "Wildfire", "Xtreme", "YonderX",
  "ZephyrX", "Archon", "Bastion", "CinderX", "Duskfire", "EclipseX", "Falcon", "Gargoyle", "HavocX", "Iceblade",
  "Jaguar", "Kryptic", "LynxX", "Maverick", "Noble", "Omega", "PhoenixX", "Quicksilver", "Rage", "Saber",
  "Titan", "UmbraX", "Vanguard", "Warden", "Xenith", "Ysera", "Zephyrion", "Astral", "BlitzX", "Cygnus",
  "Darkstar", "Eminence", "FrostbiteX", "Grim", "Havocfire", "Ion", "Javelin", "Kaiser", "LuminaraX", "Mystra",
  "Nox", "OmenX", "Pulsefire", "QuantumX", "Radiance", "Shadowfire", "Tempestron", "Unseen", "Vortexfire", "WraithX",
  "Xerox", "YukiX", "Zephyros", "Abyssfire", "Brimstone", "Crescent", "Dawnfire", "Eternity", "FuryX", "Galaxia",
  "Helix", "Ignition", "JinxX", "KronosX", "Luminance", "Mystyx", "Neon", "OblivionX", "PyroX", "QuasarX",
  "RavagerX", "Spectron", "TornadoX", "UprisingX", "VortexfireX", "WindsongX", "Xanadu", "Yonderfire", "ZephyrionX",
  "AegisX", "Blackfire", "Cinderfire", "Darknova", "Eclipsefire", "Frostfang", "Gloomfire", "Horizonfire", "InfernoFire",
  "JadefireX", "KhaosX", "Lunaris", "Mysticfire", "Nexusfire", "Omenfire", "Pyroblast", "QuicksilverX", "Roguefire",
  "SpectraFire", "Tsunamix", "Umbrax", "Venomfire", "WildfireX", "XenithX", "Yukon", "Zerox", "Azure", "Bolt",
  "Crest", "DuskfireX", "Emberfire", "Fangfire", "GaleX", "Havocs", "IcefireX", "Jinxfire", "Kross", "Luminous",
  "MaelstromX", "Nightfire", "Obsidianfire", "PyrofireX", "Quantumfire", "ReaperX", "ShadowfireX", "Tempestfire",
  "Vortexfire", "Wraithfire", "XenonX", "YonderfireX", "ZephyrosX", "AbyssX", "Blitzfire", "Cinderblast", "Darkfire",
  "Eon", "Frostblade", "Gloomblade", "HeliosX", "InfernoBlade", "Jadeblaze", "Khaosblade", "Lunafire", "Mystblade",
  "Noxfire", "Omenblade", "Pyroburn", "Quasarblade", "Ragefire", "SpectralX", "TornadoFire", "Uprisingfire",
  "Vortexblade", "Windsongfire", "Xerxes", "YukonX", "ZeroxX", "Arcane", "Blight", "CinderX", "Darkflame", "Eclipseblade",
  "Frostbitefire", "Galefire", "Heliox", "Icefang", "Jinxblade", "Krossfire", "Luminfire", "Mystfire", "Noxblade",
  "OmenfireX", "Pyrostrike", "Quasarfire", "Reaperfire", "ShadowX", "TempestX", "VortexX", "Wraithfire", "Xenithfire",
  "Yonderfire", "Zephyrfire", "Aetherfire", "BrimstoneX", "CrescentX", "DawnfireX", "EternityX", "FuryfireX", "Galaxian",
  "Helixfire", "IgnitionX", "JavelinX", "KaiserX", "LuminanceX", "MystraX", "Neonfire", "Oblivionfire", "PyroXen",
  "Quasarfire", "Ravagerfire", "SpectronX", "TsunamiFire", "UprisingfireX", "VortexfireX", "WindsongfireX", "Xanadux",
  "YonderfireX", "ZephyrosfireX", "Astra", "Blackthorn", "Crimson", "Duskshade", "Eclipsefire", "Frostwing", "Gloomshade", "Havocstorm", "Infernas", "Jinxfire",
  "Kronosfire", "LunarisX", "Mystara", "NightfireX", "Obsidianstar", "PyroclastX", "Quicksilva", "Radiant", "Shadowflame", "Tempestor",
  "Ultravox", "Vortexstar", "Wraithsong", "Xenithfire", "Yamata", "Zebulon", "Amber", "Blitzfire", "Cinderblaze", "DarkfireX",
  "Eonfire", "Frostclaw", "Galeon", "HeliX", "InfernoXen", "JadefireX", "Khaosfire", "Lunaflame", "MysticfireX", "Nighthawk",
  "Onyxfire", "Pyroclaw", "QuasarXen", "Ravage", "SpectraStar", "TornadoStorm", "UprisingX", "VortexfireX", "WindsongXen", "Xylo",
  "Yurei", "Zypher", "Azurefire", "Blazeheart", "Cinderstorm", "Duskfire", "Emberstorm", "FrostfangX", "GloomfireX", "Havocfire",
  "Ignis", "Jinxstorm", "KrossfireX", "LuminaraStar", "MystraX", "Noxstorm", "ObsidianfireX", "Pyrostar", "QuasarFireX", "Requiem",
  "Shadowfury", "TempestfireX", "Vortexstorm", "WraithfireX", "XenonStar", "YukiFire", "Zeroth", "Aetherstorm", "BlackfireX",
  "Crimsonfire", "DarkstarX", "Eclipseblade", "FrostfireX", "GaleStorm", "Heliosfire", "InfernoStorm", "Jadeshadow", "Khaosstorm",
  "Lunarisfire", "MystaraX", "NightshadeX", "OblivionX", "Pyroclasm", "QuasarX", "RavagerX", "SpectronX", "TsunamiX", "UprisingStar",
  "VortexXen", "WraithX", "XenithStar", "Yonderstorm", "Zyth", "AstraX", "BlackfireStorm", "CinderfireX", "DuskfireX", "EmberfireX",
  "Frostfang", "Gloomfire", "Havocwing", "IgnisX", "JinxfireX", "Krossfire", "Luminareth", "MystraStar", "Noxfire", "ObsidianXen",
  "Pyroclast", "Quasaris", "RequiemX", "Shadowblade", "TempestXen", "Vortexfire", "WindsongStar", "XyloX", "YureiX", "ZebulonX",
  "Aurelia", "Brimstone", "Celestia", "Duskwing", "EclipseX", "Frostwolf", "GaleX", "HelixX", "InfernasX", "Jadefire",
  "Khaosblade", "LunaflameX", "MystraStorm", "Nightshade", "ObsidianstarX", "Pyroblaze", "QuasarStar", "Ravagerfire", "SpectraX",
  "TornadoX", "UltravoxX", "VortexStar", "WraithsongX", "XenithX", "Yukimura", "Zypheron", "Azureblaze", "Blizzt", "Cinderfire",
  "Darkfire", "Eonstorm", "FrostbladeX", "Gloomblade", "HeliosXen", "InfernoFury", "Jinxblade", "KhaosXen", "LunarisXen", "MystraFire",
  "Nightfire", "OblivionStar", "PyroclasmX", "QuasarisX", "ReaperfireX", "ShadowFrost", "TempestXen", "VortexStarX", "WindsongXen", "XyloStar",
  "YureiStorm", "ZebulonFire", "AetherXen", "BlackthornX", "CrimsonX", "DuskshadeX", "EclipsefireX", "FrostwingX", "GloomshadeX", "HavocstormX",
  "InfernasX", "JadefireStar", "KhaosfireX", "LunarisStar", "MystraXen", "NightshadeXen", "ObsidianfireStar", "PyroblastX", "QuasarFireStar", "RequiemStar",
  "ShadowflameX", "TempestorX", "VortexfireX", "WraithfireStar", "XenithXen", "YukiXen", "ZerothX", "XyL0n#7", "Nebul@r_9", "Vortex~X", "Ph@nt0m$", "L1tH#8", "Shadow$p€ctre", "Frosty_Cr@z", "Bl@ze_9", "VoidW@lker", "N0va_Star",
  "G@l@xyX", "Eclipse#X", "Dusk~R1d3r", "Spectr@l_7", "Aether$w@rm", "Night$hade", "Fury_8", "Lumin@_X", "Obsidian#9", "StarF0x",
  "MystiK#X", "R@zorBlade", "V@lpus", "Cry0n_7", "DarkSh@dow", "PyroX_9", "Gl@cier_7", "Eclip$eX", "Nova#Fury", "W1nd$w@lk",
  "Sh@dowFang", "FrostBite_", "L1ghtC@st", "Vortex_7", "Specter_X", "Bl@ckH0le", "Iron_Cl@w", "G@laxyFury", "DuskV@mp", "Phantom_7",
  "N1ghtW@lk", "FireFly#X", "Crystal#9", "Mythic_7", "DarkFury", "Lunar_X", "EbonWave", "St@rG@zer", "FuryX", "V@ltor",
  "ArcaneFang", "G@laxyH0wler", "Cry0s_7", "Shadow#R1p", "FrostFang", "NightSh@de", "PyroX_7", "Void_9", "Spectra#X", "Bl@deR",
  "Obsidian#7", "StarG0d", "Mystic_7", "R@zorFury", "VortexX", "DarkN1ght", "FrostF@ng", "L1ghtning_", "Eclipz#X", "NovaSh@dow",
  "W@rlock", "Sh@dowBlade", "Fury_9", "Lumin8#X", "ObsidianFury", "StarV0id", "MystiC_9", "Cry0nX", "DuskFang", "PhantomX",
  "NightW@nd", "FireFlyX", "CrystalFury", "MythicX", "DarkFury", "LunarFang", "EbonShadow", "St@rG@zerX", "FuryX_7", "V@ltor_9",
  "ArcaneX", "G@laxyFang", "Cry0s_9", "Shadow#R1p", "FrostFang", "NightSh@de", "PyroX_7", "Void_9", "Spectra#X", "Bl@deR",
  "Obsidian#7", "StarG0d", "Mystic_7", "R@zorFury", "VortexX", "DarkN1ght", "FrostF@ng", "L1ghtning_", "Eclipz#X", "NovaSh@dow",
  "W@rlock", "Sh@dowBlade", "Fury_9", "Lumin8#X", "ObsidianFury", "StarV0id", "MystiC_9", "Cry0nX", "DuskFang", "PhantomX",
  "NightW@nd", "FireFlyX", "CrystalFury", "MythicX", "DarkFury", "LunarFang", "EbonShadow", "St@rG@zerX", "FuryX_7", "V@ltor_9",
  "ArcaneX", "G@laxyFang", "Cry0s_9", "Shadow#R1p", "FrostFang", "NightSh@de", "PyroX_7", "Void_9", "Spectra#X", "Bl@deR",
  "Obsidian#7", "StarG0d", "Mystic_7", "R@zorFury", "VortexX", "DarkN1ght", "FrostF@ng", "L1ghtning_", "Eclipz#X", "NovaSh@dow",
  "W@rlock", "Sh@dowBlade", "Fury_9", "Lumin8#X", "ObsidianFury", "StarV0id", "MystiC_9", "Cry0nX", "DuskFang", "PhantomX",
  "NightW@nd", "FireFlyX", "CrystalFury", "MythicX", "DarkFury", "LunarFang", "EbonShadow", "St@rG@zerX", "FuryX_7", "V@ltor_9","Aetherion", "Blazewind", "CygnusV", "DarkfireX", "EclipseN", "FrostbyteX", "GaleForce", "HeliosVortex", "InfernoR", "JadeV", 
  "KhaosStorm", "LunarisEcho", "MystraSoul", "NightshadeR", "ObsidianV", "PyroFang", "QuasarXenith", "RavagerSky", "SpectraNova", "TornadoV",
  "UltravoxXen", "VortexPulse", "WindsongSky", "XenithBlaze", "YonderStar", "ZebulonFury", "AmberFlame", "BrimstoneXen", "CinderSpark", "DarkstarNova",
  "EternityR", "FrostfangX", "GloomshadeR", "HavocWraith", "IgnisFury", "JinxXen", "KrossVortex", "LuminaraPulse", "MystraWave", "NoxFang", 
  "OblivionXen", "PyroBlade", "QuasarFury", "RequiemX", "ShadowFang", "TempestXen", "VortexStormX", "WraithsongXen", "XenonPulse", "YukiFury",
  "ZerothFang", "AegisVortex", "BlackfireXen", "CinderblazeX", "DarknovaX", "EclipseFury", "FrostfireXen", "GaleStormX", "HeliosXenith", "InfernoPyro",
  "JadefireXen", "KhaosFireX", "LunarisVortex", "MystraStarX", "NightshadeXen", "ObsidianStarX", "PyroclastXen", "QuasarisXen", "RavagerFireX", "SpectronV",
  "TsunamiVortex", "UprisingStarX", "VortexfireXen", "WindsongXenith", "XyloBlaze", "YureiV", "ZypheronXen", "AzurefireX", "BlizztX", "CinderstormX",
  "DarkfireXen", "EonFury", "FrostclawXen", "GaleonX", "HelixXen", "InfernoXenith", "JadeblazeX", "KhaosbladeX", "LunaflameXen", "MystraStormX",
  "NightshadeX", "ObsidianstarXen", "PyroblazeX", "QuasarbX", "ReaperXen", "ShadowFlameX", "TempestXenith", "VortexstarXen", "WindsongXen", "XenithFireX",
  "YukiXenith", "ZeroxXen", "AetherXen", "BlackthornX", "CrimsonXen", "DuskshadeX", "EmberXen", "FrostwingXen", "GloomshadeXen", "HavocstormX",
  "IgnisXen", "JinxstormX", "KrossfireXen", "LuminarethX", "MystraFireX", "NighthawkX", "OnyxXen", "PyroclawX", "QuasarXen", "RavageXen",
  "SpectraStarX", "TornadoXen", "UprisingXen", "VortexfireX", "WindsongXen", "XanaduXen", "YonderFireX", "ZephyrionX", "AegisXen", "BlackfireX",
  "CinderfireX", "DarknovaX", "EclipsefireX", "FrostfangX", "GloomfireX", "HavocwingX", "InfernasX", "JadefireX", "KhaosfireX", "LunaflameX",
  "MystraStormX", "NightshadeX", "ObsidianstarX", "PyroblazeX", "QuasarStarX", "RequiemX", "ShadowflameX", "TempestorX", "VortexstarX", "WraithsongX",
  "XenonStarX", "YukimuraX", "Zypheron2X", "AzureblazeX", "BlizztX", "CinderstormX", "DarkfireX", "EclipseXen", "FrostclawX", "GaleStormX",
  "HeliosXen", "InfernoStormX", "JadeshadowX", "KhaosstormX", "LunarisfireX", "MystaraX", "NightshadeX", "OblivionX", "PyroclasmX", "QuasarisX",
  "RavagerX", "SpectronX", "TsunamiX", "UprisingX", "VortexfireX", "WindsongX", "XanaduX", "YonderfireX", "ZephyrionX", "AegisX",
  "BlackfireX", "CinderfireX", "DarknovaX", "EclipsefireX", "FrostfangX", "GloomfireX", "HavocwingX", "InfernasX", "JadefireX", "KhaosfireX",
  "LunaflameX", "MystraStormX", "NightshadeX", "ObsidianstarX", "PyroblazeX", "QuasarStarX", "RequiemX", "ShadowflameX", "TempestorX", "VortexstarX",
  "WraithsongX", "XenonStarX", "YukimuraX", "ZypheronX4", "AzurefireX", "BlizztX", "CinderstormX", "DarkfireX", "EclipseXen", "FrostclawX",
  "GaleStormX", "HeliosXen", "InfernoStormX", "JadeshadowX", "KhaosstormX", "LunarisfireX", "MystraX", "NightshadeX", "OblivionX", "PyroclasmX",
  "QuasarisX", "RavagerX", "SpectronX", "TsunamiX", "UprisingX", "VortexfireX", "WindsongX", "XanaduX", "YonderfireX", "ZephyrionX", "AxiomX", "Blitzfire", "CrimsonV", "Darkwave", "EclipseBolt", "Frostnova", "GaleStrike", "HeliosShade", "InfernoPulse", "JadeStorm",
  "KhaosRider", "LunarisFang", "MystraVortex", "NightfallX", "ObsidianRage", "PyroClash", "QuasarFlux", "RavagerSoul", "SpectraFlick", "TempestBite",
  "UltravioX", "VortexRift", "WindsongEcho", "XenonFury", "YonderPhantom", "ZebulonVex", "AmberBlitz", "BlazewindX", "CinderFlare", "DarkstarV",
  "EternityFang", "FrostbiteR", "GloomWraith", "HavocRavager", "IgnisBolt", "JinxFury", "KrossVex", "LuminaraX", "MystraPulse", "NoxFrost",
  "OblivionFlux", "PyrofireX", "QuasarNebula", "RequiemFury", "ShadowRift", "TempestVex", "VortexFang", "WraithVortex", "XenithBlaze", "YukiRage",
  "ZerithX", "AegisFrost", "BlackfireV", "CinderVortex", "DarknovaFang", "EclipseRage", "FrostfireBolt", "GaleStormX", "HeliosVex", "InfernoFlick",
  "JadeVex", "KhaosClaw", "LunarisStrike", "MystraWinds", "NightshadeBolt", "ObsidianFury", "PyroVortex", "QuasarFlash", "RavagerXenith", "SpectraVex",
  "TsunamiBolt", "UprisingVex", "VortexRider", "WindsongFlick", "XenonRage", "YonderVortex", "ZephyrFlick", "AstraVex", "BlackthornV", "CrimsonFlick",
  "DuskShroud", "EmberVortex", "FrostWarden", "GloomFury", "HavocStrike", "InfernasVex", "JadeFlare", "KhaosRider", "LunarisFury", "MystraStorm",
  "NightshadeFlick", "ObsidianPulse", "PyroClimax", "QuasarBlitz", "ReaperVex", "ShadowFlick", "TempestRider", "VortexFlick", "WindsongPulse", "XenithFury",
  "YukiStorm", "ZypherVex", "AzureVortex", "BlizztFlick", "CinderFlick", "DarkfireVex", "EonVortex", "FrostclawFlick", "GaleForceX", "HeliosFlick",
  "InfernoBlitz", "JadeStormX", "KhaosFury", "LunaflameV", "MystraXen", "NightshadeRift", "OblivionFlick", "PyroFlick", "QuasarisVex", "RavageStorm",
  "SpectraXen", "TornadoVex", "UprisingStorm", "VortexBlitz", "WindsongXenith", "XyloVex", "YureiFlick", "ZypheronVex", "AetherVex", "BlackthornFlick",
  "CrimsonVortex", "DarknovaFlick", "EclipseRider", "FrostfangVex", "GloomfireFlick", "HavocVortex", "InfernasFlick", "JadefireRift", "KhaosstormX", "LunarisFlick",
  "MystraFlick", "NightshadeRider", "ObsidianFlick", "PyroblazeVex", "QuasarStarF", "RequiemFlick", "ShadowVortex", "TempestFlick", "VortexXen", "WraithFlick",
  "XenonVex", "YukiFlick", "ZerothVex", "AegisFlick", "BlackfireFlick", "CinderstormV", "DarkfireXen", "EclipseFlick", "FrostclawVex", "GaleStormF",
  "HeliosVortex", "InfernoFlick", "JadeshadowV", "KhaosFlick", "LunarisXen", "MystraStormV", "NightshadeFlick", "ObsidianStorm", "PyroClashX", "QuasarisX",
  "RavagerFlick", "SpectroVex", "TsunamiStorm", "UprisingFlick", "VortexStormX", "WindsongVex", "XanaduFlick", "YonderStorm", "ZephyrVex", "AegisBolt",
  "BlackfireStorm", "CinderVex", "DarknovaStorm", "EclipseBolt", "FrostbiteVex", "GloomshadeF", "HavocFlick", "InfernasStorm", "JadefireX", "KhaosRiderX",
  "LunaflameF", "MystraX", "NightshadeVex", "OblivionStorm", "PyroclasmX", "QuasarFlick", "ReaperStorm", "ShadowXen", "TempestVex", "VortexFire",
  "WindsongX", "XenithStorm", "YukiFury", "ZypherStorm", "AzureVolt", "BlizztStorm", "CinderFlare", "DarkfireBolt", "EonStorm", "FrostwingF",
  "GaleForceX", "HeliosFlick", "InfernoX", "JadeFlame", "KhaosVortex", "LunarisFlick", "MystraStormX", "NightshadeF", "ObsidianFury", "PyroblastX",
  "QuasarXenith", "RavagerXen", "SpectraBolt", "TornadoStorm", "UprisingBolt", "VortexX", "WindsongFury", "XanaduStorm", "YonderBolt", "ZephyrStorm"
];
var playstyles = ["Aggressive", "Passive", "Macro-focused", "Greedy", "Team Player"]
var roles = ["DPS", "Tank", "Support"]
var regions = ["NA", "EU", "KR", "CN", "SEA", "BR"]

var ai_players: Array = []
var generated := false

const RETIREMENT_AGE_START = 30
const SKILL_DECAY_AGE = 30
const TOTAL_PLAYERS = 500
const HIGH_MMR_PLAYERS = 150
const MIN_MMR = 300

const AI_LEAVE_CHANCE = 0.1
const HIGH_MMR_LEAVE_PROTECTION = 2800  # No leaving if MMR ≥ this
const MAX_TEAM_SIZE = 5  # max players per team
func _ready():
	randomize()
	load_ai_players()
	if ai_players.is_empty():
		generate_ai_players()
		save_ai_players()

func _create_ai(min_mmr, max_mmr, min_skill, max_skill, used_names: Dictionary) -> Dictionary:
	var ai = {}
	var ign = ""

	while true:
		ign = names.pick_random() + str(randi_range(10, 9999))
		if not used_names.has(ign):
			used_names[ign] = true
			break

	ai["ign"] = ign
	ai["role"] = roles.pick_random()
	ai["mmr"] = randi_range(min_mmr, max_mmr)
	ai["playstyle"] = playstyles.pick_random()
	ai["age"] = randi_range(16, 22)
	ai["season_history"] = []
	ai["rank"] = get_rank_name(ai["mmr"])
	ai["region"] = regions.pick_random()
	ai["team"] = ""  # no chemistry field anymore

	match ai["role"]:
		"DPS":
			ai["skills"] = {
				"Mechanics": randi_range(min_skill, max_skill),
				"Burst Timing": randi_range(min_skill, max_skill),
				"Carry Pressure": randi_range(min_skill, max_skill)
			}
		"Tank":
			ai["skills"] = {
				"Engage Timing": randi_range(min_skill, max_skill),
				"Peel & Protection": randi_range(min_skill, max_skill),
				"Positioning": randi_range(min_skill, max_skill)
			}
		"Support":
			ai["skills"] = {
				"Map Awareness": randi_range(min_skill, max_skill),
				"Utility Usage": randi_range(min_skill, max_skill),
				"Shotcalling": randi_range(min_skill, max_skill)
			}
	return ai

func generate_ai_players(force := false):
	if generated and not force:
		return
	generated = true
	var used_names = {}

	for i in range(HIGH_MMR_PLAYERS):
		var mmr = randi_range(1500, 3000)
		var skill = randi_range(80, 180)
		ai_players.append(_create_ai(mmr, mmr, skill, skill, used_names))

	while ai_players.size() < TOTAL_PLAYERS:
		var ultra_elite = randi_range(1, 1000) <= 10
		var elite = not ultra_elite and randi_range(1, 100) <= 5
		var mmr_max = 1200
		var skill_max = 100
		if elite:
			mmr_max = 1800
			skill_max = 140
		if ultra_elite:
			mmr_max = 3000
			skill_max = 180
		ai_players.append(_create_ai(300, mmr_max, 20, skill_max, used_names))

	assign_teams_to_ai()

func assign_teams_to_ai():
	var team_codes = TeamDatabase.teams.keys()
	team_codes.sort()

	for ai in ai_players:
		ai["team"] = ""

	for team_code in team_codes:
		# Start with required roles
		var needed_roles = ["DPS", "Tank", "Support"]
		# Add two flex slots as empty string placeholders (or any marker)
		var flex_slots = 2

		# Assign core roles first
		for role in needed_roles:
			var best_candidate = null
			var best_mmr := -1
			for ai in ai_players:
				if ai["team"] == "" and ai["role"] == role and ai["mmr"] > best_mmr:
					best_candidate = ai
					best_mmr = ai["mmr"]
			if best_candidate != null:
				best_candidate["team"] = team_code

		# Assign flex spots: best free players regardless of role
		for i in range(flex_slots):
			var best_candidate = null
			var best_mmr := -1
			for ai in ai_players:
				if ai["team"] == "" and ai["mmr"] > best_mmr:
					best_candidate = ai
					best_mmr = ai["mmr"]
			if best_candidate != null:
				best_candidate["team"] = team_code

func update_ai_mmr_weekly() -> Array:
	var transfer_news = []

	# Step 1: Players leave teams randomly (if eligible)
	transfer_news += evaluate_ai_transfers()

	# Step 2: Teams refill missing players by marking pending transfers
	refill_teams_if_needed()
	refill_free_high_mmr_players()

	# Step 3: Finalize transfers (assign new teams officially, generate news)
	transfer_news += finalize_transfers()

	# ✅ Step 4: Update AI MMR progression
	for ai in ai_players:
		if ai.get("retired", false):
			continue

		var momentum = ai.get("momentum", 0)
		var mmr_gain = randi_range(30, 60) + momentum
		var mmr_change = mmr_gain if randf() < 0.75 else -randi_range(10, 15)

		# ✅ Soft cap logic: apply diminishing returns after 3000 MMR
		if ai["mmr"] > 3000:
			var decay_factor = 1.0 - ((ai["mmr"] - 3000.0) / 3000.0)
			decay_factor = clamp(decay_factor, 0.1, 1.0)
			mmr_change *= decay_factor
			mmr_change = int(round(mmr_change))  # ✅ Ensure integer MMR

		# ✅ Apply change and clamp at 0–6000
		ai["mmr"] += mmr_change
		ai["mmr"] = clamp(ai["mmr"], 0, 6000)

		# Track history
		if not ai.has("mmr_history"):
			ai["mmr_history"] = []
		ai["mmr_history"].append({ "week": PlayerData.week, "mmr": ai["mmr"] })
		if ai["mmr_history"].size() > 20:
			ai["mmr_history"].pop_front()

		# Optional MMR news
		if mmr_change >= 100:
			transfer_news.append("%s skyrocketed with +%d MMR!" % [ai["ign"], mmr_change])
		elif mmr_change <= -50:
			transfer_news.append("%s struggled, losing %d MMR." % [ai["ign"], -mmr_change])

	return transfer_news
	
func evaluate_ai_transfers() -> Array:
	var news = []

	for ai in ai_players:
		if ai.get("team", "") == "":
			continue

		# Protect very high MMR players from leaving
		if ai["mmr"] >= HIGH_MMR_LEAVE_PROTECTION:
			continue

		if randf() < AI_LEAVE_CHANCE:
			var old_team = ai["team"]
			ai["old_team"] = old_team  # Save old team for news later
			ai["team"] = ""

			var new_team = find_new_team_for_player(ai)
			if new_team != "":
				ai["pending_transfer_to"] = new_team
				# Don't assign ai["team"] here, assign only in finalize_transfers()
				news.append("%s has transferred from %s to %s seeking better opportunities." % [ai["ign"], TeamDatabase.get_team_name_by_code(old_team), TeamDatabase.get_team_name_by_code(new_team)])
			else:
				news.append("%s has left %s seeking a better team, but hasn't signed with anyone yet." % [ai["ign"], TeamDatabase.get_team_name_by_code(old_team)])

	return news

# Dummy placeholder: just picks a random team that isn't the old team
func find_new_team_for_player(ai: Dictionary) -> String:
	var player_role = ai.get("role", "")
	var player_region = ai.get("region", "")
	
	var candidate_teams = []

	for team_code in TeamDatabase.teams.keys():
		var players = get_players_by_team(team_code)

		if players.size() >= MAX_TEAM_SIZE:
			continue

		# Count roles currently in team
		var roles_in_team = []
		for p in players:
			roles_in_team.append(p.get("role", ""))

		if roles_in_team.has(player_role):
			continue  # role already filled, skip

		# Score candidate team
		var score = 0
		if TeamDatabase.teams[team_code]["region"] == player_region:
			score += 50
		score += TeamDatabase.teams[team_code]["wins"] * 2

		candidate_teams.append({"code": team_code, "score": score})

	if candidate_teams.is_empty():
		return ""

	# Sort descending by score
	candidate_teams.sort_custom(func(a, b): return b["score"] - a["score"])

	# Random pick from top 3 or best
	var pick_range = min(3, candidate_teams.size())
	var chosen_index = randi() % pick_range
	return candidate_teams[chosen_index]["code"]


func refill_teams_if_needed():
	for team_code in TeamDatabase.teams.keys():
		var players = get_players_by_team(team_code)
		var needed_roles = ["DPS", "Tank", "Support"]

		# Remove already filled roles
		for p in players:
			needed_roles.erase(p["role"])

		# If team full, skip
		if players.size() >= MAX_TEAM_SIZE:
			continue

		for role in needed_roles:
			var best_candidate = null
			var best_mmr = -1
			for ai in ai_players:
				if ai.get("team", "") == "" and ai.get("pending_transfer_to", "") == "" and ai["role"] == role and ai["mmr"] > 300:
					if ai["mmr"] > best_mmr:
						best_candidate = ai
						best_mmr = ai["mmr"]
			if best_candidate != null:
				best_candidate["pending_transfer_to"] = team_code

func refill_free_high_mmr_players():
	var free_high_mmr = []
	for ai in ai_players:
		if ai.get("team", "") == "" and ai.get("pending_transfer_to", "") == "" and ai["mmr"] >= 1000:
			free_high_mmr.append(ai)

	var teams_needing_roles = {}

	for team_code in TeamDatabase.teams.keys():
		var players = get_players_by_team(team_code)
		var needed_roles = ["DPS", "Tank", "Support"]

		for p in players:
			needed_roles.erase(p["role"])

		if players.size() < MAX_TEAM_SIZE and needed_roles.size() > 0:
			teams_needing_roles[team_code] = needed_roles

	for ai in free_high_mmr:
		for team_code in teams_needing_roles.keys():
			var needed_roles = teams_needing_roles[team_code]
			if ai["role"] in needed_roles:
				ai["pending_transfer_to"] = team_code
				needed_roles.erase(ai["role"])
				if needed_roles.is_empty():
					teams_needing_roles.erase(team_code)
				break
				
func finalize_transfers() -> Array:
	var transfer_news = []

	for ai in ai_players:
		if ai.has("pending_transfer_to"):
			var old_team = ai.get("old_team", "")
			var new_team = ai["pending_transfer_to"]

			if new_team != old_team and old_team != "":
				transfer_news.append("%s transferred from %s to %s!" % [
					ai["ign"],
					TeamDatabase.get_team_name_by_code(old_team),
					TeamDatabase.get_team_name_by_code(new_team)
				])

			ai["team"] = new_team
			ai.erase("pending_transfer_to")
			ai.erase("old_team")

	return transfer_news
	
func get_all_team_codes() -> Array:
	var codes = []
	for ai in ai_players:
		if ai.get("team", "") != "" and not codes.has(ai["team"]):
			codes.append(ai["team"])
	return codes

func reset_all_ai_mmr(current_season):
	var to_remove = []
	for ai in ai_players:
		ai["season_history"].append({
			"season": current_season,
			"mmr": ai["mmr"],
			"avg_skill": get_ai_avg_skill(ai)
		})

		ai["age"] += 1

		if ai["age"] >= RETIREMENT_AGE_START and randf() < clamp((ai["age"] - 24) / 15.0, 0.1, 1.0):
			to_remove.append(ai)
			continue

		if ai["mmr"] >= 2000:
			for k in ai["skills"].keys():
				ai["skills"][k] += randi_range(1, 3)

		if ai["age"] >= SKILL_DECAY_AGE:
			for k in ai["skills"].keys():
				ai["skills"][k] = max(ai["skills"][k] - randi_range(0, 2), 10)

		ai["mmr"] = 300
		ai["rank"] = get_rank_name(ai["mmr"])

	for ai in to_remove:
		ai_players.erase(ai)

	var used_names = {}
	for ai in ai_players:
		used_names[ai["ign"]] = true
	for i in range(to_remove.size()):
		var rookie = _create_ai(300, 800, 30, 60, used_names)
		rookie["age"] = randi_range(15, 18)
		ai_players.append(rookie)

func get_ai_avg_skill(ai: Dictionary) -> float:
	if not ai.has("skills") or ai["skills"].size() == 0:
		return 0
	var total := 0.0
	for val in ai["skills"].values():
		total += val
	return total / ai["skills"].size()

func get_rank_name(mmr: int) -> String:
	if mmr >= 1000:
		return "Champion"
	elif mmr >= 900:
		return "Vanguard"
	elif mmr >= 800:
		return "Legend"
	elif mmr >= 700:
		return "Prodigy"
	elif mmr >= 600:
		return "Elite"
	elif mmr >= 500:
		return "Challenger"
	elif mmr >= 400:
		return "Contender"
	else:
		return "Rookie"

func get_players_by_team(team_code: String) -> Array:
	var team_players = []

	# Add matching AIs
	for ai in ai_players:
		if ai.get("team", "") == team_code:
			team_players.append(ai)

	# Add human player if they belong to this team
	if PlayerData.team_code == team_code:
		var player_dict = {
			"ign": PlayerData.in_game_name,
			"role": PlayerData.role,
			"mmr": PlayerData.mmr,
			"human": true  # Used for sorting
		}
		team_players.append(player_dict)

	# Sort to show human first
	team_players.sort_custom(func(a, b):
		return a.get("human", false) > b.get("human", false)
	)

	return team_players

func get_random_ai() -> Dictionary:
	return ai_players.pick_random() if ai_players.size() > 0 else {}

func save_ai_players():
	var file = FileAccess.open("user://ai_players.save", FileAccess.WRITE)
	file.store_var(ai_players)

func load_ai_players():
	if FileAccess.file_exists("user://ai_players.save"):
		var file = FileAccess.open("user://ai_players.save", FileAccess.READ)
		ai_players = file.get_var()
		generated = true
