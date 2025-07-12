#requires -Version 5.1

<#
.SYNOPSIS
    Script for converting ChatGPT JSON files to Markdown format.
.DESCRIPTION
    This script reads a ChatGPT JSON file containing conversations and converts it to Markdown format.
    Each conversation is recorded with a title, date, and messages.
.PARAMETER InputPath
    Path to the input JSON file containing conversations.
.PARAMETER OutputPath
    Path to the output Markdown file where conversations will be saved.
.EXAMPLE
    .\Convert-ChatGptToMd.ps1 -InputPath "conversations.json" -OutputPath "ChatGPT_Export.md"
    This command will convert `conversations.json` to `ChatGPT_Export.md`.
.NOTES
    Author: Miloš Perunović
    Version: 1.0.0
    Date: 2025-06-24
    License: MIT
    This script is provided "as is" without warranty of any kind.
#>

[CmdletBinding()]
param(
    [string]$InputPath = "conversations.json",
    [string]$OutputPath = "ChatGPT_Export.md"
)

function Get-AllMessages {
    param($mapping)

    $messages = @()

    foreach ($key in $mapping.Keys) {
        $node = $mapping[$key]
        if ($node.message -and $node.message.content -and $node.message.content.parts) {
            if ($node.message.metadata -and $node.message.metadata.is_visually_hidden_from_conversation) {
                continue
            }
            $messages += $node.message
        }
    }

    $sortedMessages = $messages | Sort-Object @{Expression = {
            if ($_.create_time) {
                [double][decimal]$_.create_time
            }
            else {
                [double]::MaxValue
            }
        }
    }

    return $sortedMessages
}

function Get-FirstValidCreateTime {
    param($mapping)

    $unixEpoch = [datetime]"1970-01-01T00:00:00Z"

    foreach ($key in $mapping.Keys) {
        $node = $mapping[$key]
        if ($node.message -and $node.message.create_time) {
            try {
                $rawTime = [double][decimal]$node.message.create_time
                if ($rawTime -gt 10000000000) {
                    $rawTime = $rawTime / 1000
                }
                return $unixEpoch.AddSeconds([math]::Floor($rawTime)).ToLocalTime()
            }
            catch {
                # ignore
            }
        }
    }
    return $null
}

function Convert-ChatGPTConversations {
    param (
        [string]$jsonPath,
        [string]$outputPath
    )

    if (-not (Test-Path $jsonPath)) {
        Write-Error "File '$jsonPath' not found."
        return
    }

    $jsonContent = Get-Content -Raw -Path $jsonPath | ConvertFrom-Json
    $output = @()

    foreach ($conv in $jsonContent) {
        $title = $conv.title

        $mapping = @{}
        foreach ($prop in $conv.mapping.PSObject.Properties) {
            $mapping[$prop.Name] = $prop.Value
        }

        $dt = Get-FirstValidCreateTime -mapping $mapping
        if ($dt) {
            $createTime = $dt.ToString("yyyy-MM-dd HH:mm:ss")
        }
        else {
            $createTime = "Unknown date"
        }

        # Markdown header i datum italics
        $output += "## $title"
        $output += "📅 ***$createTime***"
        $output += ""

        $messages = Get-AllMessages -mapping $mapping
        Write-Host "Messages found: $($messages.Count)" -ForegroundColor Cyan

        foreach ($msg in $messages) {
            $ts = if ($msg.create_time) {
                $epoch = [datetime]"1970-01-01T00:00:00Z"
                $timeD = [double][decimal]$msg.create_time
                if ($timeD -gt 10000000000) { $timeD = $timeD / 1000 }
                $epoch.AddSeconds([math]::Floor($timeD)).ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss")
            }
            else {
                "Unknown timestamp"
            }

            $role = $msg.author.role
            $parts = $msg.content.parts | Where-Object { ($_ -is [string]) -and ($_.Trim() -ne "") }
            if ($parts.Count -gt 0) {
                $text = $parts -join "`n"
                $output += "**[$role][$ts]**"
                $output += $text
                $output += ""
            }
        }

        $output += "---"
        $output += ""
    }

    $output | Out-File -FilePath $outputPath -Encoding UTF8
    Write-Host "Conversations have been successfully summarized in '$outputPath'."
}

Convert-ChatGPTConversations -jsonPath $InputPath -outputPath $OutputPath
