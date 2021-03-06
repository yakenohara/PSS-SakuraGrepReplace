$sakuraExeAbusolutePath = "C:\Program Files (x86)\sakura\sakura.exe"
$searchDir = "C:\dir\dir"

#変換Array
#("変換前正規表現文字列","変換後正規表現文字列")
$substitutions = @(
  ("before", "after"),
  ("before", "after")
)

#ディレクトリ存在チェック
if (-Not(Test-Path $searchDir)){ #存在しない場合
    echo ("directory not exit `""+ $searchDir +"`"")
    exit #終了
}

#Grep置換
$counter = 1
$substitutions | foreach{
    
    #progress表示
    echo ("processing " + $counter + "/" + $substitutions.Length)

    #Grep置換実行    
    $sakuraObj = Start-Process -FilePath $sakuraExeAbusolutePath `
                               -ArgumentList "-GREPMODE", `
                                             ("-GKEY=`"" + $_[0] + "`""), `
                                             ("-GREPR=`"" + $_[1] + "`""), `
                                             "-GFILE=`"*.c *.h`"", `
                                             ("-GFOLDER=`"" + $searchDir + "`""), `
                                             "-GOPT=SRP1U" `
                               -PassThru
                               
    Wait-Process -ID $sakuraObj.Id
    
    $counter++ #progress表示用counter
} 

echo "Done!"
