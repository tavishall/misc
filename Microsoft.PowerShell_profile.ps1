$VIMPATH = "F:\Program Files (x86)\Vim\vim74\vim.exe"

Set-Alias vi $VIMPATH
Set-Alias vim $VIMPATH
Set-Alias py26 "F:\PythonV\Python26\python.exe"

# For editing PowerShell profile
Function Edit-Profile
{
	vim $profile
}

Function pyRunning
{
	$process = "python.exe"
	$procs = Get-WmiObject Win32_Process -Filter "name = '$process'"
	If ($procs.length -eq $null)
	{
		"No python processes running"
	}
	Else
	{
		ForEach ($p in $procs)
		{
			"pid: " + $p.ProcessId + "`t" +  $p.CommandLine
		}
	}
}

Function killPythonProcess($kill_this_process)
{
	$process = "python.exe"
	$python_processes = Get-WmiObject Win32_Process -Filter "name = '$process'" | 
		where{$_.CommandLine -like "*$kill_this_process*"}
	If ($python_processes -ne $null )
	{
		# We got a match on the process filters, so kill it
		If ($python_processes.length -eq $null)
		{
			# .length is null if there is only one process
			$kill_pid = $python_processes.ProcessId
			taskkill /F /FI "PID eq $kill_pid"
		}
		Else
		{
			# .length is not null if there are more than one
			# For now, just kill the first one
			$kill_pid = $python_processes[0].ProcessId
			taskkill /F /FI "PID eq $kill_pid"
		}
	}
	Else
	{
		"Did not find the process containing: " + $kill_this_process
	}
}
