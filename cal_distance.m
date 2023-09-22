function [Distance] = cal_distance(Dictionary,metrictype)
% m = size(Dictionary,1);
% Distance = zeros(m);
% for i = 1:m
%     for j = i:m
%         Distance(i,j) = norm(Dictionary(i,:)-Dictionary(j,:));
%         Distance(j,i) = Distance(i,j);
%     end
% end
switch metrictype
    case 1
        str = 'euclidean';
    case 2
        str = 'seuclidean';
    case 3
        str = 'mahalanobis';
    case 4
        str = 'cityblock';
    case 5
        str = 'minkowski';
    case 6
        str = 'cosine';
    case 7
        str = 'correlation';
    case 8
        str = 'spearman';
    case 9
        str = 'hamming';
    case 10
        str = 'jaccard';
    case 11
        str = 'chebychev';
    otherwise
        error('metrictype wrong!');
end

m = size(Dictionary,1);
Distance = zeros(m);
Y = pdist(Dictionary,str);
Ylabel = 1;
for i = 1:m
    for j = i+1:m
        Distance(i,j) = Y(Ylabel);
        Ylabel = Ylabel + 1;
        Distance(j,i) = Distance(i,j);
    end
end