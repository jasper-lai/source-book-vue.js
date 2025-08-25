$folder = "d:\07-Course\自我練習\Vue.js\01-008天絕對看不完的Vue.js3指南_許國政(Kuro)\範例程式_Lab\source-book-vue.js\CH1"
$files = Get-ChildItem -Path $folder -Filter *.html

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    
    # 1. 將 https://unpkg.com/vue@next 改為 https://unpkg.com/vue@3/dist/vue.global.js
    $newContent = $content -replace 'https://unpkg.com/vue@next', 'https://unpkg.com/vue@3/dist/vue.global.js'
    
    # 檢查文件是否需要更改
    if ($content -ne $newContent) {
        Write-Host "已更新 CDN 路徑: $($file.Name)"
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
    }
}

Write-Host "所有文件處理完畢!"
