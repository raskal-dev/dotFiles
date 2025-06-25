yay -S zsh

chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme for Oh My Zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Activer le thème Powerlevel10k
## Dans le fichier ~/.zshrc :
ZSH_THEME="robbyrussell"

## et remplacer-la par :
ZSH_THEME="powerlevel10k/powerlevel10k"

## en suite, recharger Zsh :
source ~/.zshrc

# Tu seras guidé automatiquement par l’assistant Powerlevel10k pour configurer l’apparence (couleurs, style du prompt, icônes, etc.). Si ce n’est pas le cas, tu peux relancer la configuration :
p10k configure

# Installe les suggestions de commandes
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Puis, dans ~/.zshrc, ajoute zsh-autosuggestions dans la ligne plugins, par exemple :
plugins=(git zsh-autosuggestions)

# Recharge Zsh :
source ~/.zshrc

# Activer la complétion syntaxique colorée (highlighting)
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Et ajoute-le à la fin de la liste des plugins dans ton ~/.zshrc :
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Recharge encore une fois :
source ~/.zshrc

# (Optionnel) Correction orthographique dans Zsh
## Tu peux activer la correction de commande en ajoutant ceci dans ~/.zshrc :
setopt CORRECT

# Recharger Zsh une dernière fois :
source ~/.zshrc