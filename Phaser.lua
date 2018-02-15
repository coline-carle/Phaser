local libRealmInfo = LibStub("LibRealmInfo")

local realmClusters = {}
local clusterData = {}

local party_units = {}
local raid_units = {}
local playerFaction = nil
local oppositeFaction = nil

local function Phaser_OnEvent(self, event, ...)
  if event == "PLAYER_ENTERING_WORLD" then
    local opposites = {horde = "alliance", alliance = "horde"}
    playerFaction = UnitFactionGroup("player")
    playerFaction = strlower(playerFaction)
    oppositeFaction = opposites[playerFaction]
  end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", Phaser_OnEvent)
f:RegisterEvent("PLAYER_ENTERING_WORLD")

do
  for i = 1, 5 do
		tinsert(party_units, string.format("party%d", i))
	end

	for i = 1, 40 do
		tinsert(raid_units, string.format("raid%d", i))
  end
end


local function GetClusterInfo(region, name)
  local id = realmClusters[region][name]
  if not(id) then
    print("unable to find realm: ", name)
    return
  end
  return id, clusterData[id]
end

local function GetClusterByGUID(guid)
  local _, realm, _, _, _, _, region, _, _, latinName = libRealmInfo:GetRealmInfoByGUID(guid)
  if latinName then
    realm = latinName
  end
  return GetClusterInfo(region, realm)
end

local function ShowClusterLine(cluster, playersList)
  local typeColors = {PvE = 'FFFF56', PvP = 'C41F3B'}
  local realms = table.concat(cluster.realms, ', ')
  local players =  table.concat(playersList, ', ')
  local alliance = cluster.alliance / 1000
  local horde = cluster.horde / 1000
  local color = typeColors[cluster.type]
  local result = string.format("|cFF%s%s|r: [%s]  [|cFF0070DEA: %dk|r / |cFFC41F3B: %dk|r] (%s)", color, cluster.type, realms, alliance, horde, players)
  print(result)
end

