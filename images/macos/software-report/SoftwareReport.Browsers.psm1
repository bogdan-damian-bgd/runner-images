function Add-BrowserSection {
    param (
        [HeaderNode] $HeaderNode
    )

    $HeaderNode.AddToolNode("Safari", $(Get-SafariVersion))
    $HeaderNode.AddToolNode("SafariDriver", $(Get-SafariDriverVersion))
    $HeaderNode.AddToolNode("Google Chrome", $(Get-ChromeVersion))
    $HeaderNode.AddToolNode("ChromeDriver", $(Get-ChromeDriverVersion))
    $HeaderNode.AddToolNode("Microsoft Edge", $(Get-EdgeVersion))
    $HeaderNode.AddToolNode("Microsoft Edge WebDriver", $(Get-EdgeDriverVersion))
    $HeaderNode.AddToolNode("Mozilla Firefox", $(Get-FirefoxVersion))
    $HeaderNode.AddToolNode("geckodriver", $(Get-GeckodriverVersion))
    $HeaderNode.AddToolNode("Selenium server", $(Get-SeleniumVersion))
}

function Get-SafariVersion {
    $version = Run-Command "defaults read /Applications/Safari.app/Contents/Info CFBundleShortVersionString"
    $build = Run-Command "defaults read /Applications/Safari.app/Contents/Info CFBundleVersion"
    return "$version ($build)"
}

function Get-SafariDriverVersion {
    $version = Run-Command "safaridriver --version" | Take-Part -Part 3,4
    return $version
}

function Get-ChromeVersion {
    $chromePath = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    $version = Run-Command "'${chromePath}' --version"
    return $version.Substring("Google Chrome".Length).Trim()
}

function Get-ChromeDriverVersion {
    $rawOutput = Run-Command "chromedriver --version"
    $version = $rawOutput | Take-Part -Part 1
    return "${version}"
}

function Get-EdgeVersion {
    $edgePath = "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
    $version = Run-Command "'${edgePath}' --version"
    return $version.Substring("Microsoft Edge".Length).Trim()
}

function Get-EdgeDriverVersion {
    return Run-Command "msedgedriver --version" | Take-Part -Part 3
}

function Get-FirefoxVersion {
    $firefoxPath = "/Applications/Firefox.app/Contents/MacOS/firefox"
    $version = Run-Command "'${firefoxPath}' --version"
    return $version.Substring("Mozilla Firefox".Length).Trim()
}

function Get-GeckodriverVersion {
    $version = Run-Command "geckodriver --version" | Select-Object -First 1
    return $version.Substring("geckodriver".Length).Trim()
}

function Get-SeleniumVersion {
    $seleniumVersion = (Get-ChildItem -Path "/usr/local/Cellar/selenium-server*/*").Name
    return $seleniumVersion
}

function Build-BrowserWebdriversEnvironmentTable {
    $node = [HeaderNode]::new("Environment variables")

    $table = @(
        @{
            "Name" = "CHROMEWEBDRIVER"
            "Value" = $env:CHROMEWEBDRIVER
        },
        @{
            "Name" = "EDGEWEBDRIVER"
            "Value" = $env:EDGEWEBDRIVER
        },
        @{
            "Name" = "GECKOWEBDRIVER"
            "Value" = $env:GECKOWEBDRIVER
        }
    ) | ForEach-Object {
        [PSCustomObject] @{
            "Name" = $_.Name
            "Value" = $_.Value
        }
    }

    $node.AddTableNode($table)

    return $node
}
