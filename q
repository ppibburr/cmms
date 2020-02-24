
[1mFrom:[0m /home/i3/git/cmms/tool.rb @ line 174 :

    [1;34m169[0m: [32mdef[0m [1;34mpush[0m title, msg, [35micon[0m: [1;36mnil[0m
    [1;34m170[0m:   http [33m:post[0m, [31m[1;31m"[0m[31mpush[1;31m"[0m[31m[0m, [35mdata[0m: {[35mtitle[0m: title, [35mmessage[0m: msg, [35micon[0m: icon}
    [1;34m171[0m: [32mend[0m
    [1;34m172[0m: 
    [1;34m173[0m: [32mif[0m [1;36mARGV[0m[[1;34m0[0m]
 => [1;34m174[0m:   binding.pry
    [1;34m175[0m: [32melse[0m
    [1;34m176[0m:   [1;34m#send(JSON.parse(gets))[0m
    [1;34m177[0m: [32mend[0m
    [1;34m178[0m: 
    [1;34m179[0m: 

