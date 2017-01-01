#!/bin/bash

# Variables definit par l'utilisateur
read -p 'Choisissez un nom d utilisateur:' new_user
grep -w "$new_user"
read -p 'Choisissez un mot de passe:' new_passwd

# Liste des variables

