#!/usr/bin/env bash

# Starts a scan of available broadcasting SSIDs
# nmcli dev wifi rescan

# Config for rofi-wifi-menu

# position values:
# 1 2 3
# 8 0 4
# 7 6 5
POSITION=3

#y-offset
YOFF=17

#x-offset
XOFF=0

#fields to be displayed
FIELDS=SSID,SECURITY,BARS


# Fills PROFILES and ESSIDS with the profile names and essids of the profiles
# for interface $1.
init_profiles() {
    local i=0 essid profile
    while IFS= read -r profile; do
        essid=$(
            unset INTERFACE ESSID
            source "$PROFILE_DIR/$profile" > /dev/null
            if [[ "$Interface" = "$1" && -n "$ESSID" ]]; then
                printf "%s" "$ESSID"
                if [[ "$Description" =~ "Automatically generated" ]]; then
                    return 2
                else
                    return 1
                fi
            fi
            return 0
        )
        case $? in
            2)
                GENERATED+=("$profile")
                ;&
            1)
                PROFILES[i]=$profile
                ESSIDS[i]=$essid
                (( ++i ))
                ;;
        esac
    done < <(list_profiles)
}

# Builds ENTRIES as an argument list for dialog based on scan results in $1.
init_entries() {
    local i=0 sep=$'\t' flags signal ssid
    while IFS=$'\t' read -r signal flags ssid; do
        ENTRIES[i++]="--"  # $ssid might look like an option to dialog.
        ENTRIES[i++]=$ssid
        if in_array "$ssid" "${ESSIDS[@]}"; then
            if in_array "$(ssid_to_profile "$ssid")" "${GENERATED[@]}"; then
                ENTRIES[i]="."  # Automatically generated
            else
                ENTRIES[i]=":"  # Handmade
            fi
        else
            ENTRIES[i]=" "  # Not present
        fi
        if is_yes "${CONNECTED:-no}" && [[ "$ssid" = "$CONNECTION" ]]; then
            ENTRIES[i]="*"  # Currently connected
        fi
        if [[ "$flags" =~ WPA2|WPA|WEP ]]; then
            ENTRIES[i]+="${sep}${BASH_REMATCH[0],,}"
        else
            ENTRIES[i]+="${sep}none"
        fi
        ENTRIES[i]+="   ${sep}${signal}"
        (( ++i ))
    done < "$1"
}

# Finds a profile name for ssid $1.
ssid_to_profile() {
    local i
    for i in $(seq 0 $((${#ESSIDS[@]}-1))); do
        if [[ "$1" = "${ESSIDS[i]}" ]]; then
            printf "%s" "${PROFILES[i]}"
            return 0
        fi
    done
    return 1
}

init_profiles "$INTERFACE"
init_entries "$NETWORKS"


LIST=$(nmcli --fields "$FIELDS" device wifi list | sed '/^--/d')
# For some reason rofi always approximates character width 2 short... hmmm
RWIDTH=$(($(echo "$LIST" | head -n 1 | awk '{print length($0); }')+2))
# Dynamically change the height of the rofi menu
LINENUM=$(echo "$LIST" | wc -l)
# Gives a list of known connections so we can parse it later
KNOWNCON=$(nmcli connection show)
# Really janky way of telling if there is currently a connection
CONSTATE=$(nmcli -fields WIFI g)

CURRSSID=$(iwgetid -r)

if [[ ! -z $CURRSSID ]]; then
	HIGHLINE=$(echo  "$(echo "$LIST" | awk -F "[  ]{2,}" '{print $1}' | grep -Fxn -m 1 "$CURRSSID" | awk -F ":" '{print $1}') + 1" | bc )
fi

# HOPEFULLY you won't need this as often as I do
# If there are more than 8 SSIDs, the menu will still only have 8 lines
if [ "$LINENUM" -gt 8 ] && [[ "$CONSTATE" =~ "enabled" ]]; then
	LINENUM=8
elif [[ "$CONSTATE" =~ "disabled" ]]; then
	LINENUM=1
fi


if [[ "$CONSTATE" =~ "enabled" ]]; then
	TOGGLE="toggle off"
elif [[ "$CONSTATE" =~ "disabled" ]]; then
	TOGGLE="toggle on"
fi



CHENTRY=$(echo -e "$TOGGLE\nmanual\n$LIST" | uniq -u | rofi -dmenu -p "Wi-Fi SSID: " -lines "$LINENUM" -a "$HIGHLINE" -location "$POSITION" -yoffset "$YOFF" -xoffset "$XOFF" -font "DejaVu Sans Mono 8" -width -"$RWIDTH")
#echo "$CHENTRY"
CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')
#echo "$CHSSID"

# If the user inputs "manual" as their SSID in the start window, it will bring them to this screen
if [ "$CHENTRY" = "manual" ] ; then
	# Manual entry of the SSID and password (if appplicable)
	MSSID=$(echo "enter the SSID of the network (SSID,password)" | rofi -dmenu -p "Manual Entry: " -font "DejaVu Sans Mono 8" -lines 1)
	# Separating the password from the entered string
	MPASS=$(echo "$MSSID" | awk -F "," '{print $2}')

	#echo "$MSSID"
	#echo "$MPASS"

	# If the user entered a manual password, then use the password nmcli command
	if [ "$MPASS" = "" ]; then
		nmcli dev wifi con "$MSSID"
	else
		nmcli dev wifi con "$MSSID" password "$MPASS"
	fi

elif [ "$CHENTRY" = "toggle on" ]; then
	nmcli radio wifi on

elif [ "$CHENTRY" = "toggle off" ]; then
	nmcli radio wifi off

else

	# If the connection is already in use, then this will still be able to get the SSID
	if [ "$CHSSID" = "*" ]; then
		CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
	fi

	# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
	if [[ $(echo "$KNOWNCON" | grep "$CHSSID") = "$CHSSID" ]]; then
		nmcli con up "$CHSSID"
	else
		if [[ "$CHENTRY" =~ "WPA2" ]] || [[ "$CHENTRY" =~ "WEP" ]]; then
			WIFIPASS=$(echo "if connection is stored, hit enter" | rofi -dmenu -p "password: " -lines 1 -font "DejaVu Sans Mono 8" )
		fi
		nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
	fi

fi
