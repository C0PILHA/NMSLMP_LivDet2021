function lines = readlinesfromtxt(txtpath)

fileIDin = fopen(txtpath,'r');
tline = fgetl(fileIDin);
lines = cell(1,1);
k=1;
while ischar(tline)
    %disp(tline)
    lines{k,1} = tline;
    k = k + 1;
    tline = fgetl(fileIDin);
end
fclose(fileIDin);

end