local function ShowResults(pvpClusters, pveClusters, unitsByCluster)
  local n = math.min(#pvpClusters, 5)
  for i=1, n do
    local cluster = pvpClusters[i]
    local players = unitsByCluster[cluster.id]
    ShowClusterLine(cluster, players)
  end

  n = math.min(#pveClusters, 2)
  for i=1, n do
    local cluster = pveClusters[i]
    local players = unitsByCluster[cluster.id]
    ShowClusterLine(cluster, players)
  end
end

local function ShowTopCluster(clusters, unitsByCluster, sort, max)
  sortedClusters = {}
  for id, cluster in pairs(clusters) do
    cluster.id = id
    tinsert(sortedClusters, cluster)
  end
  table.sort(sortedClusters, sort)

  local n = math.min(#sortedClusters, max)
  for i=1, n do
    local cluster = sortedClusters[i]
    local players = unitsByCluster[cluster.id]
    ShowClusterLine(cluster, players)
  end
end

local function OppositeFaction()

end


local function TopSeedRealm()
  local units = IsInRaid() and raid_units or party_units

  local unitsByCluster = {}
  local clusters = {}
  clusters["PvE"] = {}
  clusters["PvP"] = {}


		for i = 1, #units do
			local unit = units[i]
			if unit and UnitExists(unit) then
        local guid = UnitGUID(unit)
        if guid then
          local name = UnitName(unit)
          local id, cluster = GetClusterByGUID(guid)
          if not(unitsByCluster[id]) then
            unitsByCluster[id] = {}
          end
          tinsert(unitsByCluster[id], name)
          clusters[cluster.type][id] = cluster
        end
			end
    end

    local sortPvP = function(a, b) return a[playerFaction] < b[playerFaction] end
    local sortPvE = function(a, b) return (a[playerFaction] + 2 * a[oppositeFaction]) < (b[playerFaction] + 2 * b[oppositeFaction]) end
    ShowTopCluster(clusters["PvP"], unitsByCluster, sortPvP, 5)
    ShowTopCluster(clusters["PvE"], unitsByCluster, sortPvE, 2)
end




SLASH_PHASER1 = "/phaser"
function SlashCmdList.PHASER(msg, editbox)
  TopSeedRealm()
end

clusterData =
{
  [121] = {
    alliance = 12844.0,
    horde = 26991.0,
    realms = {
      "Aegwynn",
      "Bonechewer",
      "Daggerspine",
      "Gurubashi",
      "Hakkar"
    } --[[table: 0x7ff1364681b0]],
    type = "PvP"
  } --[[table: 0x7ff136468130]],
  [122] = {
    alliance = 34529.0,
    horde = 6715.0,
    realms = {
      "Aerie Peak"
    } --[[table: 0x7ff136468330]],
    type = "PvE"
  } --[[table: 0x7ff136468170]],
  [123] = {
    alliance = 8794.0,
    horde = 16243.0,
    realms = {
      "Agamaggan",
      "Archimonde",
      "Burning Legion",
      "Jaedenar",
      "The Underbog"
    } --[[table: 0x7ff136468470]],
    type = "PvP"
  } --[[table: 0x7ff1364683f0]],
  [124] = {
    alliance = 26041.0,
    horde = 14801.0,
    realms = {
      "Aggramar",
      "Fizzcrank"
    } --[[table: 0x7ff136468630]],
    type = "PvE"
  } --[[table: 0x7ff1364682f0]],
  [125] = {
    alliance = 4673.0,
    horde = 27346.0,
    realms = {
      "Akama",
      "Dragonmaw",
      "Mug'thol"
    } --[[table: 0x7ff136468730]],
    type = "PvP"
  } --[[table: 0x7ff136468430]],
  [126] = {
    alliance = 18150.0,
    horde = 10601.0,
    realms = {
      "Alexstrasza",
      "Terokkar"
    } --[[table: 0x7ff1364685b0]],
    type = "PvE"
  } --[[table: 0x7ff1364688f0]],
  [127] = {
    alliance = 21385.0,
    horde = 8246.0,
    realms = {
      "Alleria",
      "Khadgar"
    } --[[table: 0x7ff136468a30]],
    type = "PvE"
  } --[[table: 0x7ff136468930]],
  [128] = {
    alliance = 8544.0,
    horde = 17294.0,
    realms = {
      "Altar of Storms",
      "Anetheron",
      "Magtheridon",
      "Ysondre"
    } --[[table: 0x7ff136468b30]],
    type = "PvP"
  } --[[table: 0x7ff1364689f0]],
  [129] = {
    alliance = 8071.0,
    horde = 14587.0,
    realms = {
      "Alterac Mountains",
      "Balnazzar",
      "Gorgonnash",
      "The Forgotten Coast",
      "Warsong"
    } --[[table: 0x7ff136468c70]],
    type = "PvP"
  } --[[table: 0x7ff136468bf0]],
  [130] = {
    alliance = 19792.0,
    horde = 7541.0,
    realms = {
      "Aman'Thul"
    } --[[table: 0x7ff136468830]],
    type = "PvE"
  } --[[table: 0x7ff136468c30]],
  [131] = {
    alliance = 5978.0,
    horde = 13018.0,
    realms = {
      "Andorhal",
      "Scilla",
      "Ursin",
      "Zuluhed"
    } --[[table: 0x7ff136468ff0]],
    type = "PvP"
  } --[[table: 0x7ff1364687f0]],
  [132] = {
    alliance = 16826.0,
    horde = 7927.0,
    realms = {
      "Antonidas",
      "Uldum"
    } --[[table: 0x7ff136469130]],
    type = "PvE"
  } --[[table: 0x7ff1364690b0]],
  [133] = {
    alliance = 6924.0,
    horde = 17081.0,
    realms = {
      "Anub'arak",
      "Chromaggus",
      "Crushridge",
      "Garithos",
      "Nathrezim",
      "Smolderthorn"
    } --[[table: 0x7ff136469250]],
    type = "PvP"
  } --[[table: 0x7ff1364690f0]],
  [134] = {
    alliance = 15037.0,
    horde = 6070.0,
    realms = {
      "Anvilmar",
      "Undermine"
    } --[[table: 0x7ff1364693d0]],
    type = "PvE"
  } --[[table: 0x7ff1364691f0]],
  [135] = {
    alliance = 15883.0,
    horde = 7561.0,
    realms = {
      "Arathor",
      "Drenden"
    } --[[table: 0x7ff1364694f0]],
    type = "PvE"
  } --[[table: 0x7ff136469390]],
  [136] = {
    alliance = 4100.0,
    horde = 126151.0,
    realms = {
      "Area 52"
    } --[[table: 0x7ff136469610]],
    type = "PvE"
  } --[[table: 0x7ff1364694b0]],
  [137] = {
    alliance = 16901.0,
    horde = 9557.0,
    realms = {
      "Argent Dawn",
      "The Scryers"
    } --[[table: 0x7ff136469710]],
    type = "PvE"
  } --[[table: 0x7ff1364695d0]],
  [138] = {
    alliance = 2588.0,
    horde = 36792.0,
    realms = {
      "Arthas"
    } --[[table: 0x7ff136468e10]],
    type = "PvP"
  } --[[table: 0x7ff1364696d0]],
  [139] = {
    alliance = 16880.0,
    horde = 8348.0,
    realms = {
      "Arygos",
      "Llane"
    } --[[table: 0x7ff136468f10]],
    type = "PvE"
  } --[[table: 0x7ff136468dd0]],
  [140] = {
    alliance = 3064.0,
    horde = 18179.0,
    realms = {
      "Auchindoun",
      "Cho'gall",
      "Laughing Skull"
    } --[[table: 0x7ff136469850]],
    type = "PvP"
  } --[[table: 0x7ff136468ed0]],
  [141] = {
    alliance = 8665.0,
    horde = 16616.0,
    realms = {
      "Azgalor",
      "Azshara",
      "Destromath",
      "Thunderlord"
    } --[[table: 0x7ff136469990]],
    type = "PvP"
  } --[[table: 0x7ff136469910]],
  [142] = {
    alliance = 16915.0,
    horde = 8094.0,
    realms = {
      "Azjol-Nerub",
      "Khaz Modan"
    } --[[table: 0x7ff136469ad0]],
    type = "PvE"
  } --[[table: 0x7ff136469a50]],
  [143] = {
    alliance = 1787.0,
    horde = 82809.0,
    realms = {
      "Azralon"
    } --[[table: 0x7ff136469bf0]],
    type = "PvP"
  } --[[table: 0x7ff136469a90]],
  [144] = {
    alliance = 15964.0,
    horde = 9481.0,
    realms = {
      "Azuremyst",
      "Staghelm"
    } --[[table: 0x7ff136469cf0]],
    type = "PvE"
  } --[[table: 0x7ff136469bb0]],
  [145] = {
    alliance = 19338.0,
    horde = 11283.0,
    realms = {
      "Baelgun",
      "Doomhammer"
    } --[[table: 0x7ff136469e10]],
    type = "PvE"
  } --[[table: 0x7ff136469cb0]],
  [146] = {
    alliance = 2743.0,
    horde = 55538.0,
    realms = {
      "Barthilas"
    } --[[table: 0x7ff136469f30]],
    type = "PvP"
  } --[[table: 0x7ff136469dd0]],
  [147] = {
    alliance = 3573.0,
    horde = 18619.0,
    realms = {
      "Black Dragonflight",
      "Gul'dan",
      "Skullcrusher"
    } --[[table: 0x7ff13646a030]],
    type = "PvP"
  } --[[table: 0x7ff136469ef0]],
  [148] = {
    alliance = 17027.0,
    horde = 14148.0,
    realms = {
      "Blackhand",
      "Galakrond"
    } --[[table: 0x7ff13646a170]],
    type = "PvE"
  } --[[table: 0x7ff13646a0f0]],
  [149] = {
    alliance = 1227.0,
    horde = 18218.0,
    realms = {
      "Blackrock"
    } --[[table: 0x7ff13646a290]],
    type = "PvP"
  } --[[table: 0x7ff13646a130]],
  [150] = {
    alliance = 13659.0,
    horde = 10135.0,
    realms = {
      "Blackwater Raiders",
      "Shadow Council"
    } --[[table: 0x7ff13646a390]],
    type = "PvE"
  } --[[table: 0x7ff13646a250]],
  [151] = {
    alliance = 8567.0,
    horde = 14526.0,
    realms = {
      "Blackwing Lair",
      "Dethecus",
      "Detheroc",
      "Haomarush",
      "Lethon",
      "Shadowmoon"
    } --[[table: 0x7ff13646a4b0]],
    type = "PvP"
  } --[[table: 0x7ff13646a350]],
  [152] = {
    alliance = 14452.0,
    horde = 11075.0,
    realms = {
      "Blade's Edge",
      "Thunderhorn"
    } --[[table: 0x7ff13646a630]],
    type = "PvE"
  } --[[table: 0x7ff13646a450]],
  [153] = {
    alliance = 15252.0,
    horde = 12766.0,
    realms = {
      "Bladefist",
      "Kul Tiras"
    } --[[table: 0x7ff13646a750]],
    type = "PvE"
  } --[[table: 0x7ff13646a5f0]],
  [154] = {
    alliance = 8297.0,
    horde = 63905.0,
    realms = {
      "Bleeding Hollow"
    } --[[table: 0x7ff13646a870]],
    type = "PvP"
  } --[[table: 0x7ff13646a710]],
  [155] = {
    alliance = 11408.0,
    horde = 8899.0,
    realms = {
      "Blood Furnace",
      "Mannoroth",
      "Nazjatar"
    } --[[table: 0x7ff13646a970]],
    type = "PvP"
  } --[[table: 0x7ff13646a830]],
  [156] = {
    alliance = 17755.0,
    horde = 12989.0,
    realms = {
      "Bloodhoof",
      "Duskwood"
    } --[[table: 0x7ff13646aab0]],
    type = "PvE"
  } --[[table: 0x7ff13646aa30]],
  [157] = {
    alliance = 10003.0,
    horde = 24910.0,
    realms = {
      "Bloodscalp",
      "Boulderfist",
      "Dunemaul",
      "Maiev",
      "Stonemaul"
    } --[[table: 0x7ff13646abd0]],
    type = "PvP"
  } --[[table: 0x7ff13646aa70]],
  [158] = {
    alliance = 15797.0,
    horde = 9235.0,
    realms = {
      "Borean Tundra",
      "Shadowsong"
    } --[[table: 0x7ff13646ad50]],
    type = "PvE"
  } --[[table: 0x7ff13646ab70]],
  [159] = {
    alliance = 16478.0,
    horde = 9167.0,
    realms = {
      "Bronzebeard",
      "Shandris"
    } --[[table: 0x7ff13646ae70]],
    type = "PvE"
  } --[[table: 0x7ff13646ad10]],
  [160] = {
    alliance = 3908.0,
    horde = 19624.0,
    realms = {
      "Burning Blade",
      "Lightning's Blade",
      "Onyxia"
    } --[[table: 0x7ff13646af90]],
    type = "PvP"
  } --[[table: 0x7ff13646ae30]],
  [161] = {
    alliance = 33962.0,
    horde = 23233.0,
    realms = {
      "Caelestrasz",
      "Nagrand"
    } --[[table: 0x7ff13646b0d0]],
    type = "PvE"
  } --[[table: 0x7ff13646b050]],
  [162] = {
    alliance = 13744.0,
    horde = 7466.0,
    realms = {
      "Cairne",
      "Perenolde"
    } --[[table: 0x7ff13646b1f0]],
    type = "PvE"
  } --[[table: 0x7ff13646b090]],
  [163] = {
    alliance = 14070.0,
    horde = 10059.0,
    realms = {
      "Cenarion Circle",
      "Sisters of Elune"
    } --[[table: 0x7ff13646b310]],
    type = "PvE"
  } --[[table: 0x7ff13646b1b0]],
  [164] = {
    alliance = 15633.0,
    horde = 4796.0,
    realms = {
      "Cenarius"
    } --[[table: 0x7ff13646b430]],
    type = "PvE"
  } --[[table: 0x7ff13646b2d0]],
  [165] = {
    alliance = 7961.0,
    horde = 16906.0,
    realms = {
      "Coilfang",
      "Dalvengyr",
      "Dark Iron",
      "Demon Soul",
      "Shattered Hand"
    } --[[table: 0x7ff13646b530]],
    type = "PvP"
  } --[[table: 0x7ff13646b3f0]],
  [166] = {
    alliance = 70318.0,
    horde = 47154.0,
    realms = {
      "Dalaran"
    } --[[table: 0x7ff13646b6b0]],
    type = "PvE"
  } --[[table: 0x7ff13646b4f0]],
  [167] = {
    alliance = 35298.0,
    horde = 12157.0,
    realms = {
      "Darkspear"
    } --[[table: 0x7ff13646b7b0]],
    type = "PvP"
  } --[[table: 0x7ff13646b670]],
  [168] = {
    alliance = 18154.0,
    horde = 6342.0,
    realms = {
      "Darrowmere",
      "Windrunner"
    } --[[table: 0x7ff13646b8b0]],
    type = "PvE"
  } --[[table: 0x7ff13646b770]],
  [169] = {
    alliance = 31209.0,
    horde = 22174.0,
    realms = {
      "Dath'Remar",
      "Khaz'goroth"
    } --[[table: 0x7ff13646b9d0]],
    type = "PvE"
  } --[[table: 0x7ff13646b870]],
  [170] = {
    alliance = 12829.0,
    horde = 10622.0,
    realms = {
      "Dawnbringer",
      "Madoran"
    } --[[table: 0x7ff13646baf0]],
    type = "PvE"
  } --[[table: 0x7ff13646b990]],
  [171] = {
    alliance = 6820.0,
    horde = 17378.0,
    realms = {
      "Deathwing",
      "Executus",
      "Kalecgos",
      "Shattered Halls"
    } --[[table: 0x7ff13646bc10]],
    type = "PvP"
  } --[[table: 0x7ff13646bab0]],
  [172] = {
    alliance = 36425.0,
    horde = 9956.0,
    realms = {
      "Dentarg",
      "Whisperwind"
    } --[[table: 0x7ff13646bd50]],
    type = "PvE"
  } --[[table: 0x7ff13646bcd0]],
  [173] = {
    alliance = 17687.0,
    horde = 9717.0,
    realms = {
      "Draenor",
      "Echo Isles"
    } --[[table: 0x7ff13646be70]],
    type = "PvE"
  } --[[table: 0x7ff13646bd10]],
  [174] = {
    alliance = 17214.0,
    horde = 10058.0,
    realms = {
      "Dragonblight",
      "Fenris"
    } --[[table: 0x7ff13646bf90]],
    type = "PvE"
  } --[[table: 0x7ff13646be30]],
  [175] = {
    alliance = 10464.0,
    horde = 26614.0,
    realms = {
      "Drak'Tharon",
      "Firetree",
      "Malorne",
      "Rivendare",
      "Spirestone",
      "Stormscale"
    } --[[table: 0x7ff13646c0b0]],
    type = "PvP"
  } --[[table: 0x7ff13646bf50]],
  [176] = {
    alliance = 12974.0,
    horde = 9348.0,
    realms = {
      "Drak'thul",
      "Skywall"
    } --[[table: 0x7ff13646c230]],
    type = "PvE"
  } --[[table: 0x7ff13646c050]],
  [177] = {
    alliance = 16287.0,
    horde = 10841.0,
    realms = {
      "Draka",
      "Suramar"
    } --[[table: 0x7ff13646c350]],
    type = "PvE"
  } --[[table: 0x7ff13646c1f0]],
  [178] = {
    alliance = 8229.0,
    horde = 11984.0,
    realms = {
      "Drakkari"
    } --[[table: 0x7ff13646c470]],
    type = "PvP"
  } --[[table: 0x7ff13646c310]],
  [179] = {
    alliance = 2029.0,
    horde = 18531.0,
    realms = {
      "Dreadmaul",
      "Thaurissan"
    } --[[table: 0x7ff13646c570]],
    type = "PvP"
  } --[[table: 0x7ff13646c430]],
  [180] = {
    alliance = 19541.0,
    horde = 14468.0,
    realms = {
      "Durotan",
      "Ysera"
    } --[[table: 0x7ff13646c690]],
    type = "PvE"
  } --[[table: 0x7ff13646c530]],
  [181] = {
    alliance = 9872.0,
    horde = 14196.0,
    realms = {
      "Earthen Ring"
    } --[[table: 0x7ff13646c7b0]],
    type = "PvE"
  } --[[table: 0x7ff13646c650]],
  [182] = {
    alliance = 16657.0,
    horde = 10443.0,
    realms = {
      "Eitrigg",
      "Shu'halo"
    } --[[table: 0x7ff13646c8b0]],
    type = "PvE"
  } --[[table: 0x7ff13646c770]],
  [183] = {
    alliance = 15040.0,
    horde = 7438.0,
    realms = {
      "Eldre'Thalas",
      "Korialstrasz"
    } --[[table: 0x7ff13646c9d0]],
    type = "PvE"
  } --[[table: 0x7ff13646c870]],
  [184] = {
    alliance = 21308.0,
    horde = 5878.0,
    realms = {
      "Elune",
      "Gilneas"
    } --[[table: 0x7ff13646caf0]],
    type = "PvE"
  } --[[table: 0x7ff13646c990]],
  [185] = {
    alliance = 44293.0,
    horde = 43219.0,
    realms = {
      "Emerald Dream"
    } --[[table: 0x7ff13646cc10]],
    type = "PvP"
  } --[[table: 0x7ff13646cab0]],
  [186] = {
    alliance = 15456.0,
    horde = 9361.0,
    realms = {
      "Eonar",
      "Velen"
    } --[[table: 0x7ff13646cd10]],
    type = "PvE"
  } --[[table: 0x7ff13646cbd0]],
  [187] = {
    alliance = 6125.0,
    horde = 18043.0,
    realms = {
      "Eredar",
      "Gorefiend",
      "Spinebreaker",
      "Wildhammer"
    } --[[table: 0x7ff13646ce30]],
    type = "PvP"
  } --[[table: 0x7ff13646ccd0]],
  [188] = {
    alliance = 18412.0,
    horde = 8091.0,
    realms = {
      "Exodar",
      "Medivh"
    } --[[table: 0x7ff13646cf70]],
    type = "PvE"
  } --[[table: 0x7ff13646cef0]],
  [189] = {
    alliance = 19916.0,
    horde = 13286.0,
    realms = {
      "Farstriders",
      "Silver Hand",
      "Thorium Brotherhood"
    } --[[table: 0x7ff13646d090]],
    type = "PvE"
  } --[[table: 0x7ff13646cf30]],
  [190] = {
    alliance = 18398.0,
    horde = 9926.0,
    realms = {
      "Feathermoon",
      "Scarlet Crusade"
    } --[[table: 0x7ff13646d1d0]],
    type = "PvE"
  } --[[table: 0x7ff13646d150]],
  [191] = {
    alliance = 9134.0,
    horde = 18486.0,
    realms = {
      "Frostmane",
      "Ner'zhul",
      "Tortheldrin"
    } --[[table: 0x7ff13646d2f0]],
    type = "PvP"
  } --[[table: 0x7ff13646d190]],
  [192] = {
    alliance = 92045.0,
    horde = 12172.0,
    realms = {
      "Frostmourne"
    } --[[table: 0x7ff13646d430]],
    type = "PvP"
  } --[[table: 0x7ff13646d3b0]],
  [193] = {
    alliance = 6560.0,
    horde = 12254.0,
    realms = {
      "Frostwolf",
      "Vashj"
    } --[[table: 0x7ff13646d530]],
    type = "PvP"
  } --[[table: 0x7ff13646d3f0]],
  [194] = {
    alliance = 10262.0,
    horde = 8987.0,
    realms = {
      "Gallywix"
    } --[[table: 0x7ff13646d650]],
    type = "PvE"
  } --[[table: 0x7ff13646d4f0]],
  [195] = {
    alliance = 12680.0,
    horde = 5764.0,
    realms = {
      "Garona"
    } --[[table: 0x7ff13646d750]],
    type = "PvE"
  } --[[table: 0x7ff13646d610]],
  [196] = {
    alliance = 6985.0,
    horde = 8257.0,
    realms = {
      "Garrosh"
    } --[[table: 0x7ff13646d850]],
    type = "PvE"
  } --[[table: 0x7ff13646d710]],
  [197] = {
    alliance = 13177.0,
    horde = 11427.0,
    realms = {
      "Ghostlands",
      "Kael'thas"
    } --[[table: 0x7ff13646d950]],
    type = "PvE"
  } --[[table: 0x7ff13646d810]],
  [198] = {
    alliance = 16843.0,
    horde = 6221.0,
    realms = {
      "Gnomeregan",
      "Moonrunner"
    } --[[table: 0x7ff13646da70]],
    type = "PvE"
  } --[[table: 0x7ff13646d910]],
  [199] = {
    alliance = 24124.0,
    horde = 13481.0,
    realms = {
      "Goldrinn"
    } --[[table: 0x7ff13646db90]],
    type = "PvE"
  } --[[table: 0x7ff13646da30]],
  [200] = {
    alliance = 18198.0,
    horde = 7709.0,
    realms = {
      "Greymane",
      "Tanaris"
    } --[[table: 0x7ff13646dc90]],
    type = "PvE"
  } --[[table: 0x7ff13646db50]],
  [201] = {
    alliance = 14177.0,
    horde = 7179.0,
    realms = {
      "Grizzly Hills",
      "Lothar"
    } --[[table: 0x7ff13646ddb0]],
    type = "PvE"
  } --[[table: 0x7ff13646dc50]],
  [202] = {
    alliance = 5469.0,
    horde = 21461.0,
    realms = {
      "Gundrak",
      "Jubei'Thos"
    } --[[table: 0x7ff13646ded0]],
    type = "PvP"
  } --[[table: 0x7ff13646dd70]],
  [203] = {
    alliance = 16403.0,
    horde = 11585.0,
    realms = {
      "Hellscream",
      "Zangarmarsh"
    } --[[table: 0x7ff13646dff0]],
    type = "PvE"
  } --[[table: 0x7ff13646de90]],
  [204] = {
    alliance = 13673.0,
    horde = 8330.0,
    realms = {
      "Hydraxis",
      "Terenas"
    } --[[table: 0x7ff13646e110]],
    type = "PvE"
  } --[[table: 0x7ff13646dfb0]],
  [205] = {
    alliance = 7706.0,
    horde = 47267.0,
    realms = {
      "Hyjal"
    } --[[table: 0x7ff13646e230]],
    type = "PvE"
  } --[[table: 0x7ff13646e0d0]],
  [206] = {
    alliance = 21621.0,
    horde = 9359.0,
    realms = {
      "Icecrown",
      "Malygos"
    } --[[table: 0x7ff13646e330]],
    type = "PvE"
  } --[[table: 0x7ff13646e1f0]],
  [207] = {
    alliance = 2741.0,
    horde = 133351.0,
    realms = {
      "Illidan"
    } --[[table: 0x7ff13646e450]],
    type = "PvP"
  } --[[table: 0x7ff13646e2f0]],
  [208] = {
    alliance = 16255.0,
    horde = 7923.0,
    realms = {
      "Kargath",
      "Norgannon"
    } --[[table: 0x7ff13646e550]],
    type = "PvE"
  } --[[table: 0x7ff13646e410]],
  [209] = {
    alliance = 56154.0,
    horde = 3578.0,
    realms = {
      "Kel'Thuzad"
    } --[[table: 0x7ff13646e670]],
    type = "PvP"
  } --[[table: 0x7ff13646e510]],
  [210] = {
    alliance = 4819.0,
    horde = 49996.0,
    realms = {
      "Kil'jaeden"
    } --[[table: 0x7ff13646e770]],
    type = "PvP"
  } --[[table: 0x7ff13646e630]],
  [211] = {
    alliance = 13753.0,
    horde = 12936.0,
    realms = {
      "Kilrogg",
      "Winterhoof"
    } --[[table: 0x7ff13646e870]],
    type = "PvE"
  } --[[table: 0x7ff13646e730]],
  [212] = {
    alliance = 17134.0,
    horde = 11296.0,
    realms = {
      "Kirin Tor",
      "Sentinels",
      "Steamwheedle Cartel"
    } --[[table: 0x7ff13646e990]],
    type = "PvE"
  } --[[table: 0x7ff13646e830]],
  [213] = {
    alliance = 21103.0,
    horde = 6151.0,
    realms = {
      "Korgath"
    } --[[table: 0x7ff13646ead0]],
    type = "PvP"
  } --[[table: 0x7ff13646ea50]],
  [214] = {
    alliance = 45216.0,
    horde = 7181.0,
    realms = {
      "Lightbringer"
    } --[[table: 0x7ff13646ebd0]],
    type = "PvE"
  } --[[table: 0x7ff13646ea90]],
  [215] = {
    alliance = 6056.0,
    horde = 12140.0,
    realms = {
      "Lightninghoof",
      "Maelstrom",
      "The Venture Co"
    } --[[table: 0x7ff13646ecd0]],
    type = "PvP"
  } --[[table: 0x7ff13646eb90]],
  [216] = {
    alliance = 1233.0,
    horde = 79617.0,
    realms = {
      "Mal'Ganis"
    } --[[table: 0x7ff13646ee10]],
    type = "PvP"
  } --[[table: 0x7ff13646ed90]],
  [217] = {
    alliance = 16560.0,
    horde = 15561.0,
    realms = {
      "Malfurion",
      "Trollbane"
    } --[[table: 0x7ff13646ef10]],
    type = "PvE"
  } --[[table: 0x7ff13646edd0]],
  [218] = {
    alliance = 14293.0,
    horde = 10930.0,
    realms = {
      "Misha",
      "Rexxar"
    } --[[table: 0x7ff13646f030]],
    type = "PvE"
  } --[[table: 0x7ff13646eed0]],
  [219] = {
    alliance = 18126.0,
    horde = 11609.0,
    realms = {
      "Mok'Nathal",
      "Silvermoon"
    } --[[table: 0x7ff13646f150]],
    type = "PvE"
  } --[[table: 0x7ff13646eff0]],
  [220] = {
    alliance = 59106.0,
    horde = 23495.0,
    realms = {
      "Moon Guard"
    } --[[table: 0x7ff13646f270]],
    type = "PvE"
  } --[[table: 0x7ff13646f110]],
  [221] = {
    alliance = 12909.0,
    horde = 7856.0,
    realms = {
      "Muradin",
      "Nordrassil"
    } --[[table: 0x7ff13646f370]],
    type = "PvE"
  } --[[table: 0x7ff13646f230]],
  [222] = {
    alliance = 18008.0,
    horde = 10821.0,
    realms = {
      "Nazgrel",
      "Nesingwary",
      "Vek'nilash"
    } --[[table: 0x7ff13646f490]],
    type = "PvE"
  } --[[table: 0x7ff13646f330]],
  [224] = {
    alliance = 106294.0,
    horde = 11953.0,
    realms = {
      "Proudmoore"
    } --[[table: 0x7ff13646f5d0]],
    type = "PvE"
  } --[[table: 0x7ff13646f550]],
  [225] = {
    alliance = 46491.0,
    horde = 41203.0,
    realms = {
      "Quel'Thalas"
    } --[[table: 0x7ff13646f6d0]],
    type = "PvE"
  } --[[table: 0x7ff13646f590]],
  [226] = {
    alliance = 15364.0,
    horde = 15175.0,
    realms = {
      "Quel'dorei",
      "Sen'jin"
    } --[[table: 0x7ff13646f7d0]],
    type = "PvE"
  } --[[table: 0x7ff13646f690]],
  [227] = {
    alliance = 29101.0,
    horde = 76733.0,
    realms = {
      "Ragnaros"
    } --[[table: 0x7ff13646f8f0]],
    type = "PvP"
  } --[[table: 0x7ff13646f790]],
  [228] = {
    alliance = 17375.0,
    horde = 11925.0,
    realms = {
      "Ravencrest",
      "Uldaman"
    } --[[table: 0x7ff13646f9f0]],
    type = "PvE"
  } --[[table: 0x7ff13646f8b0]],
  [229] = {
    alliance = 4108.0,
    horde = 8619.0,
    realms = {
      "Ravenholdt",
      "Twisting Nether"
    } --[[table: 0x7ff13646fb10]],
    type = "PvP"
  } --[[table: 0x7ff13646f9b0]],
  [230] = {
    alliance = 14758.0,
    horde = 13267.0,
    realms = {
      "Runetotem",
      "Uther"
    } --[[table: 0x7ff13646fc30]],
    type = "PvE"
  } --[[table: 0x7ff13646fad0]],
  [231] = {
    alliance = 130060.0,
    horde = 5354.0,
    realms = {
      "Sargeras"
    } --[[table: 0x7ff13646fd50]],
    type = "PvP"
  } --[[table: 0x7ff13646fbf0]],
  [232] = {
    alliance = 15996.0,
    horde = 17417.0,
    realms = {
      "Saurfang"
    } --[[table: 0x7ff13646fe50]],
    type = "PvE"
  } --[[table: 0x7ff13646fd10]],
  [233] = {
    alliance = 153614.0,
    horde = 3948.0,
    realms = {
      "Stormrage"
    } --[[table: 0x7ff13646ff50]],
    type = "PvE"
  } --[[table: 0x7ff13646fe10]],
  [234] = {
    alliance = 3030.0,
    horde = 32852.0,
    realms = {
      "Stormreaver"
    } --[[table: 0x7ff136470050]],
    type = "PvP"
  } --[[table: 0x7ff13646ff10]],
  [235] = {
    alliance = 7402.0,
    horde = 98839.0,
    realms = {
      "Thrall"
    } --[[table: 0x7ff136470150]],
    type = "PvE"
  } --[[table: 0x7ff136470010]],
  [236] = {
    alliance = 27693.0,
    horde = 112612.0,
    realms = {
      "Tichondrius"
    } --[[table: 0x7ff136470250]],
    type = "PvP"
  } --[[table: 0x7ff136470110]],
  [238] = {
    alliance = 12945.0,
    horde = 20700.0,
    realms = {
      "Turalyon"
    } --[[table: 0x7ff136470350]],
    type = "PvE"
  } --[[table: 0x7ff136470210]],
  [239] = {
    alliance = 37444.0,
    horde = 50028.0,
    realms = {
      "Wyrmrest Accord"
    } --[[table: 0x7ff136470450]],
    type = "PvE"
  } --[[table: 0x7ff136470310]],
  [240] = {
    alliance = 14832.0,
    horde = 92114.0,
    realms = {
      "Zul'jin"
    } --[[table: 0x7ff136470550]],
    type = "PvE"
  } --[[table: 0x7ff136470410]],
  [241] = {
    alliance = 62026.0,
    horde = 2323.0,
    realms = {
      "Aegwynn"
    } --[[table: 0x7ff1365288a0]],
    type = "PvP"
  } --[[table: 0x7ff136528820]],
  [242] = {
    alliance = 17585.0,
    horde = 6174.0,
    realms = {
      "Aerie Peak",
      "Bronzebeard"
    } --[[table: 0x7ff1365289c0]],
    type = "PvE"
  } --[[table: 0x7ff136528860]],
  [243] = {
    alliance = 4431.0,
    horde = 25928.0,
    realms = {
      "Agamaggan",
      "Bloodscalp",
      "Crushridge",
      "Emeriss",
      "Hakkar",
      "Twilight's Hammer"
    } --[[table: 0x7ff136528b00]],
    type = "PvP"
  } --[[table: 0x7ff136528a80]],
  [244] = {
    alliance = 27694.0,
    horde = 14589.0,
    realms = {
      "Aggra (Português)",
      "Grim Batol"
    } --[[table: 0x7ff136528cc0]],
    type = "PvP"
  } --[[table: 0x7ff136528980]],
  [245] = {
    alliance = 22873.0,
    horde = 11724.0,
    realms = {
      "Aggramar",
      "Hellscream"
    } --[[table: 0x7ff136528de0]],
    type = "PvE"
  } --[[table: 0x7ff136528ac0]],
  [246] = {
    alliance = 10563.0,
    horde = 29752.0,
    realms = {
      "Ahn'Qiraj",
      "Balnazzar",
      "Boulderfist",
      "Chromaggus",
      "Daggerspine",
      "Laughing Skull",
      "Shattered Halls",
      "Sunstrider",
      "Talnivarr",
      "Trollbane"
    } --[[table: 0x7ff136528c40]],
    type = "PvP"
  } --[[table: 0x7ff136528da0]],
  [247] = {
    alliance = 2406.0,
    horde = 17617.0,
    realms = {
      "Al'Akir",
      "Skullcrusher",
      "Xavius"
    } --[[table: 0x7ff136529080]],
    type = "PvP"
  } --[[table: 0x7ff136528c80]],
  [248] = {
    alliance = 18593.0,
    horde = 8269.0,
    realms = {
      "Alexstrasza",
      "Nethersturm"
    } --[[table: 0x7ff1365292c0]],
    type = "PvE"
  } --[[table: 0x7ff1365290c0]],
  [249] = {
    alliance = 32197.0,
    horde = 10817.0,
    realms = {
      "Alleria",
      "Rexxar"
    } --[[table: 0x7ff1365293e0]],
    type = "PvE"
  } --[[table: 0x7ff136529280]],
  [250] = {
    alliance = 22807.0,
    horde = 6484.0,
    realms = {
      "Alonsus",
      "Anachronos",
      "Kul Tiras"
    } --[[table: 0x7ff136528f00]],
    type = "PvE"
  } --[[table: 0x7ff1365293a0]],
  [251] = {
    alliance = 16887.0,
    horde = 7081.0,
    realms = {
      "Aman'thul"
    } --[[table: 0x7ff136529760]],
    type = "PvE"
  } --[[table: 0x7ff136528f40]],
  [252] = {
    alliance = 15687.0,
    horde = 6083.0,
    realms = {
      "Ambossar",
      "Kargath"
    } --[[table: 0x7ff136529860]],
    type = "PvE"
  } --[[table: 0x7ff136529720]],
  [253] = {
    alliance = 96665.0,
    horde = 3066.0,
    realms = {
      "Antonidas"
    } --[[table: 0x7ff136529960]],
    type = "PvE"
  } --[[table: 0x7ff136529820]],
  [254] = {
    alliance = 7538.0,
    horde = 20864.0,
    realms = {
      "Anub'arak",
      "Dalvengyr",
      "Frostmourne",
      "Nazjatar",
      "Zuluhed"
    } --[[table: 0x7ff136529a60]],
    type = "PvP"
  } --[[table: 0x7ff136529920]],
  [255] = {
    alliance = 9284.0,
    horde = 14739.0,
    realms = {
      "Arak-arahm",
      "Kael'thas",
      "Rashgarroth",
      "Throk'Feroth"
    } --[[table: 0x7ff136529be0]],
    type = "PvP"
  } --[[table: 0x7ff136529a20]],
  [256] = {
    alliance = 5728.0,
    horde = 14986.0,
    realms = {
      "Arathi",
      "Illidan",
      "Naxxramas",
      "Temple noir"
    } --[[table: 0x7ff136529d20]],
    type = "PvP"
  } --[[table: 0x7ff136529ca0]],
  [257] = {
    alliance = 26817.0,
    horde = 9539.0,
    realms = {
      "Arathor",
      "Hellfire"
    } --[[table: 0x7ff136529e60]],
    type = "PvE"
  } --[[table: 0x7ff136529de0]],
  [258] = {
    alliance = 22389.0,
    horde = 41156.0,
    realms = {
      "Archimonde"
    } --[[table: 0x7ff136529500]],
    type = "PvP"
  } --[[table: 0x7ff136529e20]],
  [259] = {
    alliance = 18179.0,
    horde = 9191.0,
    realms = {
      "Area 52",
      "Sen'jin",
      "Un'Goro"
    } --[[table: 0x7ff136529600]],
    type = "PvE"
  } --[[table: 0x7ff1365294c0]],
  [260] = {
    alliance = 66390.0,
    horde = 27561.0,
    realms = {
      "Argent Dawn"
    } --[[table: 0x7ff136529fe0]],
    type = "PvE"
  } --[[table: 0x7ff136529640]],
  [261] = {
    alliance = 15469.0,
    horde = 17206.0,
    realms = {
      "Arthas",
      "Blutkessel",
      "Kel'Thuzad",
      "Vek'lor",
      "Wrathbringer"
    } --[[table: 0x7ff13652a0e0]],
    type = "PvP"
  } --[[table: 0x7ff136529fa0]],
  [262] = {
    alliance = 16464.0,
    horde = 10623.0,
    realms = {
      "Arygos",
      "Khaz'goroth"
    } --[[table: 0x7ff13652a260]],
    type = "PvE"
  } --[[table: 0x7ff13652a0a0]],
  [263] = {
    alliance = 6275.0,
    horde = 27553.0,
    realms = {
      "Ashenvale"
    } --[[table: 0x7ff13652a360]],
    type = "PvP"
  } --[[table: 0x7ff13652a220]],
  [264] = {
    alliance = 23221.0,
    horde = 10466.0,
    realms = {
      "Aszune",
      "Shadowsong"
    } --[[table: 0x7ff13652a460]],
    type = "PvE"
  } --[[table: 0x7ff13652a320]],
  [265] = {
    alliance = 17092.0,
    horde = 10088.0,
    realms = {
      "Auchindoun",
      "Dunemaul",
      "Jaedenar"
    } --[[table: 0x7ff136700000]],
    type = "PvP"
  } --[[table: 0x7ff13652a420]],
  [266] = {
    alliance = 27344.0,
    horde = 17066.0,
    realms = {
      "Azjol-Nerub",
      "Quel'Thalas"
    } --[[table: 0x7ff1367001b0]],
    type = "PvE"
  } --[[table: 0x7ff136700130]],
  [267] = {
    alliance = 2892.0,
    horde = 20589.0,
    realms = {
      "Azshara",
      "Krag'jin"
    } --[[table: 0x7ff1367002d0]],
    type = "PvP"
  } --[[table: 0x7ff136700170]],
  [268] = {
    alliance = 25961.0,
    horde = 10878.0,
    realms = {
      "Azuregos"
    } --[[table: 0x7ff1367003f0]],
    type = "PvE"
  } --[[table: 0x7ff136700290]],
  [269] = {
    alliance = 18855.0,
    horde = 7648.0,
    realms = {
      "Azuremyst",
      "Stormrage"
    } --[[table: 0x7ff1367004f0]],
    type = "PvE"
  } --[[table: 0x7ff1367003b0]],
  [270] = {
    alliance = 19385.0,
    horde = 5868.0,
    realms = {
      "Baelgun",
      "Lothar"
    } --[[table: 0x7ff136700610]],
    type = "PvE"
  } --[[table: 0x7ff1367004b0]],
  [271] = {
    alliance = 6123.0,
    horde = 84830.0,
    realms = {
      "Blackhand"
    } --[[table: 0x7ff136700730]],
    type = "PvE"
  } --[[table: 0x7ff1367005d0]],
  [272] = {
    alliance = 49694.0,
    horde = 47850.0,
    realms = {
      "Blackmoore"
    } --[[table: 0x7ff136700850]],
    type = "PvP"
  } --[[table: 0x7ff1367006f0]],
  [273] = {
    alliance = 1320.0,
    horde = 76507.0,
    realms = {
      "Blackrock"
    } --[[table: 0x7ff136700950]],
    type = "PvP"
  } --[[table: 0x7ff136700810]],
  [274] = {
    alliance = 34907.0,
    horde = 8132.0,
    realms = {
      "Blackscar"
    } --[[table: 0x7ff136700a70]],
    type = "PvP"
  } --[[table: 0x7ff136700910]],
  [275] = {
    alliance = 18400.0,
    horde = 7704.0,
    realms = {
      "Blade's Edge",
      "Eonar",
      "Vek'nilash"
    } --[[table: 0x7ff136700b70]],
    type = "PvE"
  } --[[table: 0x7ff136700a30]],
  [276] = {
    alliance = 3565.0,
    horde = 26505.0,
    realms = {
      "Bladefist",
      "Frostwhisper",
      "Zenedar"
    } --[[table: 0x7ff136700cb0]],
    type = "PvP"
  } --[[table: 0x7ff136700c30]],
  [277] = {
    alliance = 4111.0,
    horde = 27537.0,
    realms = {
      "Bloodfeather",
      "Burning Steppes",
      "Executus",
      "Kor'gall",
      "Shattered Hand"
    } --[[table: 0x7ff136700df0]],
    type = "PvP"
  } --[[table: 0x7ff136700d70]],
  [278] = {
    alliance = 17642.0,
    horde = 10691.0,
    realms = {
      "Bloodhoof",
      "Khadgar"
    } --[[table: 0x7ff136700f70]],
    type = "PvE"
  } --[[table: 0x7ff136700db0]],
  [279] = {
    alliance = 4441.0,
    horde = 15340.0,
    realms = {
      "Booty Bay",
      "Deathweaver"
    } --[[table: 0x7ff136701090]],
    type = "PvP"
  } --[[table: 0x7ff136700f30]],
  [280] = {
    alliance = 18350.0,
    horde = 15716.0,
    realms = {
      "Borean Tundra"
    } --[[table: 0x7ff1367011b0]],
    type = "PvE"
  } --[[table: 0x7ff136701050]],
  [281] = {
    alliance = 17253.0,
    horde = 8373.0,
    realms = {
      "Bronze Dragonflight",
      "Nordrassil"
    } --[[table: 0x7ff1367012d0]],
    type = "PvE"
  } --[[table: 0x7ff136701170]],
  [282] = {
    alliance = 14533.0,
    horde = 47552.0,
    realms = {
      "Burning Blade",
      "Drak'thul"
    } --[[table: 0x7ff1367013f0]],
    type = "PvP"
  } --[[table: 0x7ff136701290]],
  [283] = {
    alliance = 15399.0,
    horde = 45403.0,
    realms = {
      "Burning Legion"
    } --[[table: 0x7ff136701510]],
    type = "PvP"
  } --[[table: 0x7ff1367013b0]],
  [284] = {
    alliance = 1100.0,
    horde = 28344.0,
    realms = {
      "C'Thun"
    } --[[table: 0x7ff136701610]],
    type = "PvP"
  } --[[table: 0x7ff1367014d0]],
  [285] = {
    alliance = 19305.0,
    horde = 23129.0,
    realms = {
      "Chamber of Aspects"
    } --[[table: 0x7ff136701730]],
    type = "PvE"
  } --[[table: 0x7ff1367015d0]],
  [286] = {
    alliance = 17887.0,
    horde = 7149.0,
    realms = {
      "Chants éternels",
      "Vol'jin"
    } --[[table: 0x7ff136701830]],
    type = "PvE"
  } --[[table: 0x7ff1367016f0]],
  [287] = {
    alliance = 6036.0,
    horde = 13822.0,
    realms = {
      "Cho’gall",
      "Eldre'Thalas",
      "Sinstralis"
    } --[[table: 0x7ff136701950]],
    type = "PvP"
  } --[[table: 0x7ff1367017f0]],
  [288] = {
    alliance = 25331.0,
    horde = 15374.0,
    realms = {
      "Colinas Pardas",
      "Los Errantes",
      "Tyrande"
    } --[[table: 0x7ff136701a90]],
    type = "PvE"
  } --[[table: 0x7ff136701a10]],
  [289] = {
    alliance = 20519.0,
    horde = 11701.0,
    realms = {
      "Confrérie du Thorium",
      "Les Clairvoyants",
      "Les Sentinelles"
    } --[[table: 0x7ff136701bd0]],
    type = "PvE"
  } --[[table: 0x7ff136701b50]],
  [290] = {
    alliance = 10296.0,
    horde = 13985.0,
    realms = {
      "Conseil des Ombres",
      "Culte de la Rive noire",
      "La Croisade écarlate"
    } --[[table: 0x7ff136701d10]],
    type = "PvP"
  } --[[table: 0x7ff136701c90]],
  [291] = {
    alliance = 37560.0,
    horde = 16261.0,
    realms = {
      "Dalaran",
      "Marécage de Zangar"
    } --[[table: 0x7ff136701e50]],
    type = "PvE"
  } --[[table: 0x7ff136701dd0]],
  [292] = {
    alliance = 12958.0,
    horde = 7447.0,
    realms = {
      "Darkmoon Faire",
      "Earthen Ring"
    } --[[table: 0x7ff136701f70]],
    type = "PvE"
  } --[[table: 0x7ff136701e10]],
  [293] = {
    alliance = 24866.0,
    horde = 6279.0,
    realms = {
      "Darksorrow",
      "Genjuros",
      "Neptulon"
    } --[[table: 0x7ff136702090]],
    type = "PvP"
  } --[[table: 0x7ff136701f30]],
  [294] = {
    alliance = 22405.0,
    horde = 7321.0,
    realms = {
      "Darkspear",
      "Saurfang",
      "Terokkar"
    } --[[table: 0x7ff1367021d0]],
    type = "PvE"
  } --[[table: 0x7ff136702150]],
  [295] = {
    alliance = 11714.0,
    horde = 17649.0,
    realms = {
      "Das Konsortium",
      "Das Syndikat",
      "Der Abyssische Rat",
      "Die Arguswacht",
      "Die Todeskrallen",
      "Kult der Verdammten"
    } --[[table: 0x7ff136702310]],
    type = "PvP"
  } --[[table: 0x7ff136702290]],
  [296] = {
    alliance = 17316.0,
    horde = 18084.0,
    realms = {
      "Deathguard"
    } --[[table: 0x7ff136702490]],
    type = "PvP"
  } --[[table: 0x7ff1367022d0]],
  [297] = {
    alliance = 28006.0,
    horde = 19071.0,
    realms = {
      "Deathwing",
      "Karazhan",
      "Lightning's Blade",
      "The Maelstrom"
    } --[[table: 0x7ff1367025b0]],
    type = "PvP"
  } --[[table: 0x7ff136702450]],
  [298] = {
    alliance = 10973.0,
    horde = 8120.0,
    realms = {
      "Deepholm",
      "Razuvious"
    } --[[table: 0x7ff1367026f0]],
    type = "PvP"
  } --[[table: 0x7ff136702670]],
  [299] = {
    alliance = 35895.0,
    horde = 31620.0,
    realms = {
      "Defias Brotherhood",
      "Ravenholdt",
      "Scarshield Legion",
      "Sporeggar",
      "The Venture Co"
    } --[[table: 0x7ff136702810]],
    type = "PvP"
  } --[[table: 0x7ff1367026b0]],
  [300] = {
    alliance = 2129.0,
    horde = 85343.0,
    realms = {
      "Dentarg",
      "Tarren Mill"
    } --[[table: 0x7ff136702990]],
    type = "PvP"
  } --[[table: 0x7ff1367027b0]],
  [301] = {
    alliance = 14608.0,
    horde = 5713.0,
    realms = {
      "Der Mithrilorden",
      "Der Rat von Dalaran"
    } --[[table: 0x7ff136702ab0]],
    type = "PvE"
  } --[[table: 0x7ff136702950]],
  [302] = {
    alliance = 6176.0,
    horde = 24878.0,
    realms = {
      "Destromath",
      "Gorgonnash",
      "Mannoroth",
      "Nefarian",
      "Nera'thor"
    } --[[table: 0x7ff136702bd0]],
    type = "PvP"
  } --[[table: 0x7ff136702a70]],
  [303] = {
    alliance = 3818.0,
    horde = 29093.0,
    realms = {
      "Dethecus",
      "Mug'thol",
      "Onyxia",
      "Terrordar",
      "Theradras"
    } --[[table: 0x7ff136702d50]],
    type = "PvP"
  } --[[table: 0x7ff136702b70]],
  [304] = {
    alliance = 18683.0,
    horde = 8358.0,
    realms = {
      "Die Aldor"
    } --[[table: 0x7ff136702ed0]],
    type = "PvE"
  } --[[table: 0x7ff136702d10]],
  [305] = {
    alliance = 12660.0,
    horde = 7841.0,
    realms = {
      "Die Nachtwache",
      "Forscherliga"
    } --[[table: 0x7ff136702fd0]],
    type = "PvE"
  } --[[table: 0x7ff136702e90]],
  [306] = {
    alliance = 16133.0,
    horde = 5102.0,
    realms = {
      "Die Silberne Hand",
      "Die ewige Wacht"
    } --[[table: 0x7ff1367030f0]],
    type = "PvE"
  } --[[table: 0x7ff136702f90]],
  [307] = {
    alliance = 21144.0,
    horde = 9013.0,
    realms = {
      "Doomhammer",
      "Turalyon"
    } --[[table: 0x7ff136703210]],
    type = "PvE"
  } --[[table: 0x7ff1367030b0]],
  [308] = {
    alliance = 8366.0,
    horde = 141812.0,
    realms = {
      "Draenor"
    } --[[table: 0x7ff136703330]],
    type = "PvE"
  } --[[table: 0x7ff1367031d0]],
  [309] = {
    alliance = 18689.0,
    horde = 8564.0,
    realms = {
      "Dragonblight",
      "Ghostlands"
    } --[[table: 0x7ff136703450]],
    type = "PvE"
  } --[[table: 0x7ff1367032f0]],
  [310] = {
    alliance = 5020.0,
    horde = 29094.0,
    realms = {
      "Dragonmaw",
      "Haomarush",
      "Spinebreaker",
      "Stormreaver",
      "Vashj"
    } --[[table: 0x7ff136703570]],
    type = "PvP"
  } --[[table: 0x7ff136703410]],
  [311] = {
    alliance = 15101.0,
    horde = 11786.0,
    realms = {
      "Drek'Thar",
      "Uldaman"
    } --[[table: 0x7ff1367036f0]],
    type = "PvE"
  } --[[table: 0x7ff136703510]],
  [312] = {
    alliance = 61728.0,
    horde = 2528.0,
    realms = {
      "Dun Modr"
    } --[[table: 0x7ff136703810]],
    type = "PvP"
  } --[[table: 0x7ff1367036b0]],
  [313] = {
    alliance = 19513.0,
    horde = 7661.0,
    realms = {
      "Dun Morogh",
      "Norgannon"
    } --[[table: 0x7ff136703910]],
    type = "PvE"
  } --[[table: 0x7ff1367037d0]],
  [314] = {
    alliance = 14405.0,
    horde = 5062.0,
    realms = {
      "Durotan",
      "Tirion"
    } --[[table: 0x7ff136703a30]],
    type = "PvE"
  } --[[table: 0x7ff1367038d0]],
  [315] = {
    alliance = 10059.0,
    horde = 21429.0,
    realms = {
      "Echsenkessel",
      "Mal'Ganis",
      "Taerar"
    } --[[table: 0x7ff136703b50]],
    type = "PvP"
  } --[[table: 0x7ff1367039f0]],
  [316] = {
    alliance = 13371.0,
    horde = 5875.0,
    realms = {
      "Eitrigg",
      "Krasus"
    } --[[table: 0x7ff136703c90]],
    type = "PvE"
  } --[[table: 0x7ff136703c10]],
  [317] = {
    alliance = 28968.0,
    horde = 6624.0,
    realms = {
      "Elune",
      "Varimathras"
    } --[[table: 0x7ff136703db0]],
    type = "PvE"
  } --[[table: 0x7ff136703c50]],
  [318] = {
    alliance = 25343.0,
    horde = 8578.0,
    realms = {
      "Emerald Dream",
      "Terenas"
    } --[[table: 0x7ff136703ed0]],
    type = "PvE"
  } --[[table: 0x7ff136703d70]],
  [319] = {
    alliance = 929.0,
    horde = 56033.0,
    realms = {
      "Eredar"
    } --[[table: 0x7ff136703ff0]],
    type = "PvP"
  } --[[table: 0x7ff136703e90]],
  [320] = {
    alliance = 18404.0,
    horde = 11279.0,
    realms = {
      "Eversong"
    } --[[table: 0x7ff136704110]],
    type = "PvE"
  } --[[table: 0x7ff136703fb0]],
  [321] = {
    alliance = 19509.0,
    horde = 10613.0,
    realms = {
      "Exodar",
      "Minahonda"
    } --[[table: 0x7ff136704210]],
    type = "PvE"
  } --[[table: 0x7ff1367040d0]],
  [323] = {
    alliance = 24356.0,
    horde = 15294.0,
    realms = {
      "Fordragon"
    } --[[table: 0x7ff136704330]],
    type = "PvE"
  } --[[table: 0x7ff1367041d0]],
  [324] = {
    alliance = 42138.0,
    horde = 1900.0,
    realms = {
      "Frostmane"
    } --[[table: 0x7ff136704450]],
    type = "PvP"
  } --[[table: 0x7ff1367042f0]],
  [325] = {
    alliance = 1866.0,
    horde = 39142.0,
    realms = {
      "Frostwolf"
    } --[[table: 0x7ff136704550]],
    type = "PvP"
  } --[[table: 0x7ff136704410]],
  [326] = {
    alliance = 22172.0,
    horde = 16487.0,
    realms = {
      "Galakrond"
    } --[[table: 0x7ff136704670]],
    type = "PvE"
  } --[[table: 0x7ff136704510]],
  [327] = {
    alliance = 6686.0,
    horde = 20496.0,
    realms = {
      "Garona",
      "Ner’zhul",
      "Sargeras"
    } --[[table: 0x7ff136704770]],
    type = "PvP"
  } --[[table: 0x7ff136704630]],
  [328] = {
    alliance = 25241.0,
    horde = 15039.0,
    realms = {
      "Garrosh",
      "Nozdormu",
      "Shattrath"
    } --[[table: 0x7ff1367048b0]],
    type = "PvE"
  } --[[table: 0x7ff136704830]],
  [329] = {
    alliance = 14351.0,
    horde = 6203.0,
    realms = {
      "Gilneas",
      "Ulduar"
    } --[[table: 0x7ff1367049f0]],
    type = "PvE"
  } --[[table: 0x7ff136704970]],
  [330] = {
    alliance = 20577.0,
    horde = 13218.0,
    realms = {
      "Goldrinn"
    } --[[table: 0x7ff136704b10]],
    type = "PvE"
  } --[[table: 0x7ff1367049b0]],
  [331] = {
    alliance = 112598.0,
    horde = 4766.0,
    realms = {
      "Gordunni"
    } --[[table: 0x7ff136704c30]],
    type = "PvP"
  } --[[table: 0x7ff136704ad0]],
  [332] = {
    alliance = 10613.0,
    horde = 11773.0,
    realms = {
      "Greymane",
      "Lich King"
    } --[[table: 0x7ff136704d30]],
    type = "PvP"
  } --[[table: 0x7ff136704bf0]],
  [333] = {
    alliance = 8540.0,
    horde = 8708.0,
    realms = {
      "Grom",
      "Thermaplugg"
    } --[[table: 0x7ff136704e50]],
    type = "PvP"
  } --[[table: 0x7ff136704cf0]],
  [334] = {
    alliance = 1681.0,
    horde = 61526.0,
    realms = {
      "Howling Fjord"
    } --[[table: 0x7ff136704f70]],
    type = "PvP"
  } --[[table: 0x7ff136704e10]],
  [335] = {
    alliance = 41787.0,
    horde = 64618.0,
    realms = {
      "Hyjal"
    } --[[table: 0x7ff136705090]],
    type = "PvE"
  } --[[table: 0x7ff136704f30]],
  [336] = {
    alliance = 1951.0,
    horde = 124292.0,
    realms = {
      "Kazzak"
    } --[[table: 0x7ff136705190]],
    type = "PvP"
  } --[[table: 0x7ff136705050]],
  [337] = {
    alliance = 18844.0,
    horde = 13658.0,
    realms = {
      "Khaz Modan"
    } --[[table: 0x7ff1364029f0]],
    type = "PvE"
  } --[[table: 0x7ff1364029b0]],
  [338] = {
    alliance = 27254.0,
    horde = 11123.0,
    realms = {
      "Kilrogg",
      "Nagrand",
      "Runetotem"
    } --[[table: 0x7ff13642d890]],
    type = "PvE"
  } --[[table: 0x7ff13642d650]],
  [339] = {
    alliance = 20093.0,
    horde = 8117.0,
    realms = {
      "Kirin Tor"
    } --[[table: 0x7ff13642dad0]],
    type = "PvE"
  } --[[table: 0x7ff13642da50]],
  [340] = {
    alliance = 17948.0,
    horde = 12140.0,
    realms = {
      "Lightbringer",
      "Mazrigos"
    } --[[table: 0x7ff13642dbd0]],
    type = "PvE"
  } --[[table: 0x7ff13642da90]],
  [341] = {
    alliance = 12254.0,
    horde = 5164.0,
    realms = {
      "Lordaeron",
      "Tichondrius"
    } --[[table: 0x7ff13642dcd0]],
    type = "PvE"
  } --[[table: 0x7ff13642db90]],
  [342] = {
    alliance = 18445.0,
    horde = 5724.0,
    realms = {
      "Madmortem",
      "Proudmoore"
    } --[[table: 0x7ff13642ddd0]],
    type = "PvE"
  } --[[table: 0x7ff13642dc90]],
  [343] = {
    alliance = 25309.0,
    horde = 28252.0,
    realms = {
      "Magtheridon"
    } --[[table: 0x7ff13642ded0]],
    type = "PvE"
  } --[[table: 0x7ff13642dd90]],
  [344] = {
    alliance = 25413.0,
    horde = 14573.0,
    realms = {
      "Malfurion",
      "Malygos"
    } --[[table: 0x7ff13642dfd0]],
    type = "PvE"
  } --[[table: 0x7ff13642de90]],
  [345] = {
    alliance = 19198.0,
    horde = 9188.0,
    realms = {
      "Malorne",
      "Ysera"
    } --[[table: 0x7ff13642e0f0]],
    type = "PvE"
  } --[[table: 0x7ff13642df90]],
  [346] = {
    alliance = 14846.0,
    horde = 6649.0,
    realms = {
      "Medivh",
      "Suramar"
    } --[[table: 0x7ff13642e210]],
    type = "PvE"
  } --[[table: 0x7ff13642e0b0]],
  [347] = {
    alliance = 16783.0,
    horde = 11491.0,
    realms = {
      "Moonglade",
      "Steamwheedle Cartel",
      "The Sha'tar"
    } --[[table: 0x7ff13642e330]],
    type = "PvE"
  } --[[table: 0x7ff13642e1d0]],
  [348] = {
    alliance = 7114.0,
    horde = 23072.0,
    realms = {
      "Nemesis"
    } --[[table: 0x7ff13642e470]],
    type = "PvP"
  } --[[table: 0x7ff13642e3f0]],
  [349] = {
    alliance = 87426.0,
    horde = 10967.0,
    realms = {
      "Outland"
    } --[[table: 0x7ff13642e570]],
    type = "PvP"
  } --[[table: 0x7ff13642e430]],
  [350] = {
    alliance = 16646.0,
    horde = 6032.0,
    realms = {
      "Perenolde",
      "Teldrassil"
    } --[[table: 0x7ff13642e670]],
    type = "PvE"
  } --[[table: 0x7ff13642e530]],
  [351] = {
    alliance = 23972.0,
    horde = 12883.0,
    realms = {
      "Pozzo dell'Eternità"
    } --[[table: 0x7ff13642e790]],
    type = "PvE"
  } --[[table: 0x7ff13642e630]],
  [352] = {
    alliance = 10165.0,
    horde = 79835.0,
    realms = {
      "Ragnaros"
    } --[[table: 0x7ff13642e890]],
    type = "PvP"
  } --[[table: 0x7ff13642e750]],
  [353] = {
    alliance = 94805.0,
    horde = 2969.0,
    realms = {
      "Ravencrest"
    } --[[table: 0x7ff13642e990]],
    type = "PvP"
  } --[[table: 0x7ff13642e850]],
  [354] = {
    alliance = 6487.0,
    horde = 44026.0,
    realms = {
      "Sanguino",
      "Shen'dralar",
      "Uldum",
      "Zul'jin"
    } --[[table: 0x7ff13642ea90]],
    type = "PvP"
  } --[[table: 0x7ff13642e950]],
  [355] = {
    alliance = 138294.0,
    horde = 5893.0,
    realms = {
      "Silvermoon"
    } --[[table: 0x7ff13642ebd0]],
    type = "PvE"
  } --[[table: 0x7ff13642eb50]],
  [356] = {
    alliance = 2296.0,
    horde = 83078.0,
    realms = {
      "Soulflayer"
    } --[[table: 0x7ff13642ecd0]],
    type = "PvP"
  } --[[table: 0x7ff13642eb90]],
  [357] = {
    alliance = 2023.0,
    horde = 80647.0,
    realms = {
      "Stormscale"
    } --[[table: 0x7ff13642edd0]],
    type = "PvP"
  } --[[table: 0x7ff13642ec90]],
  [358] = {
    alliance = 62614.0,
    horde = 4487.0,
    realms = {
      "Sylvanas"
    } --[[table: 0x7ff13642eed0]],
    type = "PvP"
  } --[[table: 0x7ff13642ed90]],
  [359] = {
    alliance = 5157.0,
    horde = 64164.0,
    realms = {
      "Thrall"
    } --[[table: 0x7ff13642efd0]],
    type = "PvE"
  } --[[table: 0x7ff13642ee90]],
  [360] = {
    alliance = 25936.0,
    horde = 11108.0,
    realms = {
      "Thunderhorn",
      "Wildhammer"
    } --[[table: 0x7ff13642f0d0]],
    type = "PvE"
  } --[[table: 0x7ff13642ef90]],
  [361] = {
    alliance = 15640.0,
    horde = 9542.0,
    realms = {
      "Todeswache",
      "Zirkel des Cenarius"
    } --[[table: 0x7ff13642f1f0]],
    type = "PvE"
  } --[[table: 0x7ff13642f090]],
  [362] = {
    alliance = 1716.0,
    horde = 112905.0,
    realms = {
      "Twisting Nether"
    } --[[table: 0x7ff13642f310]],
    type = "PvP"
  } --[[table: 0x7ff13642f1b0]],
  [363] = {
    alliance = 2924.0,
    horde = 34943.0,
    realms = {
      "Ysondre"
    } --[[table: 0x7ff13642f410]],
    type = "PvP"
  } --[[table: 0x7ff13642f2d0]],
  [402] = {
    alliance = 7533.0,
    horde = 21771.0,
    realms = {
      "Anetheron",
      "Festung der Stürme",
      "Gul'dan",
      "Kil'jaeden",
      "Nathrezim",
      "Rajaxx"
    } --[[table: 0x7ff13642f510]],
    type = "PvP"
  } --[[table: 0x7ff13642f3d0]],
  [791] = {
    alliance = 34592.0,
    horde = 10954.0,
    realms = {
      "Nemesis",
      "Tol Barad"
    } --[[table: 0x7ff136470650]],
    type = "PvP"
  } --[[table: 0x7ff136470510]]
} --[[table: 0x7ff1365281e0]]

realmClusters =
{
  EU = {
    Aegwynn = 241,
    ["Aerie Peak"] = 242,
    Agamaggan = 243,
    ["Aggra (Português)"] = 244,
    Aggramar = 245,
    ["Ahn'Qiraj"] = 246,
    ["Al'Akir"] = 247,
    Alexstrasza = 248,
    Alleria = 249,
    Alonsus = 250,
    ["Aman'thul"] = 251,
    Ambossar = 252,
    Anachronos = 250,
    Anetheron = 402,
    Antonidas = 253,
    ["Anub'arak"] = 254,
    ["Arak-arahm"] = 255,
    Arathi = 256,
    Arathor = 257,
    Archimonde = 258,
    ["Area 52"] = 259,
    ["Argent Dawn"] = 260,
    Arthas = 261,
    Arygos = 262,
    Ashenvale = 263,
    Aszune = 264,
    Auchindoun = 265,
    ["Azjol-Nerub"] = 266,
    Azshara = 267,
    Azuregos = 268,
    Azuremyst = 269,
    Baelgun = 270,
    Balnazzar = 246,
    Blackhand = 271,
    Blackmoore = 272,
    Blackrock = 273,
    Blackscar = 274,
    ["Blade's Edge"] = 275,
    Bladefist = 276,
    Bloodfeather = 277,
    Bloodhoof = 278,
    Bloodscalp = 243,
    Blutkessel = 261,
    ["Booty Bay"] = 279,
    ["Borean Tundra"] = 280,
    Boulderfist = 246,
    ["Bronze Dragonflight"] = 281,
    Bronzebeard = 242,
    ["Burning Blade"] = 282,
    ["Burning Legion"] = 283,
    ["Burning Steppes"] = 277,
    ["C'Thun"] = 284,
    ["Chamber of Aspects"] = 285,
    ["Chants éternels"] = 286,
    ["Cho’gall"] = 287,
    Chromaggus = 246,
    ["Colinas Pardas"] = 288,
    ["Confrérie du Thorium"] = 289,
    ["Conseil des Ombres"] = 290,
    Crushridge = 243,
    ["Culte de la Rive noire"] = 290,
    Daggerspine = 246,
    Dalaran = 291,
    Dalvengyr = 254,
    ["Darkmoon Faire"] = 292,
    Darksorrow = 293,
    Darkspear = 294,
    ["Das Konsortium"] = 295,
    ["Das Syndikat"] = 295,
    Deathguard = 296,
    Deathweaver = 279,
    Deathwing = 297,
    Deepholm = 298,
    ["Defias Brotherhood"] = 299,
    Dentarg = 300,
    ["Der Abyssische Rat"] = 295,
    ["Der Mithrilorden"] = 301,
    ["Der Rat von Dalaran"] = 301,
    Destromath = 302,
    Dethecus = 303,
    ["Die Aldor"] = 304,
    ["Die Arguswacht"] = 295,
    ["Die Nachtwache"] = 305,
    ["Die Silberne Hand"] = 306,
    ["Die Todeskrallen"] = 295,
    ["Die ewige Wacht"] = 306,
    Doomhammer = 307,
    Draenor = 308,
    Dragonblight = 309,
    Dragonmaw = 310,
    ["Drak'thul"] = 282,
    ["Drek'Thar"] = 311,
    ["Dun Modr"] = 312,
    ["Dun Morogh"] = 313,
    Dunemaul = 265,
    Durotan = 314,
    ["Earthen Ring"] = 292,
    Echsenkessel = 315,
    Eitrigg = 316,
    ["Eldre'Thalas"] = 287,
    Elune = 317,
    ["Emerald Dream"] = 318,
    Emeriss = 243,
    Eonar = 275,
    Eredar = 319,
    Eversong = 320,
    Executus = 277,
    Exodar = 321,
    ["Festung der Stürme"] = 402,
    Fordragon = 323,
    Forscherliga = 305,
    Frostmane = 324,
    Frostmourne = 254,
    Frostwhisper = 276,
    Frostwolf = 325,
    Galakrond = 326,
    Garona = 327,
    Garrosh = 328,
    Genjuros = 293,
    Ghostlands = 309,
    Gilneas = 329,
    Goldrinn = 330,
    Gordunni = 331,
    Gorgonnash = 302,
    Greymane = 332,
    ["Grim Batol"] = 244,
    Grom = 333,
    ["Gul'dan"] = 402,
    Hakkar = 243,
    Haomarush = 310,
    Hellfire = 257,
    Hellscream = 245,
    ["Howling Fjord"] = 334,
    Hyjal = 335,
    Illidan = 256,
    Jaedenar = 265,
    ["Kael'thas"] = 255,
    Karazhan = 297,
    Kargath = 252,
    Kazzak = 336,
    ["Kel'Thuzad"] = 261,
    Khadgar = 278,
    ["Khaz Modan"] = 337,
    ["Khaz'goroth"] = 262,
    ["Kil'jaeden"] = 402,
    Kilrogg = 338,
    ["Kirin Tor"] = 339,
    ["Kor'gall"] = 277,
    ["Krag'jin"] = 267,
    Krasus = 316,
    ["Kul Tiras"] = 250,
    ["Kult der Verdammten"] = 295,
    ["La Croisade écarlate"] = 290,
    ["Laughing Skull"] = 246,
    ["Les Clairvoyants"] = 289,
    ["Les Sentinelles"] = 289,
    ["Lich King"] = 332,
    Lightbringer = 340,
    ["Lightning's Blade"] = 297,
    Lordaeron = 341,
    ["Los Errantes"] = 288,
    Lothar = 270,
    Madmortem = 342,
    Magtheridon = 343,
    ["Mal'Ganis"] = 315,
    Malfurion = 344,
    Malorne = 345,
    Malygos = 344,
    Mannoroth = 302,
    ["Marécage de Zangar"] = 291,
    Mazrigos = 340,
    Medivh = 346,
    Minahonda = 321,
    Moonglade = 347,
    ["Mug'thol"] = 303,
    Nagrand = 338,
    Nathrezim = 402,
    Naxxramas = 256,
    Nazjatar = 254,
    Nefarian = 302,
    Nemesis = 348,
    Neptulon = 293,
    ["Nera'thor"] = 302,
    ["Ner’zhul"] = 327,
    Nethersturm = 248,
    Nordrassil = 281,
    Norgannon = 313,
    Nozdormu = 328,
    Onyxia = 303,
    Outland = 349,
    Perenolde = 350,
    ["Pozzo dell'Eternità"] = 351,
    Proudmoore = 342,
    ["Quel'Thalas"] = 266,
    Ragnaros = 352,
    Rajaxx = 402,
    Rashgarroth = 255,
    Ravencrest = 353,
    Ravenholdt = 299,
    Razuvious = 298,
    Rexxar = 249,
    Runetotem = 338,
    Sanguino = 354,
    Sargeras = 327,
    Saurfang = 294,
    ["Scarshield Legion"] = 299,
    ["Sen'jin"] = 259,
    Shadowsong = 264,
    ["Shattered Halls"] = 246,
    ["Shattered Hand"] = 277,
    Shattrath = 328,
    ["Shen'dralar"] = 354,
    Silvermoon = 355,
    Sinstralis = 287,
    Skullcrusher = 247,
    Soulflayer = 356,
    Spinebreaker = 310,
    Sporeggar = 299,
    ["Steamwheedle Cartel"] = 347,
    Stormrage = 269,
    Stormreaver = 310,
    Stormscale = 357,
    Sunstrider = 246,
    Suramar = 346,
    Sylvanas = 358,
    Taerar = 315,
    Talnivarr = 246,
    ["Tarren Mill"] = 300,
    Teldrassil = 350,
    ["Temple noir"] = 256,
    Terenas = 318,
    Terokkar = 294,
    Terrordar = 303,
    ["The Maelstrom"] = 297,
    ["The Sha'tar"] = 347,
    ["The Venture Co"] = 299,
    Theradras = 303,
    Thermaplugg = 333,
    Thrall = 359,
    ["Throk'Feroth"] = 255,
    Thunderhorn = 360,
    Tichondrius = 341,
    Tirion = 314,
    Todeswache = 361,
    Trollbane = 246,
    Turalyon = 307,
    ["Twilight's Hammer"] = 243,
    ["Twisting Nether"] = 362,
    Tyrande = 288,
    Uldaman = 311,
    Ulduar = 329,
    Uldum = 354,
    ["Un'Goro"] = 259,
    Varimathras = 317,
    Vashj = 310,
    ["Vek'lor"] = 261,
    ["Vek'nilash"] = 275,
    ["Vol'jin"] = 286,
    Wildhammer = 360,
    Wrathbringer = 261,
    Xavius = 247,
    Ysera = 345,
    Ysondre = 363,
    Zenedar = 276,
    ["Zirkel des Cenarius"] = 361,
    ["Zul'jin"] = 354,
    Zuluhed = 254
  } --[[table: 0x7ff13642f4d0]],
  US = {
    Aegwynn = 121,
    ["Aerie Peak"] = 122,
    Agamaggan = 123,
    Aggramar = 124,
    Akama = 125,
    Alexstrasza = 126,
    Alleria = 127,
    ["Altar of Storms"] = 128,
    ["Alterac Mountains"] = 129,
    ["Aman'Thul"] = 130,
    Andorhal = 131,
    Anetheron = 128,
    Antonidas = 132,
    ["Anub'arak"] = 133,
    Anvilmar = 134,
    Arathor = 135,
    Archimonde = 123,
    ["Area 52"] = 136,
    ["Argent Dawn"] = 137,
    Arthas = 138,
    Arygos = 139,
    Auchindoun = 140,
    Azgalor = 141,
    ["Azjol-Nerub"] = 142,
    Azralon = 143,
    Azshara = 141,
    Azuremyst = 144,
    Baelgun = 145,
    Balnazzar = 129,
    Barthilas = 146,
    ["Black Dragonflight"] = 147,
    Blackhand = 148,
    Blackrock = 149,
    ["Blackwater Raiders"] = 150,
    ["Blackwing Lair"] = 151,
    ["Blade's Edge"] = 152,
    Bladefist = 153,
    ["Bleeding Hollow"] = 154,
    ["Blood Furnace"] = 155,
    Bloodhoof = 156,
    Bloodscalp = 157,
    Bonechewer = 121,
    ["Borean Tundra"] = 158,
    Boulderfist = 157,
    Bronzebeard = 159,
    ["Burning Blade"] = 160,
    ["Burning Legion"] = 123,
    Caelestrasz = 161,
    Cairne = 162,
    ["Cenarion Circle"] = 163,
    Cenarius = 164,
    ["Cho'gall"] = 140,
    Chromaggus = 133,
    Coilfang = 165,
    Crushridge = 133,
    Daggerspine = 121,
    Dalaran = 166,
    Dalvengyr = 165,
    ["Dark Iron"] = 165,
    Darkspear = 167,
    Darrowmere = 168,
    ["Dath'Remar"] = 169,
    Dawnbringer = 170,
    Deathwing = 171,
    ["Demon Soul"] = 165,
    Dentarg = 172,
    Destromath = 141,
    Dethecus = 151,
    Detheroc = 151,
    Doomhammer = 145,
    Draenor = 173,
    Dragonblight = 174,
    Dragonmaw = 125,
    ["Drak'Tharon"] = 175,
    ["Drak'thul"] = 176,
    Draka = 177,
    Drakkari = 178,
    Dreadmaul = 179,
    Drenden = 135,
    Dunemaul = 157,
    Durotan = 180,
    Duskwood = 156,
    ["Earthen Ring"] = 181,
    ["Echo Isles"] = 173,
    Eitrigg = 182,
    ["Eldre'Thalas"] = 183,
    Elune = 184,
    ["Emerald Dream"] = 185,
    Eonar = 186,
    Eredar = 187,
    Executus = 171,
    Exodar = 188,
    Farstriders = 189,
    Feathermoon = 190,
    Fenris = 174,
    Firetree = 175,
    Fizzcrank = 124,
    Frostmane = 191,
    Frostmourne = 192,
    Frostwolf = 193,
    Galakrond = 148,
    Gallywix = 194,
    Garithos = 133,
    Garona = 195,
    Garrosh = 196,
    Ghostlands = 197,
    Gilneas = 184,
    Gnomeregan = 198,
    Goldrinn = 199,
    Gorefiend = 187,
    Gorgonnash = 129,
    Greymane = 200,
    ["Grizzly Hills"] = 201,
    ["Gul'dan"] = 147,
    Gundrak = 202,
    Gurubashi = 121,
    Hakkar = 121,
    Haomarush = 151,
    Hellscream = 203,
    Hydraxis = 204,
    Hyjal = 205,
    Icecrown = 206,
    Illidan = 207,
    Jaedenar = 123,
    ["Jubei'Thos"] = 202,
    ["Kael'thas"] = 197,
    Kalecgos = 171,
    Kargath = 208,
    ["Kel'Thuzad"] = 209,
    Khadgar = 127,
    ["Khaz Modan"] = 142,
    ["Khaz'goroth"] = 169,
    ["Kil'jaeden"] = 210,
    Kilrogg = 211,
    ["Kirin Tor"] = 212,
    Korgath = 213,
    Korialstrasz = 183,
    ["Kul Tiras"] = 153,
    ["Laughing Skull"] = 140,
    Lethon = 151,
    Lightbringer = 214,
    ["Lightning's Blade"] = 160,
    Lightninghoof = 215,
    Llane = 139,
    Lothar = 201,
    Madoran = 170,
    Maelstrom = 215,
    Magtheridon = 128,
    Maiev = 157,
    ["Mal'Ganis"] = 216,
    Malfurion = 217,
    Malorne = 175,
    Malygos = 206,
    Mannoroth = 155,
    Medivh = 188,
    Misha = 218,
    ["Mok'Nathal"] = 219,
    ["Moon Guard"] = 220,
    Moonrunner = 198,
    ["Mug'thol"] = 125,
    Muradin = 221,
    Nagrand = 161,
    Nathrezim = 133,
    Nazgrel = 222,
    Nazjatar = 155,
    Nemesis = 791,
    ["Ner'zhul"] = 191,
    Nesingwary = 222,
    Nordrassil = 221,
    Norgannon = 208,
    Onyxia = 160,
    Perenolde = 162,
    Proudmoore = 224,
    ["Quel'Thalas"] = 225,
    ["Quel'dorei"] = 226,
    Ragnaros = 227,
    Ravencrest = 228,
    Ravenholdt = 229,
    Rexxar = 218,
    Rivendare = 175,
    Runetotem = 230,
    Sargeras = 231,
    Saurfang = 232,
    ["Scarlet Crusade"] = 190,
    Scilla = 131,
    ["Sen'jin"] = 226,
    Sentinels = 212,
    ["Shadow Council"] = 150,
    Shadowmoon = 151,
    Shadowsong = 158,
    Shandris = 159,
    ["Shattered Halls"] = 171,
    ["Shattered Hand"] = 165,
    ["Shu'halo"] = 182,
    ["Silver Hand"] = 189,
    Silvermoon = 219,
    ["Sisters of Elune"] = 163,
    Skullcrusher = 147,
    Skywall = 176,
    Smolderthorn = 133,
    Spinebreaker = 187,
    Spirestone = 175,
    Staghelm = 144,
    ["Steamwheedle Cartel"] = 212,
    Stonemaul = 157,
    Stormrage = 233,
    Stormreaver = 234,
    Stormscale = 175,
    Suramar = 177,
    Tanaris = 200,
    Terenas = 204,
    Terokkar = 126,
    Thaurissan = 179,
    ["The Forgotten Coast"] = 129,
    ["The Scryers"] = 137,
    ["The Underbog"] = 123,
    ["The Venture Co"] = 215,
    ["Thorium Brotherhood"] = 189,
    Thrall = 235,
    Thunderhorn = 152,
    Thunderlord = 141,
    Tichondrius = 236,
    ["Tol Barad"] = 791,
    Tortheldrin = 191,
    Trollbane = 217,
    Turalyon = 238,
    ["Twisting Nether"] = 229,
    Uldaman = 228,
    Uldum = 132,
    Undermine = 134,
    Ursin = 131,
    Uther = 230,
    Vashj = 193,
    ["Vek'nilash"] = 222,
    Velen = 186,
    Warsong = 129,
    Whisperwind = 172,
    Wildhammer = 187,
    Windrunner = 168,
    Winterhoof = 211,
    ["Wyrmrest Accord"] = 239,
    Ysera = 180,
    Ysondre = 128,
    Zangarmarsh = 203,
    ["Zul'jin"] = 240,
    Zuluhed = 131
  } --[[table: 0x7ff136470610]]
} --[[table: 0x7ff136470830]]
