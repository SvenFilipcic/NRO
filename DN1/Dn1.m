Datoteka = fopen('naloga1_1.txt', 'r');

fgetl(Datoteka);
fgetl(Datoteka);

t = textscan(Datoteka, '%f');

fclose(Datoteka);

t = cell2mat(t);

disp(t);

Datoteka2 = fopen('naloga1_2.txt', 'r');

st_v = str2double(fgetl(Datoteka2));

P = zeros(st_v, 1);

for i = 1:st_v

    P(i) = str2double(fgetl(Datoteka2));
end

fclose(fileID);


plot(t, P, 'b'); 
xlabel('t [s]');
ylabel('P [W]');
title('graf P');

n = st_v; 
d_t = t(2) - t(1); 

Int = P(1) + P(n);

for i = 2:n-1
    Int = Int + 2 * P(i);
end

Int = (d_t / 2) * Int
Int_trapz = trapz(t, P);

Razlika=Int-Int_trapz