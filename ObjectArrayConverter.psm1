<#
.SYNOPSIS
Creates a HTML-Table from a defined Object-Array

.DESCRIPTION
Creates a HTML-Table from a defined Object-Array
NOTE The obj parameter must be a Object[]

.PARAMETER obj
Parameter obj, Object[]

.PARAMETER showOnlyTheseHeaders
Parameter showOnlyTheseHeaders
Defines which headers should be shown in the HTML Table

.PARAMETER beautified
Parameter beautified
Defines if the table should be beautified with scripts css mechanism

.EXAMPLE
$obj = Get-Service
$table = Object2HTML -obj $obj -beautified:$true -showOnlyTheseHeaders Name, Status

Gets all Services. The object array will be converted into a HTML table.
In the table there are only the properties Name and Status visible.

.NOTES
Contact primark@united-internet.de for assistance.

#>

function Convert-ObjectArrayToJiraTable() {
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline)]
        [Object[]]$obj,
        [string[]]$showOnlyTheseHeaders,
        [switch]$setToClipboard
    )
    if($obj.GetType().Name -ne "Object[]") {
        throw "$obj is no Object[]"
    }
    if($showOnlyTheseHeaders) {
        $headers = @()
        $vheaders = $obj[0].PSObject.Properties.name
        foreach($head in $vheaders) {
            if($head -in $showOnlyTheseHeaders) {
                $headers += $head
            }
        }
    } else {
        $headers = $obj[0].PSObject.Properties.name
    }
    $base_html += "|| "
    foreach($h in $headers) {
        $base_html += "$h ||"  
    }
    $base_html += "`n"
    foreach($o in $obj) {
        $base_html += "| "
        if($showOnlyTheseHeaders) {
            foreach($head in $headers) {
                $v = ($o.PSObject.Properties | Where-Object name -eq $head).value
                $base_html += "$v |" 
            }
        } else {
            foreach($v in $o.PSObject.Properties.value) {
                $base_html += "$v |"  
            }
        }
        $base_html += "`n"
    }
    if($setToClipboard) {
        return $base_html | Set-Clipboard
    } else {
        return $base_html
    }
}

function Convert-ObjectArrayToHTMLTable() {
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline)]
        [Object[]]$obj,
        [string[]]$showOnlyTheseHeaders,
        [switch]$beautified
    )
    if($obj.GetType().Name -ne "Object[]") {
        throw "$obj is no Object[]"
    }
    if($beautified) {
        $base_html += "<style>
        body {
            font-family: Verdana, Geneva, Tahoma, sans-serif;
        }

        #MakeHTMLTableFromObject {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        #MakeHTMLTableFromObject td, #prbres th {
            border: 1px solid #ddd;
            padding: 8px;
        }

        #MakeHTMLTableFromObject tr:nth-child(even){background-color: #f2f2f2;}

        #MakeHTMLTableFromObject tr:hover {background-color: #ddd;}

        #MakeHTMLTableFromObject th {
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: left;
            background-color: #738fca;
            color: white;
        }
        </style>"
    }
    $base_html += "<table id=MakeHTMLTableFromObject>"
    if($showOnlyTheseHeaders) {
        $headers = @()
        $vheaders = $obj[0].PSObject.Properties.name
        foreach($head in $vheaders) {
            if($head -in $showOnlyTheseHeaders) {
                $headers += $head
            }
        }
    } else {
        $headers = $obj[0].PSObject.Properties.name
    }
    $base_html += "<tr>"
    foreach($h in $headers) {
        $base_html += "<th>$h</th>"  
    }
    $base_html += "</tr>"
    foreach($o in $obj) {
        $base_html += "<tr>"
        if($showOnlyTheseHeaders) {
            foreach($head in $headers) {
                $v = ($o.PSObject.Properties | Where-Object name -eq $head).value
                $base_html += "<td>$v</td>" 
            }
        } else {
            foreach($v in $o.PSObject.Properties.value) {
                $base_html += "<td>$v</td>"  
            }
        }
        $base_html += "</tr>"
    }
    $base_html += "</table>"
    return $base_html
}