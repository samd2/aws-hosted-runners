#!/bin/bash        

set -ex
echo "Input is ${{ inputs.self_hosted_runners_override }}"
if [ ${{ inputs.self_hosted_runners_override }} == "true" ]; then
    self_hosted_runners="true"
    echo "Override is true"
elif [ ${{ inputs.self_hosted_runners_override }} == "false" ]; then
    self_hosted_runners="false"
    echo "Override is false"
else
    checkweb=$(curl --connect-timeout 3 ${{ inputs.self_hosted_runners_url }}) || true
    if [ $checkweb == "true" ]; then
        self_hosted_runners="true"
        echo "Web sets the value to true"
    elif [ $checkweb == "false" ]; then
        self_hosted_runners="false"
        echo "Web sets the value to false"
    else
        # the default
        self_hosted_runners="false"
        echo "The default value is set to false"
    fi
fi

supported_images_linux="ubuntu-latest"
for i in {14..44}
do
  new_image="ubuntu-${i}.04"
  supported_images_linux="${supported_images_linux} ${new_image}"
  new_image="ubuntu-${i}.10"
  supported_images_linux="${supported_images_linux} ${new_image}"
done

supported_images_windows="windows-latest"
for i in {14..44}
do
  new_image="windows-20${i}"
  supported_images_windows="${supported_images_windows} ${new_image}"
done

supported_images_macos="macos-latest"
for i in {11..44}
do
  new_image="macos-${i}"
  supported_images_macos="${supported_images_macos} ${new_image}"
done

labelmatrix="{ "

if [ ${self_hosted_runners} == "true" ]; then
  for image in ${supported_images_linux}; do 
    # basicimage=$( echo "$image" | sed -e 's/[-.]/_/g' )
    basicimage=${image}
    labelmatrix="$labelmatrix \"${basicimage}\": [ \"self-hosted\", \"linux\", \"x64\", \"${image}-aws\" ], " 
  done
  for image in ${supported_images_windows}; do 
    # basicimage=$( echo "$image" | sed -e 's/[-.]/_/g' )
    basicimage=${image}
    labelmatrix="$labelmatrix \"${basicimage}\": [ \"self-hosted\", \"windows\", \"x64\", \"${image}-aws\" ], " 
  done
  # Note: macos is not using "self-hosted" currently:
  for image in ${supported_images_macos}; do
    # basicimage=$( echo "$image" | sed -e 's/[-.]/_/g' )
    basicimage=${image}
    labelmatrix="$labelmatrix \"${basicimage}\": [ \"${image}\" ], "
  done
else
  for image in ${supported_images_linux}; do
    # basicimage=$( echo "$image" | sed -e 's/[-.]/_/g' )
    basicimage=${image}
    labelmatrix="$labelmatrix \"${basicimage}\": [ \"${image}\" ], "
  done
  for image in ${supported_images_windows}; do
    # basicimage=$( echo "$image" | sed -e 's/[-.]/_/g' )
    basicimage=${image}
    labelmatrix="$labelmatrix \"${basicimage}\": [ \"${image}\" ], "
  done
  for image in ${supported_images_macos}; do
    # basicimage=$( echo "$image" | sed -e 's/[-.]/_/g' )
    basicimage=${image}
    labelmatrix="$labelmatrix \"${basicimage}\": [ \"${image}\" ], "
  done
fi

labelmatrix=$( echo "$labelmatrix" | sed 's/,\s*$//' )
labelmatrix="$labelmatrix }"
echo "labelmatrix=$labelmatrix" >> $GITHUB_OUTPUT