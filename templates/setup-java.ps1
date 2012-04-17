# This file MUST be encoded in "ANSI" (Windows-1252), not UTF-8
# Azure Doc http://j.mp/HlAIPW | What's ANSI? http://j.mp/HlALvl

. .\utils.ps1

echo "Installing Java"
# Args from http://chocolatey.org/api/v2/package/javaruntime.x64/6.0.30 (ZIP file, tools/chocolateyInstall.ps1)
.\jdk.exe /QN /NORESTART
CheckLastExitCode

echo "Installing Maven"
# Unzipping http://serverfault.com/a/201604
$shell_app   = new-object -com shell.application
$zip_file    = $shell_app.namespace((Get-Location).Path + "\maven.zip")
$destination = $shell_app.namespace((Get-Location).Path)
$destination.Copyhere($zip_file.items()) # unzip!

setx MAVEN_HOME "$pwd\apache-maven-3.0.4"
setx PATH "$env:path;$env:maven_home\bin"

echo "Installing your app's dependencies"
mvn package
CheckLastExitCode