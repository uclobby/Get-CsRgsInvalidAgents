<#
.DESCRIPTION
	This script check and remove invalid Response Group agents from Lync Server 2010 and 2013.

.NOTES
  Version      	   		: 1.0
  Author    			: David Paulino https://uclobby.com/2015/01/09/lync-server-event-3113731138-ls-response-group-service/
  

#>

[CmdletBinding()]
param(
[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true)]
	[switch] $Remove,
[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true)]
	[string] $Name
)

$startTime=Get-Date;
if(!$Name){
    $agentGroups = Get-CsRgsAgentGroup
} else {
    $agentGroups = Get-CsRgsAgentGroup -Name $Name    
}


foreach($agentGroup in $agentGroups){
    $agents = $agentGroup | Select-Object -ExpandProperty AgentsByURI
    Write-Host "Checking Invalid users in" $agentGroup.Name -ForegroundColor Cyan
    foreach($agent in $agents){
        if((Get-CsUser | ?{($_.SipAddress -eq $agent.AbsoluteUri -and $_.Enabled)} | Measure).count -eq 0){
            if($remove){
                Write-Host "Removing invalid user:" $agent.AbsoluteUri -ForegroundColor Green
                $agentGroup.AgentsByUri.Remove($agent.AbsoluteUri)
                Set-CsRgsAgentGroup -Instance $agentGroup
            }else{
                Write-Host "Invalid user:" $agent.AbsoluteUri -ForegroundColor Yellow
            }
        }
    }
}
$endTime = Get-Date
$totalTime= [math]::round(($endTime - $startTime).TotalSeconds,2)
Write-Host "Execution time:" $totalTime "seconds" -ForegroundColor Cyan