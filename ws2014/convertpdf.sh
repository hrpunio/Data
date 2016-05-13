#!/bin/bash

B=`basename $1.pdf`

convert -density 300 $1 -background white -alpha remove  ${B}_%02d.png
