#!/bin/sh
SCRIPT_NAME="OpenTX Voice Sound Pack Generator - Mac OSX";
SCRIPT_VERSION="1.5";
SCRIPT_DATE="2019/01/09";
SCRIPT_AUTHER="Austin St. Aubin";
SCRIPT_AUTHER_CONTACT="AustinSaintAubin@gmail.com"
SCRIPT_DESCRIPTION="Description: Creates phrases with macs osx's built in say command based on cvs file."
SCRIPT_TITLE="$SCRIPT_NAME - v$SCRIPT_VERSION - $SCRIPT_DATE - Written By: $SCRIPT_AUTHER ($SCRIPT_AUTHER_CONTACT) \n   ∟ Description: $SCRIPT_DESCRIPTION"
# -------------------------------------------------------------------------------------------------
#
# Script edited by Dima Tsvetkov to suite better for Finnish translation project.
# Edited: 2019-03-15
# Contact: web@dima.fi or dimamedia@github
#
# -------------------------------------------------------------------------------------------------
# https://drive.google.com/folderview?id=0B5EqCwSC5nqjfnRFbHVSSzVJTEtuaHJacjBOd0lHZWQ3SVpsaFFvMmQtM1pwNXM1RzE0Q0k&usp=sharing
# Link to this Script: https://drive.google.com/file/d/0B5EqCwSC5nqjY3Z6S01wTEFKTnM/view?usp=sharing
# Link to Sound Index File: https://docs.google.com/spreadsheets/d/1bDz0mSIYeE8C7-y-W_uF6b5avlkYCCvsEOyOBEHg66c/edit?usp=sharing
# Special Thanks to [sendwaves](http://www.openrcforums.com/forum/viewtopic.php?f=64&t=6871#p117912) post about improvements.
# -------------------------------------------------------------------------------------------------
# General Usage: sh "/../opentx_voice_and_sound_pack_generator_script_mac-osx.sh"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mac OS X voices for using with the ‘say’ command
# =================================================================================================
# [# Global Static Variables #]
SOURCE_DIRECTORY="$(dirname "$0")"
DEFAULT_SOURCE_FILE=$(ls "$SOURCE_DIRECTORY"/OpenTX*.csv)
SOURCE_FILE=${1:-$DEFAULT_SOURCE_FILE} # CSV File with the phrases & file names.
DESTINATION_DIRECTORY_SOUNDS="$SOURCE_DIRECTORY/SOUNDS"
VOICE="Satu"  # "Satu"  # Satu, suomenkielinen ääni
VOICE_RATE=200  # Speech Rate Multiplayer, Hight Number = Faster Speech, Default: 200
Hz="32000"  # sample rate to encode the audio at, noted in Hz. 32000Hz = 32KHz. Higher is higher quality (16000, 22000, 32000).

# [# Global Variables #]

# [# Included Library's & Scripts #]

# [# Functions #]
checkFolder() { [ -d "$@" ] || mkdir -p "$@"; }

# [# Main Program #] --------------------------------------------------------------------------------------
echo "==========================="
echo "$SCRIPT_TITLE"
echo "~ - - - - - - - - - - - - ~"
echo "Source File: $SOURCE_FILE"
echo "Source Directory: $SOURCE_DIRECTORY"
echo "Destination Directory: $DESTINATION_DIRECTORY_SOUNDS"
echo "~ - - - - - - - - - - - - ~"

# Check Source File
if [ -f "$SOURCE_FILE" ]; then
	# Add blank newline to source file so the script reads everything before comeing to END OF FILE.
	echo "" >> "$SOURCE_FILE"

	echo "Hei, olen $VOICE, ääneni tulee olemaan käytössä äänipaketissa. Generoidaan äänipaketti nyt."
	say -v "$VOICE" "Hei, olen $VOICE, ääneni tulee olemaan käytössä äänipaketissa. Generoidaan äänipaketti nyt." -r $VOICE_RATE
	echo "~ - - - - - - - - - - - - ~"

	# Check Destination Folder
	checkFolder "$DESTINATION_DIRECTORY_SOUNDS"

	# Read and process CSV file
	IFS=","  # File Delimiter
	while read directory file_name phrase_en phrase
	do
		# Check that variable contain data
		if [ -n "$directory" ] && [ -n "$file_name" ] && [ -n "$phrase" ] && [[ "$directory" =~ ^[a-zA-Z]{2}(\/[a-zA-Z1-9_]+)?$ ]]; then
			# Remove Newline from phrase Variable
			phrase=$(echo ${phrase} | tr -d '\n\r')

			# Output
			echo "$DESTINATION_DIRECTORY_SOUNDS/$directory/$file_name.wav \t| \"$phrase\" "

			# Check and Create Folder
			checkFolder "$DESTINATION_DIRECTORY_SOUNDS/$directory"

			# Create Voice File
			say -v "$VOICE" "$phrase" -o "$DESTINATION_DIRECTORY_SOUNDS/$directory/$file_name.aiff" -r $VOICE_RATE

			# Convert AIFF to WAV
			afconvert -f WAVE -d LEI16@$Hz -c 1 "$DESTINATION_DIRECTORY_SOUNDS/$directory/$file_name.aiff"

			# Remove needed AIFF voice voice file
			rm "$DESTINATION_DIRECTORY_SOUNDS/$directory/$file_name.aiff"
		else
			echo "[ $directory ] $file_name ... $phrase"
		fi
	done < "$SOURCE_FILE"
	echo "~ - - - - - - - - - - - - ~"
	echo "Coping Sound Files Info [$SOURCE_FILE] -> [$DESTINATION_DIRECTORY_SOUNDS/sounds.csv]"
	cp "$SOURCE_FILE" "$DESTINATION_DIRECTORY_SOUNDS/sounds.csv"
	echo "~ - - - - - - - - - - - - ~"
	afinfo "$DESTINATION_DIRECTORY_SOUNDS/en/system/tada.wav"
	echo "==========================="
	echo "Äänipaketti on valmis!"
	say -v "$VOICE" "Äänipaketti on valmis!" -r $VOICE_RATE
else
	echo "Hello, my name is $VOICE, I would create your sound pack but I can't find the source file needed to create it. Please check your configuration in the script, and the title of your source file."
	say -v "$VOICE" "Hello, my name is $VOICE, I would create your sound pack but I can't find the source file needed to create it. Please check your configuration in the script, and the title of your source file."  -r $VOICE_RATE
fi
