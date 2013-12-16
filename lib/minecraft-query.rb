module MinecraftQuery
  require 'socket'
  require 'timeout'
  
  require 'query/query'
  # require 'rcon/rcon'
  
  #
  # Connects to a Minecraft server's RCON or Query port to send commands or fetch data.
  #
  # Example:
  #   >> rcon = RCON::Minecraft.new('localhost', 25575)
  #   => #<RCON::Minecraft:0x007ff6e29e1228 @host="localhost", @port=25575, @socket=nil, @packet=nil, @authed=false, @return_packets=false>
  #   >> rcon.auth('password')
  #   => true
  #   >> rcon.command('say hi')
  #   => "\xA7d[Server] hi\n"
  #
  #   >> query = Query::simpleQuery('localhost', 25565)
  #   => {:motd=>"ECS Survival", :gametype=>"SMP", :map=>"world", :numplayers=>"1", :maxplayers=>"20"}
  #   >> players = query[:numplayers] + '/' + query[:maxplayers]
  #   => 1/20
  #
  
end