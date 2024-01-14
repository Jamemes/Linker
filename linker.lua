if Global.game_settings.permission ~= "public" then
	managers.chat:feed_system_message(ChatManager.GAME, managers.localization:text("DBU37_premission"))
	managers.menu_component:post_event("menu_error")
	
	return
elseif managers.network:game():amount_of_members() == 4 then
	managers.chat:feed_system_message(ChatManager.GAME, managers.localization:text("DBU37_full"))
	managers.menu_component:post_event("menu_error")
	
	return
end

local levels = {
	alex = "Rats",
	alex_1 = "Cook Off",
	alex_2 = "Code for Meth",
	alex_3 = "Bus Stop",
	arm_cro = "Transport: Crossroads",
	arm_fac = "Transport: Harbor",
	arm_for = "Train Heist",
	arm_hcm = "Transport: Downtown",
	arm_par = "Transport: Park",
	arm_und = "Transport: Underpass",
	big = "The Big Bank",
	branchbank = "Bank Heist",
	branchbank_cash = "Bank Heist: Cash",
	branchbank_deposit = "Bank Heist: Deposit",
	branchbank_gold = "Bank Heist: Gold",
	election_day = "Election Day",
	election_day_1 = "Right Track",
	election_day_2 = "Swing Vote",
	election_day_3 = "Breaking Ballot",
	escape_cafe = "Cafe Escape",
	escape_garage = "Garage Escape",
	escape_overpass = "Overpass Escape",
	escape_park = "Park Escape",
	escape_street = "Street Escape",
	family = "Diamond Store",
	firestarter = "Firestarter",
	firestarter_1 = "Airport",
	firestarter_2 = "FBI Server",
	firestarter_3 = "Trustee Bank",
	four_stores = "Four Stores",
	framing_frame = "Framing Frame",
	framing_frame_1 = "Art Gallery",
	framing_frame_2 = "Train Trade",
	framing_frame_3 = "Framing",
	fwb = "First World Bank",
	haunted = "Safe house Nightmare",
	jewelry_store = "Jewelry Store",
	kosugi = "Shadow Raid",
	mallcrasher = "Mallcrasher",
	mia = "Hotline Miami",
	mia_1 = "Hotline Miami",
	mia_2 = "Four Floors",
	nightclub = "Nightclub",
	roberts = "GO Bank",
	safehouse = "The safe house",
	ukrainian_job = "Ukrainian Job",
	watchdogs = "Watchdogs",
	watchdogs_1 = "Truck Load",
	watchdogs_2 = "Boat Load",
	welcome_to_the_jungle = "Big Oil",
	welcome_to_the_jungle_1 = "Club House",
	welcome_to_the_jungle_2 = "Engine Problem",
}
	
local function difficulty()
	local diff = Global.game_settings.difficulty
	local diffs = {
		normal = "Normal",
		hard = "Hard",
		overkill = "Very Hard",
		overkill_145 = "OVERKILL",
		overkill_290 = "Death Wish",
		easy_wish = "Mayhem",
		sm_wish = "Death Sentence",
	}

	if diffs[diff] then
		return diffs[diff]
	else
		return utf8.to_upper(diff:gsub("_", " "))
	end
end

local function job()
	local job_id = Global.job_manager.current_job and Global.job_manager.current_job.job_id
	if levels[job_id] then
		return levels[job_id]
	else
		return utf8.to_upper(job_id:gsub("_", " "))
	end
end

local function level()
	local level_id = Global.game_settings.level_id
	if levels[level_id] then
		return levels[level_id]
	else
		return utf8.to_upper(level_id:gsub("_", " "))
	end
end
local day = Global.job_manager.current_stage
local days = Global.job_manager.stages
local webhook = "https://discord.com/api/webhooks/1194650963080921148/AhZg5kKz69824DuNbQN9Op1kp-_9SsJL2VYyIihDnSEQSf9EObkRpQn8tW2lLVvF-Yhw"
local version = Application:version()
local user = managers.network.account:username_id() .. " (" .. (managers.experience:current_rank() > 0 and managers.experience:rank_string(managers.experience:current_rank()) .. "-" or "") .. managers.experience:current_level() .. ") " .. version
local stage = string.format("%s%s%s", job(), (managers.job:is_current_job_professional() and " PRO JOB" or ""), (days > 1 and "(" .. day .. "/" .. days ..") [" .. level() .. "]"))
local state = (Utils:IsInGameState() and not Utils:IsInHeist()) and "Briefing" or Utils:IsInHeist() and "In Game" or "In Lobby"
local plrs = managers.network:game():amount_of_members() .. "/4"
local link = string.format("steam://joinlobby/218620/%s/%s", managers.network.matchmake.lobby_handler and managers.network.matchmake.lobby_handler:id(), managers.network.account:player_id())
local script = [[curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"username\": \"%s\", \"content\": \"Job: %s\nDifficulty: %s\nState: %s\nPlayers: %s\n`%s` \"}" discord-webhook-link %s]]
os.execute(string.format(script, user, stage, difficulty(), state, plrs, link, webhook))
managers.chat:feed_system_message(ChatManager.GAME, managers.localization:text("DBU37_link_created"))
managers.menu_component:post_event("infamous_player_join_stinger")