minecraft-query
===============

Official version 1 of the old forked rubygem, completely redone/refactored.

### Usage

To simply get basic information about the server just `require 'minecraft-query'` and 

`query = Query::simpleQuery('server.ip.here', 25565)`

which will return 

`=> {:motd=>"ECS Survival", :gametype=>"SMP", :map=>"world", :numplayers=>"1", :maxplayers=>"20"}`

The 25565 needs to be set to whatever the port you have set for query in server.properties

To get a full list of information, the syntax is 

`query = Query::fullQuery('server.ip.here', 25565)`

You can also do fun things such as 

`players = query[:numplayers] + '/' + query[:maxplayers]`

to get a nice `=> 1/20` which can easily be handled on a website. 


#### RCON

The Remote CONtrol part of the gem is implemented, but still being developed. If you want to know
syntax, have a look at the source (lib/rcon.rb) for now until I get around to documenting it