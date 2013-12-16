class Query
    def self.init
        @sock = UDPSocket.new
        @sock.connect(@addr,@port)
        @val = {}
        @buff = nil
        key
    end
    
    def self.key
        begin
            timeout(1) do
                start = @sock.send("\xFE\xFD\x09\x01\x02\x03\x04".force_encoding(Encoding::ASCII_8BIT), 0)
                t = @sock.recvfrom(1460)[0]
                key = t[5...-1].to_i
                @key = Array(key).pack('N')
            end
        rescue Timeout::Error, Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            return "Host unreachable, check your configuration and try again"
            return "An Exception occured, please check last message"
        rescue StandardError => e
            return "An other error occured. Check your ruby installation and tell the tech monkey this:"
            return e
        end
    end
    
    def self.simpleQuery(addr = 'localhost', port = 25565)
        @addr = addr
        @port = port
        init 
        begin
            timeout(1) do
                query = @sock.send("\xFE\xFD\x00\x01\x02\x03\x04".force_encoding(Encoding::ASCII_8BIT) + @key.to_s, 0)
                data = @sock.recvfrom(1460)[0]
                buffer = data[5...-1]
                @val[:motd], @val[:gametype], @val[:map], @val[:numplayers], @val[:maxplayers], @buf = buffer.split("\x00", 6)
                if @sock != nil
                    @sock.close
                end
            end
        return @val
        rescue StandardError => e
            return e
        end
    end
    
    def self.fullQuery(addr = 'localhost', port = 25565)
        @addr = addr
        @port = port
        init
        begin
            timeout(1) do
                query = @sock.send("\xFE\xFD\x00\x01\x02\x03\x04".force_encoding(Encoding::ASCII_8BIT) + @key.to_s + "\x01\x02\x03\x04".force_encoding(Encoding::ASCII_8BIT), 0)
                data = @sock.recvfrom(1460)[0]
                buffer = data[11...-1]
                items, players = buffer.split("\x00\x00\x01player_\x00\x00".force_encoding(Encoding::ASCII_8BIT))
                if items[0...8] == 'hostname'
                    items = 'motd' + items[8...-1]
                end
                vals = {}
                items = items.split("\x00")
                items.each_with_index do |key, idx|
                    next unless idx % 2 == 0
                    vals[key] = items[idx + 1]
                end
                
                vals["motd"] = vals["hostname"]
                vals.delete("hostname")
                vals.delete("um") if vals["um"]
                
                players = players[0..-2] if players
                if players
                    vals[:players] = players.split("\x00")
                end
                puts vals
                vals["raw_plugins"] = vals["plugins"]
                parts = vals["raw_plugins"].split(":")
                server = parts[0].strip() if parts[0]
                plugins = []
                if parts.size == 2
                    plugins = parts[1].split(";").map {|value| value.strip() }
                end
                vals["plugins"] = plugins
                vals["server"] = server
                vals["timestamp"] = Time.now
                return vals.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
            end
        rescue StandardError => e
            return "An other error occured. Check your minecraft config and tell the tech monkey this:"
            raise e
        end
    end
end
