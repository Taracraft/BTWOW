local addon = LibStub("AceAddon-3.0"):GetAddon("RCLootCouncil_Classic")
local RCVotingFrame = addon:GetModule("RCVotingFrame")
local RCVFP = addon:NewModule("RCVFP", "AceComm-3.0", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceSerializer-3.0")

local session = 1
local table = table

function RCVFP:OnInitialize()
	if not RCVotingFrame.scrollCols then -- RCVotingFrame hasn't been initialized.
		return self:ScheduleTimer("OnInitialize", 0.5)
	end
    self:UpdateColumns()
	self.initialize = true
end

function RCVFP:GetScrollColIndexFromName(colName)
    for i, v in ipairs(RCVotingFrame.scrollCols) do
        if v.colName == colName then
            return i
        end
    end
end

function RCVFP:UpdateColumns()
    local plusonebis =
    { name = "+BIS", DoCellUpdate = self.SetCellPlusoneBis, colName = "BIS", sortnext = self:GetScrollColIndexFromName("response"), width = 30, align = "CENTER", defaultsort = "asc" }
	table.insert(RCVotingFrame.scrollCols, plusonebis)

    local plusoneupgrade =
    { name = "+UPGRADE", DoCellUpdate = self.SetCellPlusoneUpgrade, colName = "UPGRADE", sortnext = self:GetScrollColIndexFromName("BIS"), width = 60, align = "CENTER", defaultsort = "asc" }
	table.insert(RCVotingFrame.scrollCols, plusoneupgrade)

	local plusoneZweitspec =
    { name = "+Zweitspec", DoCellUpdate = self.SetCellPlusoneZweitspec, colName = "Zweitspec", sortnext = self:GetScrollColIndexFromName("Upgrade"), width = 60, align = "CENTER", defaultsort = "asc" }
	table.insert(RCVotingFrame.scrollCols, plusoneZweitspec)
	
	table.remove(RCVotingFrame.scrollCols, self:GetScrollColIndexFromName("votes"))
	table.remove(RCVotingFrame.scrollCols, self:GetScrollColIndexFromName("vote"))

    self:ResponseSortNext()

    if RCVotingFrame:GetFrame() then
        RCVotingFrame:GetFrame().UpdateSt()
    end
end

function RCVFP:ResponseSortNext()
    local responseIdx = self:GetScrollColIndexFromName("response")
    local bisIdx = self:GetScrollColIndexFromName("BIS")
    if responseIdx then
        RCVotingFrame.scrollCols[responseIdx].sortnext = bisIdx
    end
end

function RCVFP.SetCellPlusoneBIS(rowFrame, frame, data, cols, row, realrow, column, fShow, table, ...)
	local name = data[realrow].name
	local lootTable = RCVotingFrame:GetLootTable()
	local countLoot = 0
	for nameLootReceiver, a in pairs(RCLootCouncil.lootDB.factionrealm) do
		if nameLootReceiver==name then
			for i,v in ipairs(a) do
				if v.date==date("%d/%m/%y") then
					testVar = v
					for k, t in pairs(v) do
						if k=="response" and string.find(string.lower(t), "bis") then
							countLoot=countLoot+1
						end
					end
				end
			end
		end
	end
	
	frame.text:SetText(countLoot)
	data[realrow].cols[column].value = lootTable[session].candidates[name].plusone or 0
end

function RCVFP.SetCellPlusoneUPGRADE(rowFrame, frame, data, cols, row, realrow, column, fShow, table, ...)
	local name = data[realrow].name
	local lootTable = RCVotingFrame:GetLootTable()
	local countLoot = 0
	for nameLootReceiver, a in pairs(RCLootCouncil.lootDB.factionrealm) do
		if nameLootReceiver==name then
			for i,v in ipairs(a) do
				if v.date==date("%d/%m/%y") then
					testVar = v
					for k, t in pairs(v) do
						if k=="response" and string.find(string.lower(t), "upgrade") then
							countLoot=countLoot+1
						end
					end
				end
			end
		end
	end
	
	frame.text:SetText(countLoot)
	data[realrow].cols[column].value = lootTable[session].candidates[name].plusone or 0
end

function RCVFP.SetCellPlusoneZweitspec(rowFrame, frame, data, cols, row, realrow, column, fShow, table, ...)
	local name = data[realrow].name
	local lootTable = RCVotingFrame:GetLootTable()
	local countLoot = 0
	for nameLootReceiver, a in pairs(RCLootCouncil.lootDB.factionrealm) do
		if nameLootReceiver==name then
			for i,v in ipairs(a) do
				if v.date==date("%d/%m/%y") then
					testVar = v
					for k, t in pairs(v) do
						if k=="response" and string.find(string.lower(t), "zweitspec") then
							countLoot=countLoot+1
						end
					end
				end
			end
		end
	end
	
	frame.text:SetText(countLoot)
	data[realrow].cols[column].value = lootTable[session].candidates[name].plusone or 0
end
