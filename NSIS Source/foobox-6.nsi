Unicode true

# --- Update Mode Var ---

Var Dialog.Caption

Var Update.Header.Text
Var Update.Header.SubText
Var Update.Finish.Text
Var Update.Finish.SubText
Var Update.Abort.Text
Var Update.Abort.SubText
Var Update.Mode

Var Finish.Info.Title
Var Finish.Info.Text

# --- Update Mode Var ---

# IncludeDir
!addincludedir ".\nsisfiles\include"

# Include
!include "MUI2.nsh"
!include "x64.nsh"
!include "WinVer.nsh"

# APP
!define FB2K     "foobar2000"
!define FB2K_VER "1.6.10"
!define FBOX     "foobox"
!define FBOX_VER "6.1.6.10"
!define FBOX_PUB "dreamawake"
!define FBOX_WEB "https://www.cnblogs.com/foobox/"

# RegKey
!define FBOX_KEY_ROOT   "HKLM"
!define FBOX_KEY_UNINST "Software\Microsoft\Windows\CurrentVersion\Uninstall\${FB2K}"
!define FBOX_KEY_APPDIR "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\${FB2K}.exe"

# Compile
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize on
SetDateSave off
SetOverwrite try

# Runtime
Caption "$Dialog.Caption"
RequestExecutionLevel admin
AllowRootDirInstall false
ShowInstDetails show
ShowUnInstDetails show
BrandingText "${FBOX} by ${FBOX_PUB}"

# InstType
InstType "推荐安装"
InstType "精简安装"
InstType "完全安装"

# --- MUI Settings Start ---

# ReserveFile
ReserveFile ".\resource\install.ico"
ReserveFile ".\resource\license.rtf"
ReserveFile ".\resource\wizard-fb2k.bmp"

# PluginDir
# NSIS PackedVersion
!ifdef NSIS_PACKEDVERSION
!define /math NSIS_VERSON_MAJOR ${NSIS_PACKEDVERSION} >> 24
!else
!define NSIS_VERSON_MAJOR 2
!endif

!if ${NSIS_VERSON_MAJOR} > 2

# NSIS 3.x 方式引用插件
!addplugindir "/x86-unicode" ".\nsisfiles\plugin\x86-unicode"
!addplugindir "/x86-ansi" ".\nsisfiles\plugin\x86-ansi"

!else

# NSIS 2.x 方式引用插件
!ifdef NSIS_UNICODE
!addplugindir ".\nsisfiles\plugin\x86-unicode"
!else
!addplugindir ".\nsisfiles\plugin\x86-ansi"
!endif

!endif

# Plugin
ReserveFile /plugin "System.dll"
ReserveFile /plugin "Process.dll"
ReserveFile /plugin "nsisFirewall.dll"
ReserveFile /plugin "AccessControl.dll"

# MUI
!define MUI_UI ".\nsisfiles\mui-ui\mui_sdesc.exe"

# Icon
!define MUI_ICON ".\resource\install.ico"
!define MUI_UNICON ".\resource\uninst.ico"

# Bitmap
!define MUI_WELCOMEFINISHPAGE_BITMAP ".\resource\wizard-fb2k.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP ".\resource\wizard-fb2k.bmp"

# - InstallPage -
!define MUI_ABORTWARNING
!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit

# WelcomePage
!define MUI_PAGE_CUSTOMFUNCTION_PRE VerifyUpdateMode

!define MUI_WELCOMEPAGE_TEXT "\
${FB2K} 是一个 Windows 平台下的高级音频播放器，\
支持多种音频格式播放和转换及第三方组件扩展。$\n$\n\
${FBOX} 是基于 ${FB2K} 汉化版(当前版本 ${FB2K_VER})的 CUI 界面配置。$\n$\n\
您的系统版本应不低于 Windows 7，若选装 Milkdrop2 可视化插件，需安装 DirectX 9.0。"

!insertmacro MUI_PAGE_WELCOME

# LicensePage
!define MUI_PAGE_CUSTOMFUNCTION_PRE VerifyUpdateMode
!insertmacro MUI_PAGE_LICENSE ".\resource\license.rtf"

# ComponentsPage
!define MUI_PAGE_CUSTOMFUNCTION_PRE VerifyUpdateMode
!insertmacro MUI_PAGE_COMPONENTS

# DirectoryPage
!define MUI_PAGE_CUSTOMFUNCTION_PRE VerifyUpdateMode
!insertmacro MUI_PAGE_DIRECTORY

# InstfilesPage
!define MUI_PAGE_HEADER_TEXT                   "$Update.Header.Text"
!define MUI_PAGE_HEADER_SUBTEXT                "$Update.Header.SubText"
!define MUI_INSTFILESPAGE_FINISHHEADER_TEXT    "$Update.Finish.Text"
!define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT "$Update.Finish.SubText"
!define MUI_INSTFILESPAGE_ABORTHEADER_TEXT     "$Update.Abort.Text"
!define MUI_INSTFILESPAGE_ABORTHEADER_SUBTEXT  "$Update.Abort.SubText"

!insertmacro MUI_PAGE_INSTFILES

