# Installation et compilation (Arch/EndeavourOS)

## Installation des paquets LaTeX

```bash
sudo pacman -S --needed texlive-bin texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra texlive-pictures texlive-fontsrecommended texlive-fontsextra texlive-langfrench texlive-bibtexextra texlive-binextra
```

## Compilation (LaTeX)

```bash
cd /home/raskal/Coding/erp_ahc/docs/Memoire_Kalvin
latexmk -pdf -interaction=nonstopmode -file-line-error main.tex
```

## Compilation (Makefile)

```bash
cd /home/raskal/Coding/erp_ahc/docs/Memoire_Kalvin
make
```
