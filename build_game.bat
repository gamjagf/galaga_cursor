@echo off
echo [빌드 시작: 꽃님이 겔러그 게임]

:: 버전 업데이트
for /f "tokens=1-3 delims=." %%a in (version.txt) do (
    set /a new_patch=%%c+1
    echo %%a.%%b.!new_patch! > version.txt
    echo [버전 업데이트: %%a.%%b.%%c → %%a.%%b.!new_patch!]
)

:: PDF 생성
echo [설치 가이드 PDF 생성 중...]
powershell -Command "$version = Get-Content version.txt; $content = Get-Content install_guide.txt -Raw; Add-Type -AssemblyName System.Drawing; $doc = New-Object System.Drawing.Printing.PrintDocument; $doc.DocumentName = 'install_guide.pdf'; $doc.PrinterSettings.PrinterName = 'Microsoft Print To PDF'; $doc.PrinterSettings.PrintToFile = $true; $doc.PrinterSettings.PrintFileName = 'install_guide.pdf'; $doc.DefaultPageSettings.Margins = New-Object System.Drawing.Printing.Margins(50,50,50,50); $doc.PrintPage += { $e = $args[1]; $font = New-Object System.Drawing.Font('Arial', 12); $brush = [System.Drawing.Brushes]::Black; $y = 50; $lines = $content -split '\n'; foreach($line in $lines) { $e.Graphics.DrawString($line, $font, $brush, 50, $y); $y += 20; }; $e.Graphics.DrawString('버전: ' + $version, $font, $brush, 50, $y + 20); }; $doc.Print()"

:: 게임 빌드
pyinstaller main.spec
echo.
echo [✅ 빌드 완료! dist\main.exe 생성됨]
echo [✅ 설치 가이드 PDF 생성됨]
pause 