# FinishPage
!define MUI_FINISHPAGE_TITLE                   "$Finish.Info.Title"
!define MUI_FINISHPAGE_TEXT                    "$Finish.Info.Text"

!define MUI_FINISHPAGE_RUN "$INSTDIR\${FB2K}.exe"
!define MUI_FINISHPAGE_RUN_TEXT "运行 ${FBOX}"

!insertmacro MUI_PAGE_FINISH

# - UninstPage -
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

# Language (SimpChinese.nsh & SimpChinese.nlf)
# Copy    ".\nsisfiles\language\SimpChinese.nsh & SimpChinese.nlf"
# Replace "${NSISDIR}\Contrib\Language files\SimpChinese.nsh & SimpChinese.nlf"
!insertmacro MUI_LANGUAGE "SimpChinese"

# --- MUI Settings End ---

# Setup
Name "${FBOX} ${FBOX_VER}"
OutFile "${FBOX}_${FBOX_VER}.exe"

# VerInfo
VIProductVersion "${FBOX_VER}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "ProductName"     "${FBOX}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "Comments"        "CUI for ${FB2K}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "CompanyName"     "${FBOX_WEB}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "LegalTrademarks" "${FB2K}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "LegalCopyright"  "Copyright © 2001-2021 Peter Pawlowski"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "FileDescription" "${FBOX} CUI configuration for ${FB2K}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "FileVersion"     "${FBOX_VER}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "ProductVersion"  "${FBOX_VER}"

# InstallDir
InstallDir "$PROGRAMFILES\${FB2K}"
InstallDirRegKey HKLM "${FBOX_KEY_UNINST}" "UninstallString"

# AssociateFilesFunc
!include ".\nsisfiles\include\AssociateFunc.nsh"

# --- Process Cleanup Macro ---

!macro ProcessCleanup  # 进程清理
_ProcessFindLoop:
    Process::Find "${FB2K}.exe"
    Pop $R0
    IntCmp $R0 0 _ProcessFindDone
    Process::Kill $R0
    Pop $R1
    IntCmp $R1 0 _ProcessFindDone
    Goto _ProcessFindLoop
_ProcessFindDone:
!macroend

!macro UninstCleanup  # 已安装版本检测及卸载
    ClearErrors
    ReadRegStr $R0 HKLM "${FBOX_KEY_UNINST}" "UninstallString"
    ${Unless} ${Errors}
    System::Call "*(&t${NSIS_MAX_STRLEN}R0)p.r0"
    System::Call "shlwapi::PathParseIconLocation(pr0)"
    System::Call "shlwapi::PathRemoveFileSpec(pr0)"
    System::Call "*$0(&t${NSIS_MAX_STRLEN}.R2)"
    System::Free $0
    ${AndUnless} $R2 == ""
    ExecWait `"$R0" /S _?=$R2` $0
    ${EndUnless}
!macroend

!macro DataCleanup  # 清理使用数据
    IfFileExists "$INSTDIR\cache" 0 +2
    RMDir /r "$INSTDIR\cache"
    IfFileExists "$INSTDIR\Download" 0 +2
    RMDir /r "$INSTDIR\Download"
    IfFileExists "$INSTDIR\index-data" 0 +2
    RMDir /r "$INSTDIR\index-data"
    IfFileExists "$INSTDIR\library" 0 +2
    RMDir /r "$INSTDIR\library"
    IfFileExists "$INSTDIR\Lyrics" 0 +2
    RMDir /r "$INSTDIR\Lyrics"
    IfFileExists "$INSTDIR\MusicArt" 0 +2
    RMDir /r "$INSTDIR\MusicArt"
    IfFileExists "$INSTDIR\playlists-v1.4" 0 +2
    RMDir /r "$INSTDIR\playlists-v1.4"
!macroend

# --- Install Section ---

Section "核心程序组件" CoreFiles
    SectionIn 1 2 3 RO

    ${If} $Update.Mode = 0

    !insertmacro UninstCleanup
#   !insertmacro DataCleanup

    SetOutPath "$INSTDIR"
    File /r ".\${FB2K}-core\*.*"

    ${Else}

    !insertmacro ProcessCleanup

    SetOutPath "$INSTDIR"
    File /r /x configuration ".\${FB2K}-core\*.*"

    ${EndIf}

    # 注册 ShellExt.dll
    ${If} ${RunningX64}
    ${DisableX64FSRedirection}
    ExecWait `"$SYSDIR\regsvr32.exe" /s "$INSTDIR\ShellExt64.dll"`
    ${EnableX64FSRedirection}
    ${EndIf}

    RegDLL "$INSTDIR\ShellExt32.dll"

    WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

SectionGroup "配置文件（谨慎，新安装必须勾选）" OptionalProfile

    Section "${FB2K} 核心配置文件" CoreProfile
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\configuration\Core.cfg" 0 +3
        SetOutPath "$INSTDIR\configuration"
        File ".\${FB2K}-extra\configuration\Core.cfg"
    SectionEnd

    Section "ESLyric 歌词配置文件" LyricsCfg
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\configuration\foo_uie_eslyric.dll.cfg" 0 +3
        SetOutPath "$INSTDIR\configuration"
        File ".\${FB2K}-extra\configuration\foo_uie_eslyric.dll.cfg"
    SectionEnd

    Section "转换器配置文件" ConverterCfg
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\configuration\foo_converter.dll.cfg" 0 +3
        SetOutPath "$INSTDIR\configuration"
        File ".\${FB2K}-extra\configuration\foo_converter.dll.cfg"
    SectionEnd

