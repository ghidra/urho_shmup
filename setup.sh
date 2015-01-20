#!/bin/bash

#setup.sh /Urho3D_Source /Urho_Build
#needs 2 arguents, the source folder, then the build folder

make_alias(){
  #$1 FOLDER $2 LINKEDFOLDER $3 NEWFOLDER
  if [ ! -e $3 ];then
    #link does not exist, we can make it
    ln -s $2 $3
    echo "          -"$1" folder linked"
  else
    echo "          -"$1" folder found"
  fi
}

make_alias_file(){
  if [ ! -L $3 ];then
    ln -s $2 $3
    echo "          -"$1" file linked"
  else
    echo "          -"$1" file found"
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
    make_alias "CoreData" $URHOPATH"/bin/CoreData" $URHOBUILD"/bin/CoreData"
    make_alias "Data" $URHOPATH"/bin/Data" $URHOBUILD"/bin/Data"

    #make the resources folders if they dont exist
    echo "     -create Resources folders"
    make_folder "/Resources" $URHOBUILD"/bin"
    make_folder "/Resources/Materials" $URHOBUILD"/bin"
    make_folder "/Resources/Models" $URHOBUILD"/bin"
    make_folder "/Resources/RenderPaths" $URHOBUILD"/bin"
    make_folder "/Resources/Scripts" $URHOBUILD"/bin"
    make_folder "/Resources/Shaders" $URHOBUILD"/bin"
    make_folder "/Resources/Shaders/GLSL" $URHOBUILD"/bin"
    make_folder "/Resources/Techniques" $URHOBUILD"/bin"

    echo "     -create project links"
    for Dir in $(find $SCRIPTPATH* -mindepth 1 -maxdepth 1 -not -path '*/\.*' -type d );
    do
        FOLDER=$(basename $Dir);
        case $FOLDER in
          "Scripts")make_alias $FOLDER $SCRIPTPATH"/"$FOLDER $URHOBUILD"/bin/Resources/"$FOLDER"/shmup" ;;
          "RenderPaths") make_alias $FOLDER $SCRIPTPATH"/"$FOLDER $URHOBUILD"/bin/Resources/"$FOLDER"/shmup" ;;
          "Techniques") make_alias $FOLDER $SCRIPTPATH"/"$FOLDER $URHOBUILD"/bin/Resources/"$FOLDER"/shmup" ;;
          "Shaders") make_alias $FOLDER $SCRIPTPATH"/"$FOLDER"/GLSL" $URHOBUILD"/bin/Resources/"$FOLDER"/GLSL/shmup" ;;
          "Materials") make_alias $FOLDER $SCRIPTPATH"/"$FOLDER $URHOBUILD"/bin/Resources/"$FOLDER"/shmup" ;;
          "Models") make_alias $FOLDER $SCRIPTPATH"/"$FOLDER $URHOBUILD"/bin/Resources/"$FOLDER"/shmup" ;;
          *) echo "          -ignore:" $FOLDER ;;
        esac

    done

    echo "     -link required shader includes"
    make_alias_file "Uniforms.glsl" $URHOPATH"/bin/CoreData/Shaders/GLSL/Uniforms.glsl" $SCRIPTPATH"/Shaders/GLSL/Uniforms.glsl"
    make_alias_file "Samplers.glsl" $URHOPATH"/bin/CoreData/Shaders/GLSL/Samplers.glsl" $SCRIPTPATH"/Shaders/GLSL/Samplers.glsl"
    make_alias_file "Transform.glsl" $URHOPATH"/bin/CoreData/Shaders/GLSL/Transform.glsl" $SCRIPTPATH"/Shaders/GLSL/Transform.glsl"
    make_alias_file "Lighting.glsl" $URHOPATH"/bin/CoreData/Shaders/GLSL/Lighting.glsl" $SCRIPTPATH"/Shaders/GLSL/Lighting.glsl"
    make_alias_file "ScreenPos.glsl" $URHOPATH"/bin/CoreData/Shaders/GLSL/ScreenPos.glsl" $SCRIPTPATH"/Shaders/GLSL/ScreenPos.glsl"
    make_alias_file "Fog.glsl" $URHOPATH"/bin/CoreData/Shaders/GLSL/Fog.glsl" $SCRIPTPATH"/Shaders/GLSL/Fog.glsl"

    #make or edit the launch script
    LAUNCH=$URHOBUILD"/bin/Urho3DPlayer /Scripts/shmup/Main.as -pp "$URHOBUILD"/bin -p \"CoreData;Data;Resources\""
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
