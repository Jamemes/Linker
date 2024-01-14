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

local function job()
	local job_data = managers.job:current_job_data() or ""
	local job = levels[job_data] and levels[job_data] or utf8.to_upper(job_data:gsub("_", " "))
	local level_id = Global.game_settings.level_id
	local level = levels[level_id] and levels[level_id] or utf8.to_upper(level_id:gsub("_", " "))
	local prof = managers.job:is_current_job_professional() and " PRO JOB" or ""
	local day = managers.job:current_stage() or 1
	local days = managers.job:current_job_chain_data() or 1
	
	return string.format("%s%s%s", job, prof, tostring(days > 1 and "(" .. day .. "/" .. days ..") [" .. level .. "]" or ""))
end
	
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

local day = Global.job_manager.current_stage or 1
local days = Global.job_manager.stages or 1
local webhook = "https://discord.com/api/webhooks/1194650963080921148/AhZg5kKz69824DuNbQN9Op1kp-_9SsJL2VYyIihDnSEQSf9EObkRpQn8tW2lLVvF-Yhw"
local version = Application:version()
local user = managers.network.account:username_id() .. " (" .. (managers.experience:current_rank() > 0 and managers.experience:rank_string(managers.experience:current_rank()) .. "-" or "") .. managers.experience:current_level() .. ") " .. version
local state = (Utils:IsInGameState() and not Utils:IsInHeist()) and "Briefing" or Utils:IsInHeist() and "In Game" or "In Lobby"
local plrs = managers.network:game():amount_of_members() .. "/4"
local link = string.format("steam://joinlobby/218620/%s/%s", managers.network.matchmake.lobby_handler and managers.network.matchmake.lobby_handler:id(), managers.network.account:player_id())
local script = [[curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"username\": \"%s\", \"content\": \"Job: %s\nDifficulty: %s\nState: %s\nPlayers: %s\n`%s` \"}" discord-webhook-link %s]]
os.execute(string.format(script, user, job(), difficulty(), state, plrs, link, webhook))
managers.chat:feed_system_message(ChatManager.GAME, managers.localization:text("DBU37_link_created"))
managers.menu_component:post_event("infamous_player_join_stinger")