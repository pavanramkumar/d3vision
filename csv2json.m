area = {'V1', 'V2', 'V3', 'VP', 'V3A', 'V4', 'VOT', 'V4t', 'MT', ...
        'FST', 'PITd', 'PIT', 'PITv', 'CITd', 'CIT', 'CITv', 'AITd', 'AITv', 'STPp', 'STP', 'STPa', 'TF', 'TH', ...
        'MSTd', 'MSTI', 'PO', 'PIP', 'LIP', 'VIP', 'MIP', 'MDP', 'DP', '7a', ...
        'FEF', 'BA46'};
    
grp(1:9) = 1;   % occipital
grp(10:23) = 2;   % temporal
grp(24:33) = 3;   % parietal
grp(34:35) = 4;   % frontal

sz = [20.8, 22.1, 2.2, 1.8, 2.0, 10.0, 1.4, 0.6, 1.0, ...
      1.2, 3.7, 7.2, 3.5, 1.5, 3.7, 2.2, 1.3, 2.0, 2.2, 3.9, 1.7, 1.9, 0.8, ...
      0.6, 0.5, 1.4, 1.6, 1.0, 0.7, 1.0, 0.9, 0.9, 2.1, ...
      1.3, 3.7];

data = xlsread('VisualMap_Connectivity.xlsx');

% Prepare source and target node list
for row=1:size(data,1)
  t(row).list = find(data(row,:) == 1)-1;
end

for col=1:size(data,2)
  s(col).list = find(data(:,col) == 1)-1;
end

fp = fopen('VisualMap3.json', 'wt');
fprintf(fp, '{\n');

fprintf(fp, '\t "nodes":[\n');
for n=1:35
    fprintf(fp, '\t\t {"name":"%s","group":%d,"brainarea":%4.1f,', area{n}, grp(n), 3*log(1+sz(n)));
    fprintf(fp, ' "sources":[');
    for listno=1:length(s(n).list)
      fprintf(fp, '%d', s(n).list(listno));
      if(listno < length(s(n).list)) fprintf(fp, ','); end
    end
    fprintf(fp, '],');
    
    fprintf(fp, ' "targets":[');
    for listno=1:length(t(n).list)
      fprintf(fp, '%d', t(n).list(listno));
      if(listno < length(t(n).list)) fprintf(fp, ','); end
    end
    fprintf(fp, ']}');

    if(n < 35) fprintf(fp, ',\n'); else fprintf(fp, '\n'); end
end
fprintf(fp, '\t ],\n');


fprintf(fp, '\t "links":[\n');
for source=1:35
    for target=1:35
        if(data(source,target) == 1)
          if(grp(source) == grp(target)) value = 3; else value = 6; end
          fprintf(fp, '\t\t {"source":%d,"target":%d,"value":%d}', source-1, target-1, value);
          if(source == 35 && target == 34) fprintf(fp, '\n'); else fprintf(fp, ',\n'); end
        end
    end
end
fprintf(fp, '\t ]\n');
fprintf(fp, '}\n');

fclose(fp);
