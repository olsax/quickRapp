# Aplikacja Shiny
obliczającą ryzyko wystąpienia guza złośliwego jajników implementująca model IOTA LR2.


Model IOTA LR2 jest regresją logistyczną o następującej formule
```
z = −5.3718 + 0.0354 ∗ wiek + 1.6159 ∗ wodobrzusze + 1.1768 ∗ przeplyw krwi +
	0.0697 ∗ element lity + 0.9586 ∗ sciana wewnetrzna − 2.9486 ∗ cien akustyczny
```
```
f(z) = 1/(1+exp(-z))
```
Jeżeli  f(z) > 0.1, to wynik jest: złośliwy; w przeciwnym przypadku wynik jest niezłośliwy.

******
Tworzenie produktów opartych na danych