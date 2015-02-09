require "cord" 

services_heard = {}

-- create echo server as handler
server = function()
   sock = storm.net.udpsocket(1525, 
			      function(payload, from, port)
				 		-- print (string.format("from %s port %d",from, port))
				 		local msg = storm.mp.unpack(payload)
				 		id = msg.id

				 		if id then
					 		-- print("id", msg.id)
					 		if services_heard[id] then -- already seen
					 			services_heard[id] = msg
					 		else
					 			table.insert(services_heard, msg)
					 		end
					 	end
			      end)

   -- BROADCAST
   local svc_manifest = { 
		id="ApplesandBananas",
		setRlyA={ s="setBool", desc= "red LED" },
		setRlyB={ s="setBool", desc= "green LED" },
		setRlyC={ s="setBool", desc= "blue LED" },
		getTime={ s="", desc="get my time"}
   }
	local msg = storm.mp.pack(svc_manifest)
	storm.os.invokePeriodically(5 * storm.os.SECOND, function()
			storm.net.sendto(sock, msg, "ff02::1", 1525)
	end)
end

server()


storm.os.invokePeriodically(5 * storm.os.SECOND, function()
	print("\nCURRENT SERVICES HEARD")
	for k, v in pairs(services_heard) do
		for i, j in pairs(v) do
			print("\t", i .. ":",j,"\n")
		end
	end
	print("\n------------------------")
end)

cord.enter_loop()
