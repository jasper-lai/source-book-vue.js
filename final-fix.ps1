$folder = "d:\07-Course\自我練習\Vue.js\01-008天絕對看不完的Vue.js3指南_許國政(Kuro)\範例程式_Lab\source-book-vue.js\CH1"
$files = Get-ChildItem -Path $folder -Filter *.html | Where-Object { $_.Name -match "^1-\d" }

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    
    # 檢查是否有錯誤的解構模式
    if ($content -match "(const|let|var)\s*{\s*createApp\s*}\s*=\s*Vue;\s*\r?\n\s*const\s+=\s+createApp\s*\(") {
        # 替換為正確的模式
        $newContent = $content -replace "(const|let|var)\s*{\s*createApp\s*}\s*=\s*Vue;\s*\r?\n\s*const\s+=\s+createApp\s*\(", "`$1 { createApp } = Vue;`r`n    const app = createApp("
        
        Write-Host "已修復: $($file.Name)"
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
    }
}

Write-Host "所有文件處理完畢!"
