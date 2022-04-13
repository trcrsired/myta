local Myta_Options = LibStub("AceAddon-3.0"):NewAddon("Myta_Options")

Myta_Options.option_table =
{
	type = "group",
	name = "Myta",
	args = {}
}

Myta_Options.UI = {}
Myta_Options.Module = {}

function Myta_Options : push(key,val)
	self.option_table.args[key] = val
end

function Myta_Options : get_table()
	return self.option_table
end