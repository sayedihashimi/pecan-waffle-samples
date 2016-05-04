$env:ExitOnPesterFail = $true
$env:IsDeveloperMachine=$true
$env:PSBUlidEnableMaskingSecretsInPSCmdlets=$false

(new-object Net.WebClient).DownloadString("https://raw.github.com/madskristensen/ExtensionScripts/master/AppVeyor/vsix.ps1") | iex
if($env:APPVEYOR_REPO_BRANCH -eq "release"){
    # install vsixgallery script
    Vsix-IncrementVsixVersion | Vsix-UpdateBuildVersion

    .\build.ps1

    if ($env:APPVEYOR_REPO_NAME -eq "VSSolutionTemplates/VSSolutionTemplates") {
	    Vsix-PublishToGallery
    }
}
else {
    .\build.ps1
}

Vsix-PushArtifacts
