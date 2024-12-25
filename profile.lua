local profile = {};
--This only for x86;
--[[
Usage: 
--Start measuring CPU ticks:
profile.breakpoint();

--Your code or function calls to measure:
MyFunction();

--First arg will used as message before print different between ticks
profile.breakpoint("Optional message: ");

-- Will reset profile
profile.breakpoint.reset();
--]]

local ffi = require("ffi")
--[[
//gcc -shared -fPIC -o librdtsc.so rdtsc.c
#include <stdint.h>
uint64_t rdtsc() {
    uint32_t lo, hi;
    __asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
    return ((uint64_t)hi << 32) | lo;
}
--]]

local success, librdtsc = pcall(ffi.load,"./librdtsc.so")
if not success then
	error("Cannot load ./librdtsc.so: " .. librdtsc);
end

ffi.cdef[[
    typedef uint64_t ticks;
    ticks rdtsc();
]]

function profile:GetCPUCycles()
    return librdtsc.rdtsc()
end

function profile:get_name()
	local info = debug.getinfo(2,"n")
	if info and info.name then
		return(info.name);
	end
end

function profile:get_table_name(table)
	for name, pointer in pairs(_G) do
		if pointer == table then
			return name;
		end
	end
end

function profile:get_full_name(table)
	local table_name = self:get_table_name(table);
	local info = debug.getinfo(2,"n")
	local func_name = info.name or "";
	return (table_name or "") .. ":" .. func_name;
end

function profile:convert_ticks_readable(number_str)
	number_str = tostring(number_str);
	local format = number_str:reverse():gsub("(%d%d%d)", "%1 "):reverse();
	return format:match("^%s*(.-)%s*$"):gsub("ULL$", "");
end

local function create_breakpoint_rdtsc() --looks like overlarge struct. Not sure if this right
	local last_ticks = nil;
	local ret = {
		["reset"] = function() last_ticks = nil end;
	}
	setmetatable(ret, { __call =
		function(_, comment)
			local current_ticks = librdtsc.rdtsc()
			if last_ticks then
				if comment ~= nil then
				print(comment .. profile:convert_ticks_readable(current_ticks - last_ticks));
				else
				print("Ticks since last call:" .. profile:convert_ticks_readable(current_ticks - last_ticks));
				end
			end
			last_ticks = current_ticks;
		end
	})
	return ret;
end

profile.breakpoint = create_breakpoint_rdtsc(); --magic of closure

return profile;
