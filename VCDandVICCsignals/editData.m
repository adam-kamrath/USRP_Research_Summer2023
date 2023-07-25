function data = editData(data)
    for i = 1:size(data)
        test_sample = data(i);
        if (test_sample < .01542) || (test_sample > .04005)
            data(i) = 0;
        else
            data(i) = 1;
        end
    end
end