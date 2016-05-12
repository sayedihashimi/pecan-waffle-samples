[cmdletbinding()]
param()

$templateInfo = New-Object -TypeName psobject -Property @{
    Name = 'ContosoZebra'
    Type = 'ProjectTemplate'
    DefaultProjectName = 'Zebra'
    CreateNewFolder = $false
    AfterInstall = {
        Update-PWPackagesPathInProjectFiles -slnRoot ($SolutionRoot)
    }
}

$templateInfo | replace (
    ('Contoso', {"$ProjectName"}, {"$DefaultProjectName"}),

    ('2ADA6741-AB4A-4283-BA8B-DE88E003B934', {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),
    ('278808B0-B3F3-4883-9A84-2B6429925011', {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),
    ('16481A0B-2B4B-484F-97BC-7AA09422AF8C', {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),
    ('74CA4CD8-C186-47D5-91A5-D59836037C0D', {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),
    ('751ACB67-5C02-4232-B562-8E2D90A1D5CE', {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),
    ('6154DCBD-66FD-4FDA-98F5-AB85D0C13A99', {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),
    ('FC2E39BF-7F1F-471E-895A-C9A7CAC2E54A', {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),
    ('66095F59-BE7A-48D8-8643-FFF894E66B4F', {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj"))

    # The following shows how you can use template parameters from Visual Studio
    # default template parameters ref https://msdn.microsoft.com/en-us/library/eehb4faa.aspx
    <#
    ('$clrversion$',{$p['$clrversion$']},$null),
    ('$itemname$',{$p['$itemname$']},$null),
    ('$machinename$',{$p['$machinename$']},$null),
    ('$projectname$',{$p['$projectname$']},$null),
    ('$registeredorganization$',{$p['$registeredorganization$']},$null),
    ('$rootnamespace$',{$p['$rootnamespace$']},$null),
    ('$safeitemname$',{$p['$safeitemname$']},$null),
    ('$safeprojectname$',{$p['$safeprojectname$']},$null),
    ('$time$',{$p['$time$']},$null),
    ('$SpecificSolutionName$',{$p['$SpecificSolutionName$']},$null),
    ('$userdomain$',{$p['$userdomain$']},$null),
    ('$username$',{$p['$username$']},$null),
    ('$webnamespace$',{$p['$webnamespace$']},$null),
    ('$year$',{$p['$year$']},$null),
    ('$guid1$',{$p['$guid1$']},$null),
    ('$guid2$',{$p['$guid2$']},$null),
    ('$guid3$',{$p['$guid3$']},$null),
    ('$guid4$',{$p['$guid4$']},$null),
    ('$guid5$',{$p['$guid5$']},$null),
    ('$guid6$',{$p['$guid6$']},$null),
    ('$guid7$',{$p['$guid7$']},$null),
    ('$guid8$',{$p['$guid8$']},$null),
    ('$guid9$',{$p['$guid9$']},$null),
    ('$guid10$',{$p['$guid10$']},$null)
    #>
)

# when the template is run any filename with the given string will be updated
$templateInfo | update-filename (
    ,('Contoso', {"$ProjectName"}<#,$null,@('.csproj','.bak','.projitems','.shproj','.cs')#>)
)
# excludes files from the template
$templateInfo | exclude-file 'pw-*.*','*.user','*.suo','*.userosscache','project.lock.json','*.vs*scc','*.sln'
# excludes folders from the template
$templateInfo | exclude-folder '.vs','artifacts','packages','bin','obj' 

# This will register the template with pecan-waffle
Set-TemplateInfo -templateInfo $templateInfo

<#
Use this one-liner to figure out the include expression for the project name
>Get-ChildItem .\templates * -Recurse -File|select-string 'Contoso' -SimpleMatch|Select-Object -ExpandProperty path -Unique|% { Get-Item $_ | Select-Object -ExpandProperty extension}|Select-Object -Unique|%{ Write-Host "'$_';" -NoNewline }


'.sln';'.vstemplate';'.csproj';'.bak';'.cs';'.xml';'.plist';'.projitems';'.shproj';'.xaml';'.config';'.pubxml';'.appxmanifest'

Use this one-liner to figure out the guids in your template
> Get-ChildItem .\templates *.*proj -Recurse -File|Select-Object -ExpandProperty fullname -Unique|% { ([xml](Get-Content $_)).Project.PropertyGroup.ProjectGuid|Select-Object -Unique|%{ '({0}, {{"$ProjectId"}}, [System.Guid]::NewGuid(),@("*.*proj")),' -f $_ }}

({8EBB17C5-5B87-466B-99BE-709C04F71BC8}, {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),
({B095DC2E-19D7-4852-9450-6774808B626E}, {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),
(e651c0cb-f5fb-4257-9289-ef45f3c1a02c, {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),
(1dfffd59-6b32-4937-bfde-1e10c11d22c3, {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),
({4D2348EA-44AA-479F-80FB-EF67D64F4F3A}, {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),
({0A7800A3-784F-4822-8956-7BAC2C4D194E}, {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),
({6B0A711C-8401-4240-BA08-A8198EFC271E}, {"$ProjectId"}, {[System.Guid]::NewGuid()},@("*.*proj")),


use this one-liner to figure out the include statement for update-filename
Get-ChildItem C:\temp\pean-waffle\dest\new3 *Contoso* -Recurse -File|Select-Object -ExpandProperty extension -Unique|%{ write-host ( '''{0}'',' -f $_) -NoNewline }

'.csproj','.bak','.projitems','.shproj','.cs'
#>