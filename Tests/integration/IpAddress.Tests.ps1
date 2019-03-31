#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Cédric Moreau <moreaucedric0 at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

. ../common.ps1

Describe  "Get-ArubaSWIPAddress" {
    It "Get-ArubaSWIPAddress Does not throw an error" {
        { Get-ArubaSWIPAddress } | Should Not Throw 
    }
}
