require "cord" 


-- create echo server as handler
server = function()
   sock = storm.net.udpsocket(1525, 
			      function(payload, from, port)
				 		print (string.format("from %s port %d: %s",from, port, payload))
				 		
				 		local svc_manifest = {id="ApplesandBananas"}
						local msg = storm.mp.pack(svc_manifest)
						storm.os.invokePeriodically(5 * storm.os.SECOND, function()
								storm.net.sendto(sock, msg, "ff02::1", 1525)
						end)
			      end)
end

server()
cord.enter_loop()