SectionGroupEnd

SectionGroup "额外解码器" ExtraDecoder

    Section "APE 解码器" DecAPE
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\user-components\foo_input_monkey\foo_input_monkey.dll" 0 +3
        SetOutPath "$INSTDIR\user-components\foo_input_monkey"
        File ".\${FB2K}-extra\components\foo_input_monkey.dll"
    SectionEnd

    Section "DTS 解码器" DecDTS
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\user-components\foo_input_dts\foo_input_dts.dll" 0 +3
        SetOutPath "$INSTDIR\user-components\foo_input_dts"
        File /r ".\${FB2K}-extra\components\dts\*.*"
    SectionEnd

    Section "DSD/SACD 解码器" DecSACD
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\user-components\foo_input_sacd\foo_input_sacd.dll" 0 lb_done
        SetOutPath "$INSTDIR\user-components\foo_input_sacd"
        File ".\${FB2K}-extra\components\sacd\foo_input_sacd.dll"
        File ".\${FB2K}-extra\components\sacd\dsd_transcoder.dll"
        File ".\${FB2K}-extra\components\sacd\dsd_transcoder_x64.dll"
		File ".\${FB2K}-extra\components\sacd\dsd_transcoder_ctl.exe"
		File ".\${FB2K}-extra\components\sacd\dsd_transcoder_ctl_x64.exe"

        ${If} ${RunningX64}
        ${DisableX64FSRedirection}
        ExecWait `"$SYSDIR\regsvr32.exe" /s "$INSTDIR\user-components\foo_input_sacd\dsd_transcoder_x64.dll"`
        ${EnableX64FSRedirection}
        ${EndIf}

        RegDLL "$INSTDIR\user-components\foo_input_sacd\dsd_transcoder.dll"

        SetOutPath "$INSTDIR\user-components\foo_dsd_processor"
        File ".\${FB2K}-extra\components\sacd\foo_dsd_processor.dll"

        SetOutPath "$INSTDIR\user-components\foo_dsd_converter"
        File ".\${FB2K}-extra\components\sacd\foo_dsd_converter.dll"

        SetOutPath "$INSTDIR\filters"
        File /r ".\${FB2K}-extra\components\sacd\filters\*.*"

        lb_done:
    SectionEnd

    Section "TTA 解码器" DecTTA
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\user-components\foo_input_tta\foo_input_tta.dll" 0 +3
        SetOutPath "$INSTDIR\user-components\foo_input_tta"
        File ".\${FB2K}-extra\components\foo_input_tta.dll"
    SectionEnd

    Section "TAK 解码器" DecTAK
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\user-components\foo_input_tak\foo_input_tak.dll" 0 +4
        SetOutPath "$INSTDIR\user-components\foo_input_tak"
        File ".\${FB2K}-extra\components\tak_deco_lib.dll"
        File ".\${FB2K}-extra\components\foo_input_tak.dll"
    SectionEnd

#    Section "DVD-Audio 解码器" DecDVDA
#        SectionIn 1 2 3
#
#        StrCmp $Update.Mode 1 0 +2
#        IfFileExists "$INSTDIR\user-components\foo_input_dvda\foo_input_dvda.dll" 0 +3
#        SetOutPath "$INSTDIR\user-components\foo_input_dvda"
#        File ".\${FB2K}-extra\components\foo_input_dvda.dll"
#    SectionEnd

    Section "fdk-aac packet 解码器" DecFDKAAC
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\user-components\foo_pd_aac\foo_pd_aac.dll" 0 +3
        SetOutPath "$INSTDIR\user-components\foo_pd_aac"
        File ".\${FB2K}-extra\components\foo_pd_aac.dll"
    SectionEnd

SectionGroupEnd

SectionGroup "可选组件" OptionalComponents

    Section "转换器" Converter
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\components\foo_converter.dll" 0 +3
        SetOutPath "$INSTDIR\components"
        File ".\${FB2K}-extra\components\foo_converter.dll"
    SectionEnd

    Section "文件操作" FileOps
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\components\foo_fileops.dll" 0 +3
        SetOutPath "$INSTDIR\components"
        File ".\${FB2K}-extra\components\foo_fileops.dll"
    SectionEnd

    Section "压缩包读取器" UnPack
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\components\foo_unpack.dll" 0 +3
        SetOutPath "$INSTDIR\components"
        File ".\${FB2K}-extra\components\foo_unpack.dll"
    SectionEnd

    Section "播放增益扫描器" Rgscan
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\components\foo_rgscan.dll" 0 +3
        SetOutPath "$INSTDIR\components"
        File ".\${FB2K}-extra\components\foo_rgscan.dll"
    SectionEnd

    Section "Freedb 标签获取器" Freedb
        SectionIn 1 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\components\foo_freedb2.dll" 0 +3
        SetOutPath "$INSTDIR\components"
        File ".\${FB2K}-extra\components\foo_freedb2.dll"
    SectionEnd

    Section /o "UPnP\DLNA 支持插件" UPnP
        SectionIn 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\user-components\foo_upnp\foo_upnp.dll" 0 +3
        SetOutPath "$INSTDIR\user-components\foo_upnp"
        File ".\${FB2K}-extra\components\foo_upnp.dll"
    SectionEnd

