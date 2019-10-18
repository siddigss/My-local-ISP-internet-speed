# My-local-ISP-internet-speed
Collecting data and about Zain internet speed along with some inferences.

# An Example
A sample from my results.txt (the file which the shellcode writes to).
```
10/17/2019 2:47:01 AM
119
5.90
7.45
10/17/2019 2:47:45 AM
125
6.66
4.74
```
Plotting the results


<p align="center">
<img src= https://i.imgur.com/4W5WtJH.png><br>
</p>

# How to use it
* Download the repository.
* Right Click on ```collect_speeds.ps1``` and chose ```Run with PowerShell```.
* The data will be written to a file named ```results.txt``` in the same directory as ```collect_speeds.ps1```.
* After collecting the data run the Jupyter Notebook```ploting results.ipynb```.

# Notes/Issues
* It only works nateively on windows as it uses the PowerShell.
* It's data consuming (the data plotted above consumed several gigabytes).
* The shell code occasionally throws an OutOfMemory Exception.
* The native function getElementsByClassName occationally throws "Exception from HRESULT: 0x800A01B6", this is why the shellcode uses the following function instead.
```
$list = $null
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
```
