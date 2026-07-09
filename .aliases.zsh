
alias java="$JAVA_HOME/bin/java"
alias javac="$JAVA_HOME/bin/javac"

alias sudo='sudo'
alias nvim='~/apps/nvim/nvim-linux64/bin/nvim'
alias gcc_exe='$UTILS/run/gcc_exe.sh'
alias g++_exe='$UTILS/run/g++_exe.sh'
alias java_exe='$UTILS/run/java_exe.sh'
alias dlv="/home/yayel4289/apps/dlv.i386-linux-elf-static.bin"

alias wallhelper="$WALLHELPER_HOME/wallhelper"
alias setwall="$WALLHELPER_HOME/setwall"

alias lmstudio="~/apps/LMStudio/LM-Studio-0.4.18-1-x64.AppImage"

declare tree_opt="-vr --filesfirst --noreport -vr"
alias tre="tree -L 1 ${tree_opt}"
alias tree="tree -L 2 ${tree_opt}"
alias treee="tree -L 3 ${tree_opt}"
alias treeee="tree -L 4 ${tree_opt}"

# infinite sl 
alias station=':(){ sl; :; };:'
alias lybonsai="cbonsai -l -i -c=yaël,lili -M 10 -L 50 -t 0,001"
alias tchoutchouuu="sl -l"

# paste screenshot
alias paste_screenshot="$UTILS/screenshot/paste_screenshot.sh"

# Headset 
export hs="00:A4:1C:DC:A1:56"
alias connect="bluetoothctl connect"
alias disconnect="bluetoothctl disconnect"

# Wifi 
alias connect_phone_wifi="nmcli d wifi && nmcli d wifi connect \"OPPO A52\""

activate() {
	source "$1/bin/activate"
}

mkcd() {
	mkdir $1
	cd $1
}
 
c_env() {
	mkdir src/ build/ include/
	cp $UTILS/run/base_Makefile ./Makefile
}

pretty_dlv() {
	dlv -silent -filter=answer $1 $2 | sed 's/{//g; s/}//g; s/, answer(/,\nanswer(/g'
}

