% angdiffdeg.m
%
%      usage: angdiff(a1, a2)
%         by: justin gardner
%       date: 03/08/01
%    purpose: difference in degrees of two angles
%
function a = angdiffdeg(v1, v2)

v1 = deg2rad(v1);
v2 = deg2rad(v2);

v1x = cos(v1);
v1y = sin(v1);

v2x = cos(v2);
v2y = sin(v2);

a = acos([v1x v1y]*[v2x v2y]');
a = rad2deg(a);
