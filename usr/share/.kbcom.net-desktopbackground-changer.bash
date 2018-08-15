#!/bin/bash

# Set desktop
# Reload desktop

set_desktops()
{
#Set lxde,xfce,mate,gnome,cinnamon,kde

# lxde
sed -i "/wallpaper=/c\wallpaper=$GLOBAL_BACKGROUND_FILE" "/home/$GLOBAL_USER/.config/pcmanfm/lubuntu/desktop-items-0.conf"
sed -i "/wallpaper_mode=/c\wallpaper_mode=fit" "/home/$GLOBAL_USER/.config/pcmanfm/lubuntu/desktop-items-0.conf"
sed -i "/desktop_bg=/c\desktop_bg=#2e4060" "/home/$GLOBAL_USER/.config/pcmanfm/lubuntu/desktop-items-0.conf"

# xfce
xfconf-query -c xfce4-desktop -p $xfce_desktop_prop_prefix/workspace1/last-image -s /path/to/file
xfconf-query -c xfce4-desktop -p $xfce_desktop_prop_prefix/workspace1/image-style -s 5

# mate
runuser -l $GLOBAL_WHO_USER -c "
 export DISPLAY=$GLOBAL_WHO_DISPLAY
 gsettings set org.mate.background picture-filename '$GLOBAL_FILE_BACKGROUND'
 gsettings set org.mate.background picture-options 'scaled'
 gsettings set org.mate.background primary-color '#5891BC'
 gsettings set org.mate.background color-shading-type 'solid'
"

# Gnome2
gconftool-2 --type=string --set /desktop/gnome/background/picture_filename /path/to/wallpaper.jpg

# Gnome3
gsettings set org.gnome.desktop.background picture-uri "file:///path/to/wallpaper.jpg"

# Cinnamon
gsettings set org.cinnamon.desktop.background picture-uri ''
gsettings set org.cinnamon.desktop.background picture-options ''


# KDE
dcop kdesktop KBackgroundIface setWallpaper /path/to/pic.jpg N
}

reload_desktops()
{
# Set desktop /home
WHOS=`/usr/bin/who`

IFS="
"

for WHO in $WHOS
do
 GLOBAL_WHO_USER=`echo "$WHO" | cut -f 1 -d ' '`
 GLOBAL_WHO_DISPLAY=`echo "$WHO" | cut -f 2 -d '(' | cut -f 1 -d ')'`

 sed -i "/wallpaper=/c\wallpaper=$GLOBAL_BACKGROUND_FILE" "/home/$GLOBAL_WHO_USER/.config/pcmanfm/lubuntu/desktop-items-0.conf"
 runuser - $GLOBAL_WHO_USER -c "export DISPLAY=$GLOBAL_WHO_DISPLAY && pcmanfm --desktop-off && pcmanfm --desktop --profile lubuntu &"
done
}
