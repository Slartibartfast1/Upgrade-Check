Function wmicheck{
    $strComputer = Read-Host "Enter Computer Name"

    if ($strComputer -match "gb01ws" -or $strComputer -match "gb01nb") {
        ""
        $compCAP = $strComputer.toUpper()
        "System Details for $compCAP"
        "---------------------------"
        $system =Get-wmiobject -Class "Win32_Computersystem" -namespace "root\CIMV2" `
        -computername $strComputer
        $manufacturer = $system.Manufacturer
        $model = "NULL"
        $model = $system.Model
        if ($manufacturer -eq "Gigabyte Technology Co., Ltd." -and $model -eq "To be filled by O.E.M.") {
                $model = "Zoostorm"
                "Model: $model"
        } else {
            "Manufacturer: $manufacturer"
            "Model: $model"
        }
        ""
        "Physical Memory Details for $CompCAP"
        "--------------------------------------"
        ""
         $colSlots = Get-WmiObject -Class "win32_PhysicalMemoryArray" -namespace "root\CIMV2" `
         -computerName $strComputer
         $colRAM = Get-WmiObject -Class "win32_PhysicalMemory" -namespace "root\CIMV2" `
         -computerName $strComputer
         $totalSlots = 0
         $totalSticks = 0
         $totalInstalled = 0

         Foreach ($objSlot In $colSlots){
            "Total Slots: " + $objSlot.MemoryDevices
            $totalSlots = $objSlot.MemoryDevices
        }

        Foreach ($objRAM In $colRAM) {
              ""
              "Slot: " + $objRAM.DeviceLocator
              "------------"
              $formFactor =  $objRAM.FormFactor
              switch ($formFactor) {
                0 {"Form Factor: Unknown"}
                1 {"Form Factor: Other"}
                6 {"Form Factor: Proprietary"}
                8 {"Form Factor: DIMM"}
                12 {"Form Factor: SODIMM"}
                Default {"ERROR: Memory Form Factor Could not be Determined"}
              }

              $prefix = "NULL"
              $memoryType = $objRAM.MemoryType
              switch ($memoryType) {
                0 {"Type: Unknown"; $prefix = "??-"}
                1 {"Type: Other"}
                2 {"Type: DRAM"}
                3 {"Type: Synchronous DRAM"}
                4 {"Type: Cache DRAM"}
                5 {"Type: EDO"}
                6 {"Type: EDRAM"}
                7 {"Type: VRAM"}
                8 {"Type: SRAM"}
                9 {"Type: RAM"}
                10 {"Type: ROM"}
                11 {"Type: Flash"}
                12 {"Type: EEPROM"}
                13 {"Type: FEPROM"}
                14 {"Type: EDPROM"}
                15 {"Type: CDRAM"}
                16 {"Type: 3DRAM"}
                17 {"Type: SDRAM"}
                18 {"Type: SGRAM"}
                19 {"Type: RDRAM"}
                20 {"Type: DDR"; $prefix = "PC-"}
                21 {"Type: DDR2"; $prefix = "PC2-"}
                22 {"Type: DDR2 FB-DIMM"}
                24 {"Type: DDR3"; $prefix = "PC3-"}
                25 {"Type: FBD2"}
                Default {"ERROR: Memory Type Could not be Determined"}
              }

              "Size: " + ($objRAM.Capacity / 1GB) + " GB"
              "Speed: " + ($objRAM.Speed) + " MHz"

              "Bandwidth: " + $prefix + ($objRAM.Speed * 8) #+ " MB/s"
              "---------"
              $totalSticks = $totalSticks + 1
              $totalInstalled = $totalInstalled + ($objRAM.Capacity / 1GB)
         }

         ""
         "Total Installed: $totalInstalled GB"
         $freeSlots = $totalSlots - $totalSticks
         "Free Slots: $freeSlots" 
         ""
         ""
         "Storage Details for $compCAP"
         "---------------------------"
         ""
         $diskDrives = Get-WmiObject -Class win32_diskdrive -namespace "root\CIMV2" -ComputerName $strComputer
         $totalDrives = 0

         Foreach ($objDrive In $diskDrives){
              $totalDrives = $totalDrives + 1
         }

        "No. of Drives: $totalDrives"
        ""
          Foreach ($objDrive In $diskDrives){
              "Drive: " + $objDrive.Name
              "Model: " + $objDrive.Model
              $diskSize = [Math]::Floor($objDrive.Size / 1000000000)
              "Capacity: $diskSize GB"
              ""
         }
    } else {
        "ERROR: The Computer Name Provided is Invalid"
    }
    wmicheck
}
wmicheck
