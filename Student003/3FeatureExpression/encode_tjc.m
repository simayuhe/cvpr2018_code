function words = encode_tjc(x)
% global CENTERS
% n_centers = size(CENTERS,1);
dt = 10;
sizeOfCell = 10;
H = 48;
W = 72;
n = size(x,1);
words = zeros(1,n);
% px = zeros(1,n);
% pv = zeros(1,n);
T = sqrt(2)/2 * [1 1; -1 1];
for ii = 1:n
    len_ii = size(x,1);
    if dt >= len_ii
        v = [0 0];
    elseif ii + dt > len_ii
        v = x(end,:) - x(end-dt,:);
    else
        v = x(ii+dt,:) - x(ii,:);
    end
    v = v * T;
    if (v(1)>=0 && v(2)>=0)
        direction = 0;
    elseif (v(1)<0 && v(2)<0)
        direction = 1;
    elseif (v(1)<0 && v(2)>0)
        direction = 2;
    else
        direction = 3;
    end
    x_ii = floor((x(ii,1) - 1)/sizeOfCell);
    y_ii = floor((x(ii,2) - 1)/sizeOfCell);
    words(ii) = direction * W * H + x_ii * H + y_ii + 1;
end