SectionGroupEnd

SectionGroup "格式转换编码器" Encoders

    Section "MP3 编码器(lame)" EncMP3
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\lame.exe" 0 +3
        SetOutPath "$INSTDIR\encoders"
        File ".\${FB2K}-extra\encoders\lame.exe"
    SectionEnd

    Section "FLAC 编码器" EncFLAC
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\flac.exe" 0 +4
        SetOutPath "$INSTDIR\encoders"
        File ".\${FB2K}-extra\encoders\flac.exe"
        File ".\${FB2K}-extra\encoders\metaflac.exe"
    SectionEnd

    Section "WMA 编码器" EncWMA
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\WMAEncode.exe" 0 +3
        SetOutPath "$INSTDIR\encoders"
        File ".\${FB2K}-extra\encoders\WMAEncode.exe"
    SectionEnd

    Section "APE 编码器" EncAPE
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\mac.exe" 0 +3
        SetOutPath "$INSTDIR\encoders"
        File ".\${FB2K}-extra\encoders\mac.exe"
    SectionEnd

    Section "Opus 编码器" EncOPUS
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\opusenc.exe" 0 +3
        SetOutPath "$INSTDIR\encoders"
        File ".\${FB2K}-extra\encoders\opusenc.exe"
    SectionEnd
	
	Section "QAAC 编码器" EncQAAC
      SectionIn 1 3

      StrCmp $Update.Mode 1 0 +2
      IfFileExists "$INSTDIR\encoders\qaac.exe" 0 lb_done
      SetOutPath "$INSTDIR\encoders"
      File ".\${FB2K}-extra\encoders\qaac.exe"
      File ".\${FB2K}-extra\encoders\refalac.exe"
      File ".\${FB2K}-extra\encoders\libsoxr.dll"
      File ".\${FB2K}-extra\encoders\libsoxconvolver.dll"
      SetOutPath "$INSTDIR\encoders\QTfiles"
      File /r ".\${FB2K}-extra\encoders\QTfiles\*.*"
		lb_done:
    SectionEnd

    Section "OGG 编码器" EncOGG
        SectionIn 1 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\oggenc2.exe" 0 +3
        SetOutPath "$INSTDIR\encoders"
        File ".\${FB2K}-extra\encoders\oggenc2.exe"
    SectionEnd

    Section "WavePack 编码器" EncWAV
        SectionIn 1 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\wavpack.exe" 0 +3
        SetOutPath "$INSTDIR\encoders"
        File ".\${FB2K}-extra\encoders\wavpack.exe"
    SectionEnd

    Section /o "MPC 编码器" EncMPC
        SectionIn 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\mpcenc.exe" 0 +3
        SetOutPath "$INSTDIR\encoders"
        File ".\${FB2K}-extra\encoders\mpcenc.exe"
    SectionEnd

    Section /o "TAK 编码器" EncTAK
        SectionIn 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\Takc.exe" 0 +3
        SetOutPath "$INSTDIR\encoders"
        File ".\${FB2K}-extra\encoders\Takc.exe"
    SectionEnd

    Section /o "TTA 编码器" EncTTA
        SectionIn 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\ttaenc.exe" 0 +3
        SetOutPath "$INSTDIR\encoders"
        File ".\${FB2K}-extra\encoders\ttaenc.exe"
    SectionEnd
	
    Section /o "AAC 编码器(Nero)" EncAAC
        SectionIn 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\neroAacEnc.exe" 0 +3
        SetOutPath "$INSTDIR\encoders"
        File ".\${FB2K}-extra\encoders\neroAacEnc.exe"
    SectionEnd

    Section /o "xHE-AAC 编码器(exhale)" EncXHEAAC
        SectionIn 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\exhale.exe" 0 +3
        SetOutPath "$INSTDIR\encoders"
        File ".\${FB2K}-extra\encoders\exhale.exe"
    SectionEnd

    Section /o "AAC 编码器(Winamp FhG)" EncFHGAAC
        SectionIn 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\fhgaacenc.exe" 0 +3
        SetOutPath "$INSTDIR\encoders"
        File /r ".\${FB2K}-extra\encoders\fhgaac\*.*"
    SectionEnd

    Section /o "AAC 编码器(faac)" EncFAAC
        SectionIn 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\encoders\faac.exe" 0 +3
        SetOutPath "$INSTDIR\encoders"
        File ".\${FB2K}-extra\encoders\faac.exe"
    SectionEnd

SectionGroupEnd

