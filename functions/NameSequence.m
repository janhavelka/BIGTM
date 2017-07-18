function out_name = NameSequence( in_name,in_folder,in_delimiter,in_suffix,level_up )

if ~isempty(level_up) && level_up>0
    for i=1:level_up
        cd ..
    end
end

if isempty(in_delimiter)
    in_delimiter='_';
end
if isempty(in_folder)
    in_folder='';
end
if isempty(in_name)
    in_name='new_file';
end
if isempty(in_suffix)
    in_suffix='';
end

out_name=fullfile(cd,in_folder,[in_name,in_suffix]);
if exist(out_name,'file')~=0
    count=1;
    while exist(out_name,'file')~=0
        new_name=fullfile(cd,in_folder,[in_name,in_delimiter,sprintf('%d',count),in_suffix]);
        count=count+1;
        out_name=new_name;
    end
else
    out_name=fullfile(cd,in_folder,[in_name,in_suffix]);
end

end

