ColorsScreen = Screen:subclass "ColorsScreen"

function ColorsScreen:init(componentName)
	self.super:init()
	self.componentsSelection = ComponentSelection({
		{name="BodyColor", 		camera="bodyColor", 	locale="garage_tuning_paint_body"},
	})
	local vehicle = GarageCar.getVehicle()
	-- Если на машине установлены диски
	if vehicle:getData("Wheels") and vehicle:getData("Wheels") > 0 then
		self.componentsSelection:addComponent("WheelsColor", "wheelLF", "garage_tuning_paint_wheels")
	end
	-- Если на машине установлен спойлер
	if vehicle:getData("Spoilers") and vehicle:getData("Spoilers") > 0 then
		self.componentsSelection:addComponent("SpoilerColor", "spoiler", "garage_tuning_paint_spoiler")
	end

	if componentName then
		self.componentsSelection:showComponentByName(componentName)
	end
end

function ColorsScreen:draw()
	self.super:draw()
	self.componentsSelection:draw(self.fadeProgress)
end

function ColorsScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.componentsSelection:update(deltaTime)
end

function ColorsScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		self.componentsSelection:showNextComponent()
	elseif key == "arrow_l" then
		self.componentsSelection:showPreviousComponent()
	elseif key == "backspace" then
		self.componentsSelection:stop()
		self.screenManager:showScreen(TuningScreen(2))
		GarageUI.showSaving()
		GarageCar.save()
	elseif key == "enter" then
		self.componentsSelection:stop()
		local componentName = self.componentsSelection:getSelectedComponentName()
		self.screenManager:showScreen(ColorScreen(componentName))
	end
end