SectionGroup "高级输出组件" AdvancedOutputComponents

    
    Section "ASIO+DSD 输出组件" ASIODSD
        SectionIn 1 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\user-components\foo_out_asio+dsd\foo_out_asio+dsd.dll" 0 +3
        SetOutPath "$INSTDIR\user-components\foo_out_asio+dsd"
        File /r ".\${FB2K}-extra\components\asio+dsd\*.*"
    SectionEnd
    
    Section /o "WASAPI 输出组件" WASAPI
        SectionIn 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\user-components\foo_out_wasapi\foo_out_wasapi.dll" 0 +3
        SetOutPath "$INSTDIR\user-components\foo_out_wasapi"
        File /r ".\${FB2K}-extra\components\wasapi\*.*"
    SectionEnd

    Section /o "ASIO 输出组件" ASIO
        SectionIn 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\user-components\foo_out_asio\foo_out_asio.dll" 0 +3
        SetOutPath "$INSTDIR\user-components\foo_out_asio"
        File /r ".\${FB2K}-extra\components\asio\*.*"
    SectionEnd

SectionGroupEnd

SectionGroup "增强版附加组件和程序" EnhancedAddOnsAndPrograms

    Section "Milkdrop2 可视化插件(要求DirectX 9.0)" Milkdrop2
        SectionIn 1 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\components\foo_vis_shpeck.dll" 0 lb_done
        SetOutPath "$INSTDIR\components"
        File ".\${FB2K}-extra\visualization\foo_vis_shpeck.dll"

        SetOutPath "$INSTDIR\configuration"
        File ".\${FB2K}-extra\visualization\foo_vis_shpeck.dll.cfg"

        SetOutPath "$INSTDIR\plugins"
        File /r ".\${FB2K}-extra\visualization\plugins\*.*"

        lb_done:
    SectionEnd

    Section "MusicTag 音乐标签管理插件" MusicTag
        SectionIn 1 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\assemblies\MusicTag\MusicTag.exe" 0 +3
        SetOutPath "$INSTDIR\assemblies\MusicTag"
        File /r ".\${FB2K}-extra\assemblies\MusicTag\*.*"
    SectionEnd

SectionGroupEnd

SectionGroup "默认界面DUI相关" DefaultInterfaceDuiRelated

    Section /o "专辑列表组件" AlbumList
        SectionIn 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\components\foo_albumlist.dll" 0 +3
        SetOutPath "$INSTDIR\components"
        File ".\${FB2K}-extra\components\foo_albumlist.dll"
    SectionEnd

    Section /o "预置主题集" DuiThemes
        SectionIn 3

        StrCmp $Update.Mode 1 0 +2
        IfFileExists "$INSTDIR\themes\*.fth" 0 +3
        SetOutPath "$INSTDIR\themes"
        File /r ".\${FB2K}-extra\themes\*.*"
    SectionEnd

SectionGroupEnd

Section "均衡器预置文件" EqualizerPresets
    SectionIn 1 2 3

    StrCmp $Update.Mode 1 0 +2
    IfFileExists "$INSTDIR\Equalizer Presets\*.feq" 0 +3
    SetOutPath "$INSTDIR\Equalizer Presets"
    File /r ".\${FB2K}-extra\Equalizer Presets\*.*"
SectionEnd

Section "文件关联" AssociateFiles
    SectionIn 1 2 3

    StrCmp $Update.Mode 1 +2
    Call AssociateFilesFunc
SectionEnd

SectionGroup "快捷方式" Shortcuts

    Section "桌面" ShortcutsDesktop
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +3
        SetShellVarContext current
        IfFileExists "$DESKTOP\${FB2K}.lnk" 0 +3
        SetShellVarContext current
        CreateShortCut "$DESKTOP\${FB2K}.lnk" "$INSTDIR\${FB2K}.exe"
    SectionEnd

    Section "开始菜单" ShortcutsPrograms
        SectionIn 1 2 3

        StrCmp $Update.Mode 1 0 +3
        SetShellVarContext current
        IfFileExists "$SMPROGRAMS\${FB2K}\*.lnk" 0 +5
        SetShellVarContext current
        CreateDirectory "$SMPROGRAMS\${FB2K}"
        CreateShortCut "$SMPROGRAMS\${FB2K}\${FB2K}.lnk" "$INSTDIR\${FB2K}.exe"
        CreateShortCut "$SMPROGRAMS\${FB2K}\卸载 ${FB2K}.lnk" "$INSTDIR\Uninstall.exe"
    SectionEnd

SectionGroupEnd

Section -Post
    # 获取安装目录读写权限
    AccessControl::GrantOnFile "$INSTDIR" "(BU)" "FullAccess"

    # 写入防火墙规则
    nsisFirewall::AddAuthorizedApplication "$INSTDIR\${FB2K}.exe" "${FB2K}"

    SetRegView 32
    WriteRegStr HKLM "${FBOX_KEY_UNINST}" "DisplayName"     "${FB2K}"
    WriteRegStr HKLM "${FBOX_KEY_UNINST}" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "${FBOX_KEY_UNINST}" "DisplayIcon"     "$INSTDIR\${FB2K}.exe"
    WriteRegStr HKLM "${FBOX_KEY_UNINST}" "DisplayVersion"  "${FBOX_VER}"
    WriteRegStr HKLM "${FBOX_KEY_UNINST}" "URLInfoAbout"    "${FBOX_WEB}"
    WriteRegStr HKLM "${FBOX_KEY_UNINST}" "Publisher"       "${FBOX_PUB}"
    SetRegView lastused

    # 获取安装段的大小(KB)写入注册表
    SectionGetSize ${CoreFiles} $R0

    SetRegView 32
    WriteRegDWORD HKLM "${FBOX_KEY_UNINST}" "EstimatedSize" "$R0"
    WriteRegStr   HKLM "${FBOX_KEY_APPDIR}" "" "$INSTDIR\${FB2K}.exe"
    SetRegView lastused

    System::Call 'shell32::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)'
