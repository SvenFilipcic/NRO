clc;
clear;

T_podatki = readmatrix("vozlisca_temperature_dn2.txt", "NumHeaderLines", 4);
x_os = T_podatki(:, 1);
y_os = T_podatki(:, 2);
T = T_podatki(:, 3);

x_T = 0.403;
y_T = 0.503;

Celice = readmatrix("celice_dn2.txt", "NumHeaderLines", 2);

figure;
scatter(x_os, y_os, 10, T, "filled");
colorbar;
hold on;

plot(x_T, y_T, "ro", "MarkerSize", 12, "LineWidth", 2);

%scatteredInterpolant
tic;
Scatt_Int = scatteredInterpolant(x_os, y_os, T, "linear");
T_scattered = Scatt_Int(x_T, y_T);
casScattered = toc;

%griddedInterpolant
x_unique = unique(x_os);
y_unigue = unique(y_os);
[X, Y] = ndgrid(x_unique, y_unigue);

% Preoblikovanje temperature za mrežo
T_mreza = reshape(T, length(x_unique), length(y_unigue));
tic;
griddedInterp = griddedInterpolant(X, Y, T_mreza, "linear");
tempGridded = griddedInterp(x_T, y_T);
casGridded = toc;

%interpolacija
tic;
for i = 1:size(Celice, 1)

    tocka1 = Celice(i, 1);
    tocka2 = Celice(i, 2);
    tocka3 = Celice(i, 3);
    tocka4 = Celice(i, 4);

    x1 = x_os(tocka1); y1 = y_os(tocka1); T11 = T(tocka1);
    x2 = x_os(tocka2); y2 = y_os(tocka2); T21 = T(tocka2);
    x3 = x_os(tocka3); y3 = y_os(tocka3); T22 = T(tocka3);
    x4 = x_os(tocka4); y4 = y_os(tocka4); T12 = T(tocka4);

    if x_T >= x1 && x_T <= x2 && y_T >= y1 && y_T <= y3
        K1 = (x2 - x_T) / (x2 - x1) * T11 + (x_T - x1) / (x2 - x1) * T21;
        K2 = (x2 - x_T) / (x2 - x1) * T12 + (x_T - x1) / (x2 - x1) * T22;
        T_lastna = (y3 - y_T) / (y3 - y1) * K1 + (y_T - y1) / (y3 - y1) * K2;
        break;
    end
end
casLastna = toc;

%% Največja temperatura
[T_max, Poz_T] = max(T);
xMax = x_os(Poz_T);
yMax = y_os(Poz_T);

%% Primerjava rezultatov
fprintf("\nPrimerjava metod:\n");
fprintf("Metoda                       Temperatura[°C]       Čas[s]\n");
fprintf("-----------------------------------------------------------\n");
fprintf("scatteredInterpolant          %.5f             %.5f\n", T_scattered, casScattered);
fprintf("griddedInterpolant            %.5f             %.5f\n", tempGridded, casGridded);
fprintf("aproksimacija      %.5f             %.5f\n\n\n", T_lastna, casLastna);
fprintf("Najvišja temperatura je %.3f °C v točki (%.2f , %.2f)\n", T_max, xMax, yMax);
