@echo off

set "serverHost="
set /p serverHost="Enter server host/ip: "

if not "%serverHost%" == "" goto :generateKeys
echo No server was entered (%ERRORLEVEL%). Exiting.
goto :endScript

:generateKeys
echo Generating keys...
ssh-keygen -t rsa -b 2048 -f %userprofile%\.ssh\id_rsa -q -N ""
if %ERRORLEVEL% == 0 goto :sendPublicKey
echo An error occurred when trying to generate SSH key pair (%ERRORLEVEL%). Exiting.
goto :endScript

:sendPublicKey
echo Sending keys to server...
type %userprofile%\.ssh\id_rsa.pub | ssh developer@%serverHost% "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
if %ERRORLEVEL% == 0 goto :success
echo An error occurred when trying to send public key to server %serverHost% (%ERRORLEVEL%). Exiting.
goto :endScript

:success
echo Success!

:endScript
pause