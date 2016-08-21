local function vehicleAction(name, value)
	return function()
		exports.dpVehicles:toggleVehicleParam(name, value)
	end
end

local doorsLocales = {
	[2] = {"context_menu_vehicle_door_lf_close", "context_menu_vehicle_door_lf_open"},
	[3] = {"context_menu_vehicle_door_rf_close", "context_menu_vehicle_door_rf_open"},
	[4] = {"context_menu_vehicle_door_lb_close", "context_menu_vehicle_door_lb_open"},
	[5] = {"context_menu_vehicle_door_rb_close", "context_menu_vehicle_door_rb_open"},
}

local function getActionString(name, value)
	return function(vehicle)
		if name == "engine" then
			if getVehicleEngineState(vehicle) then
				return exports.dpLang:getString("context_menu_vehicle_engine_off")
			else
				return exports.dpLang:getString("context_menu_vehicle_engine_on")
			end
		elseif name == "handbrake" then
			return exports.dpLang:getString("context_menu_vehicle_handbrake_on")
		elseif name == "lights" then
			if vehicle:getData("LightsState") then
				return exports.dpLang:getString("context_menu_vehicle_lights_off")
			else
				return exports.dpLang:getString("context_menu_vehicle_lights_on")
			end
		elseif name == "door" and type(value) == "number" then
			if vehicle:getDoorOpenRatio(value) > 0.5 then
				return exports.dpLang:getString(doorsLocales[value][1])
			else
				return exports.dpLang:getString(doorsLocales[value][2])
			end
		end
	end
end

local myVehicleMenu = {
	{ getText = getActionString("engine"), 		click = vehicleAction("engine")},
	{ getText = getActionString("handbrake"), 	click = vehicleAction("handbrake"), enabled = false},
	{ getText = getActionString("lights"), 		click = vehicleAction("lights")}, 
	{ getText = getActionString("door", 2), 	click = vehicleAction("door", 2)},
	{ getText = getActionString("door", 3), 	click = vehicleAction("door", 3)},
	{ getText = getActionString("door", 4),
		-- Проверка наличия двери 
		enabled = function(vehicle) 
			return vehicle:getComponentVisible("door_lb_dummy")
		end,

		click = vehicleAction("door", 4)
	},
	{ getText = getActionString("door", 5),
		-- Проверка наличия двери 
		enabled = function(vehicle) 
			return vehicle:getComponentVisible("door_rb_dummy")
		end,

		click = vehicleAction("door", 5)
	},	
}

local vehicleMenu = {
	title = "Автомобиль",
	items = {}
}

function vehicleMenu:init(vehicle)
	if not vehicle.controller then
		return false
	end

	if vehicle.controller == localPlayer then
		self.items = myVehicleMenu
		self.title = exports.dpLang:getString("context_menu_title_car")
	else
		self.items = getContextMenu("player").items
		self.title = string.format("%s %s", 
			exports.dpLang:getString("context_menu_title_player"),
			tostring(player.name))
	end
end

registerContextMenu("vehicle", vehicleMenu)