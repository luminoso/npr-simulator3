r= [2.3 4.5 1.5 5.4 2.9 3.2];
s= [30 70 20 80 35 40];
c= [100 60];
n= length(r);
v= length(c);
fid = fopen('lip_example.lp','wt');
fprintf(fid,'Maximize\n');
for i=1:n
    fprintf(fid,' + %f x%d',r(i),i);
end
fprintf(fid,'\nSubject To\n');
for j=1:v
    for i=1:n
        fprintf(fid,' + %f y%d,%d',s(i),i,j);
    end
    fprintf(fid,' <= %f\n',c(j));
end
for i=1:n
    for j=1:v
        fprintf(fid,' + y%d,%d',i,j);
    end
    fprintf(fid,' - x%d = 0\n',i);
end
fprintf(fid,'Binary\n');
for i=1:n
    fprintf(fid,' x%d\n',i);
    for j=1:v
        fprintf(fid,' y%d,%d\n',i,j);
    end
end
fprintf(fid,'End\n');
fclose(fid);