#include <iostream>
#include <cmath>

// Taylor
double ArcTan(double x, int N_steps) {
    double result = 0.0;
    double term = x; 
    for (int n = 0; n < N_steps; ++n) {
        if (n > 0) {
            term *= -x * x; 
        }
        result += term / (2 * n + 1);
    }
    return result;
}

// Konèna funkcija
double Funkcija(double x) {
    int N_steps = 10;
    double ArcTan_f = ArcTan(x / 2, N_steps);
    return exp(3 * x) * ArcTan_f;
}

// Trapezna metoda
double Trapz(double a, double b, int n) {
    double h = (b - a) / n; //Kok je step
    double sum = Funkcija(a) + Funkcija(b);

    for (int i = 1; i < n; ++i) {
        sum += 2 * Funkcija(a + i * h);
    }
    return h * sum / 2.0;
}

int main() {
    const double PI = 3.141592653589;
    double a = 0;
    double b = PI / 4;
    int n = 1000; 

    double površina = Trapz(a, b, n);


    std::cout << "površina funkcije:" << površina << std::endl;

    return 0;
}
