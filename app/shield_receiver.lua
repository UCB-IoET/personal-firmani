require("storm") -- libraries for interfacing with the board and kernel
require("cord") -- scheduler / fiber library
LED = require("led")
blu = LED:new("D2")		-- LEDS on starter shield
grn = LED:new("D3")
red = LED:new("D4")
--red:flash(val)

answersock = storm.net.udpsocket(1526, 
			    function(payload, from, port)
			       
			       print (string.format("echo from %s port %d: %s",from,port,payload))
			    end)
local svc_manifest = {id=”ApplesandBananas2,”
		      setRed1On={ s=“setBool”, desc= “red LED” },
		      setRed2On={ s=“setBool”, desc= “red2 LED” },
		      setGreenOn={ s=“setBool”, desc= “green LED” },
		      setBlueOn={ s=“setBool”, desc= “blue LED” },
}              
local msg = storm.mp.pack(svc_manifest)
storm.os.invokePeriodically(5*storm.os.SECOND, function()
storm.net.sendto(a_socket, msg, “ff02::1”, 1525)
end)

