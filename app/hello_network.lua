require "cord" 

local svc_manifest = {id="ApplesandBananas"}
local msg = storm.mp.pack(svc_manifest)
	storm.os.invokePeriodically(5*storm.os.SECOND, function()
	storm.net.sendto(a_socket, msg, "ff02::1", 1525)
end)

cord.enter_loop()
