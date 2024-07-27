# powervoodoo
powershell reverse shell (windows/linux)
### about :
powervoodoo is (windows/linux) reverse shell payload generator and handler that abuses the builtin stuffs in powershell to get reverse shell on ( windows , linux ) machines, it uses a oneliner stager to stage the payload .
### powervoodoo  features : 
- host the stage on a python simple http.server
- provides a simple oneliner stager to stage the payload


### installation :
clone the github repo :
`git clone https://github.com/o-sec/powervoodoo.git `
### usage :
```
usage :
 powervoodoo.sh <LHOST> <LPORT> <TARGET-OS>
e.g : 
 powervoodoo.sh 192.168.1.23 4444 windows
 powervoodoo.sh 192.168.1.23 4444 linux
```

### screenshot :

<img src='https://raw.githubusercontent.com/o-sec/powervoodoo/main/powervoodoo_screenshot.png' />

### disclaimer :
i am not responsable for whatever you do with this tool !
