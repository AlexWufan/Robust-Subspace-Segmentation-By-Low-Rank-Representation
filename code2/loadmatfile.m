function [data] = loadmatfile(path)
%LOADMATFILE Summary of this function goes here
%   Detailed explanation goes here
data = load(path);
data = data.obj;