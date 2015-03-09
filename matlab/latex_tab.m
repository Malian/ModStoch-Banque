function [] = latex_tab(filename,a,headers)

%Copy the matrix a in a latex tab
% in the file denoted by filename
% with header 'headers' (cell array)

% TODO : check a and headers have the same number of columns


[nLINES,nCOLUMNS] = size(a)
% Open fid
fid = fopen(filename,'w');

% Start + define number of columns
fprintf(fid,'\\begin{tabular}{|');
for i = 1:nCOLUMNS
	fprintf(fid,'c|');
end
fprintf(fid,'}\n\\hline \n');

% Print header
for j = 1 : nCOLUMNS
	if j ==nCOLUMNS
		fprintf(fid,'%s \\\\ \n \\hline \n',headers{1,j});
	else
		fprintf(fid,'%s & ',headers(1,j){1});
	end
end

for i=1:nLINES
	for j = 1 : nCOLUMNS
		if j ==nCOLUMNS
			fprintf(fid,'$%g$ \\\\ \n \\hline \n',a(i,j));
		else
			fprintf(fid,'$%g$ & ',a(i,j));
		end
	end
end
fprintf(fid,' \n \\end{tabular}');
fclose(fid);
