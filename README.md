# My-local-ISP-internet-speed
collecting data and about Zain internet speed along with some inferences.

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

# Notes/Issues.
..* It's data consuming (the data plotted above consumed several gigabytes).
..* The shell code occasionally throws an OutOfMemory Exception.
..* The native function getElementsByClassName occationally throws "Exception from HRESULT: 0x800A01B6", this is why the shellcode uses the following function instead.
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
