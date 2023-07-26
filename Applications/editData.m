function data = editData(data)
    data = abs(data);
    for k=1:size(data)
        sample = data(k);
        if (sample > 0.574965) && (sample < 0.576901)
            data(k) = 1;
        else
            data(k) = 0;
        end
    end
end