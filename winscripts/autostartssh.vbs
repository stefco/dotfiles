Dim WinScriptHost
Set WinScriptHost = CreateObject("WScript.Shell")
' WinScriptHost.Run Chr(34) & "C:\Windows\System32\bash.exe -c 'sudo /usr/sbin/sshd -D'" & Chr(34), 0
' WinScriptHost.Run "C:\Windows\System32\bash.exe -c 'sudo /usr/sbin/sshd -D'" , 0
WinScriptHost.Run "C:\Windows\System32\bash.exe -c 'sudo service ssh --full-restart'" , 0
Set WinScriptHost = Nothing
