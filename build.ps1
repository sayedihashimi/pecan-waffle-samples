[cmdletbinding(DefaultParameterSetName='build')]
param(
    [Parameter(ParameterSetName='build',Position=1)]
    [string]$configuration = 'Release',

    [Parameter(ParameterSetName='build',Position=2)]
    [System.IO.DirectoryInfo]$outputPath,

    [Parameter(ParameterSetName='build',Position=3)]
    [switch]$cleanBeforeBuild,

    [Parameter(ParameterSetName='build',Position=3)]
    [switch]$buildAllProjects,

    # clean parameters
    [Parameter(ParameterSetName='clean',Position=0)]
    [switch]$clean
)

Set-StrictMode -Version Latest

function Get-ScriptDirectory{
    split-path (((Get-Variable MyInvocation -Scope 1).Value).MyCommand.Path)
}
$scriptDir = ((Get-ScriptDirectory) + "\")

if([string]::IsNullOrWhiteSpace($outputPath)){
    $outputPath = (Join-Path $scriptDir 'OutputRoot')
}

$env:GeoffreyBinPath = $outputPath
[string]$slnFile = (get-item(Join-Path $scriptDir 'PecanWaffle.sln')).FullName
[string]$sln2File = (get-item(join-path $scriptDir 'templates\MultiprojTemplates01\MultiprojTemplates01.sln')).FullName

function EnsurePsbuildInstlled{
    [cmdletbinding()]
    param(
        [string]$psbuildInstallUri = 'https://raw.githubusercontent.com/ligershark/psbuild/master/src/GetPSBuild.ps1'
    )
    process{
        if(-not (Get-Command "Invoke-MsBuild" -errorAction SilentlyContinue)){
            'Installing psbuild from [{0}]' -f $psbuildInstallUri | Write-Verbose
            (new-object Net.WebClient).DownloadString($psbuildInstallUri) | iex
        }

        # make sure it's loaded and throw if not
        if(-not (Get-Command "Invoke-MsBuild" -errorAction SilentlyContinue)){
            throw ('Unable to install/load psbuild from [{0}]' -f $psbuildInstallUri)
        }
    }
}

[hashtable]$buildProperties = @{
    'Configuration'=$configuration
    'DeployExtension'='false'
    'OutputPath'=$outputPath.FullName
    'VisualStudioVersion'='14.0'
}

function Build-Projects{
    [cmdletbinding()]
    param()
    process {
        $env:IsDeveloperMachine=$true
        if($outputPath -eq $null){throw 'outputpath is null'}

        [string[]]$projectToBuild = $slnFile
        if( $buildAllProjects -eq $true){
            $projectToBuild += $slnFile
        }

        foreach($file in $projectToBuild){
            if(-not (Test-Path $file)){
                throw ('Could not find the project to build at [{0}]' -f $file)
            }
        }

        if(-not (Test-Path $OutputPath)){
            'Creating output folder [{0}]' -f $outputPath | Write-Output
            New-Item -Path $outputPath -ItemType Directory
        }

        Invoke-MSBuild $projectToBuild -properties $buildProperties
    }
}

function Clean{
    [cmdletbinding()]
    param()
    process {
        [System.IO.FileInfo]$projectToBuild = $slnFile

        if(-not (Test-Path $projectToBuild)){
            throw ('Could not find the project to build at [{0}]' -f $projectToBuild)
        }

        Invoke-MSBuild $projectToBuild -targets Clean -properties $buildProperties

        [System.IO.DirectoryInfo[]]$foldersToDelete = (Get-ChildItem $scriptDir -Include bin,obj -Recurse -Directory)
        $foldersToDelete += $outputPath

        foreach($folder in $foldersToDelete){
            if(Test-Path $folder){
                Remove-Item $folder -Recurse -Force
            }
        }
    }
}

function RestoreNuGetPackages(){
    [cmdletbinding()]
    param()
    process{
        Push-Location
        try{
            'restoring nuget packages' | Write-Output
            Set-Location (get-item ($slnfile)).Directory.FullName
            Invoke-CommandString -command (get-nuget) -commandArgs restore

            Set-Location (get-item ($sln2File)).Directory.FullName
            Invoke-CommandString -command (get-nuget) -commandArgs restore
        }
        finally{
            Pop-Location
        }
    }
}


# being script
try{
    EnsurePsbuildInstlled
    Import-NuGetPowershell
    RestoreNuGetPackages
    Build-Projects
}
catch{
    "Build failed with an exception:`n`n{0}`n`n{1}`n`n{2}" -f ($_.Exception),(Get-PSCallStack|Out-String),($Error|Out-String) |  Write-Error
    exit 1
}
