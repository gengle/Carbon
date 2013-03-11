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

$siteName = 'CarbonSetIisMimeMap'

function Setup
{
    & (Join-Path $TestDir ..\..\Carbon\Import-Carbon.ps1 -Resolve)
    Install-IisWebsite -Name $siteName -Binding 'http/*:48284:*' -Path $TestDir
}

function TearDown
{
    Remove-IisWebsite -Name $siteName
    Remove-Module Carbon
}

function Test-ShouldCreateNewMimeMapForServer
{
    $fileExtension = '.CarbonSetIisMimeMap'
    $mimeType = 'text/plain'
    
    $mimeMap = Get-IisMimeMap -FileExtension $fileExtension
    Assert-Null $mimeMap
    
    try
    {
        Set-IisMimeMap -FileExtension $fileExtension -MimeType $mimeType
        
        $mimeMap = Get-IisMimeMap -FileExtension $fileExtension
        Assert-NotNull $mimeMap
        Assert-Equal $mimeMap.FileExtension $fileExtension
        Assert-Equal $mimeMap.MimeType $mimeType
    }
    finally
    {
        Remove-IisMimeMap -FileExtension $fileExtension
    }
}

function Test-ShouldUpdateExistingMimeMapForServer
{
    $fileExtension = '.CarbonSetIisMimeMap'
    $mimeType = 'text/plain'
    $mimeType2 = 'text/html'
    
    $mimeMap = Get-IisMimeMap -FileExtension $fileExtension
    Assert-Null $mimeMap
    
    try
    {
        Set-IisMimeMap -FileExtension $fileExtension -MimeType $mimeType
        Set-IisMimeMap -FileExtension $fileExtension -MimeType $mimeType2
        
        $mimeMap = Get-IisMimeMap -FileExtension $fileExtension
        Assert-NotNull $mimeMap
        Assert-Equal $mimeMap.FileExtension $fileExtension
        Assert-Equal $mimeMap.MimeType $mimeType2
    }
    finally
    {
        Remove-IisMimeMap -FileExtension $fileExtension
    }
}

function Test-ShouldSupportWhatIf
{
    $fileExtension = '.CarbonSetIisMimeMap'
    $mimeType = 'text/plain'

    try
    {    
        $mimeMap = Get-IisMimeMap -FileExtension $fileExtension
        Assert-Null $mimeMap
        
        Set-IisMimeMap -FileExtension $fileExtension -MimeType $mimeType -WhatIf
        
        $mimeMap = Get-IisMimeMap -FileExtension $fileExtension
        Assert-Null $mimeMap
    }
    finally
    {
        Remove-IisMimeMap -FileExtension $fileExtension
    }    
}