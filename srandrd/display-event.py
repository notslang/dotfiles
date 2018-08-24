# this script is triggered by srandrd. it logs display events to a file and updates xrandr accordingly

import time
import json
import os
from math import floor

action_parts = os.environ['SRANDRD_ACTION'].split(' ')

if len(action_parts) == 1:
    display = None
    action = action_parts[0]
else:
    [display, action] = action_parts

edid = os.environ['SRANDRD_EDID']

with open("/data/screen-history.json", "a") as f:
    f.write(json.dumps({
        'screenId': os.environ['SRANDRD_SCREENID'],
        'edid': None if edid == '' else edid,
        'display': display,
        'time': floor(time.time()),
        'isConnected': action == 'connected'
    }, separators=(',', ':')) + '\n')
