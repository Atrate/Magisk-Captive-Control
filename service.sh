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

#!/system/bin/sh

# Mode: 1 — Just change the Captive Portal URL, 0 — Completely disable Captive Portal detection
# ---------------------------------------------------------------------------------------------
MCC_MODE=<DUMMY>

# Always set the Captive Portal URL to other than Google
# ------------------------------------------------------
settings put global captive_portal_http_url "http://captiveportal.kuketz.de"
settings put global captive_portal_https_url "https://captiveportal.kuketz.de"
settings put global captive_portal_fallback_url "http://captiveportal.kuketz.de"
settings put global captive_portal_other_fallback_urls "http://captiveportal.kuketz.de"

# Disable Captive Portal Detection if it is desired
# -------------------------------------------------
if [ "$MCC_MODE" -eq 0 ]; then
    settings put global captive_portal_detection_enabled 0
    settings put global captive_portal_server localhost
    settings put global captive_portal_mode 0
fi

exit 0
