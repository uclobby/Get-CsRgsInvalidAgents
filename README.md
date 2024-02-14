# Get-CsRgsInvalidAgents
This script checks and removes invalid Response Group agents.

If we don’t delete them, we will have the following warning events:

Lync Server: Event 31137,31138 LS Response Group Service
<br/>https://uclobby.com/2015/01/09/lync-server-event-3113731138-ls-response-group-service/

Usage:
Get-CsRgsInvalidAgents.ps1 [-Name] [-Remove]

Without parameters, the script will check all Response Groups for invalid agents:

-Name
Use this to specify a response group. For instance, check all invalid agents from Test Response Group

-Remove
Use this switch to Remove invalid agents
