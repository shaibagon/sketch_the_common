#
#
#   Matlab package implementing "Sketching the Common"
#   Written by Shai Bagon (shai.bagon@weizmann.ac.il)
#   www.wisdom.weizmann.ac.il/~bagon
#   and Or Brostovsky
#
#   Copyright 2011 Shai Bagon
#                                                                 
#

# Introduction.

     This package implements the algorithm for Sketching the Common
     as described in:

     Shai Bagon, Or Brostovsky, Meirav Galun and Michal Irani
     "Detecting and Sketching the Common", CVPR 2010

# License.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    If you wish to use this software (or the algorithms described in the
    aforementioned paper) for commercial purposes, you should be aware that
    there is a US patent:

       Eli Shechtman and Michal Irani
       "METHOD AND APPARATUS FOR MATCHING LOCAL SELF-SIMILARITIES"


# Citation.

    If you use this package you HAVE to reference the aforementioned CVPR 2010 paper.
    Here is a bibtex for that paper:

@INPROCEEDINGS{Bagon2010,
    author={Shai Bagon and Or Brostovski and Meirav Galun and  Michal Irani},
    booktitle={Computer Vision and Pattern Recognition (CVPR), 2010 IEEE Conference on},
    title={Detecting and Sketching the Common},
    year={2010},
    month=june,
    url={http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=5540233&tag=1},
    pages={33--40},
    doi={10.1109/CVPR.2010.5540233},
    ISSN={1063-6919}
}

# Supported platforms

    This package contains Linux implementation only. It is unlikely that
    a Windows/Mac/Unix versions will be added in the future. (if you wish
    to create such a version by yourself, you may contact me at
    shai.bagon@weizmann.ac.il for some assistance).

    The software was tested with Matlab version 2008b and 2010b with 64bit
    Linux machines.

# Installation.

    Pre-requisite:
    You need to have opencv shared libraries installed on your machine, and
    the enviromental variable LD_LIBRARY_PATH pointing to the installation directory.

    1. Extract the files from the gz tarball to a folder of your choice
    (for example /home/bagon/sketch_cvpr2010).
    ->% cd /home/bagon/sketch_cvpr2010
    ->% tar -zxf SketchCommonCVPR10_1.0.tar.gz

    2. Open Matlab and compile cpp code for mex function:
    >> cd /home/bagon/sketch_cvpr2010 % or where you extracted the package to
    >> mexall
    Make sure your Matlab is configured with gcc compiler.
    If not, you have to configure your mex compiler BEFORE running mexall.
    To configure mex type:
    >> mex -setup
    Matlab should be able to guide you through the rest of the configuration process.


# Usage.

    1. The package comes with a simple usage example.
    In Matlab type:
    >> cd /home/bagon/sketch_cvpr2010 % or where you extracted the package to
    >> Sketch_example
    When this functions terminates, you should see a figure with the input images
    and a figure with the resulting output sketch.

    2. Main function.
    The main sketching function is sketch_the_common_CVPR10.m
    Use
    >> doc sketch_the_common_CVPR10
    To see how to use this function.


# Code.

    The following Matlab functions are part of this package:
    0. mexall.m
       Mexing the associated cpp code into mex files and installs the package.

       ***********************************************************************
       If you have warnings/errors running this code, you might not be able to
       Use this package!
       ***********************************************************************

    1. Sketch_example.m
       Usage example using the thumbnail images in the example folder

    2. sketch_the_common_CVPR10.m
       Main sketching function

    3. self_sim_correlation_matrix.m
       Taking images cropped around the common part (and optionally an exact center
       of each detected object) and computes the "self-similarity correlation matrix"
       for the common ensemble of descriptors.

    4. self_sim_win.m
       A matlab wrapper for the executable that computes local self-similarity descriptors

    5. self_sim_connectivity.m
       Taking an ensemble of descriptors represented by an array of descriptors and their
       spatial locations, and computes the "self-similarity correlation matrix"

    6. LaplacianLinf.m
       Defines the quadratic programming (QP) optimization problem that arises from the
       sketching functional and optimize it using Matlab's quadratic programming function.

    7. my_tformarray.m
       Auxilary function for translating all thumbs to be aligned according to the center of
       the common part.

    8. loc_offset_mex.cpp
       Auxilary function that computes the relative offsets between the descriptors in the ensemble


