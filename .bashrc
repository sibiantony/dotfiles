# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

export EDITOR=vim

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=


resizeall() {
        if [[ $# -eq 1 ]]; then
                dir=$1
        else
                echo "Usage : resizeall <directory>"
		return
	fi
	
	cd $dir
	for file in *; 
	do 
		echo $file; 
		convert -resize 30% $file scaled_$file; 
	done
	cd -
}


search() {
	if [[ $# -lt 1 ]]; then
		echo "Usage search <string>";
		return 1
	fi
	
	find . -exec grep -i "$@" {} \; -print 2>/dev/null
}

javasearch() {
	if [[ $# -lt 1 ]]; then
		echo "Usage search <string>";
		return 1
	fi
	
	find . -name "*.java" -exec grep -i "$@" {} \; -print 2>/dev/null
}

cert() {
	[[ $# -lt 1 ]] && echo "Usage cert <cert-file-or-string>" && return 1
	[[ -f $1 ]] && openssl x509 -in $1 -noout -text && return 0
	echo "$1" | sed 's/ //g' | base64 -d | openssl x509 -noout -text -in - -inform DER
}

archive() {
        # Usage: archive.sh ./directory
        [[ $# -lt 1 ]] && echo "Usage $0 <directory>" && return 1

        SOURCE=$( realpath --relative-to=${PWD} $1 )
        ARCHIVE_BASE=$( basename $SOURCE )
        ARCHIVE=${ARCHIVE_BASE}.tar.xz
        ARCHIVE_METADATA=${ARCHIVE}_metadata.txt
        [[ ! -d $SOURCE ]] && echo "Directory $SOURCE doesn't exist!" && return 1
        [[ -f $ARCHIVE ]] && echo "There exists archive file $ARCHIVE" && return 1

        echo "* Create tar archive with xz"
        SOURCE_SIZE=$(du -sk "${SOURCE}" | cut -f1)
        tar -cf - "${SOURCE}" | pv -s "${SOURCE_SIZE}k" | xz -6 --threads=6 -c - >$ARCHIVE
        echo "* Record sha256 checksum"
        echo -e "sha256sum : `sha256sum $ARCHIVE` \n\n" >${ARCHIVE_METADATA}
        echo "* Record filenames and timestamps"
        tar -tvf ${ARCHIVE} >>${ARCHIVE_METADATA}
        echo "* Written : $ARCHIVE $ARCHIVE_METADATA"
}

powerscale() {
	SCALING_GOVERNOR=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
	[[ $SCALING_GOVERNOR = "powersave" ]] && echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor >/dev/null
	[[ $SCALING_GOVERNOR = "performance" ]] && echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor >/dev/null
	echo `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
}

screenshot() {
	[[ $1 == ?(-)+([:digit:]) ]] && SLEEP=$1 || SLEEP=3
	sleep $SLEEP
	import -window root ~/Pictures/Screenshot-`date +'%Y-%m-%d-%H-%M-%S'`.png
}

genpasswd() {
	local l=$1
       	[ "$l" == "" ] && l=24
      	tr -dc "A-Za-z0-9_@%+-,[]=?./" < /dev/urandom | head -c ${l} | xargs
}

gain() {
	[[ $# -lt 2 ]] && echo "Usage ${FUNCNAME[0]} <num1> <num2>" && return 1
	if [[ "$1" =~  ^[0-9]+(\.[0-9]+)?$ ]] && [[ "$2" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
		echo "scale=2; ($2-$1)*100/$1" | bc
	else
		echo "Invalid number[s]."
		return 1
	fi
}

scan_epson_630() {
	[[ $# -lt 1 ]] && echo "Usage $0 <file-name>" && return 1
	scanimage --device "airscan:e0:EPSON XP-630 Series" --format=png --output-file $1 --progress
}

. "$HOME/.acme.sh/acme.sh.env"
alias audacity='audacity 2>/dev/null '
alias se='search'
alias jse='javasearch'
alias clip='xclip -sel clip'
alias bc='bc -l'
alias scan='scan_epson_630'

# Undocumented feature which sets the size to "unlimited".
export HISTFILESIZE=
export HISTSIZE=
export PATH=$GOPATH/bin:/usr/local/go/bin:/usr/loca/gradle/bin/:$HOME/.cargo/bin:$PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export BC_ENV_ARGS=$HOME/.bc

