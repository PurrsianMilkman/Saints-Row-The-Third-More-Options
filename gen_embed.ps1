# Generates src\lua_embed.h (the Lua script as a C++ raw string) so the ASI can carry it. Run by build.bat.
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$lua = [IO.File]::ReadAllText("$here\lua\moreoptions.lua")
if ($lua.Contains(')LUA"')) { throw 'lua contains the raw string terminator' }
[IO.File]::WriteAllText("$here\src\lua_embed.h", 'static const char kLua[] = R"LUA(' + $lua + ')LUA";' + "`r`n")
