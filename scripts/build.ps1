param(
    [ValidatePattern('^[A-Za-z][A-Za-z0-9_-]*$')]
    [string]$Language = 'Chinese',
    [switch]$Release
)

$ErrorActionPreference = 'Stop'
$bookProjectRoot = Split-Path -Parent $PSScriptRoot
$bookBuildRoot = Join-Path $bookProjectRoot 'build'
$bookSourceDirectory = if ($Language -eq 'Chinese') {
    $Language = 'Chinese'
    Join-Path $bookProjectRoot 'book'
} else {
    Join-Path $bookProjectRoot "translations/$Language"
}
$bookSourcePath = Join-Path $bookSourceDirectory 'main.tex'
$bookOutputDirectory = if ($Language -eq 'Chinese') { $bookBuildRoot } else { Join-Path $bookBuildRoot $Language }
$bookPdfPath = Join-Path $bookOutputDirectory 'main.pdf'

if (-not (Test-Path -LiteralPath $bookSourcePath -PathType Leaf)) {
    throw "Missing source: $bookSourcePath. Create the requested translation before compiling."
}

$bookVersion = $null
$bookReleaseDirectory = $null
if ($Release) {
    $bookConfigPath = Join-Path $bookSourceDirectory 'config.tex'
    $bookConfigText = (Get-Content -LiteralPath $bookConfigPath | Where-Object { -not $_.TrimStart().StartsWith('%') }) -join "`n"
    $bookVersionMatch = [regex]::Match($bookConfigText, '\\newcommand\s*\{\\bookversion\}\s*\{([A-Za-z0-9][A-Za-z0-9._-]*)\}')
    if (-not $bookVersionMatch.Success) {
        throw 'config.tex must define a simple bookversion value using letters, digits, dots, underscores or hyphens.'
    }
    $bookVersion = $bookVersionMatch.Groups[1].Value
    $bookReleaseDirectory = Join-Path $bookProjectRoot "releases/$Language/$bookVersion"
}

if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
    throw 'latexmk is missing. Install a TeX environment with latexmk, XeLaTeX and Chinese packages.'
}
if (-not (Get-Command xelatex -ErrorAction SilentlyContinue)) {
    throw 'XeLaTeX is missing. Install it as part of your TeX environment.'
}

New-Item -ItemType Directory -Path $bookBuildRoot -Force | Out-Null
$bookBuildLock = $null
try {
    try {
        $bookBuildLock = [System.IO.File]::Open((Join-Path $bookBuildRoot '.build.lock'), [System.IO.FileMode]::OpenOrCreate, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
    } catch {
        throw 'Another build is running, or the build lock cannot be opened. Wait and check directory permissions.'
    }
    if ($Release -and (Test-Path -LiteralPath $bookReleaseDirectory)) {
        throw "Version archive already exists: $bookReleaseDirectory. Choose a new version; existing archives are not overwritten."
    }
    New-Item -ItemType Directory -Path $bookOutputDirectory -Force | Out-Null
    & latexmk '-cd' '-xelatex' '-interaction=nonstopmode' '-halt-on-error' '-file-line-error' "-outdir=$bookOutputDirectory" $bookSourcePath
    if ($LASTEXITCODE -ne 0) {
        throw "LaTeX compilation failed (exit code $LASTEXITCODE). See $bookOutputDirectory/main.log."
    }
    if (-not (Test-Path -LiteralPath $bookPdfPath -PathType Leaf) -or (Get-Item -LiteralPath $bookPdfPath).Length -eq 0) {
        throw "Compiler reported success but no nonempty PDF was produced: $bookPdfPath"
    }
    if ($Release) {
        $bookSourcePrefix = $bookSourceDirectory.TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
        $bookSourceManifest = @(
            Get-ChildItem -LiteralPath $bookSourceDirectory -File -Recurse |
                Where-Object { $_.FullName -notlike "$(Join-Path $bookSourceDirectory 'original')/*" -and $_.FullName -notlike "$(Join-Path $bookSourceDirectory 'original')\*" } |
                Sort-Object FullName |
                ForEach-Object {
                    [ordered]@{
                        Path = $_.FullName.Substring($bookSourcePrefix.Length).Replace('\', '/')
                        SHA256 = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
                    }
                }
        )
        $bookManifest = [ordered]@{
            Language = $Language
            Version = $bookVersion
            GeneratedAtUTC = (Get-Date).ToUniversalTime().ToString('o')
            SourceDirectory = $bookSourceDirectory.Substring($bookProjectRoot.Length + 1).Replace('\', '/')
            SourceFiles = $bookSourceManifest
            PDFSHA256 = (Get-FileHash -LiteralPath $bookPdfPath -Algorithm SHA256).Hash
        }
        New-Item -ItemType Directory -Path $bookReleaseDirectory | Out-Null
        Copy-Item -LiteralPath $bookPdfPath -Destination (Join-Path $bookReleaseDirectory 'book.pdf')
        $bookManifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $bookReleaseDirectory 'manifest.json') -Encoding utf8
        $bookLanguageReleaseDirectory = Split-Path -Parent $bookReleaseDirectory
        Copy-Item -LiteralPath (Join-Path $bookReleaseDirectory 'book.pdf') -Destination (Join-Path $bookLanguageReleaseDirectory 'latest.pdf') -Force
        [ordered]@{Language=$Language; Version=$bookVersion; PDF="$bookVersion/book.pdf"; Manifest="$bookVersion/manifest.json"} |
            ConvertTo-Json | Set-Content -LiteralPath (Join-Path $bookLanguageReleaseDirectory 'latest.json') -Encoding utf8
        Write-Output (Join-Path $bookReleaseDirectory 'book.pdf')
    } else {
        Write-Output $bookPdfPath
    }
} finally {
    if ($bookBuildLock) { $bookBuildLock.Dispose() }
}
