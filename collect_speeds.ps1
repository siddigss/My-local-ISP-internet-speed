$sleep_seconds = 10*60
$sleep_seonds_between_samples = 10
$number_of_samples = 5
$file_path = "results.txt"
$started_measuring = $true

$ie = New-Object -com InternetExplorer.Application
$ie.visible = $true
$ie.navigate("https://www.speedtest.net")

while($ie.busy -or ($ie.ReadyState -ne 4)){
Start-Sleep -s 2
}
Start-Sleep -s 2
#$ie.Document.GetElementsByClassName("js-start-test test-mode-multi")[0].click() 
#For some reason I getting "Exception from HRESULT: 0x800A01B6" with this line above
#After googling (Although not sure what the cause is), I had write the following function.

$list = $null #list to store 
#args[0] : tag name
#arge[1] : class name
Function findElementByClassNameAndTagName{
Clear-Variable list
$list = $ie.Document.IHTMLDocument3_getElementsByTagName($args[0])

	for($i=0; $i -lt $list.Length; $i++){
		if($list[$i].className -eq $args[1]){
			return $list[$i]
		}
	}
return $null
}

(findElementByClassNameAndTagName "a" "js-start-test test-mode-multi").click()

Write-Host "First Click Done."

while($true){

	$sample_number = 1

	if(-Not $started_measuring){
		(findElementByClassNameAndTagName "a" "js-start-test test-mode-multi start-button-state-after").click()
	}

	$reset_counter = 0
	while($sample_number -le $number_of_samples){
		$reset_counter = $reset_counter + 1
		while($ie.busy -or ($ie.ReadyState -ne 4)){Start-Sleep -s 1}
		Start-Sleep -s 1

		Start-Sleep -s $sleep_seonds_between_samples

		if($ie.Document.URL -match "error"){
			$ie.navigate("https://www.speedtest.net")

			while($ie.busy -or ($ie.ReadyState -ne 4)){
			Start-Sleep -s 2
			}
			Start-Sleep -s 2

			(findElementByClassNameAndTagName "a" "js-start-test test-mode-multi").click()

			Write-Host "Error page encountered, Reload." -ForegroundColor DarkGreen -BackgroundColor White
		}


		if($reset_counter -gt 30){
			$reset_counter = 0
			$ie.navigate("https://www.speedtest.net")

			while($ie.busy -or ($ie.ReadyState -ne 4)){
			Start-Sleep -s 2
			}
			Start-Sleep -s 2

			(findElementByClassNameAndTagName "a" "js-start-test test-mode-multi").click()

			Write-Host "More than five minutes without actions, Reload." -ForegroundColor DarkGreen -BackgroundColor White
		}


		if($ie.Document.URL -eq "https://www.speedtest.net/"){
			$started_measuring = $true
		}


		if(($ie.Document.URL -match "result") -and $started_measuring ){
			$reset_counter = 0
			$started_measuring  = $false
			(Get-Date).ToString() >> $file_path

			#$ie.Document.GetElementsByClassName("result-data-large number result-data-value download-speed")[0].innerHTML >> $file_path
			#$ie.Document.GetElementsByClassName("result-data-large number result-data-value upload-speed")[0].innerHTML >> $file_path

			(findElementByClassNameAndTagName "span" "result-data-large number result-data-value ping-speed").innerHTML >> $file_path
			(findElementByClassNameAndTagName "span" "result-data-large number result-data-value download-speed").innerHTML >> $file_path
			(findElementByClassNameAndTagName "span" "result-data-large number result-data-value upload-speed").innerHTML >> $file_path


			if($sample_number -lt $number_of_samples){
				#$ie.Document.GetElementsByClassName("js-start-test test-mode-multi start-button-state-after")[0].click()
				(findElementByClassNameAndTagName "a" "js-start-test test-mode-multi start-button-state-after").click()
			}

			$sample_number = $sample_number + 1
		}


	}
	
	$started_measuring = $false
	Write-Host "Last writing: " -NoNewline
	Write-Host (Get-Date).toString()
	Write-Host "`n"
	Start-Sleep -s $sleep_seconds
	Write-Host "Will write in 10 seconds" -ForegroundColor Red -BackgroundColor White
	Start-Sleep -s 10
}



