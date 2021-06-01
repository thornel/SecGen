REM  Modified from https://github.com/joefitzgerald/packer-windows/blob/master/scripts/vm-guest-tools.bat

powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://www.7-zip.org/a/7z920-x64.msi', 'C:\Windows\Temp\7z920-x64.msi')" <NUL
msiexec /qb /i C:\Windows\Temp\7z920-x64.msi

if "%PACKER_BUILDER_TYPE%" equ "vmware-iso" goto :vmware
if "%PACKER_BUILDER_TYPE%" equ "virtualbox-iso" goto :virtualbox
goto :done

:vmware

powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://softwareupdate.vmware.com/cds/vmw-desktop/ws/12.0.0/2985596/windows/packages/tools-windows.tar', 'C:\Windows\Temp\vmware-tools.tar')" <NUL
cmd /c ""C:\Program Files\7-Zip\7z.exe" x C:\Windows\Temp\vmware-tools.tar -oC:\Windows\Temp\vmware-tools"
FOR /r "C:\Windows\Temp\vmware-tools" %%a in (VMware-tools-windows-*.iso) DO REN "%%~a" "windows.iso"
rd /S /Q "C:\Program Files (x86)\VMWare"

cmd /c ""C:\Program Files\7-Zip\7z.exe" x "C:\Windows\Temp\vmware-tools\windows.iso" -oC:\Windows\Temp\VMWare"
cmd /c del /s /q C:\Windows\Temp\vmware-tools.tar
cmd /c rd /s /q C:\Windows\Temp\vmware-tools
cmd /c C:\Windows\Temp\VMWare\setup.exe /S /v"/qn REBOOT=R\"
cmd /c rd /s /q C:\Windows\Temp\VMWare

goto :done

:virtualbox

move /Y C:\Users\vagrant\VBoxGuestAdditions.iso C:\Windows\Temp
cmd /c ""C:\Program Files\7-Zip\7z.exe" x C:\Windows\Temp\VBoxGuestAdditions.iso -oC:\Windows\Temp\virtualbox"
cmd /c for %%i in (C:\Windows\Temp\virtualbox\cert\vbox*.cer) do C:\Windows\Temp\virtualbox\cert\VBoxCertUtil add-trusted-publisher %%i --root %%i
cmd /c C:\Windows\Temp\virtualbox\VBoxWindowsAdditions.exe /S
cmd /c rd /s /q C:\Windows\Temp\virtualbox
cmd /c del /s /q C:\Windows\Temp\VBoxGuestAdditions.iso
goto :done

:done
msiexec /qb /x C:\Windows\Temp\7z920-x64.msi
cmd /c del /q C:\Windows\Temp\7z920-x64.msi
REM self-delete this script
(goto) 2>nul & del "%~f0"
