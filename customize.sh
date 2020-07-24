# Copyright (C) 2020 Atrate <atrate@protonmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# Thanks to Jman420 for these volume input functions
# --------------------------------------------------
keytest() 
{
    ui_print "- Vol Key Test -"
    ui_print "   Press Vol Up:"
    (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > "$TMPDIR"/events) || return 1
    return 0
}

choose() 
{
    #note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
    while (true); do
        /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > "$TMPDIR"/events
        if (`cat "$TMPDIR"/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
            break
        fi
    done
    if (`cat "$TMPDIR"/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
        return 1
    else
        return 0
    fi
}

# Check whether using a legacy device
# -----------------------------------
if keytest; then
    FUNC=choose
else
    FUNC=false
    ui_print "   ! Legacy device detected! Setting module to default state (1). You can change it in $MODPATH/service.sh !"
    ui_print "   ! Setting MCC_MODE to 0 will disable CPD completely, while setting it to 1 will just change the Google URL to Kuketz !"
fi

# Ask user for Captive Portal Detection mode
# ------------------------------------------
ui_print " "
ui_print "--- Select Captive Portal Detection mode ---"
ui_print "  Vol+ = Change to Kuketz.de  "
ui_print "  Vol- = Completely disable  "
ui_print " "

if "$FUNC"; then
    MCC_MODE=0
    ui_print "Selected: Completely disable Captive Portal Detection"
else
    MCC_MODE=1
    ui_print "Selected: Change the Captive Portal Detection URL to Kuketz.de"
fi

ui_print " "
ui_print "Writing Captive Portal Detection mode to startup script…  "
sed -i "s/<DUMMY>/$MCC_MODE/g" "$MODPATH/service.sh"

# Just in case, make startup script executable
# --------------------------------------------
chmod 0755 "$MODPATH/service.sh"
