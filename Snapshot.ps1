$toAddr 		= 'ADRESSE DE DESTINATION' 	#Exemple toto@toto.fr
$fromAddr 		= 'ADRESSE DENVOIE'			#Exemple postier@toto.fr
$smtpsrv 		= 'SERVEUR SMTP'			#Serveur SMTP sans demande d'authentification
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer -server IP DU SERVER VCENTER -User UTILISATEUR -Password MOTDEPASSE
$date 			= Get-Date
$VMsWithSnaps 	= @(Get-VM | Get-Snapshot | Select VM,Name,Created,sizemb)

if($VMsWithSnaps -ne $null){
    $body = @("
        <center><table border=1 width=50 % cellspacing=0 cellpadding=8 bgcolor=Black cols=3>
        <tr bgcolor=White><td>Virtual Machine</td><td>Snapshot</td><td>Size in MB</td><td>Creation Time</td></tr>")
    $i = 0
    do {
        if($i % 2){$body += "<tr bgcolor=#D2CFCF><td>$($VMsWithSnaps[$i].VM)</td><td>$($VMsWithSnaps[$i].Name)</td><td>$($VMsWithSnaps[$i].Sizemb)</td><td>$($VMsWithSnaps[$i].Created)</td></tr>";$i++}
        else {$body += "<tr bgcolor=#EFEFEF><td>$($VMsWithSnaps[$i].VM)</td><td>$($VMsWithSnaps[$i].Name)</td><td>$($VMsWithSnaps[$i].Sizemb)</td><td>$($VMsWithSnaps[$i].Created)</td></tr>";$i++}
    }
    while ($VMsWithSnaps[$i] -ne $null)
		$body += "</table></center>"
		Send-MailMessage -To "$toAddr" -From "$fromAddr" -Subject "WARNING: VMware SNAPSHOTS TROUVE SUR MANAGEMENT.NCITL.INT" -Body "$body" -SmtpServer "$smtpsrv" -BodyAsHtml
}
else{
	Send-MailMessage -To $toAddr -From $fromAddr -Subject "WARNING: PAS DE VMware SNAPSHOTS TROUVE SUR MANAGEMENT.NCITL.INT" -Body "RAS" -SmtpServer $smtpsrv
}

Disconnect-VIServer -Server IP DU SERVER VCENTER -Confirm:$false
exit