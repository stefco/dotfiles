# Winscripts

Scripts for windows, duh.

## `plexadd.py`

Link files into plex directories for scanning.
[Edit](https://www.youtube.com/watch?v=oNBS162khf8) the
[registry](https://www.youtube.com/watch?v=jS2LuG1p8Vw)
(using `regedit` as administrator), adding a new key
under `HKEY_CLASSES_ROOT\Directory\Background\shell` by right-clicking it
and hitting `New > Key`.
Name it whatever you want, set the key's `Default` value to a descriptive
string like "Add TV show to Plex", and optionally add an extra string value
with key `Icon` and value equal to the executable (probably Plex) whose
icon you want to appear in the context menu.

Create a new key under this one called `command`, which will specify the
actual command associated with the action as the `Default` value.
It will be something like
`C:\Python39\python.exe "C:\Users\Stefan\dev\dotfiles\winscripts\plexadd.py"`.

## `plexmovie.py`

Same thing as `plexadd.py`, but under `HKEY_CLASSES_ROOT\*\shell` and pointing to `plexmovie.py` instead (duh) and with `"%1"` at the end to pass the path in.