SectionEnd

# --- Install Function ---

Function .onInit
    InitPluginsDir
	System::Call 'SHCore::SetProcessDpiAwareness(i 1)i.R0'
    File "/oname=$PLUGINSDIR\install.ico"     ".\resource\install.ico"
    File "/oname=$PLUGINSDIR\license.rtf"     ".\resource\license.rtf"
    File "/oname=$PLUGINSDIR\wizard-fb2k.bmp" ".\resource\wizard-fb2k.bmp"

    StrCpy $Dialog.Caption "$(^NameDA) 安装向导"

    # 创建互斥防止重复运行
    System::Call `kernel32::CreateMutex(i0,i0,t"${FBOX}_installer")i.r1?e`
    Pop $R0
    StrCmp $R0 0 +3
    MessageBox MB_OK|MB_ICONEXCLAMATION "安装程序已经运行！"
    Abort

    # 系统版本低于 Win7
    ${If} ${AtMostWin2008}
    MessageBox MB_OK|MB_ICONEXCLAMATION "本程序不支持 Windows 7 以下版本的系统！"
    Abort
    ${EndIf}
FunctionEnd

Function onGUIInit  # 升级模式
    ClearErrors
    ReadRegStr $R0 HKLM "${FBOX_KEY_UNINST}" "DisplayVersion"
    ${Unless} ${Errors}
    ${AndUnless} ${Cmd} `MessageBox MB_ICONINFORMATION|MB_YESNO "检测到您的计算机上安装了 ${FBOX} $R0，是否直接覆盖升级？ $\n$\n点击“是”执行覆盖升级操作；点击“否”执行全新安装操作。" /SD IDYES IDNO`
        StrCpy $Dialog.Caption        "$(^NameDA) 升级"
        StrCpy $Update.Header.Text    "正在升级"
        StrCpy $Update.Header.SubText "$(^NameDA) 正在升级，请稍候。"
        StrCpy $Update.Finish.Text    "升级完成"
        StrCpy $Update.Finish.SubText "升级程序已成功地运行完成。"
        StrCpy $Update.Abort.Text     "升级中止"
        StrCpy $Update.Abort.SubText  "升级程序未成功地运行完成。"
        StrCpy $Finish.Info.Title     "完成 $(^NameDA) 升级程序"
        StrCpy $Finish.Info.Text      "恭喜！$(^NameDA) 已升级成功！$\r$\n$\r$\n单击 [完成(&F)] 关闭此向导。"
        StrCpy $Update.Mode 1
    ${Else}
        StrCpy $Dialog.Caption        "$(^NameDA) 安装"
        StrCpy $Update.Header.Text    "$(MUI_TEXT_INSTALLING_TITLE)"
        StrCpy $Update.Header.SubText "$(MUI_TEXT_INSTALLING_SUBTITLE)"
        StrCpy $Update.Finish.Text    "$(MUI_TEXT_FINISH_TITLE)"
        StrCpy $Update.Finish.SubText "$(MUI_TEXT_FINISH_SUBTITLE)"
        StrCpy $Update.Abort.Text     "$(MUI_TEXT_ABORT_TITLE)"
        StrCpy $Update.Abort.SubText  "$(MUI_TEXT_ABORT_SUBTITLE)"
        StrCpy $Finish.Info.Title     "$(MUI_TEXT_FINISH_INFO_TITLE)"
        StrCpy $Finish.Info.Text      "$(MUI_TEXT_FINISH_INFO_TEXT)"
    ${EndUnless}
FunctionEnd

Function VerifyUpdateMode
    ${If} $Update.Mode <> 0
        Abort
    ${EndIf}
FunctionEnd

Function .onSelChange  # 安装组件设置
    SectionGetFlags ${EncMP3}    $0
    SectionGetFlags ${EncFLAC}   $1
    SectionGetFlags ${EncWMA}    $2
    SectionGetFlags ${EncAPE}    $3
    SectionGetFlags ${EncOPUS}   $4
    SectionGetFlags ${EncAAC}    $5
    SectionGetFlags ${EncOGG}    $6
    SectionGetFlags ${EncWAV}    $7
    SectionGetFlags ${EncMPC}    $8
    SectionGetFlags ${EncTAK}    $9
    SectionGetFlags ${EncTTA}    $R1
    SectionGetFlags ${EncXHEAAC} $R2
    SectionGetFlags ${EncFAAC}   $R3
    SectionGetFlags ${EncFHGAAC} $R4
	SectionGetFlags ${EncQAAC}	 $R5
    SectionGetFlags ${Converter} $R0
    SectionGetFlags ${DuiThemes} $R9

    StrCmp $0 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $1 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $2 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $3 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $4 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $5 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $6 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $7 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $8 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $9 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $R1 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $R2 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $R3 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $R4 1 0 +2
	SectionSetFlags ${Converter} 1
    StrCmp $R5 1 0 +2
    SectionSetFlags ${Converter} 1
    StrCmp $R0 0 0 +2
    SectionSetFlags ${ConverterCfg} 0
    StrCmp $R9 1 0 +2
    SectionSetFlags ${AlbumList} 1
