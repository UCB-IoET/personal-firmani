require "cord" 

services_heard = {}

-- create echo server as handler
server = function()
   sock = storm.net.udpsocket(1525, 
			      function(payload, from, port)
				 		print (string.format("from %s port %d",from, port))
				 		local msg = storm.mp.unpack(payload)
				 		id = msg.id

				 		if id then
					 		print("id", msg.id)
					 		if services_heard[id] then -- already seen
					 			services_heard[id] = msg
					 		else
					 			table.insert(services_heard, msg)
					 		end

					 		table.insert(services_heard, msg)
					 		for service, v in pairs(msg) do 
					 			print(service)
					 				for k, value in pairs(v) do
					 					print("\t", k, ":",value)
					 				end
					 		end
					 	end
			      end)

   -- BROADCAST
   local svc_manifest = {id="ApplesandBananas"}
	local msg = storm.mp.pack(svc_manifest)
	storm.os.invokePeriodically(5 * storm.os.SECOND, function()
			storm.net.sendto(sock, msg, "ff02::1", 1525)
	end)
end

server()
storm.os.invokePeriodically(5 * storm.os.SECOND, function()
	print("\nCURRENT SERVICES HEARD")
	for k, v in pairs(services_heard) do
		print(k, "\n")
		for i, j in pairs(v) do
			print(i .. ":" .. j .. "\n")
		end
	end
	print("\n------------------------")
end)

cord.enter_loop()
