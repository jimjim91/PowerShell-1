﻿function Get-NewPassword
{
<#
	.SYNOPSIS
		Function to Generate a new password.
	
	.DESCRIPTION
		Function to Generate a new password.
		By default it will generate a 12 characters length password, you can change this using the parameter Length.
		I excluded the following characters: ",',.,/,1,<,>,`,O,0,l,|
		You can add exclusion by checking the following ASCII Table http://www.asciitable.com/
	
		If the length requested is less or equal to 4, it will generate a random password.
		If the length requested is greater than 4, it will make sure the password contains an Upper and Lower case letter, a Number and a special character
	
	.PARAMETER Length
		Specifies the length of the password
	
	.EXAMPLE
		PS C:\> Get-NewPassword -Length 30
		
		=E)(71&:f\W6:VRGE(,t1x6sZi-346

    .EXAMPLE
        PS C:\> Get-NewPassword 3
        
        !}R
	
	.NOTES
		See ASCII Table http://www.asciitable.com/
		Code based on a blog post of https://mjolinor.wordpress.com/2014/01/31/random-password-generator/
#>
	[CmdletBinding()]
	PARAM
	(
		[ValidateNotNull()]
		[int]$Length = 12
	)#PARAM
	
	BEGIN
	{
		# Create Char Codes 
		$PasswordCharCodes = { 33..126 }.invoke()
		
		# Exclude ",',.,/,1,<,>,`,O,0,l,|
		# See http://www.asciitable.com/ for mapping
		34, 39, 46, 47, 49, 60, 62, 96, 48, 79, 108, 124 | ForEach-Object { [void]$PasswordCharCodes.Remove($_) }
		$PasswordChars = [char[]]$PasswordCharCodes
	}#BEGIN
	PROCESS
	{
		IF ($Length -gt 4)
		{
			
			DO
			{
				# Generate a Password of the length requested
				$NewPassWord = $(foreach ($i in 1..$length) { Get-Random -InputObject $PassWordChars }) -join ''
			}#Do
			UNTIL (
			# Make sure it contains an Upercase and Lowercase letter, a number and another special character
			($NewPassword -cmatch '[A-Z]') -and
			($NewPassWord -cmatch '[a-z]') -and
			($NewPassWord -imatch '[0-9]') -and
			($NewPassWord -imatch '[^A-Z0-9]')
			)#Until
		}#IF
		ELSE
		{
			$NewPassWord = $(foreach ($i in 1..$length) { Get-Random -InputObject $PassWordChars }) -join ''
		}#ELSE
		
		# Output a new password
		$NewPassword
	} #PROCESS
	END
	{
		Remove-Variable -Name NewPassWord -ErrorAction 'SilentlyContinue'
	} #END
} #Function