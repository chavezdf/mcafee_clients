# McAfee Clients Batch Scripts

## Description

These scripts are used to Install, Uninstall and Update McAfee EPO and VSE clients on a local system. This does not have remote system functionality.

## Prerequisites
* Must be Local admin on system the script is ran on
* Run as administrator
* Sometimes the security will break running it from UNC share. Simply copy the parent script '''McAfee-Clients.cmd''' to any temp location locally and run from local system. Also, some security settings automatically block scripts in Windows and you'll need to unblock it by right-clicking and selecting unblock.

## Setup

1. Clone to a system that can share the files out on a Windows (SMB) share from Github. I tend to do this on the EPO Server.<br>
  ```git clone https://github.com/LevonBecker/mcafee_clients.git C:\McAfee\Scripts\```
2. Copy EPO and VSE client files into the shared folder.
  * Example
  * C:\Mcafee\EPO\Windows\4.6.0.3122
  * C:\Mcafee\VSE\Windows\8.8.0.975
  * C:\Mcafee\Scripts\McAfee-Clients.cmd
3. Setup Network SMB share to the root of the repo download and ient files.<br>
  ```\\EPOSERVER\Mcafee```
4. Edit User Variables at top of parent script (McAfee-Clients.cmd) to reflect your setup.
  * SET SHARESRVIP=<Share Server IP>
  * SET CUREPOVER=4.6.0.3122
  * SET CURVSEVER=8.8.0.975
  * SET WindowsScriptTemp=C:\WindowsScriptTemp

## Usage

1. From system that needs client services by the script; open Windows Explorer to the UNC path of the parent script
  * \\EPOSERVER\Mcafee\Scripts
2. Either copy the parent script locally or run from UNC (Depending on security settings).
3. Run the parent script as administrator
4. A information splash screen should display in a command shell.
5. Hit any key to continue
6. The Top level Selection menu should display with several options.
```
[1] Install McAfee Clients
[2] Reinstall McAfee Clients
[3] Uninstall McAfee Clients
[4] Install EPO Agent
[5] Reinstall EPO Agent
[6] Uninstall EPO Agent
[7] Install VSE Client
[8] Reinstall VSE Client
[9] Uninstall VSE Client
[10] Update EPO
[11] Update VSE
[12] Show EPO Monitor
[13] Show Access Protection Log
[14] Show On-Access Log
[15] Show On-Demand Log
[R] Return to Splash Screen
[X] Exit
```
7. Enter the number or letter for your selection and push enter

---

## Disclaimer

Use at your own risk.