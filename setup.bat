@echo OFF
setlocal EnableDelayedExpansion

Echo ***********************************

if NOT "%1"=="" (
  if NOT "%2"=="" (

    if 1==0 (
      Echo Launch dir: "%~dp0"
      Echo Current dir: "%CD%"
      Echo Passed in dir: "%1"
    )

    SET URHOPATH=%1
    SET URHOBUILD=%2

    if exist "!URHOPATH!" (
      if exist "!URHOBUILD!" (
        echo being build process

        SET "URHOBINPATH=!URHOPATH!\Bin\"
        SET "URHODATAPATH=!URHOPATH!\Bin\Data\"
        SET "URHOCOREDATAPATH=!URHOPATH!\Bin\CoreData\"

        if 1==0 (
          echo valid path "!URHOPATH!"
          echo bin: "!URHOBINPATH!"
          echo data: "!URHODATAPATH!"
          echo core: "!URHOCOREDATAPATH!"
        )

        echo      -link CoreData and Data folders
        call:makeAlias "CoreData" "!URHOCOREDATAPATH!" "!URHOBUILD!\Bin\CoreData"
        call:makeAlias "Data" "!URHODATAPATH!" "!URHOBUILD!\Bin\Data"

        echo      -create Resource folders
        call:makeFolder "\Resources" "!URHOBUILD!\Bin"
        call:makeFolder "\Resources\Materials" "!URHOBUILD!\Bin"
        call:makeFolder "\Resources\Models" "!URHOBUILD!\Bin"
        call:makeFolder "\Resources\RenderPaths" "!URHOBUILD!\Bin"
        call:makeFolder "\Resources\Scripts" "!URHOBUILD!\Bin"
        call:makeFolder "\Resources\Shaders" "!URHOBUILD!\Bin"
        call:makeFolder "\Resources\Shaders\GLSL" "!URHOBUILD!\Bin"
        call:makeFolder "\Resources\Techniques" "!URHOBUILD!\Bin"

        echo      -create project links
        for /D %%f in (*.*) do (
          SET FOLDER=%~dp0%%f
          ::http://stackoverflow.com/questions/17279114/split-path-and-take-last-folder-name-in-batch-script
          set MYDIR=!FOLDER:~0!
          for %%f in (!MYDIR!) do set myfolder=%%~nxf
          if "!myfolder!"=="Scripts" call:makeAlias "!myfolder!" "!FOLDER!" "!URHOBUILD!\Bin\Resources\!myfolder!\shmup"
          if "!myfolder!"=="RenderPaths" call:makeAlias "!myfolder!" "!FOLDER!" "!URHOBUILD!\Bin\Resources\!myfolder!\shmup"
          if "!myfolder!"=="Techniques" call:makeAlias "!myfolder!" "!FOLDER!" "!URHOBUILD!\Bin\Resources\!myfolder!\shmup"
          if "!myfolder!"=="Shaders" call:makeAlias "!myfolder!" "!FOLDER!\GLSL" "!URHOBUILD!\Bin\Resources\!myfolder!\GLSL\shmup"
          if "!myfolder!"=="Materials" call:makeAlias "!myfolder!" "!FOLDER!" "!URHOBUILD!\Bin\Resources\!myfolder!\shmup"
          if "!myfolder!"=="Models" call:makeAlias "!myfolder!" "!FOLDER!" "!URHOBUILD!\Bin\Resources\!myfolder!\shmup"

        )

        echo      -link required shader includes
        call:makeAliasFile "Uniforms.glsl" "!URHOCOREDATAPATH!Shaders\GLSL\Uniforms.glsl" "%~dp0%Shaders\GLSL\Uniforms.glsl"
        call:makeAliasFile "Samplers.glsl" "!URHOCOREDATAPATH!Shaders\GLSL\Samplers.glsl" "%~dp0%Shaders\GLSL\Samplers.glsl"
        call:makeAliasFile "Transform.glsl" "!URHOCOREDATAPATH!Shaders\GLSL\Transform.glsl" "%~dp0%Shaders\GLSL\Transform.glsl"
        call:makeAliasFile "ScreenPos.glsl" "!URHOCOREDATAPATH!Shaders\GLSL\ScreenPos.glsl" "%~dp0%Shaders\GLSL\ScreenPos.glsl"
        call:makeAliasFile "Lighting.glsl" "!URHOCOREDATAPATH!Shaders\GLSL\Lighting.glsl" "%~dp0%Shaders\GLSL\Lighting.glsl"
        call:makeAliasFile "Fog.glsl" "!URHOCOREDATAPATH!Shaders\GLSL\Fog.glsl" "%~dp0%Shaders\GLSL\Fog.glsl"

        echo      -launch.bat
        SET LAUNCH=!URHOBUILD!\Bin\Urho3DPlayer /Scripts/shmup/Main.as -pp !URHOBUILD!\Bin -p "CoreData;Data;Resources"
        if exist "launch.bat" (
          echo !LAUNCH! > launch.bat
          echo           -launch.bat edited
        ) else (
          echo. 2>launch.bat
          echo !LAUNCH! > launch.bat
          echo           -launch.bat created
        )



      ) else (
          echo invalid build path given "%URHOBUILD%"
      )
    ) else (
      echo invalid source path given: "!URHOPATH!"
    )
  ) else (
    Echo second argument required, urho build path
  )

) else (

  Echo no arguments given, please provide:
  Echo      -urho source path
  Echo      -urho build path

)

Echo ***********************************

GOTO:EOF

:makeAlias
if exist %~3 (
  echo           -%~1 already exists
) else (
  mklink /J %~3 %~2
)
GOTO:EOF

:makeAliasFile
if exist %~3 (
  echo           -%~1 already exists
) else (
  mklink /H %~3 %~2
)
GOTO:EOF

:makeFolder
if exist %~2%~1 (
  echo           -%~1 already exists
) else (
  mkdir %~2%~1
  echo           -%~1 created
)
GOTO:EOF
