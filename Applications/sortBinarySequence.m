function [flags, info_flags, uid, dsfid, afi, memory, ic_reference, crc] = sortBinarySequence(binary_sequence)
    %Makes empty strings for all sections;
    flags = '';
    info_flags = '';
    uid = '';
    dsfid = '';
    afi = '';
    memory = '';
    ic_reference = '';
    crc = '';
    %Sorts Flags section
    for i=8:-1:1
        flags = append(flags, binary_sequence(i));
    end
    flags = bin2hex(flags);
    flags = append('FLAGS: 0x', flags);
    %Sorts Info Flags section
    for i=16:-1:9
        info_flags = append(info_flags, binary_sequence(i));
    end
    info_flags = bin2hex(info_flags);
    info_flags = append('INFO FLAGS: 0x', info_flags);
    %Sorts UID
    for i=80:-1:17
        uid = append(uid, binary_sequence(i));
    end
    uid = bin2hex(uid);
    uid = append('UID: 0x', uid);
    %Sorts DSFID
    for i=88:-1:81
        dsfid = append(dsfid, binary_sequence(i));
    end
    dsfid = bin2hex(dsfid);
    dsfid = append('DSFID: 0x', dsfid);
    %Sorts AFI
    for i=96:-1:89
        afi = append(afi, binary_sequence(i));
    end
    afi = bin2hex(afi);
    afi = append('AFI: 0x', afi);
    %Sorts Memory
    for i=112:-1:97
        memory = append(memory, binary_sequence(i));
    end
    memory = bin2hex(memory);
    memory = append('MEMORY: 0x', memory);
    %Sorts IC Reference
    for i=120:-1:113
        ic_reference = append(ic_reference, binary_sequence(i));
    end
    ic_reference = bin2hex(ic_reference);
    ic_reference = append('IC REFERENCE: 0x', ic_reference);
    %Sorts CRC
    for i=136:-1:121
        crc = append(crc, binary_sequence(i));
    end
    crc = bin2hex(crc);
    crc = append('CRC: 0x', crc);
end

%Converts a binary string into a hex string
function hex = bin2hex(bin)
    hex = dec2hex(bin2dec(reshape(bin,4,[]).')).';
end