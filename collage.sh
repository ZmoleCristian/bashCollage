#!/bin/bash

read -p "Enter the path to the directory containing the images you want to use (default current working directory):" input_dir
read -p "Enter the path to the directory where you want to save the collage (default current working directory):" output_dir

if [ -z "$input_dir" ]; then
  input_dir="$(pwd)/"
fi

if [ -z "$output_dir" ]; then
  output_dir="$(pwd)/"
fi

if [ ! -d "$input_dir" ]; then
  echo "Input directory does not exist"
  exit 1
fi

if [ ! -d "$output_dir" ]; then
  echo "Output directory does not exist"
  exit 1
fi

if [ -z "$(ls -A "$input_dir"/*.{jpg,jpeg,png,webp,gif,tiff,bmp,JPG,JPEG,PNG,WEBP,GIF,TIFF,BMP} &>/dev/null) " ]; then
  echo "Input directory does not contain images"
  exit 1
fi

if [ ! -w "$output_dir" ]; then
  echo "Output directory is not writable"
  exit 1
fi

read -p "Enter the name of the collage image (default is collage.jpg):" output_image

if [ -z "$output_image" ]; then
  output_image="collage.jpg"
fi
if [ -f "$output_dir/$output_image" ]; then
  read -p "File already exists. Do you want to overwrite it? (y/n):" overwrite
  if [ "$overwrite" != "y" ]; then
    echo "Exiting"
    exit 1
  fi
fi

read -p "What percentage of the original size do you want the images to be? (default is 50%): " choice
if [ -z "$choice" ]; then
  choice=50
fi

if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
  echo "error: Not a number" >&2
  exit 1
fi

read -p "How many images per line do you want? (default is 5): " grid
if [ -z "$grid" ]; then
  grid=5
fi

if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
  echo "error: Not a number" >&2
  exit 1
fi

images=$(find "$input_dir" -maxdepth 1 -type f -name "*.jpg" -o -name "*.JPG" -o -name "*.jpeg" -o -name "*.JPEG" -o -name "*.png" -o -name "*.PNG" -o -name "*.tiff" -o -name "*.TIFF" -o -name "*.bmp" -o -name "*.BMP" >tmplist)
sed 's/.*/"&"/' tmplist >imglist
num_images=$(wc -l <imglist)
if [ $((num_images % grid)) -eq 0 ]; then
  num_rows=$((num_images / grid))
else
  num_rows=$((num_images / grid + 1))
fi

echo "Creating a collage with $num_images images in $num_rows rows"

montage @imglist -resize "$choice"% -tile "$grid"x"$num_rows" "$output_dir$output_image"
echo "Removing temporary files"
rm tmplist imglist 
echo "Collage created and saved to $output_dir$output_image"
