local tabs = {
	modes = textModes,
}

local width = 0.3
local vein = exports.vein
local menu = false
local page, pages, entries, entriesPerPage
local firstEntry, lastEntry
local heading = 'Brown Thunder Menu'

tabs.modes.display = function(entry, i)
	vein:separator(width)

	vein:label(entry.name .. ' - ' .. entry.getTargets)

	vein:textArea(entry.description, width)
	
	vein:beginRow()
		if vein:button('Launch') then
			menu = not menu
			endMode()
			TriggerServerEvent('brownThunder:nextRound', i, 1)
		end

		if vein:button('Details') then
		end
	vein:endRow()
end

RegisterCommand('btMenu', function(source, args, rawCommand)
	menu = not menu

	local windowX, windowY

	while menu do
		Wait(0)

		vein:beginWindow(windowX, windowY)

		vein:heading(heading)

		vein:beginRow()
			if vein:button('Modes') then
				entries = tabs.modes
				entriesPerPage = 4
				pages = math.ceil(#entries / entriesPerPage)
				page = 1
				heading = 'Brown Thunder Menu'
			end
        vein:endRow()

		if entries then
			firstEntry = page * entriesPerPage - entriesPerPage + 1
			lastEntry = math.min(firstEntry + entriesPerPage - 1, #entries)

			for i = firstEntry, lastEntry do
				entries.display(entries[i], i)
			end

			vein:separator(width)

			vein:beginRow()
				if vein:button('Close') then
					menu = false
				end

				if vein:button('&lt;') then
					if page > 1 then
						page -= 1
					end
				end

				if vein:button(page .. ' of ' .. pages) then
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
		end

		windowX, windowY = vein:endWindow()
	end
end)

RegisterKeyMapping('btMenu', 'Open Menu', 'keyboard', 'i')
