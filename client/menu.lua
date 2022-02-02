local tabs = {
	modes = textModes,
}

local controlWidth = 0.3

local vein = exports.vein
local menu

RegisterCommand('btMenu', function(source, args, rawCommand)
	if menu then
		menu = false
		return
	end
	menu = rawCommand
	local tab = 'modes'
	local page = 1
	local entries = tabs[tab]
	local entriesPerPage = 4
	local pages = math.ceil(#entries / entriesPerPage)
	local firstEntry
	local lastEntry

	local windowX
	local windowY

	while menu == rawCommand do
		Wait(0)

		firstEntry = page * entriesPerPage - entriesPerPage + 1
		lastEntry = math.min(firstEntry + entriesPerPage - 1, #entries)

		vein:beginWindow(windowX, windowY)

		vein:heading('Brown Thunder Controls')

		vein:beginRow()
			if vein:button('Modes') then
				tab = 'modes'
			end
        vein:endRow()


		for i = firstEntry, lastEntry do
			vein:separator(controlWidth)

			vein:textArea(entries[i].name .. ' - ' .. entries[i].description, controlWidth)

			vein:beginRow()
                if vein:button('Launch') then
                    menu = false
					endMode()
                    TriggerServerEvent('brownThunder:nextRound', i, 1)
                end

                if vein:button('Details') then
                end
        	vein:endRow()
		end

		vein:separator(controlWidth)

		vein:beginRow()
			if vein:button('Close') then
				menu = false
			end

			if vein:button('&lt;') then
				if page > 1 then
					page -= 1
				end
			end

			if vein:button(tostring(page)) then
			end

			if vein:button('>') then
				if page < pages then
					page += 1
				end
			end

			if activeMode then
				if vein:button('End Mode') then
					endMode()
				end
			end
		vein:endRow()
		

		windowX, windowY = vein:endWindow()
	end
end)

RegisterKeyMapping('btMenu', 'Open Menu', 'keyboard', 'i')
