#
# Copyright 2018, Alexis La Goutte <alexis.lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1
#TODO: Add check if no ipaddress/login/password info...

$mysecpassword = ConvertTo-SecureString $password -AsPlainText -Force
Connect-ArubaSW -Server $ipaddress -Username $login -password $mysecpassword -httpOnly

Describe  "Get Port" {
    BeforeAll {
        #Always set name to DEFAULT_PORT (no way to remove Port name/description...)
        Set-ArubaSWPort -port_id 3 -name DEFAULT_PORT
        #Always enable the port (disabled on WorkBench...)
        Set-ArubaSWPort -port_id 3 -is_port_enable
    }
    It "Get Port Does not throw an error" {
        {
            Get-ArubaSWPort
        } | Should Not Throw 
    }

    It "Get ALL Port" {
            $PORTS = Get-ArubaSWPort
            $PORTS.count | Should not be $NULL
    }

    It "Get the Port ID (3)" {
        $PORT = Get-ArubaSWPort -port_id 3
        $PORT.id | Should be 3
        $PORT.name | Should be "DEFAULT_PORT"
        $PORT.is_port_enabled | should be $true
        $PORT.is_port_up | should not be $null
        $PORT.config_mode | should be "PCM_AUTO"
        $PORT.trunk_mode | should be "PTT_NONE"
        $PORT.lacp_status | should be "LAS_DISABLED"
        $PORT.trunk_group | should be ""
        $PORT.is_flow_control_enabled | should be $false
        $PORT.is_dsnoop_port_trusted | should be $false
    }
}

Describe  "Configure Port" {

    Context "Configure Port via ID" {

        It "Configure Port name" {
            Set-ArubaSWPort -port_id 3 -name "PowerArubaSW-Port"
            $PORT = Get-ArubaSWPort -port_id 3
            $PORT.name | should be "PowerArubaSW-Port"
        }

        It "Configure Port option (enable flow control/dsnoop port trusted)" {
            Set-ArubaSWPort -port_id 3 -is_flow_control_enabled -is_dsnoop_port_trusted
            $PORT = Get-ArubaSWPort -port_id 3
            $PORT.id | Should Be 3
            $PORT.is_flow_control_enabled | should be $true
            $PORT.is_dsnoop_port_trusted | should be $true
        }

        It "Configure Port option (disable flow control/dsnoop port trusted)" {
            Set-ArubaSWPort -port_id 3 -is_flow_control_enabled:$false -is_dsnoop_port_trusted:$false
            $PORT = Get-ArubaSWPort -port_id 3
            $PORT.id | Should Be 3
            $PORT.is_flow_control_enabled | should be $false
            $PORT.is_dsnoop_port_trusted | should be $false
        }

        It "Configure Port config mode (10HDX, 100HDX, 10FDX, 100FDX, AUTO...)" {
            Set-ArubaSWPort -port_id 3 -config_mode PCM_100HDX
            $PORT = Get-ArubaSWPort -port_id 3
            $PORT.id | Should Be 3
        }

        AfterAll {
            #Always set name to DEFAULT_PORT (no way to remove Port name/description...)
            Set-ArubaSWPort -port_id 3 -name DEFAULT_PORT
            #Set to default config mode
            Set-ArubaSWPOrt -port_id 3 -config PCM_AUTO
        }
    }

    Context "Configure Port via pipeline" {

        It "Configure Port name" {
            $PORT = Get-ArubaSWPort -port_id 3
            $PORT | Set-ArubaSWPort -name "PowerArubaSW-Port"
            $PORT = Get-ArubaSWPort -port_id 3
            $PORT.name | should be "PowerArubaSW-Port"
        }

        It "Configure Port option (enable flow control/dsnoop port trusted)" {
            $PORT = Get-ArubaSWPort -port_id 3
            $PORT | Set-ArubaSWPort -is_flow_control_enabled -is_dsnoop_port_trusted
            $PORT = Get-ArubaSWPort -port_id 3
            $PORT.id | Should Be 3
            $PORT.is_flow_control_enabled | should be $true
            $PORT.is_dsnoop_port_trusted | should be $true
        }

        It "Configure Port option (disable flow control/dsnoop port trusted)" {
            $PORT = Get-ArubaSWPort -port_id 3
            $PORT | Set-ArubaSWPort -is_flow_control_enabled:$false -is_dsnoop_port_trusted:$false
            $PORT = Get-ArubaSWPort -port_id 3
            $PORT.id | Should Be 3
            $PORT.is_flow_control_enabled | should be $false
            $PORT.is_dsnoop_port_trusted | should be $false
        }

        It "Configure Port config mode (10HDX, 100HDX, 10FDX, 100FDX, AUTO...)" {
            $PORT = Get-ArubaSWPort -port_id 3
            $PORT | Set-ArubaSWPort -config_mode PCM_100HDX
            $PORT = Get-ArubaSWPort -port_id 3
            $PORT.id | Should Be 3
        }

        AfterAll {
            #Always set name to DEFAULT_PORT (no way to remove Port name/description...)
            Set-ArubaSWPort -port_id 3 -name DEFAULT_PORT
            #Set to default config mode
            Set-ArubaSWPOrt -port_id 3 -config PCM_AUTO
        }

    }
}

Disconnect-ArubaSW -noconfirm