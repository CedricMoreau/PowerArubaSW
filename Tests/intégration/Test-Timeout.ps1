#
# Copyright 2018, Alexis La Goutte <alexis.lagoutte at gmail dot com>
# Copyright 2018, Cédric Moreau <moreaucedric0 at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
Param(
    [string]$password,
    [string]$login,
    [string]$ipaddress
)

$mysecpassword = ConvertTo-SecureString $password -AsPlainText -Force
Connect-ArubaSW -Server $ipaddress -Username $login -password $mysecpassword

Describe  "Get RestSessionTimeout" {
    It "Get RestSessionTimeout Does not throw an error" {
        {
            Get-ArubaSWRestSessionTimeout
        } | Should Not Throw 
    }

    It "Get RestSessionTimeout" {
        $timeout = Get-ArubaSWRestSessionTimeout
        $timeout | Should not be $NULL
    }
}

Describe  "Set RestSessionTimeout" {
    It "Change SessionTimeout value" {
        $default = Get-ArubaSWRestSessionTimeout
        Set-ArubaSWRestSessionTimeout -timeout 800
        $timeout = Get-ArubaSWRestSessionTimeout
        $timeout | Should be "800"
        Set-ArubaSWRestSessionTimeout -timeout $default
    }

    It "Check range of RestSessionTimeout value" {
        $change = 90
        {Set-ArubaSWRestSessionTimeout -timeout $change} | Should Throw
        
        $change = 8500
        {Set-ArubaSWRestSessionTimeout -timeout $change} | Should Throw
    }
}

Disconnect-ArubaSW -noconfirm