FunctionEnd

# --- Mui Description Text ---

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${CoreFiles}                  "安装 ${FB2K}"
    !insertmacro MUI_DESCRIPTION_TEXT ${CoreProfile}                "${FB2K} 核心配置文件"
    !insertmacro MUI_DESCRIPTION_TEXT ${LyricsCfg}                  "ESLyric 歌词配置文件"
    !insertmacro MUI_DESCRIPTION_TEXT ${ConverterCfg}               "转换器配置文件"
    !insertmacro MUI_DESCRIPTION_TEXT ${ExtraDecoder}               "额外解码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${DecAPE}                     "APE 解码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${DecDTS}                     "DTS 解码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${DecSACD}                    "DSD/SACD 解码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${DecTTA}                     "TTA 解码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${DecTAK}                     "TAK 解码器"
#    !insertmacro MUI_DESCRIPTION_TEXT ${DecDVDA}                    "DVD-Audio 解码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${DecFDKAAC}                  "fdk-aac packet 解码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${OptionalComponents}         "可选组件"
    !insertmacro MUI_DESCRIPTION_TEXT ${Converter}                  "转换器"
    !insertmacro MUI_DESCRIPTION_TEXT ${FileOps}                    "文件操作"
    !insertmacro MUI_DESCRIPTION_TEXT ${UnPack}                     "压缩包读取器"
    !insertmacro MUI_DESCRIPTION_TEXT ${Rgscan}                     "播放增益扫描器"
    !insertmacro MUI_DESCRIPTION_TEXT ${Freedb}                     "Freedb 标签获取器"
    !insertmacro MUI_DESCRIPTION_TEXT ${UPnP}                       "UPnP\DLNA 支持插件"
    !insertmacro MUI_DESCRIPTION_TEXT ${Encoders}                   "格式转换编码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncMP3}                     "MP3 编码器(lame)"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncFLAC}                    "FLAC 编码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncWMA}                     "WMA 编码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncAPE}                     "APE 编码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncOPUS}                    "Opus 编码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncAAC}                     "AAC 编码器(Nero)"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncQAAC}                  	"QAAC 编码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncFHGAAC}                  "AAC 编码器(Winamp FhG)"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncOGG}                     "OGG 编码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncWAV}                     "WavePack 编码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncMPC}                     "MPC 编码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncTAK}                     "TAK 编码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncTTA}                     "TTA 编码器"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncXHEAAC}                  "AAC 编码器(xHE-AAC, exhale)"
    !insertmacro MUI_DESCRIPTION_TEXT ${EncFAAC}                    "AAC 编码器(faac)"
    !insertmacro MUI_DESCRIPTION_TEXT ${AdvancedOutputComponents}   "高级输出组件"
    !insertmacro MUI_DESCRIPTION_TEXT ${WASAPI}                     "WASAPI 输出组件"
    !insertmacro MUI_DESCRIPTION_TEXT ${ASIO}                       "ASIO 输出组件"
    !insertmacro MUI_DESCRIPTION_TEXT ${ASIODSD}                    "ASIO+DSD 输出组件"
    !insertmacro MUI_DESCRIPTION_TEXT ${EnhancedAddOnsAndPrograms}  "增强版附加组件和程序"
    !insertmacro MUI_DESCRIPTION_TEXT ${Milkdrop2}                  "Milkdrop2 可视化插件(要求DirectX 9.0)"
    !insertmacro MUI_DESCRIPTION_TEXT ${MusicTag}                   "MusicTag 音乐标签管理插件"
    !insertmacro MUI_DESCRIPTION_TEXT ${DefaultInterfaceDuiRelated} "默认界面 DUI 相关组件"
    !insertmacro MUI_DESCRIPTION_TEXT ${AlbumList}                  "专辑列表组件"
    !insertmacro MUI_DESCRIPTION_TEXT ${DuiThemes}                  "预置主题集"
    !insertmacro MUI_DESCRIPTION_TEXT ${EqualizerPresets}           "均衡器预置文件"
    !insertmacro MUI_DESCRIPTION_TEXT ${AssociateFiles}             "关联常见音频文件"
    !insertmacro MUI_DESCRIPTION_TEXT ${Shortcuts}                  "创建快捷方式"
    !insertmacro MUI_DESCRIPTION_TEXT ${ShortcutsDesktop}           "创建桌面快捷方式"
    !insertmacro MUI_DESCRIPTION_TEXT ${ShortcutsPrograms}          "创建开始菜单程序组快捷方式"
    !insertmacro MUI_FUNCTION_DESCRIPTION_END

# --- Uninst Section ---

