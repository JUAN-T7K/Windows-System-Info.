@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: =======================================================
:: JUAN - T7K
:: INFORMACION DE WINDOWS
:: Version 1.1
:: =======================================================

title JUAN - T7K - WINDOWS
color 0A

set "TEMP_RAW=%TEMP%\JuanT800_WindowsReport.txt"
set "ARCHIVO=%USERPROFILE%\Desktop\Reporte_PC.txt"

:: =======================================================
:: INTERFAZ PRINCIPAL
:: =======================================================

cls

echo ========================================================================
echo.
echo                    ####   ##   ##    #####    ##   ##
echo                      ##   ##   ##   ##   ##   ###  ##
echo                      ##   ##   ##   #######   #### ##
echo                      ##   ##   ##   ##   ##   ## ####
echo                 ##   ##   ##   ##   ##   ##   ##  ###
echo                  #####     #####    ##   ##   ##   ##
echo.
echo                               JUAN - T7K
echo.
echo                         INFORMACION DE WINDOWS
echo                              VERSION 1.1
echo.
echo ========================================================================
echo.
echo Generando reporte de sistema...
echo El archivo se guardara directamente en tu Escritorio
echo Por favor espera un momento...
echo.

:: =======================================================
:: 1. ENCABEZADO
:: =======================================================

echo [1/10] Generando encabezado...

(
echo ====================================================================
echo                          JUAN - T7K
echo                            WINDOWS
echo ====================================================================
echo                    INFORMACION DE WINDOWS
echo                         VERSION 1.1
echo ====================================================================
echo Fecha y hora : %date% %time%
echo Equipo       : %COMPUTERNAME%
echo Usuario      : %USERNAME%
echo ====================================================================
echo.
) > "%TEMP_RAW%"

:: =======================================================
:: 2. VERSION DE WINDOWS
:: =======================================================

echo [2/10] Obteniendo version de Windows...

(
echo [1] VERSION DE WINDOWS
echo --------------------------------------------------------------------
powershell -NoProfile -Command "$os=Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue; if($os){Write-Host ('Nombre  : ' + $os.Caption); Write-Host ('Version : ' + $os.Version)}else{Write-Host 'No se pudo obtener la informacion de Windows.'}"
echo.
) >> "%TEMP_RAW%"

:: =======================================================
:: 3. EQUIPO Y USUARIO
:: =======================================================

echo [3/10] Obteniendo nombre del equipo y usuario...

(
echo [2] EQUIPO Y USUARIO
echo --------------------------------------------------------------------
echo Nombre del PC : %COMPUTERNAME%
echo Usuario       : %USERNAME%
echo Dominio       : %USERDOMAIN%
echo.
) >> "%TEMP_RAW%"

:: =======================================================
:: 4. SISTEMA OPERATIVO
:: =======================================================

echo [4/10] Analizando sistema operativo...

(
echo [3] SISTEMA OPERATIVO
echo --------------------------------------------------------------------
powershell -NoProfile -Command "$os=Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue; if($os){Write-Host ('Nombre       : ' + $os.Caption); Write-Host ('Version      : ' + $os.Version); Write-Host ('Arquitectura : ' + $os.OSArchitecture); Write-Host ('Build        : ' + $os.BuildNumber)}else{Write-Host 'No se pudo obtener la informacion del sistema.'}"
echo.
) >> "%TEMP_RAW%"

:: =======================================================
:: 5. PROCESADOR
:: =======================================================

echo [5/10] Analizando procesador CPU...

(
echo [4] PROCESADOR CPU
echo --------------------------------------------------------------------
powershell -NoProfile -Command "$cpu=Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue; if($cpu){foreach($c in $cpu){Write-Host ('Procesador : ' + $c.Name); Write-Host ('Nucleos    : ' + $c.NumberOfCores); Write-Host ('Hilos      : ' + $c.NumberOfLogicalProcessors); Write-Host ('Frecuencia : ' + $c.MaxClockSpeed + ' MHz')}}else{Write-Host 'No se pudo obtener la informacion del procesador.'}"
echo.
) >> "%TEMP_RAW%"

:: =======================================================
:: 6. MEMORIA RAM
:: =======================================================

echo [6/10] Analizando memoria RAM...

(
echo [5] MEMORIA RAM
echo --------------------------------------------------------------------
powershell -NoProfile -Command "$ram=Get-CimInstance Win32_PhysicalMemory -ErrorAction SilentlyContinue; if($ram){$total=0; $num=0; foreach($r in $ram){$num++; $gb=[math]::Round($r.Capacity/1GB,2); $total+=$gb; Write-Host ('Modulo ' + $num + ' : ' + $gb + ' GB'); Write-Host ('Velocidad : ' + $r.Speed + ' MHz'); Write-Host ('Fabricante: ' + $r.Manufacturer); Write-Host ''}; Write-Host ('RAM TOTAL : ' + $total + ' GB')}else{Write-Host 'No se pudo obtener la informacion de la RAM.'}"
echo.
) >> "%TEMP_RAW%"

:: =======================================================
:: 7. ALMACENAMIENTO
:: =======================================================

echo [7/10] Detectando discos y almacenamiento...

(
echo [6] ALMACENAMIENTO
echo --------------------------------------------------------------------
powershell -NoProfile -Command "$disks=Get-CimInstance Win32_DiskDrive -ErrorAction SilentlyContinue; if($disks){$num=0; foreach($d in $disks){$num++; $gb=[math]::Round($d.Size/1GB,2); Write-Host ('Disco ' + $num); Write-Host ('Modelo   : ' + $d.Model); Write-Host ('Tamano   : ' + $gb + ' GB'); Write-Host ('Interfaz : ' + $d.InterfaceType); Write-Host ('Estado   : ' + $d.Status); Write-Host ''}}else{Write-Host 'No se pudo obtener la informacion de los discos.'}"
echo.
) >> "%TEMP_RAW%"

