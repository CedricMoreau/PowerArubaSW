#
# Copyright 2018, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

Describe  "Get PoE" {
    It "Get PoE Does not throw an error" {
        {
            Get-ArubaSWPoE
        } | Should Not Throw
    }

    It "Get ALL PoE (Port)" {
        $poe = Get-ArubaSWPoE
        $poe | Should not be $NULL
        $poe.port_id | Should -BeOfType string
        $poe.is_poe_enabled | Should -BeOfType boolean
        $poe.poe_priority | Should -BeOfType string
        $poe.poe_allocation_method | Should -BeOfType string
        $poe.allocated_power_in_watts | Should -BeOfType long
        $poe.port_configured_type | Should -BeOfType string
        $poe.pre_standard_detect_enabled | Should -BeOfType boolean
    }

    It "Get PoE Port $pester_poe_port" {
        $poe = Get-ArubaSWPoE -port $pester_poe_port
        $poe | Should not be $NULL
        $poe.port_id | Should -Be $pester_poe_port
        $poe.is_poe_enabled | Should -BeOfType boolean
        $poe.poe_priority | Should -BeOfType string
        $poe.poe_allocation_method | Should -BeOfType string
        $poe.allocated_power_in_watts | Should -BeOfType long
        $poe.port_configured_type | Should -BeOfType string
        $poe.pre_standard_detect_enabled | Should -BeOfType boolean
    }
}

Describe  "Configure PoE" {
    Context "Configure PoE via Port ID" {
        BeforeAll {
            $script:poe_default = Get-ArubaSWPoE -port $pester_poe_port
        }
        It "Configure PoE Port $pester_poe_port : status, priority, allocation Method/Power in Watt, pre standard detect" {
            Set-ArubaSWPoE -port_id $pester_poe_port -is_poe_enabled:$false -poe_priority critical -poe_allocation_method value -allocated_power_in_watt 1 -pre_standard_detect_enabled:$true
            $poe = Get-ArubaSWPoE -port $pester_poe_port
            $poe.port_id | Should -Be $pester_poe_port
            $poe.is_poe_enabled | Should -Be $false
            $poe.poe_priority | Should -Be "PPP_CRITICAL"
            $poe.poe_allocation_method | Should -Be "PPAM_VALUE"
            $poe.allocated_power_in_watts | Should -Be 1
            $poe.pre_standard_detect_enabled | Should -Be $true
        }
    }
    Context "Configure POE Port via pipeline" {
        It "Configure POE Port $pester_poe_port : status, priority, allocation Method/Power in Watt, pre standard detect" {
            Get-ArubaSWSTPPort $pester_poe_port | Set-ArubaSWPoE -is_poe_enabled:$enable -poe_priority low -poe_allocation_method usage -pre_standard_detect_enabled:$false
            $poe = Get-ArubaSWPoE -port $pester_poe_port
            $poe.port_id | Should -Be $pester_poe_port
            $poe.is_poe_enabled | Should -Be $false
            $poe.poe_priority | Should -Be "PPP_LOW"
            $poe.poe_allocation_method | Should -Be "PPAM_USAGE"
            $poe.allocated_power_in_watts | Should -Be $poe_default.allocated_power_in_watts
            $poe.pre_standard_detect_enabled | Should -Be $false
        }
    }
}


Describe  "Get PoE Stats" {
    It "Get PoE StatsDoes not throw an error" {
        {
            Get-ArubaSWPoEStats
        } | Should Not Throw
    }

    It "Get ALL PoE Stats (Port)" {
        $poe = Get-ArubaSWPoEStats
        $poe | Should not be $NULL
        $poe.port_id | Should -BeOfType string
        $poe.port_voltage_in_volts | Should -BeOfType long
        $poe.power_denied_count | Should -BeOfType long
        $poe.over_current_count | Should -BeOfType long
        $poe.mps_absent_count | Should -BeOfType long
        $poe.short_count | Should -BeOfType long
        $poe.actual_power_in_watts | Should -BeOfType long
        $poe.power_class | Should -BeOfType long
    }

    It "Get PoE Port Stats $pester_poe_port" {
        $poe = Get-ArubaSWPoEStats -port $pester_poe_port
        $poe | Should not be $NULL
        $poe.port_id | Should -Be $pester_poe_port
        $poe.port_voltage_in_volts | Should -BeOfType long
        $poe.power_denied_count | Should -BeOfType long
        $poe.over_current_count | Should -BeOfType long
        $poe.mps_absent_count | Should -BeOfType long
        $poe.short_count | Should -BeOfType long
        $poe.actual_power_in_watts | Should -BeOfType long
        $poe.power_class | Should -BeOfType long
    }
}

Disconnect-ArubaSW -noconfirm