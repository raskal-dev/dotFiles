# Git Config
## 1. Configurer ton nom d’utilisateur et ton email Git
Ouvre un terminal, puis tape ces commandes en remplaçant par ton nom et ton email GitHub (ou autre service Git) :
```bash 
git config --global user.name "TonNom"
git config --global user.email "tonemail@example.com"
```
Vérification :
```bash
git config --global --list
```
## 2. Générer une clé SSH
Si tu n’as pas encore de clé SSH, génère-en une avec :
```bash
ssh-keygen -t ed25519 -C "tonemail@example.com"
```
ou 
```bash
ssh-keygen -t rsa -b 4096 -C "tonemail@example.com"
```
## 3. Ajouter la clé SSH à l’agent SSH
Démarre l’agent SSH et ajoute ta clé privée :
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```
(adapte si tu as une clé RSA : ~/.ssh/id_rsa)

## 4. Ajouter ta clé SSH à ton compte GitHub (ou autre)
Affiche ta clé publique avec :
```bash
cat ~/.ssh/id_ed25519.pub
```
Copie tout le contenu affiché.

Ensuite, va sur GitHub :

Paramètres → SSH and GPG keys → New SSH key

Colle ta clé publique dans le champ et donne-lui un nom (ex : "PC perso")

## 5. Tester la connexion SSH
Dans le terminal, tape :
```bash
ssh -T git@github.com
```
Reponse succes :
```bash
Hi tonusername! You've successfully authenticated, but GitHub does not provide shell access.
```
