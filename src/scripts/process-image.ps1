Add-Type -AssemblyName System.Drawing

$srcPath = Resolve-Path "public/assets/images/nutricionista-luisa-scheffler-original.jpg"
$destPath = Join-Path (Resolve-Path "public/assets/images") "nutricionista-luisa-scheffler.jpg"

$image = [System.Drawing.Image]::FromFile($srcPath)
$image.RotateFlip([System.Drawing.RotateFlipType]::RotateNoneFlipX)
$image.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$image.Dispose()

Write-Host "Success: $destPath"
