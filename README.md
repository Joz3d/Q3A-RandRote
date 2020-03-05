# Q3A-RandRote
Quake 3 Arena Random Map Rotator

Two best friends were so young at the turn of the century, and so nerdy, playing their Q3A instead of getting laid.

20 years later, busy in their now post-laid, with actual-wives-and-children lives (👍🏻🎊), they are separated by a continent, but alas, they have indeed noticed that Internet connections are so much faster in the year 2020.  They could probably even setup a Q3A server somehwere in the middle of the country and both get reasonable pings?  Yes, they can!  Some of that dot-com fiber is indeed glowing!

The fragging has picked up right where it left off.  But how about randomizing that damn map rotation!?

It was supposed to be a really basic bash script... then I realized I wanted an option to have a specific map always be one of the first 3 in the rotation, which then created a bunch of logic requirements.  It was then that I realized I probably should've written it in Python, but who gives a shit.


# Instructions
1. List your favorite map names in a file called `mappool`
2. Run this script with an arg for the number of maps you want to randomly rotate
		ex: `randrote.sh 5`
3. Run your dedicated quake3 server with `+exec maplist.cfg`
		ex: `ioq3ded +exec maplist.cfg`
4. Have so much fun fragging, ok? ❤️

TIP: Put this in a nightly cronjob!
