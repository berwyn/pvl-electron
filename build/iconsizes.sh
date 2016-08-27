#!/bin/bash
#
# Creates series of OS X icon sizes and assembles them into an .icns file. 
#
# Requires GraphicsMagick: http://www.graphicsmagick.org/
# ImageMagick will work too, just s/gm\ convert/convert 
#
# Use only on square images! I couldn't get GM to act reasonable. (see note
# below.)


filename=$(basename "$1")
extension="${filename##*.}"
newdirectory="${filename%.*}"

#echo filename $filename
#echo extension $extension
#echo nd $newdirectory

# largest icon dimension
i=512

# create iconset directory based on input filename
if ! [ -e "$PWD/$newdirectory.iconset" ]; then
    newdirectory="$newdirectory.iconset"
    mkdir $newdirectory
else
    count=1
    
    while [ -e "$newdirectory-${count}.iconset" ]; do
        let "count++"
    done
    
    newdirectory="$newdirectory-${count}.iconset"
    mkdir $newdirectory
fi    

# batch resize
while [ $i -ge 15 ]
do
    gm convert -verbose "$1" -scale $i"x"$i'>' "$newdirectory/icon_$ix$i".png

    # ^^^ You may need to use the -transparent [color] flag to preserve
    # transparency if the source image "background color" attribute is not white.
    # (gm identify -verbose [filename] to check.)

    # TODO: -extent kills transparency due to a WONTFIX. There is a workaround
    # involving -compose onto a blank transparent PNG. In the meantime, square
    # up source images before feeding them to this script -- a non-square image
    # will result in an invalid .iconset/.icns

    let "i /= 2" 
done

# convert to .icns format
iconutil -c icns $newdirectory
rm -rf $newdirectory

echo "Done."



