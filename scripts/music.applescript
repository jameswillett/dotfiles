on escape_quotes(string_to_escape)
  set AppleScript's text item delimiters to the "\""
  set the item_list to every text item of string_to_escape
  set AppleScript's text item delimiters to the "\\\""
  set string_to_escape to the item_list as string
  set AppleScript's text item delimiters to ""
  return string_to_escape
end escape_quotes

set r to "{\"spotify\": {"
set r to r & "\"app\": \"spotify\""
if application "Spotify" is running then
  tell application "Spotify"
    set r to r & ",\"running\": " & running
    set r to r & ",\"shuffling\": " & shuffling
    set r to r & ",\"repeating\": " & repeating
    set r to r & ",\"position\": " & (player position as integer)
    set r to r & ",\"volume\": " & (sound volume as integer)
    set r to r & ",\"duration\": " & (current track's duration / 1000 as integer)
    set r to r & ",\"state\": \"" & player state & "\""
    set r to r & ",\"artist\": \"" & my escape_quotes(current track's artist) & "\""
    set r to r & ",\"title\": \"" & my escape_quotes(current track's name) & "\""
  end tell
else
  set r to r & ",\"running\": " & running
end if

set r to r & "}, \"itunes\": {"
set r to r & "\"app\": \"itunes\""
if application "Music" is running then
  tell application "Music"
    if current track exists then
      set r to r & ",\"running\": " & running
      set r to r & ",\"shuffling\": " & shuffle enabled
      set r to r & ",\"repeating\": " & (song repeat is not off)
      set r to r & ",\"position\": " & (player position)
      set r to r & ",\"volume\": " & (sound volume as integer)
      set r to r & ",\"duration\": " & (current track's duration)
      set r to r & ",\"state\": \"" & player state & "\""
      set r to r & ",\"artist\": \"" & my escape_quotes(current track's artist) & "\""
      set r to r & ",\"title\": \"" & my escape_quotes(current track's name) & "\""
    else
      set r to r & ",\"running\": false"
    end if
  end tell
else
  set r to r & ",\"running\": false"
end if

set r to r & "}, \"system\": {"
set r to r & "\"volume\" : " & output volume of (get volume settings)
set r to r & ",\"muted\": " & output muted of (get volume settings)
set r to r & "}}"

do shell script "echo " & r

return r
