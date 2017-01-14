===========
Hopkins 155
==================================================================
A Benchmark for Multibody Multiview Motion Segmentation Algorithms
==================================================================
Version: June 18th, 2007


Database content
----------------
			2 Groups		3 Groups
		# Seq. Points Frames 	# Seq. Points Frames
Checkerboard 	78     291    28     	26     437    28
Traffic 	31     241    30     	7      332    31
Articulated 	11     155    40     	2      122    31

All 		120    266    30     	35     398    29

Database description
--------------------
. Checkerboard sequences: this group consists of 104 sequences of
indoor scenes taken with a handheld camera under controlled
conditions. The checkerboard pattern on the objects is used to assure
a large number of tracked points. Sequences 1R2RC--2T3RTCR contain
three motions: two objects (identified by the numbers 1 and 2, or 2
and 3) and the camera itself (identified by the letter C). The type of
motion of each object is indicated by a letter: R for rotation, T for
translation and RT for both rotation and translation. If there is no
letter after the C, this signifies that the camera is fixed. For
example, if a sequence is called 1R2TC it means that the first object
rotates, the second translates and the camera is fixed.  Sequence
three-cars is taken from [1] and contains three motions of two toy
cars and a box moving on a plane (the table) taken by a fixed camera.

. Traffic sequences: this group consists of 38 sequences of outdoor
traffic scenes taken by a moving handheld camera. Sequences
carsX--truckX have vehicles moving on a street. Sequences kanatani1
and kanatani2 are taken from [2] and display a car moving in a parking
lot. Most scenes contain degenerate motions, particularly linear and
planar motions.

. Articulated/non-rigid sequences: this group contains 13 sequences
displaying motions constrained by joints, head and face motions,
people walking, etc. Sequences arm and articulated contain
checkerboard objects connected by arm articulations and by strings,
respectively. Sequences people1 and people2 display people walking,
thus one of the two motions (the person walking) is partially
non-rigid.  Sequence kanatani3 is taken from [2] and contains a moving
camera tracking a person moving his head.  Sequences head and
two\_cranes are taken from [3] and contain two and three articulated
objects, respectively.

File format
-----------

Each sequence is contained in a directory having the corresponding
name.  In each directory there are some files.
. description.txt: a brief description of what appears in the
  sequence.
. preview.jpg: the first frame of the sequences with the extracted
  feature points.
. *.avi and *_points.avi: the video sequence in the original form and
  with tracked correspondences superimposed.
. *_truth.mat: a Matlab 6 .MAT file containing the ground-truth.

The variables inside the ground-truth file are organized as follow:
. width and height: dimensions (in pixels) of all the frames in the
  video sequence.
. points: number of tracked points P.
. frames: number of frames F.
. y: a matrix 3xPxF containing the homogeneous coordinates of the P
  points in the F frames.
. x: a matrix 3xPxF derived from y by normalizing the first two
  components of each vector such that they belong to the interval
  [-1;1].
. K: the 3x3 normalization matrix used to pass from y to x
  (x=K^(-1)*x).
. s: a Px1 vector containing the ground-truth segmentation; for each
  point it gives the index of the corresponding motion group.

References
----------
[1] R. Vidal, Y. Ma, S. Soatto, and S. Sastry. Two-view multibody
structure from motion. International Journal of Computer
 Vision, 68(1):7–25, 2006.

[2] Y. Sugaya and K. Kanatani. Geometric structure of degeneracy
for multi-body motion segmentation. In Workshop on
Statistical Methods in Video Processing, 2004.

[3] J. Yan and M. Pollefeys. A general framework for motion
segmentation: Independent, articulated, rigid, non-rigid, degenerate
and non-degenerate. In European Conference on
Computer Vision, pages 94–106, 2006.
