Add-Type -AssemblyName System.Drawing

$baseDir = Resolve-Path "public/assets/images"
$srcImgPath = Join-Path $baseDir "nutricionista-alexandrapetry.jpg"
$src = [System.Drawing.Image]::FromFile($srcImgPath)

# 1. About image: high-quality portrait crop (e.g. 1000 x 1350)
$aboutWidth = 1000
$aboutHeight = 1350
$aboutBmp = New-Object System.Drawing.Bitmap($aboutWidth, $aboutHeight)
$gAbout = [System.Drawing.Graphics]::FromImage($aboutBmp)
$gAbout.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gAbout.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$gAbout.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

# Source crop from original (focusing on upper body and face)
# src is 3672 x 6528
$cropX = 0
$cropY = [int]($src.Height * 0.02)
$cropW = $src.Width
$cropH = [int]($src.Width * 1.35)

$srcRect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
$destRect = New-Object System.Drawing.Rectangle(0, 0, $aboutWidth, $aboutHeight)
$gAbout.DrawImage($src, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
$gAbout.Dispose()

$aboutOut = Join-Path $baseDir "sobre-nutricionista-alexandrapetry.jpg"
$aboutBmp.Save($aboutOut, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$aboutBmp.Dispose()
Write-Host "Created $aboutOut"

# 2. Hero Desktop: 2400 x 1200 canvas
# Background color: #f8f3e9 (248, 243, 233)
$heroW = 2400
$heroH = 1200
$heroBmp = New-Object System.Drawing.Bitmap($heroW, $heroH)
$gHero = [System.Drawing.Graphics]::FromImage($heroBmp)
$gHero.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gHero.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$gHero.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

# Fill background with --paper color
$bgColor = [System.Drawing.Color]::FromArgb(248, 243, 233)
$brush = New-Object System.Drawing.SolidBrush($bgColor)
$gHero.FillRectangle($brush, 0, 0, $heroW, $heroH)
$brush.Dispose()

# Place Alexandra on the right side
# Scale Alexandra so height covers heroH
$scale = $heroH / ($src.Height * 0.85)
$targetW = [int]($src.Width * $scale)
$targetH = $heroH
$targetX = $heroW - $targetW - 60
$targetY = 0

$destHeroRect = New-Object System.Drawing.Rectangle($targetX, $targetY, $targetW, $targetH)
$srcHeroRect = New-Object System.Drawing.Rectangle(0, 0, $src.Width, [int]($src.Height * 0.85))
$gHero.DrawImage($src, $destHeroRect, $srcHeroRect, [System.Drawing.GraphicsUnit]::Pixel)

# Smooth gradient blend on the left edge of Alexandra's photo to seamlessly merge with background
$blendW = 280
$blendStart = $targetX
for ($i = 0; $i -lt $blendW; $i++) {
    $alpha = [int](255 * (1.0 - ($i / $blendW)))
    $col = [System.Drawing.Color]::FromArgb($alpha, 248, 243, 233)
    $pen = New-Object System.Drawing.Pen($col, 1)
    $gHero.DrawLine($pen, $blendStart + $i, 0, $blendStart + $i, $heroH)
    $pen.Dispose()
}

$gHero.Dispose()
$heroOut = Join-Path $baseDir "nutricionista-alexandrapetry-hero.jpg"
$heroBmp.Save($heroOut, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$heroBmp.Dispose()
Write-Host "Created $heroOut"

# 3. Hero Mobile: 1080 x 1200 canvas
$mHeroW = 1080
$mHeroH = 1200
$mBmp = New-Object System.Drawing.Bitmap($mHeroW, $mHeroH)
$gM = [System.Drawing.Graphics]::FromImage($mBmp)
$gM.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gM.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$gM.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

$brushM = New-Object System.Drawing.SolidBrush($bgColor)
$gM.FillRectangle($brushM, 0, 0, $mHeroW, $mHeroH)
$brushM.Dispose()

$mScale = $mHeroH / ($src.Height * 0.75)
$mTargetW = [int]($src.Width * $mScale)
$mTargetX = [int](($mHeroW - $mTargetW) / 2)
$destMRect = New-Object System.Drawing.Rectangle($mTargetX, 0, $mTargetW, $mHeroH)
$srcMRect = New-Object System.Drawing.Rectangle(0, 0, $src.Width, [int]($src.Height * 0.75))
$gM.DrawImage($src, $destMRect, $srcMRect, [System.Drawing.GraphicsUnit]::Pixel)
$gM.Dispose()

$mOut = Join-Path $baseDir "nutricionista-alexandrapetry-hero-m.jpg"
$mBmp.Save($mOut, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$mBmp.Dispose()
Write-Host "Created $mOut"

$src.Dispose()
