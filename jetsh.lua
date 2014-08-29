--[[
    jetsh.lua - Shared part of jet module.
    Copyright (C) 2014 - Ali Deym (https://github.com/111WARLOCK111/)

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
]]

if SERVER then AddCSLuaFile() end

local jet = {}
jet.__index = jet

--[[ Function: Class, Usage:
	 local obj = class("Objs",
	    function(self, name) self.Name = name end
	 )
	 
	 function obj:Kill()
	     return self.Name
	 end
	 
	 local o = Objs("Hello")
	 print(o:Kill())
]] 
function class(tab, func)
    local tb = {}
	tb.__index = tb
	
    _G[tab] = function(...) 
	    local slf = {}
		setmetatable(slf, tb)
		slf.__index = tb
		func(slf, unpack(...))
		return slf
	end
	
	return tb
end

--[[ Function: Switch case
     Source: http://lua-users.org/wiki/SwitchStatement
     Usage: 
     switch(case) {
         [1] = function () print"number 1!" end,
         [2] = math.sin,
         [false] = function (a) return function (b) return (a or b) and not (a and b) end end,
         Default = function (x) print"Look, Mom, I can differentiate types!" end, -- ["Default"] ;)
         [Default] = print,
         [Nil] = function () print"I must've left it in my other jeans." end,
    }
]]
Default, Nil = {}, function () end -- for uniqueness
function switch (i)
  return setmetatable({ i }, {
    __call = function (t, cases)
      local item = #t == 0 and Nil or t[1]
      return (cases[item] or cases[Default] or Nil)(item)
    end
  })
end

--[[ Function: catch/try
     Source: Christian G. Warden (https://gist.github.com/cwarden)
	 Usage:
try {
   function()
      error('oops')
   end,
 
   catch {
      function(error)
         print('caught error: ' .. error)
      end
   }
}
]]
function catch(what)
   return what[1]
end
 
function try(what)
   status, result = pcall(what[1])
   if not status then
      what[2](result)
   end
   return result
end

--[[ Function: jet checknumber
     Usage:
	 
	 if not j:CheckNumber(256, "byte") then cry() end
]]
function jet:CheckNumber(num, m)
    if not jet.max[m] or not jet.min[m] then error("Invalid number type") return false end
	
	if num > jet.max[m] or number < jet.min[m] then error("Number can not go " .. number > jet.max[m] and "over" or "below" .. " " .. tostring(number > jet.max[m] and jet.max[m] or jet.min[m])) return false end

	return true
end

--[[ Function: jet pack
     Usage:
	 
	 function test(...)
	    local tb = j:pack(...)
		
		for k, v in pairs(tb) do print(v) end
	 end
]]
	
function jet:pack(...)
    return {...}
end
--[[
▒█▀▀▀ ▒█▄░▒█ ▒█░▒█ ▒█▀▄▀█ 
▒█▀▀▀ ▒█▒█▒█ ▒█░▒█ ▒█▒█▒█ 
▒█▄▄▄ ▒█░░▀█ ░▀▄▄▀ ▒█░░▒█ 
]]

jet.max = {
    short = 32767,
	int16 = 32767,
	
	int = 2147483647,
	int32 = 2147483647,
	
	byte = 255
}

jet.min = {
    short = -32768,
	int16 = -32768,
	
	int = -2147483648,
	int32 = 2147483647,
	
	byte = 0
}

--[[
░░░▒█ ▒█▀▀▀ ▀▀█▀▀   ▒█▄░▒█ ▒█▀▀▀ ▀▀█▀▀ 
░▄░▒█ ▒█▀▀▀ ░▒█░░   ▒█▒█▒█ ▒█▀▀▀ ░▒█░░ 
▒█▄▄█ ▒█▄▄▄ ░▒█░░   ▒█░░▀█ ▒█▄▄▄ ░▒█░░ 
]]

local jnet = class("jetnet", function(self) end)

--[[
▒█░░▒█ ▒█▀▀█ ▀█▀ ▀▀█▀▀ ▒█▀▀▀ 
▒█▒█▒█ ▒█▄▄▀ ▒█░ ░▒█░░ ▒█▀▀▀ 
▒█▄▀▄█ ▒█░▒█ ▄█▄ ░▒█░░ ▒█▄▄▄ 
]]

--[[ Common usage: jn:Write%var%(num) ]]

function jnet:WriteInt(int)
    jet:CheckNumber(int, "int")
    net.WriteInt(int, 32)
end

function jnet:WriteShort(int)
    jet:CheckNumber(int, "short")
    net.WriteInt(int, 16)
end

function jnet:WriteByte(bt)
    jet:CheckNumber(int, "byte")
    net.WriteInt(int, 8)
end

--[[ All in one sending ]]
function jnet:Send(tb)
    if SERVER then 
	    if not tb then net.Broadcast() return end
	    net.Send(tb) 
	return end
	
	net.SendToServer()
end

function jnet:Start(name)
    net.Start(name)
end

--[[
▒█▀▀█ ▒█▀▀▀ ░█▀▀█ ▒█▀▀▄ 
▒█▄▄▀ ▒█▀▀▀ ▒█▄▄█ ▒█░▒█ 
▒█░▒█ ▒█▄▄▄ ▒█░▒█ ▒█▄▄▀ 
]]

function jnet:ReadInt()
    return net.ReadInt(32)
end

function jnet:ReadShort()
    return net.ReadInt(16)
end

function jnet:ReadByte()
    return net.ReadInt(8)
end

--[[
▒█▀▀█ ▒█▀▀█ 
▒█░▄▄ ▒█░░░ 
▒█▄▄█ ▒█▄▄█ 
]]
function jet:GC()
    garbagecollector()
end

--[[
▒█░▒█ ░█▀▀█ ▒█▄░▒█ ▒█▀▀▄     ▒█▀▀▀█ ▒█░▒█ ░█▀▀█ ▒█░▄▀ ▒█▀▀▀ 
▒█▀▀█ ▒█▄▄█ ▒█▒█▒█ ▒█░▒█     ░▀▀▀▄▄ ▒█▀▀█ ▒█▄▄█ ▒█▀▄░ ▒█▀▀▀ 
▒█░▒█ ▒█░▒█ ▒█░░▀█ ▒█▄▄▀     ▒█▄▄▄█ ▒█░▒█ ▒█░▒█ ▒█░▒█ ▒█▄▄▄ 
]]

return jet