function data = editData(data)
    for i = 1:size(data)
        if data(i) < .008
            data(i) = 0;
        else
            data(i) = 1;
        end
    end
end