#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later

source /etc/profile

set_kill set "Ryujinx"

sway_fullscreen "Ryujinx" &

/usr/bin/Ryujinx >/dev/null 2>&1
