#####################################################################################################################################
# This script is a basic sample on how to interact with the PartnerCenter SDK using PowerShell. 			 						#
#																																	#
# Script: PowerShell_PartnerCenterSDK_Sample.ps1																					#
# Author: Joao Brazao - jbrazao@microsoft.com																						#
# Last Change: 09/01/2017																											#
# 																																	#
#																																	#
# Disclaimer																														#
# ==========																														#
# The sample scripts are not supported under any Microsoft standard support program or service. 									#
# The sample scripts are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including,	#
# without limitation, any implied warranties of merchantability or of fitness for a particular purpose. 							#
# The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. 					#
# In no event shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be 		#
# liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, 	#
# loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or 		#
# documentation, even if Microsoft has been advised of the possibility of such damages. 											#
#####################################################################################################################################

################################################################################################################################################################
# Define here the variables needed to do User authentication to the PartnerCenter																			   #
# cspDomain 	: CSP Partner Center tenant (sandbox recommended for testing)																				   #
# cspUsername 	: Partner Center user in UPN format (e.g. admin@csptenant.onmicrosoft.com). Note that this will follow the same user permission model.         #
# cspPassword	: The cspUsername password																													   #
# cspClientID	: Native App ID (to get one log into the Partner Center, then select Account Settings | App Management | Native App list -> Add new native app #
#				  Once created,  copy/paste the App ID value to the variable below																			   #
################################################################################################################################################################
$cspDomain = 'YOURCSPTENANT.onmicrosoft.com'
$cspPassword = 'YOURPASSWORD'
$cspUsername = 'USERNAME@YOURCSPTENANT.onmicrosoft.com'
$cspClientID = '<THIS IS A SAMPLE ID>480e5339-c2a3-45af-9706-d7Cf233b500a'

#################################################################################
# First lets get the Azure AD Token     										#
# This sample uses Authentication with App+User credentials and the REST API	#
#################################################################################
$url  = "https://login.windows.net/{0}/oauth2/token" -f $cspDomain
$body =         "grant_type=password&"
$body = $body + "resource=" + 'https://api.partnercenter.microsoft.com' + "&"
$body = $body + "client_id=$cspClientID&"
$body = $body + "username=$cspUsername&"
$body = $body + "password=$cspPassword&"
$body = $body + "scope=openid"

$response = Invoke-RestMethod -Uri $url -ContentType "application/x-www-form-urlencoded" -Headers $headers -Body $body -method "POST" -Debug -Verbose
    
$AADToken = $response.access_token

###########################################################
# Now, if everything went ok, we can perform any operation#
# In this example, lets get a list o customers            #
###########################################################
$url = "https://api.partnercenter.microsoft.com/v1/customers"
$headers = @{Authorization="Bearer $AADToken"}
    
$response = Invoke-RestMethod -Uri $url -Headers $headers -ContentType "application/json" -Method "GET" -Debug -Verbose
$customers = $response.Substring(1) | ConvertFrom-Json

$customers.items

#####################################################################################################
# If everything works fine, you can now try additional operations, such as the scenarios listed in:	#
# https://msdn.microsoft.com/en-us/library/partnercenter/mt634715.aspx								#
# Happy scripting!																					#
#####################################################################################################
