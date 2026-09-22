Add-Type -AssemblyName System.Drawing

$srcPath = Resolve-Path "public/assets/images/nutricionista-alexandrapetry-original.jpg"
$destPath = Join-Path (Resolve-Path "public/assets/images") "nutricionista-alexandrapetry.jpg"

$image = [System.Drawing.Image]::FromFile($srcPath)
$image.RotateFlip([System.Drawing.RotateFlipType]::RotateNoneFlipX)
$image.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$image.Dispose()

Write-Host "Success: $destPath"
