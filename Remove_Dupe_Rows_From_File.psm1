Function global:Dupe_Rows_Removal() {
    $file = Read-Host 'Please enter your original file' # Change Read-Host 'Please enter your original file'.... to your static file if you want to automate this 
    $NewFile = Read-Host 'Please enter your New File with .ext' # Change Read-Host 'Please enter your New File with .ext'.... to your static new file if you want to automate this 

    $hash = @{}                              # Define an empty hashtable
    Get-Content $file |                      # Send the content of the file into the pipeline... 
        ForEach-Object {                     # For each object in the pipeline...
        # note '%' is an alias of 'foreach-object'          
        if ($hash.$_ -eq $null) {
            # if that line is not a key in our hashtable...
            # note -eq means 'equals'
            # note $_ means 'the data we got from the pipe'
            # note $null means NULL
            $_                               # ... send that line further along the pipe
        };
        $hash.$_ = 1                         # Add that line to the hash (so we won't send it again)
        # note that the value isn't important here,
        # only the key. ;-)
    } > $NewFile  # finally... redirect the pipe into a new file. 
    
    Get-ChildItem $NewFile | ForEach-Object {
        # get the contents and replace line breaks by U+000A
        $contents = [IO.File]::ReadAllText($_) -replace "`r`n?", "`n"
        # create UTF-8 encoding without signature
        $utf8 = New-Object System.Text.UTF8Encoding $false
        # write the text back
        [IO.File]::WriteAllText($_, $contents, $utf8)
    }
}