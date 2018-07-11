' Runs youtube-sync-playlists.py in the background (no new window). Taken from:
' https://serverfault.com/questions/9038/run-a-bat-file-in-a-scheduled-task-without-a-window
Dim WinScriptHost
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "C:\Users\Stefan\dev\dotfiles\bin\sync-youtube-music.py" & Chr(34), 0
Set WinScriptHost = Nothing
