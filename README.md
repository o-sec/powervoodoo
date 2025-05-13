# powervoodoo
Windows/Linux reverse shell made easy

### About:
**powervoodoo** is a powerful payload generation and staging tool designed for red teamers and CTF enthusiasts. It simplifies and automates the process of creating reverse shell payloads, staging them, and handling connections from compromised targets.


### Features:
-  Generates OS-specific reverse shell payloads (supports **Windows** and **Linux**)
-  Generates payloads (basic/advanced/more advanced) with code names (bare/shade/specter) for windows , (basic/ghost) for linux
-  Generates multiple stagers for all payloads
-  Automatically obfuscate the payloads to evade basic detection
-  Generates a variety of oneliner stagers to deliver the payloads effectively
-  Launch an HTTP server to host payloads for download on the target machine
-  Open a Netcat listener to catch incoming reverse shell connections
-  Change themes by commenting/uncommenting a line in the top source code

### Prerequisites:
install the needed packages:
```text
nc
python3
iconv
rlwrap
```
### Installation:
 clone the github repo :
`git clone https://github.com/o-sec/powervoodoo.git `

### Themes:
the tool supports 3 different command line themes (`GREEN_AND_WHITE`, `YELLOW_AND_WHITE`, and `PURPLE_AND_WHITE`) , you can change between them by commenting/uncommenting it's representative line in the top of source code.

### Screenshots:
**purple**
<img src='https://raw.githubusercontent.com/o-sec/powervoodoo/main/purple.png' />
**green**
<img src='https://raw.githubusercontent.com/o-sec/powervoodoo/main/green.png' />
**yellow**
<img src='https://raw.githubusercontent.com/o-sec/powervoodoo/main/yellow.png' />

### Conclusion: 
This tool is incredibly useful for penetration testers, red teamers, and CTF players who want to rapidly deploy reverse shells with minimal setup. It takes care of the heavy lifting so you can focus on post-exploitation.

### Disclaimer:
This tool is intended for good purposes. The creator does not condone or support any illegal or unethical use of this tool. Users are responsible for ensuring that their use complies with all applicable laws and regulations.
