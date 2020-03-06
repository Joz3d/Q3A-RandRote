#!/bin/sh
# Q3A Random Map Rotator
# by Joz
# Last Update: 5 Mar 2020

# 1. List your favorite map names in a file called 'mappool'
# 2. Run this script with an arg for the number of maps you want to randomly rotate
#		ex: 'randrote.sh 5'
# 3. Run your dedicated quake3 server with '+exec maplist.cfg'
#		ex: 'ioq3ded +exec maplist.cfg'
# 4. Have so much fun fragging, ok? ❤️
#
# TIP: Put this in a nightly cronjob!

baseq3=/home/joz/.q3a/baseq3	# Set your baseq3 directory (no trailing slash[/]!)

must=q3dm17		# You can put a map here that you want to guarantee comes up in the first 3 maps
				# Set to 'none' (no quotes) to not utilize this feature
i=1

# If the arg is only 2 maps, bump up the initial strike level so that the 'must'
# map will still be one of the 2 maps.
if [ $1 -eq 2 ]
then
	strike=2
else
	strike=1
fi

# If we're not using the 'must' feature described above, then disable the strike system.
if [ $must = "none" ]
then
	strike=-1
fi

rm -f $baseq3/maplist.cfg						# Clear the old map rotation
shuf -n $1 $baseq3/mappool > $baseq3/randmaps	# Shuffle the maps!

for map in $(cat $baseq3/randmaps)
do
	if [ $i -eq $1 ]			# If we're on the last line of the maps file
	then						# then we need nextmap vstr set to 'm01'.
		if [ $skipped ]
		then
			echo set m0$i \"map $skipped\; set nextmap vstr m01\" >> $baseq3/maplist.cfg
		elif [ $strike -eq 3 ]
		then
			echo set m0$i \"map $must\; set nextmap vstr m01\" >> $baseq3/maplist.cfg
		else
			echo set m0$i \"map $map\; set nextmap vstr m01\" >> $baseq3/maplist.cfg
		fi
		echo vstr m01 >> $baseq3/maplist.cfg	# The required last line of a map rotation file
	else
		if [ $map = $must ]
		then
			if [ $skipped ]		# 'skipped' is the original map that was in the 3rd slot and over-written by our 'must' map.  We'll swap it back in if we encounter our 'must' map later in the list.
			then
				echo set m0$i \"map $skipped\; set nextmap vstr m0"$(($i+1))"\" >> $baseq3/maplist.cfg
				unset skipped
			else
				# We found our map, go ahead and write it out naturally.
				echo set m0$i \"map $map\; set nextmap vstr m0"$(($i+1))"\" >> $baseq3/maplist.cfg
				strike=-1		# Setting 'strike' to -1 disables the strike system.
			fi					# In this case we don't need it anymore since we've already hit our 'must' map.
		else
			if [ $strike -eq 3 ]
			then
				# We've struck out, time to put our 'must' map into the next slot.
				echo set m0$i \"map $must\; set nextmap vstr m0"$(($i+1))"\" >> $baseq3/maplist.cfg
                skipped=$map	# Save the original map that was in this slot so that we may put it in should our 'must' map show up later in the random map list.
                strike=-1
			else
				# All the way down here is the actual "default" action (just put the map on the list)...
				echo set m0$i \"map $map\; set nextmap vstr m0"$(($i+1))"\" >> $baseq3/maplist.cfg
				if [ $strike -ne -1 ]		# ...and increment the strike count IF we are using it.
				then
					strike=$((strike+1))
				fi
			fi
		fi
	fi
    i=$((i+1))
done
