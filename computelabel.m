function labelresult = computelabel(representation,pred_clusters)

ar  = size(representation,1);
ap  = size(pred_clusters,1);
labelresult = zeros(ar,1);
for i = 1:ar
    dist = zeros(ap,1);
    for j = 1:ap
        dist(j,1) = norm(representation(i,:) - pred_clusters(j,:));
    end
    [~,labelresult(i,1)] = min(dist);
end