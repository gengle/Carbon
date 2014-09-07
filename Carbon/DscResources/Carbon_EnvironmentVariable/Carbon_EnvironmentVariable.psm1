# Copyright 2012 Aaron Jensen
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

& (Join-Path -Path $PSScriptRoot -ChildPath '..\Initialize-CarbonDscResource.ps1' -Resolve)

function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([Collections.Hashtable])]
	param
	(
		[Parameter(Mandatory=$true)]
		[string]
        # The name of the environment variable.
		$Name,

		[string]
        # the value of the environment variable.        
		$Value,

		[ValidateSet("Present","Absent")]
		[string]
        # Create or delete the resource?
		$Ensure = 'Present'
	)
    
    Set-StrictMode -Version 'Latest'

    $actualValue = [Environment]::GetEnvironmentVariable($Name,[EnvironmentVariableTarget]::Machine)

    $Ensure = 'Present'
    if( $actualValue -eq $null )
    {
        $Ensure = 'Absent'
    }

    Write-Verbose ('{0} = {1}' -f $Name,$actualValue)
    @{
        Name = $Name;
        Ensure = $Ensure;
        Value = $actualValue;
    }
}


function Set-TargetResource
{
    <#
    .SYNOPSIS
    DSC resource for managing environment variables.

    .DESCRIPTION
    The Carbon_EnvironmentVariable resource will add, update, or remove environment variables. The environment variable is set/removed at both the computer *and* process level, so that the process applying the DSC configuration will have access to the variable in later resources.

    .LINK
    Get-EnvironmentVariable

    .LINK
    Set-EnvironmentVariable

    .EXAMPLE
    > 
    Demonstrates how to create or update an environment variable:

        Carbon_EnvironmentVariable SetCarbonEnv
        {
            Name = 'CARBON_ENV';
            Value = 'developer';
            Ensure = 'Present';
        }

    .EXAMPLE
    >
    Demonstrates how to remove an environment variable.
        
        Carbon_EnvironmentVariable RemoveCarbonEnv
        {
            Name = 'CARBON_ENV';
            Ensure = 'Absent';
        }

    #>
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[string]
        # The name of the environment variable.
		$Name,

		[string]
        # The value of the environment variable.
		$Value,

		[ValidateSet("Present","Absent")]
		[string]
        # Set to `Present` to create the environment variable. Set to `Absent` to delete it.
		$Ensure = 'Present'
	)

    Set-StrictMode -Version 'Latest'

    Write-Verbose ('{0} environment variable {1} value to {2}' -f $Ensure,$Name,$Value)

    [Environment]::SetEnvironmentVariable($Name,$null,([EnvironmentVariableTarget]::Machine))
    [Environment]::SetEnvironmentVariable($Name,$null,([EnvironmentVariableTarget]::Process))

    if( $Ensure -eq 'Present' )
    {
        Write-Verbose ('Setting environment variable {0} = {1}.' -f $Name,$Value)
        Set-EnvironmentVariable -Name $Name -Value $Value -ForComputer -ForProcess
    }

}

function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[String]
		$Name,

		[String]
		$Value,

		[ValidateSet("Present","Absent")]
		[String]
		$Ensure = 'Present'
	)

    Set-StrictMode -Version 'Latest'
    Write-Verbose ('Getting current value of ''{0}'' environment variable.' -f $Name)

    $resource = $null
    $resource = Get-TargetResource -Name $Name
    if( -not $resource )
    {
        Write-Verbose ('Environment variable ''{0}'' not found.' -f $Name)
        return $false
    }

    if( $Ensure -eq 'Present' )
    {
        Write-Verbose ('{0} -eq {1}' -f $resource.Value,$Value)
        return ($resource.Value -eq $Value);
    }
    else
    {
        Write-Verbose ('{0}: {1}' -f $Name,$Value)
        return ($resource.Value -eq $null)
    }

    $false
}

Export-ModuleMember -Function '*-TargetResource'