#!/bin/bash

#setup.sh /Urho3D_Source /Urho_Build
#needs 2 arguents, the source folder, then the build folder

make_alias(){
  #$1 FOLDER $2 LINKEDFOLDER $3 NEWFOLDER
  if [ ! -e $3 ];then
    #link does not exist, we can make it
    ln -s $2 $3
    echo "          -"$1" linked"
  else
    echo "          -"$1" found"
  fi
}

link_folder(){
  if [ ! -d $3$1 ];then
    ln -s $2$1 $3$1
    echo "          -"$1" folder linked"
  else
    echo "          -"$1" folder found"
  fi
}

make_folder(){
  if [ ! -d $2$1 ];then
    mkdir $2$1
    echo "          -"$1" folder created"
  else
    echo "          -"$1" folder found"
  fi
}

URHOPATH=$1
URHOBUILD=$2
#first make sure that the given folder is good

if [ $# -eq 0 ];then
  echo "***********************************"
  echo "no arguments given, please provide:"
  echo "     -urho source path"
  echo "     -urho build path"
  echo "***********************************"
else
  if [[ ( -d $URHOPATH ) && ( -d $URHOBUILD ) ]];then

    echo "***********************************"
    echo "begun setup process"

    # Absolute path this script is in, thus /home/user/bin
    SCRIPT=$(readlink -f "$0")
    SCRIPTPATH=$(dirname "$SCRIPT")

    #link the data and core data folder
    echo "     -link CoreData and Data folders"
    make_alias "CoreData" $URHOPATH"/Bin/CoreData" $URHOBUILD"/Bin/CoreData"
    make_alias "Data" $URHOPATH"/Bin/Data" $URHOBUILD"/Bin/Data"

    #make the resources folders if they dont exist
    echo "     -create Resources folders"
    make_folder "/Resources" $URHOBUILD"/Bin"
    make_folder "/Resources/Materials" $URHOBUILD"/Bin"
    make_folder "/Resources/Models" $URHOBUILD"/Bin"
    make_folder "/Resources/RenderPaths" $URHOBUILD"/Bin"
    make_folder "/Resources/Scripts" $URHOBUILD"/Bin"
    make_folder "/Resources/Shaders" $URHOBUILD"/Bin"
    make_folder "/Resources/Shaders/GLSL" $URHOBUILD"/Bin"
    make_folder "/Resources/Techniques" $URHOBUILD"/Bin"

    echo "     -create project links"
    for Dir in $(find $SCRIPTPATH* -mindepth 1 -maxdepth 1 -not -path '*/\.*' -type d );
    do
        FOLDER=$(basename $Dir);
        case $FOLDER in
          "Scripts")make_alias $FOLDER $SCRIPTPATH"/"$FOLDER $URHOBUILD"/Bin/Resources/"$FOLDER"/shmup" ;;
          "RenderPaths") make_alias $FOLDER $SCRIPTPATH"/"$FOLDER $URHOBUILD"/Bin/Resources/"$FOLDER"/shmup" ;;
          "Techniques") make_alias $FOLDER $SCRIPTPATH"/"$FOLDER $URHOBUILD"/Bin/Resources/"$FOLDER"/shmup" ;;
          "Shaders") make_alias $FOLDER $SCRIPTPATH"/"$FOLDER"/GLSL" $URHOBUILD"/Bin/Resources/"$FOLDER"/GLSL/shmup" ;;
          "Materials") make_alias $FOLDER $SCRIPTPATH"/"$FOLDER $URHOBUILD"/Bin/Resources/"$FOLDER"/shmup" ;;
          "Models") make_alias $FOLDER $SCRIPTPATH"/"$FOLDER $URHOBUILD"/Bin/Resources/"$FOLDER"/shmup" ;;
          *) echo "          -ignore:" $FOLDER ;;
        esac

    done

    echo "     -link required shader includes"
    make_alias "Uniforms.glsl" $URHOPATH"/Bin/CoreData/Shaders/GLSL/Uniforms.glsl" $SCRIPTPATH"/Shaders/GLSL/Uniforms.glsl"
    make_alias "Samplers.glsl" $URHOPATH"/Bin/CoreData/Shaders/GLSL/Samplers.glsl" $SCRIPTPATH"/Shaders/GLSL/Samplers.glsl"
    make_alias "Transform.glsl" $URHOPATH"/Bin/CoreData/Shaders/GLSL/Transform.glsl" $SCRIPTPATH"/Shaders/GLSL/Transform.glsl"
    make_alias "ScreenPos.glsl" $URHOPATH"/Bin/CoreData/Shaders/GLSL/ScreenPos.glsl" $SCRIPTPATH"/Shaders/GLSL/ScreenPos.glsl"
    make_alias "Lighting.glsl" $URHOPATH"/Bin/CoreData/Shaders/GLSL/Lighting.glsl" $SCRIPTPATH"/Shaders/GLSL/Lighting.glsl"
    make_alias "Fog.glsl" $URHOPATH"/Bin/CoreData/Shaders/GLSL/Fog.glsl" $SCRIPTPATH"/Shaders/GLSL/Fog.glsl"

    #make or edit the launch script
    LAUNCH=$URHOBUILD"/Bin/Urho3DPlayer /Scripts/shmup/Main.as -pp "$URHOBUILD"/Bin -p \"CoreData;Data;Resources\""
    FILE=$SCRIPTPATH/launch.sh
    if [ -f "$FILE" ];then
      printf "$LAUNCH" > $FILE
      echo "     -launch.sh edited"
    else
      touch $FILE
      printf "$LAUNCH" > $FILE
      echo "     -launch.sh created"
    fi
    echo "          -alias: sh "$SCRIPTPATH"/launch.sh"

    echo "***********************************"

  else
    echo "***********************************"
    echo "invalid path or paths given:"
    echo "     -source:" $URHOPATH
    echo "     -build:" $URHOBUILD
    echo "***********************************"
  fi
fi
