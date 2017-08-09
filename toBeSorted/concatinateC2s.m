%Testing stuff.
clear; clc;
%% 1-10000
load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single1-10000/c2f1.mat')
c2f1 = c2f;

load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single1-10000/c2f2.mat')
c2f2 = c2f;

load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single1-10000/c2f3.mat')
c2f3 = c2f;

load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single1-10000/c2f4.mat')
c2f4 = c2f;

c2f10000 = horzcat(c2f1, c2f2, c2f3, c2f4);
%% 10001-20000
load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single10001-20000/c2f1.mat')
c2f1 = c2f;

load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single10001-20000/c2f2.mat')
c2f2 = c2f;

load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single10001-20000/c2f3.mat')
c2f3 = c2f;

load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single10001-20000/c2f4.mat')
c2f4 = c2f;

c2f20000 = horzcat(c2f1, c2f2, c2f3, c2f4);
%% 20001-30000
load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single20001-30000/c2f1.mat')
c2f1 = c2f;

load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single20001-30000/c2f2.mat')
c2f2 = c2f;

load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single20001-30000/c2f3.mat')
c2f3 = c2f;

load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single20001-30000/c2f4.mat')
c2f4 = c2f;

c2f30000 = horzcat(c2f1, c2f2, c2f3, c2f4);
%% 30001-40000
load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single30001-40000/c2f1.mat')
c2f1 = c2f;

load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single30001-40000/c2f2.mat')
c2f2 = c2f;

load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single30001-40000/c2f3.mat')
c2f3 = c2f;

load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/single30001-40000/c2f4.mat')
c2f4 = c2f;

c2f40000 = horzcat(c2f1, c2f2, c2f3, c2f4);

%% Concatinate all 40000
c2fALL = vertcat(c2f10000,c2f20000,c2f30000,c2f40000);