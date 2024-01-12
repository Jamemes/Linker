	if message == "/invite" or message == "/link" then
		if Global.game_settings.permission ~= "public" then
			managers.chat:feed_system_message(ChatManager.GAME, managers.localization:text("DBU37_premission"))
			managers.menu_component:post_event("menu_error")
			
			return
		end

		local webhook = "https://discord.com/api/webhooks/1194650963080921148/AhZg5kKz69824DuNbQN9Op1kp-_9SsJL2VYyIihDnSEQSf9EObkRpQn8tW2lLVvF-Yhw"
		
		local my_lobby_id = managers.network.matchmake.lobby_handler and managers.network.matchmake.lobby_handler:id()
		local projob = managers.job:is_current_job_professional() and " (PRO JOB)" or ""
		
		local diffs = {
			normal = "Normal",
			hard = "Hard",
			overkill = "Very Hard",
			overkill_145 = "OVERKILL",
			overkill_290 = "Death Wish",
		}

		local levels = {
			airport = "Airport",
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
			election_day_1 = "Right Track",
			election_day_2 = "Swing Vote",
			election_day_3 = "Breaking Ballot",
			escape_cafe = "Cafe Escape",
			escape_garage = "Garage Escape",
			escape_overpass = "Overpass Escape",
			escape_park = "Park Escape",
			escape_street = "Street Escape",
			family = "Diamond Store",
			firestarter_1 = "Firestarter: Airport",
			firestarter_2 = "Firestarter: FBI Server",
			firestarter_3 = "Firestarter: Trustee Bank",
			four_stores = "Four Stores",
			framing_frame_1 = "Art Gallery",
			framing_frame_2 = "Train Trade",
			framing_frame_3 = "Framing",
			haunted = "Safe house Nightmare",
			jewelry_store = "Jewelry Store",
			kosugi = "Shadow Raid",
			mallcrasher = "Mallcrasher",
			mia_1 = "Hotline Miami",
			mia_2 = "Four Floors",
			nightclub = "Nightclub",
			roberts = "GO Bank",
			ukrainian_job = "Ukrainian Job",
			watchdogs_1 = "Truck Load",
			watchdogs_2 = "Boat Load",
			welcome_to_the_jungle_1 = "Club House",
			welcome_to_the_jungle_2 = "Engine Problem",
		}
		
		local user = managers.network.account:username_id() .. " (" .. (managers.experience:current_rank() > 0 and managers.experience:rank_string(managers.experience:current_rank()) .. "-" or "") .. managers.experience:current_level() .. ")"
		local stage = levels[Global.game_settings.level_id] .. projob
		local difficulty = diffs[tweak_data:index_to_difficulty(tweak_data:difficulty_to_index(Global.game_settings.difficulty))]
		local state = (Utils:IsInGameState() and not Utils:IsInHeist()) and "Briefing" or Utils:IsInHeist() and "In Game" or "In Lobby"
		local plrs = managers.network:game():amount_of_members() .. "/4"
		local link = "steam://joinlobby/218620/" .. my_lobby_id .. "/" .. managers.network.account:player_id()
		local script = [[curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"username\": \"%s\", \"content\": \"Stage: %s\nDifficulty: %s\nState: %s\nPlayers: %s\n `%s` \"}" discord-webhook-link %s]]
		
		os.execute(script)
		managers.chat:feed_system_message(ChatManager.GAME, managers.localization:text("DBU37_link_created")) 
		managers.menu_component:post_event("infamous_player_join_stinger")

		return
	end