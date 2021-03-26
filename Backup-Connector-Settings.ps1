Get-TransportService | % {
	$server = $_.Name
	Get-ReceiveConnector -identity "$server\Default $server" | fl > "c:\Current $server Default $server.txt"
	Get-ReceiveConnector -identity "$server\Client Proxy $server" | fl > "c:\Current $server_Client Proxy $server.txt"
	Get-ReceiveConnector -identity "$server\Client Frontend $server" | fl > "c:\Current $server Client Frontend $server.txt"
	Get-ReceiveConnector -identity "$server\Outbound Proxy Frontend $server" | fl > "c:\Current $server_Outbound Proxy Frontend $server.txt"
	Get-ReceiveConnector -identity "$server\Default Frontend $server" | fl > "c:\Current $server Default Frontend $server.txt"
}