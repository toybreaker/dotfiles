#!/bin/bash

# (c) 2012 by Adrian Zaugg under GNU GPL v.2

CHROMENAME="Google Chrome"

MYPATH="$(dirname "$(dirname "$0" | sed -e "s%/Contents/Resources$%%")")"
MYAPPNAME="$(basename "$(dirname "$0" | sed -e "s%/Contents/Resources$%%")" | sed -e "s/\.app$//")"
# Ask Spotlight where Chrome is located, chose top entry since this was the latest opened Chrome version
CHROMEPATH="$(mdfind 'kMDItemContentType == "com.apple.application-bundle" && kMDItemFSName = "'"$CHROMENAME.app"'"' | head -1)"

# Expect Chrome next to me, if the system doesn't know where it is.
if [ -z "$CHROMEPATH" ]; then
    CHROMEPATH="$MYPATH/$CHROMENAME.app"
fi

if [ -e "$CHROMEPATH" ]; then
    # Is there an instance already running?
    if [ $(ps -u $(id -u) | grep -c "$CHROMEPATH/Contents/MacOS/Google Chrome") -gt 1 ]; then
        # use apple script to open a new incognito window
        osascript -e 'tell application "'"$CHROMENAME"'"' \
                  -e '  set IncogWin to make new window with properties {mode:"incognito"}' \
                  -e '  set URL of active tab of IncogWin to "about:blank"' \
                  -e 'end tell'
    else
        # just open Chrome in incognito mode
        open -n "$CHROMEPATH" --args --incognito --new-window "about:blank"
    fi

    # bring Chrome to front
    osascript -e 'tell application "'"$CHROMENAME"'" to activate'

else
    # Chrome not found
    osascript -e 'tell app "'"$MYAPPNAME"'" to display dialog "Place me next to '"$CHROMENAME"', please!" buttons "OK" default button 1 with title "'"$MYAPPNAME"'" with icon stop'
fi

exit 0
