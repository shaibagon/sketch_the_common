function mexall()
%
% Code for compiling all associated cpp files into mex files.
% Requires c++ compiler installed and configured with Matlab's mex
% Use either MS visual studion (for win PC) or gcc (for Linux/Unix machines).
% To setup c++ compiler in Matlab, type:
% >> mex -setup
% Matlab should guide you through the procerss
% 


% check that is is a linux machine
if ~ strcmp(computer,'GLNXA64')
    warning('Sketch_the_common:Linux',...
        'This package is for use on Linux 64bits machines only');
end

% check if opencv is installed
[status result] = system('locate libhighgui.so');
if status ~= 0
    warning('Sketch_the_common:opencv',...
        'Unable to locate OpenCV shared libraries. You might not be able to use this package');
end

cpp_files = {'loc_offset_mex.cpp'};

for fi=1:numel(cpp_files)
    cmd = sprintf('mex -largeArrayDims -O %s', cpp_files{fi});
    fprintf(1, 'Executing:\n\t%s\n', cmd);
    eval(cmd);
end

fprintf(1, '\n\nInstallation complete.\nTry:\n >> Sketch_example();\nto see if code works\n\n');

