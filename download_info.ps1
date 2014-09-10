# Use a script to download everything from http://scipp.ucsc.edu/~johnson/phys160/
# Use the 'index' page, search it for the link names, and download to same directory

Function saveAllFilesFromHttpDir($dir,$save_dir,$client)
{
	"===================="
	"DIR: $dir"
	"SAVEDIR: $save_dir"
	"===================="

	If (!(Test-Path -Path $save_dir))
	{
		New-Item -ItemType directory -Path $save_dir
	}

	$index_file = $save_dir+"index.txt"
	$client.DownloadFile($dir,$index_file)	
	$lines = Get-Content $index_file
	ForEach ($line in $lines)
	{
		$line -match '<a href="(.*)">'
		If ($matches)
		{
			$link = $matches[1]
		}
		If ($line -like "*folder.gif*")
		{
			$new_save_dir = "{0}{1}" -f $save_dir,$link
			$new_save_dir = $new_save_dir -replace "/"
			$new_save_dir = $new_save_dir + "\"
			$new_dir = "{0}{1}" -f $dir,$link
			saveAllFilesFromHttpDir $new_dir $new_save_dir $client
		}
		# Not sure how to test if there is a file that is worth downloading...
		# Maybe check if it has an extension? If so it is most likely a file...
		# But I'm pretty sure you can have a file without an extension too...
		If ($line -like "*.pdf*" `
			-OR $line -like "*.txt*" `
			-OR $line -like "*.htm*" `
			-OR $line -like "*.xml*")
		{
			$client.DownloadFile($dir,$save_dir+$link)
		}
	}
}

$client = New-Object "System.Net.WebClient"
$init_directory = "http:\\scipp.ucsc.edu/~johnson/phys160/"
$save_directory = "F:\Grad_School\EE631\Misc\johnson_phys160\"
saveAllFilesFromHttpDir $init_directory $save_directory $client
