function [sec] = convertDataToTime(filename)

fid = fopen(filename, 'rt');
a = textscan(fid, '%s %f %f %f %f %f %f', 'Delimiter',',', 'CollectOutput',1, 'HeaderLines',1);
fclose(fid);

n = size(a{1}, 1);

sec = NaN(n, 4);

for i=1:n
    c = textscan(a{1}{i}, '%s', 'delimiter', ';');
    m = size(c{1}, 1);
    
    for j=1:m
       
        if ~isempty(c{1}{j})
                hms = textscan(c{1}{j}, '%s', 'delimiter', ':');
            
            if size(hms{1}) == [2 1]
                hms = {hms{1}{1}, hms{1}{2}, '00'};                
                
            elseif size(hms{1}) == [1 1]
                hms = {hms{1}{1}, '00', '00'};
            else
                hms = {hms{1}{1}, hms{1}{2}, hms{1}{3}};
            end

            sec(i, 2*j-1) = str2double(hms{3}) + 60*(str2double(hms{2})+60*str2double(hms{1}));

            sec(i, 2*j) = str2double(hms{1});
            
        end
        
    end
   
    for j=1:2
    	if isnan(sec(i, 2*j))
            sec(i, 2*j) = sec(i-1, 2*j);
        end
    end
    
end

end

