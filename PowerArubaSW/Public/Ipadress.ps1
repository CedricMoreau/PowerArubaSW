#
# Copyright 2019, Alexis La Goutte <alexis.lagoutte at gmail dot com>
# Copyright 2019, Cédric Moreau <moreaucedric0 at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-ArubaSWIpAddress {

    <#
        .SYNOPSIS
        Get ip address information.

        .DESCRIPTION
        Get ip address information about the device

        .EXAMPLE
        Get-ArubaSWIPAddress
        This function give you all the informations about the ip parameters configured on the switch
    #>

    Begin {
    }

    Process {

        $url = "rest/v4/ipaddresses"

        $response = invoke-ArubaSWWebRequest -method "GET" -url $url

        $run = ($response | convertfrom-json)

        $run.ip_address_subnet_element
    }

    End {
    }
}