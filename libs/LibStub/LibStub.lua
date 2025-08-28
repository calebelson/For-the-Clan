-- LibStub is a simple versioning stub meant for use in libraries.  www.wowace.com
-- This version is a cut-down version of the full LibStub library for minimal footprint.

local LIBSTUB_MAJOR, LIBSTUB_MINOR = "LibStub", 2
local LibStub = _G[LIBSTUB_MAJOR]

if not LibStub or LibStub.minor < LIBSTUB_MINOR then
    LibStub = LibStub or {}
    _G[LIBSTUB_MAJOR] = LibStub
    LibStub.minor = LIBSTUB_MINOR
    
    LibStub.libs = LibStub.libs or {}
    LibStub.minors = LibStub.minors or {}
    
    function LibStub:NewLibrary(major, minor)
        assert(type(major) == "string", "Bad argument #2 to `NewLibrary' (string expected)")
        minor = assert(tonumber(strmatch(minor, "%d+") or minor), "Minor version must be a number")
        
        if self.minors[major] and self.minors[major] >= minor then return nil end
        self.minors[major], self.libs[major] = minor, self.libs[major] or {}
        return self.libs[major]
    end
    
    function LibStub:GetLibrary(major, silent)
        if not self.libs[major] and not silent then
            error(("Cannot find a library instance of %q."):format(tostring(major)), 2)
        end
        return self.libs[major], self.minors[major]
    end
    
    function LibStub:IterateLibraries() return pairs(self.libs) end
    
    setmetatable(LibStub, { __call = LibStub.GetLibrary })
end
