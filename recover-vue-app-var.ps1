$folder = "d:\07-Course\自我練習\Vue.js\01-008天絕對看不完的Vue.js3指南_許國政(Kuro)\範例程式_Lab\source-book-vue.js\CH1"
$files = Get-ChildItem -Path $folder -Filter "*.html" | Where-Object { $_.Name -match "^1-\d" }

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    
    # 檢查是否包含有問題的模式
    if ($content -match "const\s+{\s*createApp\s*}\s*=\s*Vue;\r?\n\s*const\s+=\s+createApp") {
        # 找出 script 標籤內的部分
        $scriptContent = $content -match "<script>\s*\/\/.*\s*const\s+{\s*createApp\s*}\s*=\s*Vue;\r?\n\s*const\s+=\s+createApp.*?<\/script>"
        
        if ($scriptContent) {
            # 從原始檔案中讀取出 app 名稱
            $originalContent = Get-Content $file.FullName -Raw
            $originalScriptMatch = $originalContent | Select-String -Pattern "const\s+(\w+)\s*=\s*Vue\.createApp" -AllMatches
            
            if ($originalScriptMatch.Matches.Count -gt 0) {
                $appName = $originalScriptMatch.Matches[0].Groups[1].Value
                
                # 替換為正確的格式
                $newContent = $content -replace "const\s+{\s*createApp\s*}\s*=\s*Vue;\r?\n\s*const\s+=\s+createApp", "const { createApp } = Vue;`r`n    const $appName = createApp"
                
                Write-Host "已修復: $($file.Name)"
                Set-Content -Path $file.FullName -Value $newContent -NoNewline
            }
            else {
                Write-Host "無法從原始檔案找出應用程式名稱: $($file.Name)"
            }
        }
        else {
            Write-Host "無法匹配 script 內容: $($file.Name)"
        }
    }
}

Write-Host "所有文件處理完畢!"
