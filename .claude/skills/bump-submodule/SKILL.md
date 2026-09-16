---
name: bump-submodule
description: Met à jour la référence d'un submodule dans le repo meta après un push dans le submodule
disable-model-invocation: true
allowed-tools: Bash(git status *) Bash(git submodule *) Bash(git add *) Bash(git commit *)
---

## État actuel
!`git submodule status`

## Tâche
Pour le submodule `$ARGUMENTS` :
1. Vérifier que son working tree est propre et poussé (`git -C $ARGUMENTS status`)
2. Depuis la racine du meta : `git add $ARGUMENTS`
3. Commiter avec le message `chore: bump $ARGUMENTS submodule`
4. Ne pas pousser ; me demander de confirmer