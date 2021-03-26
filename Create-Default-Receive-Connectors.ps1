$range = "0.0.0.0-255.255.255.255","::-ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff"
Get-TransportService | % {
	$server = $_.Name
	New-ReceiveConnector -Name "Client Proxy $server" -Bindings 0.0.0.0:465, [::]:465 -AuthMechanism Tls,Integrated,BasicAuth,BasicAuthRequireTLS,ExchangeServer -RemoteIPRanges $range -TransportRole HubTransport -PermissionGroups ExchangeUsers,ExchangeServers -MaxMessageSize 35MB -MessageRateLimit 5 -MessageRateSource User -EnableAuthGSSAPI $True -Server $server

	New-ReceiveConnector -Name "Default Frontend $server" -Bindings 0.0.0.0:25, [::]:25 -AuthMechanism Tls,Integrated,BasicAuth,BasicAuthRequireTLS,ExchangeServer -RemoteIPRanges $range -TransportRole FrontendTransport -PermissionGroups AnonymousUsers,ExchangeServers,ExchangeLegacyServers -MaxMessageSize 36MB -DomainSecureEnabled $True -ProtocolLoggingLevel Verbose -Server $server

	New-ReceiveConnector -Name "Outbound Proxy Frontend $server" -Bindings 0.0.0.0:717, [::]:717 -AuthMechanism Tls,Integrated,BasicAuth,BasicAuthRequireTLS,ExchangeServer -RemoteIPRanges $range -TransportRole FrontendTransport -PermissionGroups ExchangeServers -MaxMessageSize 36MB -DomainSecureEnabled $True -ProtocolLoggingLevel Verbose -Server $server

	New-ReceiveConnector -Name "Client Frontend $server" -Bindings 0.0.0.0:587, [::]:587 -AuthMechanism Tls,Integrated,BasicAuth,BasicAuthRequireTLS -RemoteIPRanges $range -TransportRole FrontendTransport -PermissionGroups ExchangeUsers -MaxMessageSize 35MB -MessageRateLimit 5 -MessageRateSource User -EnableAuthGSSAPI $True -Server $server

	New-ReceiveConnector -Name "Default $server" -Bindings [::]:2525, 0.0.0.0:2525 -AuthMechanism Tls,Integrated,BasicAuth,BasicAuthRequireTLS,ExchangeServer -RemoteIPRanges $range -TransportRole HubTransport -PermissionGroups ExchangeUsers,ExchangeServers,ExchangeLegacyServers -MaxMessageSize 35MB -MaxInboundConnectionPerSource Unlimited -MaxInboundConnectionPercentagePerSource 100 -MaxRecipientsPerMessage 5000 -SizeEnabled EnabledWithoutValue -Server $server
}