Section Uninstall
    # 进程清理
    !insertmacro ProcessCleanup

    # 删除防火墙规则
    nsisFirewall::RemoveAuthorizedApplication "$INSTDIR\${FB2K}.exe"

    # 反注册dll
    ${If} ${RunningX64}
    ${DisableX64FSRedirection}
    ExecWait `"$SYSDIR\regsvr32.exe" /s /u "$INSTDIR\ShellExt64.dll"`
    ExecWait `"$SYSDIR\regsvr32.exe" /s /u "$INSTDIR\user-components\foo_input_sacd\dsd_transcoder_x64.dll"`
    ${EnableX64FSRedirection}
    ${EndIf}

    UnRegDLL "$INSTDIR\ShellExt32.dll"
    UnRegDLL "$INSTDIR\user-components\foo_input_sacd\dsd_transcoder.dll"

    # 解除文件关联
    ExecWait `"$INSTDIR\foobar2000 Shell Associations Updater.exe" /sanitize`

    # 删除安装文件
    RMDir /r "$INSTDIR\assemblies"
    RMDir /r "$INSTDIR\cache"
    RMDir /r "$INSTDIR\components"
    RMDir /r "$INSTDIR\configuration"
    RMDir /r "$INSTDIR\crash reports"
    RMDir /r "$INSTDIR\doc"
    RMDir /r "$INSTDIR\encoders"
    RMDir /r "$INSTDIR\Equalizer Presets"
    RMDir /r "$INSTDIR\filters"
    RMDir /r "$INSTDIR\icons"
    RMDir /r "$INSTDIR\plugins"
    RMDir /r "$INSTDIR\runtime"
    RMDir /r "$INSTDIR\themes"
    RMDir /r "$INSTDIR\user-components"

    Delete "$INSTDIR\avcodec-fb2k-58.dll"
    Delete "$INSTDIR\avutil-fb2k-56.dll"
    Delete "$INSTDIR\concrt140.dll"
    Delete "$INSTDIR\dsound.dll"
    Delete "$INSTDIR\foo_upnp.xml"
    Delete "$INSTDIR\LargeFieldsConfig.txt"
	Delete "$INSTDIR\libwebp-fb2k.dll"
    Delete "$INSTDIR\msvcp140.dll"
    Delete "$INSTDIR\msvcp140_1.dll"
    Delete "$INSTDIR\msvcp140_2.dll"
    Delete "$INSTDIR\msvcp140_codecvt_ids.dll"
    Delete "$INSTDIR\PP-UWP-Interop.dll"
    Delete "$INSTDIR\shared.dll"
    Delete "$INSTDIR\ShellExt32.dll"
    Delete "$INSTDIR\ShellExt64.dll"
    Delete "$INSTDIR\theme.fth"
    Delete "$INSTDIR\vccorlib140.dll"
    Delete "$INSTDIR\vcruntime140.dll"
    Delete "$INSTDIR\version.txt"
    Delete "$INSTDIR\zlib1.dll"
    Delete "$INSTDIR\running"
    Delete "$INSTDIR\foobox帮助.CHM"
    Delete "$INSTDIR\foobar2000.exe"
    Delete "$INSTDIR\foobar2000 Shell Associations Updater.exe"

    Delete "$INSTDIR\Uninstall.exe"

    # 删除桌面快捷方式
    SetShellVarContext current
    Delete "$DESKTOP\${FB2K}.lnk"

    # 删除开始菜单程序组快捷方式
    SetShellVarContext current
    Delete "$SMPROGRAMS\${FB2K}\${FB2K}.lnk"
    Delete "$SMPROGRAMS\${FB2K}\卸载 ${FB2K}.lnk"

    SetShellVarContext current
    RMDir "$SMPROGRAMS\${FB2K}"

    # 删除注册表
    SetRegView 32
    DeleteRegKey HKLM "${FBOX_KEY_APPDIR}"
    DeleteRegKey HKLM "${FBOX_KEY_UNINST}"
    SetRegView lastused

    SetRegView 32
    DeleteRegKey HKLM "SOFTWARE\ASIO"
    SetRegView lastused

    DeleteRegKey HKLM "SOFTWARE\Classes\Applications\${FB2K}.exe"
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\${FB2K}"

    DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlers\PlayMusicFilesOnArrival" "${FB2K}"
    DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlers\UnknownContentOnArrival" "${FB2K}"

    # 是否保留用户文件
    MessageBox MB_YESNO|MB_ICONQUESTION "是否保留媒体库数据、播放列表、封面、歌词及下载的内容？$\n$\n若要保留这些文件，请点击“是”按钮。 $\n$\n注意：不会保留configuration文件夹下的配置文件！" /SD IDYES IDNO lb_delete

    Goto lb_done

    lb_delete:
    # 删除使用数据
    !insertmacro DataCleanup

    lb_done:
    RMDir "$INSTDIR"

    System::Call 'shell32::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)'

    SetAutoClose true
SectionEnd

# --- Uninst Function ---

Function un.onInit
    InitPluginsDir
	System::Call 'SHCore::SetProcessDpiAwareness(i 1)i.R0'
	
    # 创建互斥防止重复运行
    System::Call `kernel32::CreateMutex(i 0, i 0, t "${FBOX}_uninstaller") i .r1 ?e`
    Pop $R0
    StrCmp $R0 0 +3
    MessageBox MB_OK|MB_ICONEXCLAMATION "卸载程序已经运行！"
    Abort
FunctionEnd