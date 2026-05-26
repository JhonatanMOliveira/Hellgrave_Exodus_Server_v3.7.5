DUNGEON_SYSTEM = {

	Storages = {
		timerDungeon = 49356,
		timerCooldown = 59003,
		storageReward = 59005,
	},
	
	Modal = {
		IDType = 2049,
		TitleType = "Dungeon System",
		MsgType = "Select this type:",
	
		ID = 2050,
		Title = "Dungeon System",
		Msg = "Select your Dungeon:",
		
		IDDetails = 2051,
		TitleDetails = "Details Dungeon",
	},
	
	Messages = {
		ToEntry = "Welcome to Dungeon",
		ToFail = "You were unable to complete the dungeon in the respective time.\n\nNext time you will do it better!",
		
		WaitFriendsCooldown = "Wait your party: %s",
		ToCooldown = "You're in cooldown to enter in a dungeon again. Cooldown: %s.",
		MsgNeedLevel = "You don't have level required. You need level %s.",
		MsgUniqueNeedParty = "You need party, to entry in dungeon",
		MsgNeedParty = "You need to be at a party to enter the dungeon. You need %s players",
		MsgLeaderParty = "You are not the leader of the Party.",
		
		MsgDistanceLeader = "Your team need to be close to you.",
		
		NeedPzSoloMsg = "You need to be in a safe area [PZ].",
		NeedPzMsg = "Your team needs to go a safe area [PZ].",
	
		PlayerInside = "A team is already inside.",
	},
	
	CooldownTime = 3600,
	
	PzToEntry = true,
	
	SQMsDistanceOfLeader = 20,

	Dungeons = {
		[1] = {
			Name = "Bones ",
			NeedParty = true,
			AmountParty = 1,
			NeedLevel = true,
			Level = 150,
			DungeonTime = 3600,
			DungeonPos = Position(31662, 32143, 8),
			FromPos = {x = 31630, y = 32134, z = 8}, 	
			ToPos = {x = 31851, y = 32300, z = 8},
			SpawnMonsters = false,
			Monsters = {
			},			
		},	
		[2] = {
			Name = "Master of the Elements",
			NeedParty = true,
			AmountParty = 1,
			NeedLevel = true,
			Level = 200,
			DungeonTime = 3600,
			DungeonPos = Position(31700, 32340, 8),
			FromPos = {x = 31633, y = 32322, z = 8},
			ToPos = {x = 31855, y = 32596, z = 8},
			SpawnMonsters = false,
			Monsters = {
			},			
		},
		[3] = {
			Name = "Forbidden Chevalier",
			NeedParty = true,
			AmountParty = 1,
			NeedLevel = true,
			Level = 500,
			DungeonTime = 3600,
			DungeonPos = Position(32031, 33163, 0),
			FromPos = {x = 31963, y = 33109, z = 7},
			ToPos = {x = 32069, y = 33215, z = 7},
			SpawnMonsters = false,
			Monsters = {
			},			
		},
		[4] = {
			Name = "Rootkraken",
			NeedParty = false,
			AmountParty = 1,
			NeedLevel = true,
			Level = 600,
			DungeonTime = 1800,
			DungeonPos = Position(1182, 609, 8),
			FromPos = {x = 1091, y = 414, z = 7},
			ToPos = {x = 1184, y = 609, z = 8},
			SpawnMonsters = false,
			Monsters = {
			},			
		},
		[5] = {
			Name = "Troll Wolf Dungeon",
			NeedParty = false,
			AmountParty = 1,
			NeedLevel = false,
			Level = 1,
			DungeonTime = 1800,
			DungeonPos = Position(1182, 609, 8),
			FromPos = {x = 1182, y = 612, z = 9},
			ToPos = {x = 1205, y = 753, z = 9},
			SpawnMonsters = false,
			Monsters = {
			},
			CustomStart = "TrollWolfDungeonStart",
		},
	},
}