:: =======================================================
:: 8. SISTEMA DE ARCHIVOS Y DISCO C:
:: =======================================================

echo [8/10] Verificando disco C:...

(
echo [7] SISTEMA DE ARCHIVOS Y DISCO C:
echo --------------------------------------------------------------------
powershell -NoProfile -Command "$d=Get-CimInstance Win32_LogicalDisk -Filter 'DeviceID=''C:''' -ErrorAction SilentlyContinue; if($d){Write-Host ('Sistema de archivos : ' + $d.FileSystem); Write-Host ('Tamano total       : ' + [math]::Round($d.Size/1GB,2) + ' GB'); Write-Host ('Espacio libre      : ' + [math]::Round($d.FreeSpace/1GB,2) + ' GB'); Write-Host ('Espacio usado      : ' + [math]::Round(($d.Size-$d.FreeSpace)/1GB,2) + ' GB'); Write-Host ('Etiqueta           : ' + $d.VolumeName)}else{Write-Host 'No se pudo obtener la informacion del disco C.'}"
echo.
) >> "%TEMP_RAW%"

:: =======================================================
:: 9. TARJETA GRAFICA
:: =======================================================

echo [9/10] Analizando tarjeta grafica...

(
echo [8] TARJETA GRAFICA / GPU
echo --------------------------------------------------------------------
powershell -NoProfile -Command "$gpu=Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue; if($gpu){foreach($g in $gpu){if($g.AdapterRAM){$vram=[math]::Round($g.AdapterRAM/1MB)}else{$vram='No disponible'}; Write-Host ('GPU        : ' + $g.Name); Write-Host ('VRAM       : ' + $vram + ' MB'); Write-Host ('Driver     : ' + $g.DriverVersion); Write-Host ('Resolucion : ' + $g.CurrentHorizontalResolution + ' x ' + $g.CurrentVerticalResolution); Write-Host ''}}else{Write-Host 'No se pudo obtener la informacion de la GPU.'}"
echo.
) >> "%TEMP_RAW%"

:: =======================================================
:: 10. PLACA BASE Y BIOS
:: =======================================================

echo [10/10] Obteniendo placa base y BIOS...

(
echo [9] PLACA BASE / MOTHERBOARD
echo --------------------------------------------------------------------
powershell -NoProfile -Command "$b=Get-CimInstance Win32_BaseBoard -ErrorAction SilentlyContinue; if($b){Write-Host ('Fabricante : ' + $b.Manufacturer); Write-Host ('Modelo     : ' + $b.Product); Write-Host ('Version    : ' + $b.Version)}else{Write-Host 'No se pudo obtener la informacion de la placa base.'}"
echo.
echo [10] BIOS Y NUMERO DE SERIE
echo --------------------------------------------------------------------
powershell -NoProfile -Command "$bios=Get-CimInstance Win32_BIOS -ErrorAction SilentlyContinue; if($bios){Write-Host ('Fabricante BIOS : ' + $bios.Manufacturer); Write-Host ('Version BIOS    : ' + $bios.SMBIOSBIOSVersion); Write-Host ('Fecha BIOS      : ' + $bios.ReleaseDate); Write-Host ('Numero de serie : ' + $bios.SerialNumber)}else{Write-Host 'No se pudo obtener la informacion de la BIOS.'}"
echo.
) >> "%TEMP_RAW%"

:: =======================================================
:: ANALISIS FINAL
:: =======================================================

(
echo ====================================================================
echo                         ANALISIS FINALIZADO
echo ====================================================================
echo.
echo                          AUTOR: JUAN - T7K
echo.
echo                       INFORMACION DE WINDOWS
echo                            VERSION 1.1
echo.
echo ====================================================================
) >> "%TEMP_RAW%"

:: =======================================================
:: GUARDAR ANALISIS EN ESCRITORIO
:: =======================================================

powershell -NoProfile -Command "Get-Content -LiteralPath '%TEMP_RAW%' | Set-Content -LiteralPath '%ARCHIVO%' -Encoding UTF8" >nul 2>&1

if not exist "%ARCHIVO%" goto ERROR_REPORTE

if exist "%TEMP_RAW%" del /q "%TEMP_RAW%" >nul 2>&1

:: =======================================================
:: PANTALLA FINAL
:: =======================================================

cls

echo.
echo ========================================================================
echo.
echo                               JUAN - T7K
echo.
echo                         INFORMACION DE WINDOWS
echo                              VERSION 1.1
echo.
echo ========================================================================
echo.
echo                    ANALISIS COMPLETADO CON EXITO!
echo.
echo          Se ha creado "Analisis_Pc.txt" en tu Escritorio.
echo.
echo ========================================================================
echo.
pause
goto FIN

:: =======================================================
:: ERROR
:: =======================================================

:ERROR_REPORTE

if exist "%TEMP_RAW%" del /q "%TEMP_RAW%" >nul 2>&1

cls

echo.
echo ========================================================================
echo.
echo                               JUAN - T7K
echo.
echo                         INFORMACION DE WINDOWS
echo.
echo ========================================================================
echo.
echo                         ERROR AL ANALIZAR
echo.
echo   No se pudo crear el archivo Analisis_Pc.txt.
echo.
echo ========================================================================
echo.
pause

:FIN
endlocal