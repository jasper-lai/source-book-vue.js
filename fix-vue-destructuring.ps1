$folder = "d:\07-Course\自我練習\Vue.js\01-008天絕對看不完的Vue.js3指南_許國政(Kuro)\範例程式_Lab\source-book-vue.js\CH1"
$files = Get-ChildItem -Path $folder -Filter "*.html" | Where-Object { $_.Name -match "^1-\d" }

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    
    # 如果檔案內容包含 Vue.createApp 或已經有錯誤的解構模式
    if ($content -match "Vue\.createApp" -or $content -match "const\s+=\s+createApp") {
        # 找出應用程式變數名稱
        $appVarNameMatch = $content | Select-String -Pattern "(const|let|var)\s+(\w+)\s*=\s*(Vue\.createApp|createApp)" -AllMatches
        
        if ($appVarNameMatch.Matches.Count -gt 0) {
            $appVarName = $appVarNameMatch.Matches[0].Groups[2].Value
            
            # 替換為正確的解構方式
            $newContent = $content -replace "Vue\.createApp", "createApp"
            $newContent = $newContent -replace "(const|let|var)\s+(\w+)\s*=\s*createApp", "const { createApp } = Vue;`r`n    const `$2 = createApp"
            
            # 修復空變數名的問題
            $newContent = $newContent -replace "const\s+=\s+createApp", "const { createApp } = Vue;`r`n    const $appVarName = createApp"
            
            # 移除重複的解構聲明
            $newContent = $newContent -replace "(const { createApp } = Vue;[\r\n\s]*){2,}", "const { createApp } = Vue;`r`n    "
            
            Write-Host "已修復: $($file.Name)"
            Set-Content -Path $file.FullName -Value $newContent -NoNewline
        }
        else {
            Write-Host "無法找到應用程式變數名稱: $($file.Name)"
        }
    }
}

Write-Host "所有文件處理完畢!"
