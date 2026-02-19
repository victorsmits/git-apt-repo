# Git Cascade

Outil CLI interactif pour merger une chaîne de branches git en cascade avec interface fzf.

## Installation

```bash
# Ajoute le repo APT
echo "deb [trusted=yes] https://victorsmits.github.io/git-apt-repo stable main" | sudo tee /etc/apt/sources.list.d/git-cascade.list

# Mets à jour et installe
sudo apt update
sudo apt install git-cascade
```

## Prérequis

- `git`
- `fzf` (installé automatiquement via apt)

## Utilisation

```bash
# Mode interactif
git cascade

# Avec push automatique après chaque merge
git cascade --push
```

## Fonctionnement

1. Sélectionne la branche de base (ex: `master`)
2. Option `--push` : active le push automatique
3. Sélectionne les branches dans l'ordre (A → B → C)
4. Confirme la cascade
5. Pour chaque branche :
   - `git checkout branch`
   - `git pull`
   - `git merge prev`
   - `git push` (si --push)

## Gestion des conflits

En cas de conflit, le script s'arrête et attend que tu :
1. Résolves les conflits dans tes fichiers
2. Fasses `git add . && git commit`
3. Appuies sur Entrée pour continuer

Ou tape `abort` pour annuler le merge en cours.

## Raccourcis fzf

- `Entrée` : Sélectionner / Ajouter à la chaîne
- `Ctrl+Y` : Finir la sélection et lancer
- `Échap` : Annuler

## Désinstallation

```bash
sudo apt remove git-cascade
sudo rm /etc/apt/sources.list.d/git-cascade.list
sudo apt update
```

## License

MIT
