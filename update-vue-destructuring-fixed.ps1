$folder = "d:\07-Course\自我練習\Vue.js\01-008天絕對看不完的Vue.js3指南_許國政(Kuro)\範例程式_Lab\source-book-vue.js\CH1"
$files = Get-ChildItem -Path $folder -Filter *.html

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    
    # 檢查是否使用了 Vue.createApp 的模式
    if ($content -match "Vue\.createApp") {
        # 使用更精確的正則表達式替換
        $newContent = $content -replace "(const|let|var)\s+(\w+)\s*=\s*Vue\.createApp", "const { createApp } = Vue;`n  const `$2 = createApp"
        
        Write-Host "已更新為解構方式: $($file.Name)"
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
    }
}

Write-Host "所有文件處理完畢!"
