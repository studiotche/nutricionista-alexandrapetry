import asyncio
from playwright.async_api import async_playwright
import json
import re

async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        print("Navigating to GMB...")
        
        # Google Maps never reaches networkidle, so we use domcontentloaded and wait manually
        await page.goto("https://www.google.com/maps/place/Alexandra+D.+Petry+I+Nutricionista+Cl%C3%ADnica+e+Esportiva+em+Novo+Hamburgo/@-29.6912225,-51.1272169,979m/data=!3m1!1e3!4m15!1m8!3m7!1s0x95194313e3d54ef7:0xaf9a49855b655981!2sAlexandra+D.+Petry+I+Nutricionista+Cl%C3%ADnica+e+Esportiva+em+Novo+Hamburgo!8m2!3d-29.6910819!4d-51.1272354!10e5!16s%2Fg%2F11qr9fkwj9!3m5!1s0x95194313e3d54ef7:0xaf9a49855b655981!8m2!3d-29.6910819!4d-51.1272354!16s%2Fg%2F11qr9fkwj9?entry=ttu", wait_until="domcontentloaded", timeout=60000)
        
        print("Waiting 10 seconds for map and images to load...")
        await page.wait_for_timeout(10000)
        
        print("Extracting images...")
        images = await page.evaluate('''() => {
            const urls = [];
            document.querySelectorAll('img, div, button').forEach(el => {
                if (el.tagName === 'IMG' && el.src && (el.src.includes('googleusercontent.com') || el.src.includes('ggpht.com'))) urls.push(el.src);
                const bg = window.getComputedStyle(el).backgroundImage;
                if (bg && (bg.includes('googleusercontent.com') || bg.includes('ggpht.com'))) {
                    const match = bg.match(/url\\("?(.*?)"?\\)/);
                    if (match && match[1] && !match[1].includes('favicon')) urls.push(match[1]);
                }
            });
            return Array.from(new Set(urls));
        }''')
        
        print("Found URLs:", json.dumps(images, indent=2))
        
        with open("scratch/gmb_images.json", "w") as f:
            json.dump(images, f)
            
        await browser.close()

if __name__ == "__main__":
    asyncio.run(main())
